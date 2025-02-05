ALTER TABLE CORPORATIVO.CP_ORGAO_USUARIO ADD (ID_ORGAO_USU_INICIAL NUMBER(10,0));
ALTER TABLE CORPORATIVO.CP_ORGAO_USUARIO ADD (DT_ALTERACAO DATE);
ALTER TABLE CORPORATIVO.CP_ORGAO_USUARIO ADD (MARCO_REGULATORIO VARCHAR2(500));

ALTER TABLE CORPORATIVO.CP_ORGAO_USUARIO ADD CONSTRAINT "ORGAO_USU_INICIAL_ORGAO_USU_FK" FOREIGN KEY ("ID_ORGAO_USU_INICIAL") REFERENCES "CORPORATIVO"."CP_ORGAO_USUARIO" ("ID_ORGAO_USU") ENABLE;
 
UPDATE CORPORATIVO.CP_ORGAO_USUARIO SET ID_ORGAO_USU_INICIAL = ID_ORGAO_USU where ID_ORGAO_USU_INICIAL  is null;

CREATE SEQUENCE  CORPORATIVO.CP_ORGAO_USUARIO_SEQ  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 100000 CACHE 20 NOORDER  NOCYCLE;