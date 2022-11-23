#
# *******************************************************************************
# * PCRJ     - Prefeitura da cidade do Rio de Janeiro                           *
# * SEGOVI   - Secretaria de Governo (cliente)                                  *
# * IPLANRIO - Empresa Municipal de Inform�tica                                 *
# *                                                                             *
# * Supervisor: Ivan Gon�alves Silv�rio                                         *
# *                                                                             *
# * Autor: Jorge Lu�s de Oliveira Borges                                        *
# * Nota: a primeira vers�o deste programa foi feita pela DOP em 2020.          *
# *                                                                             *
# * E-mails: (ivan.silverio, jborges)@rio.rj.gov.br                             *
# *                                                                             *
# * Data: 08 de dezembro de 2021                                                *
# *                                                                             *
# * Objetivo: Efetua a carga do usu�rios do processo.rio.                       *
# *                                                                             *
# * � Copyright 2000-2022 Jorge Lu�s de Oliveira Borges.                        *
# *                                                                             *
# *   Respeite os direitos autorais.                                            *
# *                                                                             *
# *                                         Ana Beatriz Barbosa Silva:          *
# *                                              "A vida � bumerangue:          *
# *                                               tudo que vem tem volta." :)   *
# *                                                                             *
# *******************************************************************************
#
# Rotina de carga dos XMLs propriamente dita
carga_XMLs(){
    local FileName=$1
    echo $FileName
  
	ThisSigla="${FileName%%.*}"
	ThisXML="${BASE}/xmls/${ThisSigla}.XML"
	ThisLogPreCarga="${BASE}/logs/${ThisSigla}_pre_carga.log"
	ThisLogCarga="${BASE}/logs/${ThisSigla}.log"

#   Testa se a carga do arquivo XML ser� bem sucedida, porem n�o efetua as atualiza��es.
    curl --noproxy '*' ${sitio1} -H "Authorization: ${chave}" -F file=@${ThisXML} "${sitio2}?sigla=${ThisSigla}&maxSinc=100000&modoLog=true" 1> ${ThisLogPreCarga} 2>&1

    ThisExcluidos=`egrep -ic excluindo ${ThisLogPreCarga}`
	ThisPessoas=`egrep -ic 'pessoa ' ${ThisXML}`
	ThisLogPreCarga_atualizacoes=`egrep -ic atualizando ${ThisLogPreCarga}`
#   Verifica a carga foi bem sucedida, ou n�o.
#   Verifica se o layout � de uma carga mesmo ou se � apenas o relat�rio de erro.
    certo=`egrep -ic "Total de altera.*es" $ThisLogPreCarga`
    layout=`egrep -ic "XML confirma .*rg.*o usu.*rio" $ThisLogPreCarga`
# 1 liga o certo, 0 desliga o certo (errado)
#   certo=1; layout=1  # Efetua a carga na for�a bruta
    echo -e "${ThisSigla} modo log: $certo"
# 1 informa que � o log do aplicativo de carga (API REST), 0 trata-se do relat�rio do 'parsing'
    echo -e "Layout $layout"
    echo -e "ThisExcluidos $ThisExcluidos, ThisPessoas $ThisPessoas, ThisLogPreCarga_atualizacoes $ThisLogPreCarga_atualizacoes"
    
#   continue

#   se o certo est� ligado, efetua a carga sabendo o gabarito previamente.
#   o layout define que trata-se do layout da carga do aplicativo (1) contrapondo-se ao layout de erro de parsing (0)
    if [[ $certo -ne 0 && $layout -ne 0 ]]; then
#      if [[ $ThisExcluidos -ge $ThisPessoas ]]; then
#      if [[ $ThisPessoas   -lt $ThisExcluidos ]]; then
       if [[ $ThisPessoas   -gt $ThisExcluidos || $ThisSigla = "INV777" ]]; then 
#         efetua a carga propriamente dita	
          curl --noproxy '*' ${sitio1} -H "Authorization: ${chave}" -F file=@${ThisXML} "${sitio2}?sigla=${ThisSigla}&maxSinc=100000&modoLog=false" 1> ${ThisLogCarga} 2>&1

          echo -e "Arquivo ${ThisXML} processado com sucesso!!!\n"
#         apaga arquivos tempor�rios para n�o ter problemas de espa�o em disco.	   
          rm -f /tmp/*.data
          rm -f /tmp/*.ehcache-diskstore.lock
       else # avisa que detectou uma incoer�ncia no arquivo XML
#         echo -e "\n\n\n\nO arquivo ${ThisXML} veio com ${ThisPessoas} pessoas, e na pre-carga constam ${ThisExcluidos} exclusoes, ${ambiente}. \n\n\n O arquivo em tela necessita de conferencia manual.\n" | mail -s "Processo rio, ${ambiente}, alerta de carga com muitas exclusoes. ${ThisSigla}" jborges@rio.rj.gov.br
          echo -e "\n\n\n\nO arquivo ${ThisXML} veio com ${ThisPessoas} pessoas, e na pre-carga constam ${ThisExcluidos} exclusoes, ${ambiente}. \n\n\n O arquivo em tela necessita de conferencia manual.\n" | mailx -s "Processo rio, ${ambiente}, alerta de carga com muitas exclusoes. ${ThisSigla}" -a ${ThisLogPreCarga}  ${e_correio_erros}
          echo -e "O arquivo ${ThisXML} nao foi processado pois contem erros!!!\n" 1> ${ThisLogCarga} 2>&1
          nl -bn ${ThisLogCarga}

       fi
         
    else
            echo -e "O arquivo ${ThisXML} nao foi processado pois contem erros!!!\n" 1> ${ThisLogCarga} 2>&1
            nl -bn ${ThisLogCarga}
    fi
  
}

# =================
#  inicio do main
# =================
# declara��o de vari�veis
BASE="/opt/java/xml_processo_rio"
JAVA_HOME="/usr/java/jdk1.7.0_71"
JAVA_OPTS="-Dsiga.properties.file=${BASE}/bin/siga.properties"
JAVA_FILE="${BASE}/bin/siga-cp-sinc.one-jar.jar" 
export JAVA_HOME

tempo1=`date`
now="date +%Y-%m-%d_%Hh%Mm%Ss_$RANDOM"
NroDias=180
CargaUnica=""


# Inclui os par�metros deste ambiente.
source ${BASE}/bin/parametros.sh

# testa se o tipo de carga � completa, ou de uma �nica secretaria.
if [[ -z ${1} ]]
then
        # RHUPAG
#       mv ${BASE}/xmls/IC.XML ${BASE}/zips/IC.XXMMLL_`$now`
#       mv ${BASE}/xmls/TUR.XML ${BASE}/zips/TUR.XXMMLL_`$now`
#       mv ${BASE}/xmls/ZOO.XML ${BASE}/zips/ZOO.XXMMLL_`$now`
#       mv ${BASE}/xmls/CEN.XML ${BASE}/zips/CEN.XXMMLL_`$now`
  
#       mv ${BASE}/xmls/SME.XML ${BASE}/zips/SME.XML_`$now`
        mv ${BASE}/xmls/XXX.XML ${BASE}/zips/XXX.XML_`$now`
        mv ${BASE}/xmls/ServidoresSemUABasica.XML ${BASE}/zips/ServidoresSemUABasica.XML_`$now`
        mv ${BASE}/xmls/ServidoresDemUABasica.XML ${BASE}/zips/ServidoresDemUABasica.XML_`$now`

        SEARCH="${BASE}/xmls/*.xml ${BASE}/xmls/*.XML"
        rm -f ${BASE}/logs/*.log
#		Passa um email de in�cio da carga quando a carga � completa.
        echo -e "\n\n\n\nFoi iniciada uma carga completa no sistema processo.rio, ${ambiente}.\n\n inicio: $tempo1 \n\n`ls -l ${BASE}/xmls/*.XML | nl`" | mail -s "Processo rio, ${ambiente}. Aviso de inicio da carga completa." ${e_correio} &

else
        SEARCH="${BASE}/xmls/${1}"
		CargaUnica="${1}"
fi

# Efetua a carga para a(s) secretarias selecionadas.
for F in $( ls -1rS ${SEARCH} )
do
    FN=${F##*/}
  	carga_XMLs $FN # coloca a fun��o em background
