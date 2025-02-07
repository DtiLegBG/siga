package br.gov.jfrj.siga.gc.api.v1;

import javax.persistence.EntityManager;

import br.gov.jfrj.siga.context.ApiContextSupport;
import br.gov.jfrj.siga.cp.bl.Cp;
import br.gov.jfrj.siga.dp.dao.CpDao;
import br.gov.jfrj.siga.gc.util.GcStarter;

public class GcApiV1Context extends ApiContextSupport {
	private static final String DOC_MÓDULO_DE_GESTAO_DO_CONHECIMENTO = "GC:Módulo de Gestão do Conhecimento;";

	public void atualizarCacheDeConfiguracoes() throws Exception {
		Cp.getInstance().getConf().limparCacheSeNecessario();
	}

	public CpDao inicializarDao() {
		return CpDao.getInstance();
	}

	public EntityManager criarEntityManager() {
		return GcStarter.emf.createEntityManager();
	}

	/**
	 * Verifica se o usuário tem acesso ao serviço
	 * <code>{@value #DOC_MÓDULO_DE_DOCUMENTOS}<code> e ao serviço informado no
	 * parâmetro acesso.
	 * 
	 * @param acesso Caminho do serviço a ser verificado a permissão de acesso
	 * 
	 * @throws Exception Se houver algo de errado.
	 */
	public void assertAcesso(String acesso) throws Exception {
		getSigaObjects().assertAcesso(DOC_MÓDULO_DE_GESTAO_DO_CONHECIMENTO + acesso);
	}

}
