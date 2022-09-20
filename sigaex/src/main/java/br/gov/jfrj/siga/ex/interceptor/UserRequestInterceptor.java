package br.gov.jfrj.siga.ex.interceptor;

import br.com.caelum.vraptor.AroundCall;
import br.com.caelum.vraptor.Intercepts;
import br.com.caelum.vraptor.interceptor.AcceptsWithAnnotations;
import br.com.caelum.vraptor.interceptor.SimpleInterceptorStack;
import br.gov.jfrj.siga.dp.DpLotacao;
import br.gov.jfrj.siga.dp.DpPessoa;
import br.gov.jfrj.siga.ex.ExMobil;
import br.gov.jfrj.siga.ex.interceptor.payload.UserRequestPayload;
import br.gov.jfrj.siga.ex.logic.ExPodeRegistrarRequisicaoUsuario;
import br.gov.jfrj.siga.hibernate.ExDao;
import br.gov.jfrj.siga.persistencia.ExMobilDaoFiltro;
import br.gov.jfrj.siga.vraptor.SigaObjects;
import br.gov.jfrj.siga.vraptor.TrackRequest;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

@Intercepts
@RequestScoped
@AcceptsWithAnnotations(TrackRequest.class)
public class UserRequestInterceptor {
    private HttpServletRequest request;
    private DpPessoa cadastrante;
    private DpLotacao lotacaoCadastrante;
    private ExMobil mob;
    private String sigla; 
    private String nomeAcao;
    private ExPodeRegistrarRequisicaoUsuario exPodeRegistrarRequisicaoUsuario;
    private UserRequestPayload userRequestPayload;

    private final Level BLAME = Level.forName("BLAME", 450);
    private final Logger logger = LogManager.getLogger(UserRequestInterceptor.class);

    public UserRequestInterceptor() {
        this.userRequestPayload = null;
        this.mob = null;
        this.sigla = null;
        this.nomeAcao = null;
        this.exPodeRegistrarRequisicaoUsuario = null;
    }

    public UserRequestInterceptor(HttpServletRequest request, String sigla, String nomeAcao, 
                                  DpPessoa cadastrante, DpLotacao lotacaoCadastrante) {
        this.request = request;
        this.sigla = sigla;
        this.nomeAcao = nomeAcao;
        this.cadastrante = cadastrante;
        this.lotacaoCadastrante = lotacaoCadastrante;

        final ExMobilDaoFiltro filter = new ExMobilDaoFiltro();
        filter.setSigla(sigla);

        this.mob = ExDao.getInstance().consultarPorSigla(filter);

        this.exPodeRegistrarRequisicaoUsuario = new ExPodeRegistrarRequisicaoUsuario(mob, nomeAcao,
                cadastrante, lotacaoCadastrante);
    }


    @Inject
    public UserRequestInterceptor(HttpServletRequest request, SigaObjects sigaObjects) {
        this(request, request.getParameter("sigla"), request.getParameter("nomeAcao"), 
                sigaObjects.getCadastrante(), sigaObjects.getCadastrante().getLotacao());
    }

    @AroundCall
    public void around(SimpleInterceptorStack stack) {
        log();

        stack.next();

    }

    public void log() {

        if (this.exPodeRegistrarRequisicaoUsuario != null &&
                this.exPodeRegistrarRequisicaoUsuario.eval()) {

            this.userRequestPayload = new UserRequestPayload(this.request, this.sigla, this.nomeAcao, this.cadastrante);
            logger.log(BLAME, userRequestPayload);
        }

        this.exPodeRegistrarRequisicaoUsuario = null;
        UserRequestPayload.clear();
    }

}
