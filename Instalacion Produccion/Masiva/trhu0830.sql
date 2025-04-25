--****************************************************************
--** NOMBRE SCRIPT        : trhu0830.sql
--** OBJETIVO             : Crear el trigger TRG_CBU_ID_AUTO en el esquema RHU para asignar 
--**                        automáticamente un ID a los registros insertados en la tabla 
--**                        CANDIDATE_BULK_UPLOAD utilizando la secuencia CBU_ID_SEQ.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
CREATE TABLE RHU.CANDIDATE_BULK_UPLOAD (
    CBU_ID NUMBER PRIMARY KEY,  
    CBU_IDENTIFICATION_TYPE VARCHAR2(3 BYTE) NOT NULL,  
    CBU_IDENTIFICATION_NUMBER NUMBER(20,0) NOT NULL UNIQUE,  
    CBU_EMAIL VARCHAR2(250 BYTE) NOT NULL,  
    CBU_STATUS VARCHAR2(10 BYTE) NOT NULL CHECK (CBU_STATUS IN ('PENDING', 'SENT', 'ERROR')),  
    CBU_TRANSACTION_ID NUMBER NOT NULL, 
    CBU_USER VARCHAR2(50 BYTE) NOT NULL,  
    CBU_CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
);
/
--****************************************************************
--** OBJETIVO             : Asignar todos los permisos (GRANT ALL) a la tabla RHU.CANDIDATE_BULK_UPLOAD del esquema RHU para que sean accesibles públicamente.
--****************************************************************
GRANT ALL ON RHU.CANDIDATE_BULK_UPLOAD TO PUBLIC;
/
--****************************************************************
--** OBJETIVO             : Crear las secuencias RHU.CBU_ID_SEQ en el esquema RHU para generar identificadores únicos y consecutivos para las tablas 
--**                        RHU.CANDIDATE_BULK_UPLOAD, respectivamente.
--****************************************************************
CREATE SEQUENCE RHU.CBU_ID_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE;    
/
--****************************************************************
--** OBJETIVO             : Crear los triggers RHU.CANDIDATE_BULK_UPLOAD en el esquema RHU para asignar automáticamente valores únicos a los campos CBU_ID 
--**                        mediante sus respectivas secuencias antes de cada operación INSERT.
--****************************************************************
CREATE OR REPLACE TRIGGER RHU.TRG_CBU_ID_AUTO
BEFORE INSERT ON RHU.CANDIDATE_BULK_UPLOAD
FOR EACH ROW
BEGIN
  IF :NEW.CBU_ID IS NULL THEN
    SELECT RHU.CBU_ID_SEQ.NEXTVAL INTO :NEW.CBU_ID FROM DUAL;
  END IF;
END;