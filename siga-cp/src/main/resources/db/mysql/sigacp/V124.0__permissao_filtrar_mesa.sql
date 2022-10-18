-- Permissao para usar Mesa 2 - Se já existir, não faz nada
Insert into corporativo.cp_servico (SIGLA_SERVICO, DESC_SERVICO, ID_SERVICO_PAI, ID_TP_SERVICO) 
   SELECT  'SIGA-DOC-MESA2', 'Mesa Versão 2',  max(id_servico) , '2'
   FROM corporativo.cp_servico 
   WHERE SIGLA_SERVICO = 'SIGA-DOC'
   ON DUPLICATE KEY UPDATE SIGLA_SERVICO = 'SIGA-DOC-MESA2';   
   
-- Permissao para filtrar documentos na mesa
Insert into corporativo.cp_servico (SIGLA_SERVICO, DESC_SERVICO, ID_SERVICO_PAI, ID_TP_SERVICO) 
   SELECT  'SIGA-DOC-MESA2-FILTRO', 'Permitir usar o filtro de pesquisa da mesa',  max(id_servico) , '2'
   FROM corporativo.cp_servico 
   WHERE SIGLA_SERVICO = 'SIGA-DOC-MESA2'   
   ON DUPLICATE KEY UPDATE SIGLA_SERVICO = 'SIGA-DOC-MESA2-FILTRO';

-- Permissao default para todos poderem filtrar a mesa
Insert into corporativo.cp_configuracao (HIS_DT_INI, ID_SIT_CONFIGURACAO, ID_TP_CONFIGURACAO, ID_SERVICO, HIS_IDC_INI)
	values (current_timestamp(), '1', '200', 
	(select max(ID_SERVICO) FROM corporativo.cp_servico WHERE SIGLA_SERVICO = 'SIGA-DOC-MESA2-FILTRO'), '1');