done

wait # aguarda todos as trheads completarem os seus respectivos processamentos.

# Passa um email informado dados do fim da carga
echo -e "\n\n\n\nConcluida uma carga no sistema processo.rio, ${ambiente}. \n\nInicio : $tempo1, \nTermino: `date` \n\n\n Os arquivos abaixo necessitam de conferencia manual:\n`egrep -ic "Total de altera.*es" ${BASE}/logs/*.log | egrep '\:0' | sort | nl`" | mail -s "Processo rio, ${ambiente}. Aviso de conclusao de carga. ${CargaUnica}" ${e_correio} &

# Apaga os arquivos compactados mais velhos do que o valor informado em dias.
find ${BASE}/zips -maxdepth 1 -mtime +${NroDias} -exec rm {} \; &

# Apaga os arquivos da SME mais velhos do que o valor informado em dias.
# find ${BASE}/xmls -maxdepth 1 -mtime +${NroDias} -name SME.XML_20*  -exec rm {} \; &
# find ${BASE}/zips -maxdepth 1 -mtime +${NroDias} -name ${BASE}/zips/ServidoresDemUABasica.XML_20* -exec rm {} \; &
# find ${BASE}/zips -maxdepth 1 -mtime +${NroDias} -name ${BASE}/zips/CEN.XXMMLL_20*  -exec rm {} \; &
# find ${BASE}/xmls -maxdepth 1 -mtime +3 name *.XML  -exec rm {} \; &

if [[ -z ${1} ]]
then
#   No caso de haver uma carga completa, salvaguarda os arquivos de carga e os seus logs
    tar -czf ${BASE}/zips/XML_`$now`.tgz ${BASE}/xmls/*.XML &
#   tar -czf ${BASE}/zips/XXMMLL_`$now`.tgz ${BASE}/xmls/*.XXMMLL_20* &
    tar -czf ${BASE}/zips/LOG_`$now`.tgz ${BASE}/logs/*.log &

fi

# 'destroi' as vari�veis
unset certo
unset layout

unset chave
unset sitio1
unset sitio2
unset e_correio
unset e_correio_erros

# aguarda at� que seus processos-filhos tenham finalizado.
wait
#
exit 0

#
# ******************************************************************************* 
# *                                    FIM                                      *
# *******************************************************************************
#

# mail -s "Teste" jborges@rio.rj.gov.br <<< "\n\n\n texto do corpo do email `ls -l /opt/java/xml_processo_rio/logs/*.log | nl`"
# mail -s "Teste" jborges@rio.rj.gov.br <<< "`echo;echo;echo` texto do corpo do email `echo; ls -l /opt/java/xml_processo_rio/logs/*.log | nl; echo`"
# mailx -s "Processo rio, ${ambiente}, rela��o dos arquivos XMLs apagados antes da carga." jborges@rio.rj.gov.br <<< "`echo;echo;echo` texto do corpo do email `echo; ls -l ${BASE}/xmls/*.XML | nl; echo; echo`"
		  