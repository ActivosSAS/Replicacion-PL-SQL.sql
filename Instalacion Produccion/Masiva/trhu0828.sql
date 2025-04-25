--****************************************************************
--** NOMBRE SCRIPT        : trhu0828.sql
--** OBJETIVO             : Crear la tabla Replication_Config en el esquema RHU para almacenar la configuración de replicación entre la base de datos local y GCP.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
--SELECT * FROM RHU.Replication_Config;
CREATE TABLE RHU.Replication_Config (
    ID_CONFIG VARCHAR2(100),                
    LOCAL_TABLE_REF VARCHAR2(100),          
    GCP_TABLE_REF VARCHAR2(100),            
    STATUS_RC VARCHAR2(50) NOT NULL,        
    CONSTRAINT PK_ID_CONFIG PRIMARY KEY (ID_CONFIG) 
);
/
--****************************************************************
--** OBJETIVO             : Asignar todos los permisos (GRANT ALL) a la tabla Replication_Detail y Replication_Config del esquema RHU para que sean accesibles públicamente.
--****************************************************************
GRANT ALL ON RHU.Replication_Config TO PUBLIC;
/
--****************************************************************
--** OBJETIVO             : Crear las secuencias Replication_Detail_SEQ y Replication_Config_SEQ en el esquema RHU para generar identificadores únicos y consecutivos para las tablas 
--**                        Replication_Detail y Replication_Config, respectivamente.
--****************************************************************
CREATE SEQUENCE RHU.Replication_Config_SEQ
    START WITH 1                           
    INCREMENT BY 1                         
    NOCACHE;   
/
--****************************************************************
--** OBJETIVO             : Crear los triggers Replication_Detail_BI y Replication_Config_BI en el esquema RHU para asignar automáticamente valores únicos a los campos ID_RD e ID_CONFIG 
--**                        mediante sus respectivas secuencias antes de cada operación INSERT.
--****************************************************************
CREATE OR REPLACE TRIGGER RHU.Replication_Config_BI
BEFORE INSERT ON RHU.Replication_Config    
FOR EACH ROW                                
BEGIN    
    IF :NEW.ID_CONFIG IS NULL THEN
        SELECT RHU.Replication_Config_SEQ.NEXTVAL INTO :NEW.ID_CONFIG FROM DUAL;
    END IF;
END;