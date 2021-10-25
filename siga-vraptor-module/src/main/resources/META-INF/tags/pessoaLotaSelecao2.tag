<%@ tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://localhost/jeetags" prefix="siga"%>
<%@ taglib uri="http://localhost/libstag" prefix="f"%>

<%@ attribute name="propriedadePessoa" required="true"%>
<%@ attribute name="propriedadeLotacao" required="true"%>
<%@ attribute name="propriedadeEmail" required="false"%>
<%@ attribute name="disabled" required="false"%>
<%@ attribute name="labelPessoaLotacao" required="false"%>
<%@ attribute name="hideLabels" required="false" type="java.lang.Boolean"%>


<c:set var="propriedadePessoaClean"
	value="${f:slugify(propriedadePessoa,true,true)}" />
<c:set var="propriedadeLotacaoClean"
	value="${f:slugify(propriedadeLotacao,true,true)}" />
<c:set var="propriedadeEmailClean"
	value="${f:slugify(propriedadeEmail,true,true)}" />

<c:set var="desativar" value="nao"></c:set>
<c:if test="${disabled == 'sim'}">
	<c:set var="pessoaLotaSelecaoDisabled" value="disabled='disabled'"
		scope="request" />
	<c:set var="desativar" value="sim"></c:set>
</c:if>


<!-- com: Pessoa ou Lotacao  -->
<div class="row">
	<div class="col-sm-3">
		<div class="form-group">
			<c:if test="${hideLabels != true}">
				<label>${not empty labelPessoaLotacao ? labelPessoaLotacao : 'Tipo'}</label>
			</c:if>
			<select id="${propriedadePessoaClean}${propriedadeLotacaoClean}"
				onchange="javascript:alteraAtendente_${propriedadePessoaClean}();" ${pessoaLotaSelecaoDisabled} class="form-control">
				<option value="1">Pessoa</option>
				<option value="2">Lotação</option>
				<c:if test="${not empty propriedadeEmail}">
					<option value="3">E-mail</option>
				</c:if>
			</select>
		</div>
	</div>
	<div class="col-sm-9">
		<!-- Matricula -->
		<div id="spanPessoa${propriedadePessoaClean}" class="form-group">
			<c:if test="${hideLabels != true}">
				<label>Pessoa</label> 
			</c:if>
			<siga:selecao3
				tipo="pessoa" propriedade="${propriedadePessoa}" tema="simple"
				modulo="siga" desativar="${desativar}" />
		</div>
		
		<!-- Lotacao -->
		<div id="spanLotacao${propriedadeLotacaoClean}" class="form-group" style="display: none">
			<c:if test="${hideLabels != true}">
				<label>Lotação</label> 
			</c:if>
			<siga:selecao3
				tipo="lotacao" propriedade="${propriedadeLotacao}" tema="simple"
				modulo="siga" desativar="${desativar}" />
		</div>
	</div>
</div>



<c:if test="${not empty propriedadeEmail}">
	<c:set var="inputNameEmail" value="${propriedadeEmail}" />
</c:if>
<span style="display: none;" id="spanEmail${propriedadeEmailClean}">
	<input type='text' name='${inputNameEmail}' size="70"
	id="formulario_${propriedadeEmailClean}" /> Obs.: Ao informar
	v&aacute;rios, separar por espa&ccedil;o.
</span>



