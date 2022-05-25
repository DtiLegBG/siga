/*******************************************************************************
 * Copyright (c) 2006 - 2011 SJRJ.
 * 
 *     This file is part of SIGA.
 * 
 *     SIGA is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     SIGA is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with SIGA.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
/*
 * Criado em : 25/04/2007
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

package br.gov.jfrj.siga.vraptor;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.persistence.EntityManager;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;

import br.com.caelum.vraptor.Controller;
import br.com.caelum.vraptor.Get;
import br.com.caelum.vraptor.Result;
import br.com.caelum.vraptor.observer.download.Download;
import br.com.caelum.vraptor.observer.download.InputStreamDownload;
import br.gov.jfrj.siga.base.AplicacaoException;
import br.gov.jfrj.siga.base.Prop;
import br.gov.jfrj.siga.base.util.Utils;
import br.gov.jfrj.siga.cp.model.DpLotacaoSelecao;
import br.gov.jfrj.siga.cp.model.DpPessoaSelecao;
import br.gov.jfrj.siga.dp.DpLotacao;
import br.gov.jfrj.siga.dp.DpPessoa;
import br.gov.jfrj.siga.dp.dao.CpDao;
import br.gov.jfrj.siga.ex.relatorio.dinamico.relatorios.RelDocsQuantidadeGerados;
import br.gov.jfrj.siga.ex.relatorio.dinamico.relatorios.RelPermanenciaSetorAssunto;
import br.gov.jfrj.siga.ex.util.MascaraUtil;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;

@Controller
public class ExRelatorioPrioController extends ExController {

	private static final String APPLICATION_PDF = "application/pdf";
	private static final String APPLICATION_EXCEL = "application/vnd.ms-excel";
	private static final String APPLICATION_CSV = "text/csv";

	private static final String ACESSO_PERMASETORASSUNTO = "PERMASETORASSUNTO:Relatório de Permanência por Setor e Assunto";
	private static final String ACESSO_DOCGERADOSQUANTITATIVO = "DOCGERADOSQUANTITATIVO:Relatório de Documentos Gerados com Quantitativo";
	
	/**
	 * @deprecated CDI eyes only
	 */
	public ExRelatorioPrioController() {
		super();
	}

	@Inject
	public ExRelatorioPrioController(HttpServletRequest request, HttpServletResponse response, ServletContext context,
			Result result, SigaObjects so, EntityManager em) {
		super(request, response, context, result, CpDao.getInstance(), so, em);
	}

	private void addParametrosPersonalizadosOrgaoString(Map<String, String> parameters) {

		parameters.put("titulo", Prop.get("/siga.relat.titulo"));
		parameters.put("subtitulo", Prop.get("/siga.relat.subtitulo"));
		parameters.put("brasao", Prop.get("/siga.relat.brasao"));
	}

	protected void assertAcesso(final String pathServico) {
		super.assertAcesso("REL:Gerar relatórios;" + pathServico);
	}

	private String linkHttp() {
		String url = request.getRequestURL().toString();
		String pattern = "^(https)://.*$";
		if (url.matches(pattern)) {
			return "https://";
		} else {
			return "http://";
		}
	}

	@Get("app/expediente/rel/emiteRelPermanenciaSetorAssunto")
	public Download aRelPermanenciaSetorAssunto() throws Exception {
		
		assertAcesso(ACESSO_PERMASETORASSUNTO);

		final Map<String, String> parametros = new HashMap<String, String>();

		parametros.put("lotacao",getRequest().getParameter("lotacaoDestinatarioSel.id"));
		
		parametros.put("secaoUsuario", getRequest().getParameter("secaoUsuario"));

		
		parametros.put("link_siga", linkHttp() + getRequest().getServerName() + ":" + getRequest().getServerPort()	+ getRequest().getContextPath()
				+ "/app/expediente/doc/exibir?sigla=");

		parametros.put("lotacaoTitular",getRequest().getParameter("lotacaoTitular"));

		parametros.put("idTit", getRequest().getParameter("idTit"));
		
		String[] setoresSelecionados = getRequest().getParameterValues("setoresSelecionados");
		
		
		String[] assuntos = getRequest().getParameterValues("assuntos");
		
		
		String idTipoFormaDoc =  getRequest().getParameter("idTipoFormaDoc");
		
		String idTipoSaida = getRequest().getParameter("idTipoSaida");
		
		if (setoresSelecionados == null ) {
			
			throw new AplicacaoException( "Selecione pelo menos um Setor.");
		}
		
		if (assuntos == null ) {
			
			throw new AplicacaoException( "Selecione pelo menos um Assunto.");
		}
		

		if (StringUtils.isBlank(idTipoFormaDoc ) ) {
			
			throw new AplicacaoException( "Selecione pelo menos um Tipo de Forma Documental.");
		}
		
		if (StringUtils.isBlank(idTipoSaida ) ) {
			
			throw new AplicacaoException( "Selecione o tipo de saida desejado :PDF, EXCEL ou CSV");
		}
	
		parametros.put("listaSetoresSubordinados",Arrays.toString(setoresSelecionados).replace("[", "").replace("]",""));
		
		parametros.put("listaAssunto",Arrays.toString(assuntos).replace("[", "").replace("]",""));
		
		parametros.put("idTipoFormaDoc", idTipoFormaDoc);
		
		parametros.put("idTipoSaida", idTipoSaida); 
		
		addParametrosPersonalizadosOrgaoString(parametros);

		final RelPermanenciaSetorAssunto rel = new RelPermanenciaSetorAssunto(parametros);
		
		
		InputStream inputStream   =null; 

		String nomeArquivoSaida = 	"RelPermanenciaSetorAssunto_"+ new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
		
		
		if (Integer.valueOf(idTipoSaida) == 1){ 
			rel.gerar();
			inputStream = new ByteArrayInputStream(	rel.getRelatorioPDF());
			return new InputStreamDownload(inputStream, APPLICATION_PDF,	nomeArquivoSaida +".pdf");

		} else if (Integer.valueOf(idTipoSaida) == 2){ 
			rel.gerar();
			inputStream   = new ByteArrayInputStream(	rel.getRelatorioExcel());
			return new InputStreamDownload(inputStream, APPLICATION_EXCEL,nomeArquivoSaida +".xlsx");

		} else {
			  
			inputStream = new ByteArrayInputStream( rel.gerarRelatorioCSV() );
			return new InputStreamDownload(inputStream, "text/csv",  nomeArquivoSaida +".csv" );
		}
	}
	
	@Get("app/expediente/rel/emiteRelDocsQuantidadeGerados")
	public Download aRelDocsQuantidadeGerados() throws Exception {

		assertAcesso(ACESSO_DOCGERADOSQUANTITATIVO);

		final Map<String, String> parametros = new HashMap<String, String>();

		parametros.put("lotacao", getRequest().getParameter("lotacaoDestinatarioSel.id"));

		parametros.put("secaoUsuario", getRequest().getParameter("secaoUsuario"));

		parametros.put("link_siga", linkHttp() + getRequest().getServerName() + ":" + getRequest().getServerPort()
				+ getRequest().getContextPath() + "/app/expediente/doc/exibir?sigla=");

		parametros.put("lotacaoTitular", getRequest().getParameter("lotacaoTitular"));

		parametros.put("idTit", getRequest().getParameter("idTit"));

		String[] setoresSelecionados = getRequest().getParameterValues("setoresSelecionados");

		String[] assuntos = getRequest().getParameterValues("assuntos");

		String idTipoFormaDoc = getRequest().getParameter("idTipoFormaDoc");

		String idTipoSaida = getRequest().getParameter("idTipoSaida");

		if (setoresSelecionados == null) {

			throw new AplicacaoException("Selecione pelo menos um Setor.");
		}

		if (assuntos == null) {

			throw new AplicacaoException("Selecione pelo menos um Assunto.");
		}

		if (StringUtils.isBlank(idTipoFormaDoc)) {

			throw new AplicacaoException("Selecione pelo menos um Tipo de Forma Documental.");
		}

		if (StringUtils.isBlank(idTipoSaida)) {

			throw new AplicacaoException("Selecione o tipo de saida desejado :PDF, EXCEL ou CSV");
		}

		parametros.put("listaSetoresSubordinados",
				Arrays.toString(setoresSelecionados).replace("[", "").replace("]", ""));

		parametros.put("listaAssunto", Arrays.toString(assuntos).replace("[", "").replace("]", ""));

		parametros.put("idTipoFormaDoc", idTipoFormaDoc);

		parametros.put("idTipoSaida", idTipoSaida);

		addParametrosPersonalizadosOrgaoString(parametros);

		final RelDocsQuantidadeGerados rel = new RelDocsQuantidadeGerados(parametros);

		InputStream inputStream = null;

		String nomeArquivoSaida = "RelDocsQuantidadeGerados_"
				+ new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());

		if (Integer.valueOf(idTipoSaida) == 1) {
			rel.gerar();
			inputStream = new ByteArrayInputStream(rel.getRelatorioPDF());
			return new InputStreamDownload(inputStream, APPLICATION_PDF, nomeArquivoSaida + ".pdf");

		} else if (Integer.valueOf(idTipoSaida) == 2) {
			rel.gerar();
			inputStream = new ByteArrayInputStream(rel.getRelatorioExcel());
			return new InputStreamDownload(inputStream, APPLICATION_EXCEL, nomeArquivoSaida + ".xlsx");

		} else {

			inputStream = new ByteArrayInputStream(rel.gerarRelatorioCSV());
			return new InputStreamDownload(inputStream, "text/csv", nomeArquivoSaida + ".csv");
		}
	}
}