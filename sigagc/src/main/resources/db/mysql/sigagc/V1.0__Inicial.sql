CREATE DATABASE  IF NOT EXISTS `sigagc` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sigagc`;

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `gc_acesso`
--

DROP TABLE IF EXISTS `gc_acesso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_acesso` (
  `id_acesso` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome_acesso` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_acesso`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_arquivo`
--

DROP TABLE IF EXISTS `gc_arquivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_arquivo` (
  `id_conteudo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `classificacao` varchar(4000) COLLATE utf8_bin DEFAULT NULL,
  `conteudo` longblob,
  `conteudo_tipo` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `titulo` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id_conteudo`)
) ENGINE=InnoDB AUTO_INCREMENT=4836 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_configuracao`
--

DROP TABLE IF EXISTS `gc_configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_configuracao` (
  `id_configuracao_gc` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_tipo_informacao` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_configuracao_gc`),
  KEY `fk5b6c283297a881ad` (`id_tipo_informacao`),
  CONSTRAINT `fk5b6c283297a881ad` FOREIGN KEY (`id_tipo_informacao`) REFERENCES `gc_tipo_informacao` (`id_tipo_informacao`),
  CONSTRAINT `fk5b6c2832f6a487c3` FOREIGN KEY (`id_configuracao_gc`) REFERENCES `corporativo`.`cp_configuracao` (`id_configuracao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_informacao`
--

DROP TABLE IF EXISTS `gc_informacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_informacao` (
  `id_informacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ano` INT UNSIGNED DEFAULT NULL,
  `dt_elaboracao_fim` datetime(6) DEFAULT NULL,
  `his_dt_fim` datetime(6) DEFAULT NULL,
  `his_dt_ini` datetime(6) DEFAULT NULL,
  `numero` INT UNSIGNED DEFAULT NULL,
  `id_arquivo` INT UNSIGNED NOT NULL,
  `id_pessoa_titular` INT UNSIGNED NOT NULL,
  `id_acesso_edicao` INT UNSIGNED NOT NULL,
  `his_idc_ini` INT UNSIGNED NOT NULL,
  `id_informacao_pai` INT UNSIGNED DEFAULT NULL,
  `id_lotacao_titular` INT UNSIGNED NOT NULL,
  `id_orgao_usuario` INT UNSIGNED NOT NULL,
  `id_tipo_informacao` INT UNSIGNED NOT NULL,
  `id_acesso` INT UNSIGNED NOT NULL,
  `id_grupo` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_informacao`),
  KEY `fk8b6611fc97a881ad` (`id_tipo_informacao`),
  KEY `fk8b6611fc8deefe82` (`id_acesso_edicao`),
  KEY `fk8b6611fc14a981c` (`id_acesso`),
  KEY `fk8b6611fc5c8d8b16` (`id_arquivo`),
  KEY `fk8b6611fc9139cd43` (`id_informacao_pai`),
  KEY `fk8b6611fcfc20d6a3` (`his_idc_ini`),
  KEY `fk8b6611fc4a634b1a` (`id_lotacao_titular`),
  KEY `fk8b6611fcc8778546` (`id_pessoa_titular`),
  KEY `fk8b6611fce2b26866` (`id_orgao_usuario`),
  KEY `gc_informacao_grupo_fk` (`id_grupo`),
  CONSTRAINT `fk8b6611fc14a981c` FOREIGN KEY (`id_acesso`) REFERENCES `gc_acesso` (`id_acesso`),
  CONSTRAINT `fk8b6611fc4a634b1a` FOREIGN KEY (`id_lotacao_titular`) REFERENCES `corporativo`.`dp_lotacao` (`id_lotacao`),
  CONSTRAINT `fk8b6611fc5c8d8b16` FOREIGN KEY (`id_arquivo`) REFERENCES `gc_arquivo` (`id_conteudo`),
  CONSTRAINT `fk8b6611fc8deefe82` FOREIGN KEY (`id_acesso_edicao`) REFERENCES `gc_acesso` (`id_acesso`),
  CONSTRAINT `fk8b6611fc9139cd43` FOREIGN KEY (`id_informacao_pai`) REFERENCES `gc_arquivo` (`id_conteudo`),
  CONSTRAINT `fk8b6611fc97a881ad` FOREIGN KEY (`id_tipo_informacao`) REFERENCES `gc_tipo_informacao` (`id_tipo_informacao`),
  CONSTRAINT `fk8b6611fcc8778546` FOREIGN KEY (`id_pessoa_titular`) REFERENCES `corporativo`.`dp_pessoa` (`id_pessoa`),
  CONSTRAINT `fk8b6611fce2b26866` FOREIGN KEY (`id_orgao_usuario`) REFERENCES `corporativo`.`cp_orgao_usuario` (`id_orgao_usu`),
  CONSTRAINT `fk8b6611fcfc20d6a3` FOREIGN KEY (`his_idc_ini`) REFERENCES `corporativo`.`cp_identidade` (`id_identidade`),
  CONSTRAINT `gc_informacao_grupo_fk` FOREIGN KEY (`id_grupo`) REFERENCES `corporativo`.`cp_grupo` (`id_grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=4831 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_movimentacao`
--

DROP TABLE IF EXISTS `gc_movimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_movimentacao` (
  `id_movimentacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `his_dt_ini` datetime(6) DEFAULT NULL,
  `id_conteudo` INT UNSIGNED DEFAULT NULL,
  `his_idc_ini` INT UNSIGNED NOT NULL,
  `id_informacao` INT UNSIGNED NOT NULL,
  `id_lotacao_atendente` INT UNSIGNED DEFAULT NULL,
  `id_lotacao_titular` INT UNSIGNED DEFAULT NULL,
  `id_movimentacao_canceladora` INT UNSIGNED DEFAULT NULL,
  `id_movimentacao_ref` INT UNSIGNED DEFAULT NULL,
  `id_pessoa_atendente` INT UNSIGNED DEFAULT NULL,
  `id_pessoa_titular` INT UNSIGNED DEFAULT NULL,
  `id_tipo_movimentacao` INT UNSIGNED NOT NULL,
  `descricao` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `id_papel` INT UNSIGNED DEFAULT NULL,
  `id_grupo` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_movimentacao`),
  KEY `fk3157f386d38b6636` (`id_informacao`),
  KEY `fk3157f386e56b561e` (`id_movimentacao_ref`),
  KEY `fk3157f3864101359e` (`id_conteudo`),
  KEY `fk3157f386a3658f2c` (`id_movimentacao_canceladora`),
  KEY `fk3157f3861debb381` (`id_tipo_movimentacao`),
  KEY `mov_papel_fk` (`id_papel`),
  KEY `fk3157f386fc20d6a3` (`his_idc_ini`),
  KEY `fk3157f386c8778546` (`id_pessoa_titular`),
  KEY `fk3157f3864a634b1a` (`id_lotacao_titular`),
  KEY `fk3157f386bc9a64c1` (`id_pessoa_atendente`),
  KEY `fk3157f3869b156615` (`id_lotacao_atendente`),
  KEY `mov_grupo_fk` (`id_grupo`),
  CONSTRAINT `fk3157f3861debb381` FOREIGN KEY (`id_tipo_movimentacao`) REFERENCES `gc_tipo_movimentacao` (`id_tipo_movimentacao`),
  CONSTRAINT `fk3157f3864101359e` FOREIGN KEY (`id_conteudo`) REFERENCES `gc_arquivo` (`id_conteudo`),
  CONSTRAINT `fk3157f3864a634b1a` FOREIGN KEY (`id_lotacao_titular`) REFERENCES `corporativo`.`dp_lotacao` (`id_lotacao`),
  CONSTRAINT `fk3157f3869b156615` FOREIGN KEY (`id_lotacao_atendente`) REFERENCES `corporativo`.`dp_lotacao` (`id_lotacao`),
  CONSTRAINT `fk3157f386a3658f2c` FOREIGN KEY (`id_movimentacao_canceladora`) REFERENCES `gc_movimentacao` (`id_movimentacao`),
  CONSTRAINT `fk3157f386bc9a64c1` FOREIGN KEY (`id_pessoa_atendente`) REFERENCES `corporativo`.`dp_pessoa` (`id_pessoa`),
  CONSTRAINT `fk3157f386c8778546` FOREIGN KEY (`id_pessoa_titular`) REFERENCES `corporativo`.`dp_pessoa` (`id_pessoa`),
  CONSTRAINT `fk3157f386d38b6636` FOREIGN KEY (`id_informacao`) REFERENCES `gc_informacao` (`id_informacao`),
  CONSTRAINT `fk3157f386e56b561e` FOREIGN KEY (`id_movimentacao_ref`) REFERENCES `gc_movimentacao` (`id_movimentacao`) ON DELETE SET NULL,
  CONSTRAINT `fk3157f386fc20d6a3` FOREIGN KEY (`his_idc_ini`) REFERENCES `corporativo`.`cp_identidade` (`id_identidade`),
  CONSTRAINT `mov_grupo_fk` FOREIGN KEY (`id_grupo`) REFERENCES `corporativo`.`cp_grupo` (`id_grupo`),
  CONSTRAINT `mov_papel_fk` FOREIGN KEY (`id_papel`) REFERENCES `gc_papel` (`id_papel`)
) ENGINE=InnoDB AUTO_INCREMENT=4843 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_papel`
--

DROP TABLE IF EXISTS `gc_papel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_papel` (
  `id_papel` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `desc_papel` varchar(40) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_papel`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_tag`
--

DROP TABLE IF EXISTS `gc_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_tag` (
  `id_tag` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `categoria` varchar(20) COLLATE utf8_bin DEFAULT NULL,
  `titulo` varchar(256) COLLATE utf8_bin DEFAULT NULL,
  `tipo_id_tipo_tag` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_tag`),
  KEY `fk7d04ad97f23572ce` (`tipo_id_tipo_tag`),
  CONSTRAINT `fk7d04ad97f23572ce` FOREIGN KEY (`tipo_id_tipo_tag`) REFERENCES `gc_tipo_tag` (`id_tipo_tag`)
) ENGINE=InnoDB AUTO_INCREMENT=4718 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_tag_x_informacao`
--

DROP TABLE IF EXISTS `gc_tag_x_informacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_tag_x_informacao` (
  `id_informacao` INT UNSIGNED NOT NULL,
  `id_tag` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id_informacao`,`id_tag`),
  KEY `fk6dcf9ea8635922f0` (`id_tag`),
  CONSTRAINT `fk6dcf9ea8635922f0` FOREIGN KEY (`id_tag`) REFERENCES `gc_tag` (`id_tag`),
  CONSTRAINT `fk6dcf9ea8d38b6636` FOREIGN KEY (`id_informacao`) REFERENCES `gc_informacao` (`id_informacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_tipo_informacao`
--

DROP TABLE IF EXISTS `gc_tipo_informacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_tipo_informacao` (
  `id_tipo_informacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome_tipo_informacao` varchar(255) COLLATE utf8_bin NOT NULL,
  `arquivo` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_tipo_informacao`),
  KEY `tipo_informacao_arquivo_fk` (`arquivo`),
  CONSTRAINT `tipo_informacao_arquivo_fk` FOREIGN KEY (`arquivo`) REFERENCES `gc_arquivo` (`id_conteudo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_tipo_movimentacao`
--

DROP TABLE IF EXISTS `gc_tipo_movimentacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_tipo_movimentacao` (
  `id_tipo_movimentacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome_tipo_movimentacao` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tipo_movimentacao`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gc_tipo_tag`
--

DROP TABLE IF EXISTS `gc_tipo_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `gc_tipo_tag` (
  `id_tipo_tag` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome_tipo_tag` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tipo_tag`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ht_cp_configuracao`
--

DROP TABLE IF EXISTS `ht_cp_configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ht_cp_configuracao` (
  `id_configuracao` INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ht_gc_configuracao`
--

DROP TABLE IF EXISTS `ht_gc_configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ht_gc_configuracao` (
  `id_configuracao_gc` INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ri_atualizacao`
--

DROP TABLE IF EXISTS `ri_atualizacao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ri_atualizacao` (
  `id_atualizacao` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `desempate_atualizacao` INT UNSIGNED DEFAULT NULL,
  `nome_atualizacao` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `sigla_atualizacao` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `dt_ultima_atualizacao` datetime(6) DEFAULT NULL,
  `url_atualizacao` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id_atualizacao`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ri_configuracao`
--

DROP TABLE IF EXISTS `ri_configuracao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ri_configuracao` (
  `id_configuracao_ri` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_configuracao_ri`),
  CONSTRAINT `fk830c72b7f6a4891e` FOREIGN KEY (`id_configuracao_ri`) REFERENCES `corporativo`.`cp_configuracao` (`id_configuracao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'sigagc'
--
drop function if exists remove_acento;
delimiter //
create function remove_acento( textvalue varchar(20000) )
returns varchar(20000) DETERMINISTIC
begin

set @textvalue = textvalue;

-- ACCENTS
set @withaccents = 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿþƒ';
set @withoutaccents = 'SsZzAAAAAAACEEEEIIIINOOOOOOUUUUYYBaaaaaaaceeeeiiiinoooooouuuuyybf';
set @count = length(@withaccents);

while @count > 0 do
    set @textvalue = replace(@textvalue, substring(@withaccents, @count, 1), substring(@withoutaccents, @count, 1));
    set @count = @count - 1;
end while;

-- SPECIAL CHARS
set @special = '!@#$%¨&*()_+=§¹²³£¢¬"`´{[^~}]<,>.:;?/°ºª+*|\\''';
set @count = length(@special);
while @count > 0 do
    set @textvalue = replace(@textvalue, substring(@special, @count, 1), '');
    set @count = @count - 1;
end while;

return @textvalue;

end;//
DELIMITER ;

INSERT INTO `sigagc`.`gc_tipo_informacao` (`id_tipo_informacao`, `nome_tipo_informacao`) VALUES ('1', 'Registro de Conhecimento');
INSERT INTO `sigagc`.`gc_tipo_informacao` (`id_tipo_informacao`, `nome_tipo_informacao`) VALUES ('2', 'Erro Conhecido');
INSERT INTO `sigagc`.`gc_tipo_informacao` (`id_tipo_informacao`, `nome_tipo_informacao`) VALUES ('3', 'Procedimento');
INSERT INTO `sigagc`.`gc_tipo_informacao` (`id_tipo_informacao`, `nome_tipo_informacao`) VALUES ('4', 'Processo de Trabalho');

insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Criação', 1);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Concluído', 2);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Cancelado', 3);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Solicitação de revisão', 4);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Revisado', 5);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Notificação', 6);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Ciente', 7);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Classificação', 8);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Interesse', 9);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Edição', 10);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Visita', 11);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Cancelamento de movimentação', 12);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Anexação de arquivo', 13);
insert into sigagc.gc_tipo_movimentacao (NOME_TIPO_MOVIMENTACAO, ID_TIPO_MOVIMENTACAO) values ('Duplicado', 14);
insert into sigagc.gc_tipo_movimentacao (ID_TIPO_MOVIMENTACAO, NOME_TIPO_MOVIMENTACAO) values (15, 'Definição de Perfil');

insert into sigagc.gc_tipo_tag (NOME_TIPO_TAG, ID_TIPO_TAG) values ('Classificação', 1);
insert into sigagc.gc_tipo_tag (NOME_TIPO_TAG, ID_TIPO_TAG) values ('Marcador', 2);
insert into sigagc.gc_tipo_tag (NOME_TIPO_TAG, ID_TIPO_TAG) values ('Âncora', 3);

insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Ostensivo', 0);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Público', 1);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Restrito ao órgão', 2);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Lotação e superiores', 3);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Lotação e inferiores', 4);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Lotação', 5);
insert into sigagc.gc_acesso (NOME_ACESSO, ID_ACESSO) values ('Pessoal', 6);
insert into sigagc.gc_acesso values (7, 'Lotação e Grupo');

insert into sigagc.gc_papel(id_papel, desc_papel) values (2, 'Executor');
insert into sigagc.gc_papel(id_papel, desc_papel) values (1, 'Interessado');



--
-- Dumping routines for database 'corporativo'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-25 11:23:06