<script language="javascript">

	var select = document.getElementById('${propriedadePessoaClean}${propriedadeLotacaoClean}');

	// Seta opcao Pessoa se id da pessoa estiver presente. Caso contrario seta Lotacao no 'select':
	//if (document.getElementById('formulario_${propriedadePessoaClean}_id').value)
	if(get_${propriedadePessoaClean}_by_id().value) 
		select.value = 1;
	else
		select.value = 2;

	// Exibe o campo siga:select correto (pessoa ou lotacao):
	alteraAtendente_${propriedadePessoaClean}();
	
	// O onchange tem de ser definido da forma abaixo porque, quando esta tag está dentro de um código
	// carregado por ajax, não funciona o tratamento do modo tradicional (onchange="", etc)
	// http://stackoverflow.com/questions/8893786/uncaught-referenceerror-x-is-not-defined
	
	/*
	select.onchange = function() {
		var select = document
				.getElementById('${propriedadePessoaClean}${propriedadeLotacaoClean}');

		if (select.value == '1') {
			document.getElementById('spanLotacao${propriedadeLotacaoClean}').style.display = 'none';
			document.getElementById('spanPessoa${propriedadePessoaClean}').style.display = 'inline';
			document.getElementById('formulario_${propriedadeLotacaoClean}_id').value = '';
			document
					.getElementById('formulario_${propriedadeLotacaoClean}_sigla').value = '';
			document
					.getElementById('formulario_${propriedadeLotacaoClean}_descricao').value = '';

			document.getElementById('${propriedadeLotacaoClean}Span').innerHTML = '';

			document.getElementById('spanEmail${propriedadeEmailClean}').style.display = 'none';
			document.getElementById('formulario_${propriedadeEmailClean}').value = '';
		} else if (select.value == '2') {
			document.getElementById('spanPessoa${propriedadePessoaClean}').style.display = 'none';
			document.getElementById('spanLotacao${propriedadeLotacaoClean}').style.display = 'inline';
			document.getElementById('formulario_${propriedadePessoaClean}_id').value = '';
			document
					.getElementById('formulario_${propriedadePessoaClean}_sigla').value = '';
			document
					.getElementById('formulario_${propriedadePessoaClean}_descricao').value = '';
			document.getElementById('${propriedadePessoaClean}Span').innerHTML = '';

			document.getElementById('spanEmail${propriedadeEmailClean}').style.display = 'none';
			document.getElementById('formulario_${propriedadeEmailClean}').value = '';
		} else if (select.value == '3') {
			document.getElementById('spanLotacao${propriedadeLotacaoClean}').style.display = 'none';
			document.getElementById('formulario_${propriedadeLotacaoClean}_id').value = '';
			document
					.getElementById('formulario_${propriedadeLotacaoClean}_sigla').value = '';
			document
					.getElementById('formulario_${propriedadeLotacaoClean}_descricao').value = '';
			document.getElementById('${propriedadeLotacaoClean}Span').innerHTML = '';

			document.getElementById('spanPessoa${propriedadePessoaClean}').style.display = 'none';
			document.getElementById('formulario_${propriedadePessoaClean}_id').value = '';
			document
					.getElementById('formulario_${propriedadePessoaClean}_sigla').value = '';
			document
					.getElementById('formulario_${propriedadePessoaClean}_descricao').value = '';

			document.getElementById('${propriedadePessoaClean}Span').innerHTML = '';

			document.getElementById('spanEmail${propriedadeEmailClean}').style.display = 'inline';
		}
	}
	select.onchange();
	*/

	function alteraAtendente_${propriedadePessoaClean}() {
		const idSelect = '${propriedadePessoaClean}${propriedadeLotacaoClean}';
		const idPessoa = "spanPessoa${propriedadePessoaClean}";
		const idLotacao = "spanLotacao${propriedadeLotacaoClean}";
		const idEmail = "spanEmail${propriedadeEmailClean}";

		var objSelecionado = document.getElementById(idSelect);
	
		switch (parseInt(objSelecionado.value)) {
		case 1:
			// Exibe as entradas para pessoa e esconde as entradas para lotacao:
			document.getElementById(idPessoa).style.display = '';
			document.getElementById(idLotacao).style.display = 'none';

			// Apaga as informacoes da lotacao selecionada:
			limpa_${propriedadeLotacaoClean}();
			break;
		case 2:
			// Exibe as entradas para lotacao e esconde as entradas para pessoa:
			document.getElementById(idPessoa).style.display = 'none';
			document.getElementById(idLotacao).style.display = '';

			// Apaga as informacoes da pessoa selecionada:
			limpa_${propriedadePessoaClean}();
			break;
		case 3:
			// Exibe as entradas para lotacao e esconde as entradas para pessoa:
			document.getElementById(idPessoa).style.display = 'none';
			document.getElementById(idLotacao).style.display = 'none';
			document.getElementById(idEmail).style.display = '';

			// Apaga as informacoes da pessoa selecionada:
			limpa_${propriedadePessoaClean}();
			limpa_${propriedadeLotacaoClean}();
			break;
		}	
	}
</script>