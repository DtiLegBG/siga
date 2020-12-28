package br.gov.jfrj.siga.ex.api.v1;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeParseException;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

import com.crivano.swaggerservlet.SwaggerException;

import br.gov.jfrj.siga.ex.ExMobil;
import br.gov.jfrj.siga.ex.api.v1.IExApiV1.DocSiglaTramitarSpPostRequest;
import br.gov.jfrj.siga.ex.api.v1.IExApiV1.DocSiglaTramitarSpPostResponse;
import br.gov.jfrj.siga.ex.api.v1.IExApiV1.IDocSiglaTramitarSpPost;
import br.gov.jfrj.siga.ex.bl.Ex;
import br.gov.jfrj.siga.hibernate.ExDao;
import br.gov.jfrj.siga.vraptor.SigaObjects;

public class DocSiglaTramitarSpPost implements IDocSiglaTramitarSpPost {

	@Override
	public String getContext() {
		return "tramitar documento (SP sem Papel)";
	}

	private Date getDataDevolucao(DocSiglaTramitarSpPostRequest req, DocSiglaTramitarSpPostResponse resp)
			throws SwaggerException {
		if (StringUtils.isEmpty(req.dataDevolucao)) {
			return null;
		}
		try {
			LocalDate localDate = LocalDate.parse(req.dataDevolucao);
			if (localDate.isBefore(LocalDate.now())) {
				throw new SwaggerException(
						"Data de devolução não pode ser anterior à data de hoje: " + req.dataDevolucao, 400, null, req,
						resp, null);
			}
			return Date.from(localDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
		} catch (DateTimeParseException e) {
			throw new SwaggerException("Data de Devolução inválida: " + req.dataDevolucao, 400, null, req, resp, null);
		}
	}

	private TramitacaoTipoDestinoEnum getTipoTramitcao(DocSiglaTramitarSpPostRequest req,
			DocSiglaTramitarSpPostResponse resp) throws SwaggerException {
		try {
			TramitacaoTipoDestinoEnum tipoTramitacao = TramitacaoTipoDestinoEnum.valueOf(req.tipoDestinatario);

			if (StringUtils.isEmpty(req.destinatario)) {
				throw new SwaggerException(tipoTramitacao.descricao + " não Fornecido", 400, null, req, resp, null);
			}
			if (!req.destinatario.matches(tipoTramitacao.pattern)) {
				throw new SwaggerException(tipoTramitacao.descricao + " (" + req.destinatario + ") Inválido. "
						+ tipoTramitacao.msgErroPattern, 400, null, req, resp, null);
			}
			return tipoTramitacao;
		} catch (IllegalArgumentException e) {
			throw new SwaggerException("Tipo de Tramitação inválido: " + req.tipoDestinatario, 400, null, req, resp,
					null);
		}
	}

	@Override
	public void run(DocSiglaTramitarSpPostRequest req, DocSiglaTramitarSpPostResponse resp) throws Exception {
		req.sigla = SwaggerHelper.decodePathParam(req.sigla);
		TramitacaoTipoDestinoEnum tipoDestino = getTipoTramitcao(req, resp);
		Date dataDevolucao = getDataDevolucao(req, resp);

		try {
			SwaggerHelper.buscarEValidarUsuarioLogado();
			SigaObjects so = SwaggerHelper.getSigaObjects();

			ExMobil mob = SwaggerHelper.buscarEValidarMobil(req.sigla, req, resp);
			System.out.println("MobilTramitarSiglaPost.run(): " + mob);

			Utils.assertAcesso(mob, so.getCadastrante(), so.getCadastrante().getLotacao());

			if (!Ex.getInstance().getComp().podeTransferir(so.getCadastrante(), so.getCadastrante().getLotacao(),
					mob)) {
				throw new SwaggerException("O documento " + req.sigla + " não pode ser tramitado por "
						+ so.getCadastrante().getSiglaCompleta() + "/"
						+ so.getCadastrante().getLotacao().getSiglaCompleta(), 403, null, req, resp, null);
			}

			Date dt = ExDao.getInstance().consultarDataEHoraDoServidor();

			tipoDestino.efetuarTramitacaoParaDestino(so, mob, dataDevolucao, dt, req, resp);
		} catch (Exception e) {
			e.printStackTrace(System.out);
			throw e;
		}
	}

}