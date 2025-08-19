--****************************************************************
--** NOMBRE SCRIPT        : trhu0829.sql
--** OBJETIVO             : Crear la tabla Replication_Detail en el esquema RHU para almacenar los detalles de replicación, incluyendo información del documento y datos en formato JSON, 
--**                        relacionados con la configuración de replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
CREATE TABLE RHU.Replication_Detail (
    ID_RD NUMBER,                           
    DOCUMENT_TYPE VARCHAR2(100),            
    DOCUMENT_NUMBER VARCHAR2(100),          
    ID_CONFIG VARCHAR2(100),                
    STATE_RD VARCHAR2(50) NOT NULL,         
    DATA_JSON CLOB,                         
    DATE_RD VARCHAR2(50),                   
    USER_RD VARCHAR2(100),                  
    DESCRIPTION_RD	VARCHAR2(4000),
    CONSTRAINT FK_ID_CONFIG FOREIGN KEY (ID_CONFIG)
    REFERENCES RHU.Replication_Config (ID_CONFIG) ON DELETE CASCADE -- Relationship with Replication_Config
);
/
--****************************************************************
--** OBJETIVO             : Asignar todos los permisos (GRANT ALL) a la tabla Replication_Detail y Replication_Config del esquema RHU para que sean accesibles públicamente.
--****************************************************************
GRANT ALL ON RHU.Replication_Detail TO PUBLIC;
/
--****************************************************************
--** OBJETIVO             : Agregar la clave primaria PK_Replication_Detail a la tabla Replication_Detail en el esquema RHU, asegurando la unicidad de los registros basados en el campo ID_RD.
--****************************************************************
ALTER TABLE RHU.Replication_Detail
ADD CONSTRAINT PK_Replication_Detail PRIMARY KEY (ID_RD);
/
--****************************************************************
--** OBJETIVO             : Crear las secuencias Replication_Detail_SEQ y Replication_Config_SEQ en el esquema RHU para generar identificadores únicos y consecutivos para las tablas 
--**                        Replication_Detail y Replication_Config, respectivamente.
--****************************************************************
CREATE SEQUENCE RHU.Replication_Detail_SEQ
    START WITH 1                          
    INCREMENT BY 1                         
    NOCACHE; 
/
--****************************************************************
--** OBJETIVO             : Crear los triggers Replication_Detail_BI y Replication_Config_BI en el esquema RHU para asignar automáticamente valores únicos a los campos ID_RD e ID_CONFIG 
--**                        mediante sus respectivas secuencias antes de cada operación INSERT.
--****************************************************************
CREATE OR REPLACE TRIGGER RHU.Replication_Detail_BI
BEFORE INSERT ON RHU.Replication_Detail    
FOR EACH ROW                                
BEGIN    
    IF :NEW.ID_RD IS NULL THEN
        SELECT RHU.Replication_Detail_SEQ.NEXTVAL INTO :NEW.ID_RD FROM DUAL;
    END IF;
END;