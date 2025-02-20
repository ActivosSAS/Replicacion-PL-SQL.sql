--Trigger PAR.HV_RESTRICCIONES_AUDIT alterado.


--Trigger PAR.HV_REQUISICION_AUDIT alterado.


--Trigger RHU.HV_CONTRATO_AUDIT alterado.


--Trigger RHU.OBSERVACION_LINGRESO_AUDIT alterado.

SELECT * FROM RHU.Replication_Detail ORDER BY ID_RD DESC;
SELECT * FROM  RHU.Replication_Config;
 --DROP TRIGGER RHU.Replication_Detail_BI;
--DROP TRIGGER RHU.Replication_Config_BI;
--DROP SEQUENCE RHU.Replication_Detail_SEQ;
--DROP SEQUENCE RHU.Replication_Config_SEQ;
--ALTER TABLE RHU.Replication_Detail
--DROP CONSTRAINT PK_Replicacion_Detalle;
--ALTER TABLE RHU.Replication_Config
--DROP CONSTRAINT PK_Replication_Config;
--DROP TABLE RHU.Replication_Detail;
--DROP TABLE RHU.Replication_Config;
/
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear la tabla Replication_Config en el esquema RHU para almacenar la configuración de replicación entre la base de datos local y GCP.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
CREATE TABLE RHU.Replication_Config (
    ID_CONFIG VARCHAR2(100),                -- Unique identifier for the configuration
    LOCAL_TABLE_REF VARCHAR2(100),          -- Name of the local database table where information will be reflected
    GCP_TABLE_REF VARCHAR2(100),            -- Name of the GCP table where information will be reflected
    STATUS_RC VARCHAR2(50) NOT NULL,        -- Record status (e.g., 'Pending', 'Processed', 'Error')
    CONSTRAINT PK_ID_CONFIG PRIMARY KEY (ID_CONFIG) -- Primary key constraint
);
/
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear la tabla Replication_Detail en el esquema RHU para almacenar los detalles de replicación, incluyendo información del documento y datos en formato JSON, 
--**                        relacionados con la configuración de replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
CREATE TABLE RHU.Replication_Detail (
    ID_RD NUMBER,                           -- Unique identifier for each record
    DOCUMENT_TYPE VARCHAR2(100),            -- Document type
    DOCUMENT_NUMBER VARCHAR2(100),          -- Document number
    ID_CONFIG VARCHAR2(100),                -- Reference ID (foreign key)
    STATE_RD VARCHAR2(50) NOT NULL,         -- Record status (e.g., 'Pending', 'Processed', 'Error')    
    DATA_JSON CLOB,                         -- Replicated data in JSON format
    DATE_RD VARCHAR2(50),                   -- Date and time when the record was generated (stored as text)
    USER_RD VARCHAR2(100),                  -- User performing the operation
    DESCRIPTION_RD	VARCHAR2(4000),
    CONSTRAINT FK_ID_CONFIG FOREIGN KEY (ID_CONFIG)
    REFERENCES RHU.Replication_Config (ID_CONFIG) ON DELETE CASCADE -- Relationship with Replication_Config
);
-- SELECT * FROM RHU.Replication_Config;
/
--****************************************************************
--** OBJETIVO             : Asignar todos los permisos (GRANT ALL) a la tabla Replication_Detail y Replication_Config del esquema RHU para que sean accesibles públicamente.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
GRANT ALL ON RHU.Replication_Detail TO PUBLIC;
GRANT ALL ON RHU.Replication_Config TO PUBLIC;
/
--****************************************************************
--** OBJETIVO             : Agregar la clave primaria PK_Replication_Detail a la tabla Replication_Detail en el esquema RHU, asegurando la unicidad de los registros basados en el campo ID_RD.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
ALTER TABLE RHU.Replication_Detail
ADD CONSTRAINT PK_Replication_Detail PRIMARY KEY (ID_RD);
/
--****************************************************************
--** OBJETIVO             : Crear las secuencias Replication_Detail_SEQ y Replication_Config_SEQ en el esquema RHU para generar identificadores únicos y consecutivos para las tablas 
--**                        Replication_Detail y Replication_Config, respectivamente.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
CREATE SEQUENCE RHU.Replication_Detail_SEQ
    START WITH 1                          
    INCREMENT BY 1                         
    NOCACHE;                               

CREATE SEQUENCE RHU.Replication_Config_SEQ
    START WITH 1                           
    INCREMENT BY 1                         
    NOCACHE;                               
/
--****************************************************************
--** OBJETIVO             : Crear los triggers Replication_Detail_BI y Replication_Config_BI en el esquema RHU para asignar automáticamente valores únicos a los campos ID_RD e ID_CONFIG 
--**                        mediante sus respectivas secuencias antes de cada operación INSERT.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
CREATE OR REPLACE TRIGGER RHU.Replication_Detail_BI
BEFORE INSERT ON RHU.Replication_Detail    
FOR EACH ROW                                
BEGIN    
    IF :NEW.ID_RD IS NULL THEN
        SELECT RHU.Replication_Detail_SEQ.NEXTVAL INTO :NEW.ID_RD FROM DUAL;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER RHU.Replication_Config_BI
BEFORE INSERT ON RHU.Replication_Config    
FOR EACH ROW                                
BEGIN    
    IF :NEW.ID_CONFIG IS NULL THEN
        SELECT RHU.Replication_Config_SEQ.NEXTVAL INTO :NEW.ID_CONFIG FROM DUAL;
    END IF;
END;
/
--****************************************************************
--** OBJETIVO             : Insertar registros iniciales en la tabla Replication_Config del esquema RHU, configurando las referencias locales y de GCP junto con el estado inicial de cada configuración.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.HOJA_VIDA_RESTRICCIONES', 'BlockData', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.REQUISICION_HOJA_VIDA', 'RequisitionData', 'Active');
--UPDATE RHU.Replication_Config SET LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' WHERE ID_CONFIG = '2'; 
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'RHU.CONTRATO', 'AgreementData', 'Active');
--UPDATE RHU.Replication_Config SET LOCAL_TABLE_REF = 'RHU.CONTRATO' WHERE ID_CONFIG = '3'; 
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'RHU.OBSERVACION_LINGRESO', 'UserDocumentaryReview', 'Active');
--UPDATE RHU.Replication_Config SET LOCAL_TABLE_REF = 'RHU.OBSERVACION_LINGRESO' WHERE ID_CONFIG = '4'; 
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'Observaciones', 'RemarkData', 'Active');
/
SELECT * FROM RHU.Replication_Config;
/
--****************************************************************
--** OBJETIVO             : Dar Privilegios de la Cola de Mensaria a los Esquemas correspondientes
--** ESQUEMA              : RHU-PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
SET SERVEROUTPUT ON
 
BEGIN
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
        privilege => 'ENQUEUE',
        queue_name => 'AQ_ADMIN.my_qu',
        grantee => 'PAR'
    );
END;
/
SET SERVEROUTPUT ON
 
BEGIN
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE(
        privilege => 'ENQUEUE',
        queue_name => 'AQ_ADMIN.my_qu',
        grantee => 'RHU'
    );
END;
/
--DROP TRIGGER PAR.HV_RESTRICCIONES_AUDIT;
CREATE OR REPLACE TRIGGER PAR.HV_RESTRICCIONES_AUDIT
AFTER INSERT OR UPDATE ON PAR.HOJA_VIDA_RESTRICCIONES
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear el trigger HV_RESTRICCIONES_AUDIT en el esquema PAR para auditar las operaciones de inserción o actualización en la tabla HOJA_VIDA_RESTRICCIONES, 
--**                        generando un registro en RHU.Replication_Detail con la información en formato JSON y marcándola como pendiente de replicación.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************

    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER; 
BEGIN
    INSERT INTO RHU.Replication_Detail (
    ID_RD,
    DOCUMENT_TYPE,
    DOCUMENT_NUMBER,
    ID_CONFIG,
    STATE_RD,
    DATA_JSON,
    DATE_RD,
    USER_RD
        ) VALUES (
    NULL,                                   
    :NEW.TDC_TD_EPL,                           
    :NEW.EPL_ND,                           
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'PAR.HOJA_VIDA_RESTRICCIONES' AND GCP_TABLE_REF = 'BlockData'), 
    'PENDING',                             
    '{
        "cause": "' || :NEW.CAU_SECUENCIA || '",
        "company": "' || :NEW.EMP_ND || '",
        "companyDocumentNumber": "' || :NEW.EMP_ND || '",
        "companyDocumentType": "' || :NEW.TDC_TD || '",
        "description": "' || :NEW.REST_MOTIVO || '",
        "itBlocks": "' || :NEW.REST_TIPO || '"
    }',                                   
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;
    
--    Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    -- Envío del mensaje a la cola AQ
    dbms_aq.enqueue (
        queue_name         => 'AQ_ADMIN.my_qu',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
       payload            => l_message,
        msgid              => l_msgid
    );
END;
/
--****************************************************************
--** OBJETIVO             : Insertar un registro de prueba en la tabla HOJA_VIDA_RESTRICCIONES del esquema PAR, para validar la funcionalidad del trigger asociado (HV_RESTRICCIONES_AUDIT) 
--**                        y comprobar la generación del registro correspondiente en RHU.Replication_Detail.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
INSERT INTO PAR.HOJA_VIDA_RESTRICCIONES (DCM_RADICACION,REST_ITEM,REST_TIPO,REST_MOTIVO,REST_USUARIO_GRABA,REST_FECHA_GRABA,TDC_TD,EMP_ND,TDC_TD_EPL,EPL_ND
,CAU_SECUENCIA,TDC_TD_ORG,EMP_ND_ORG,REST_VALOR,REST_FECHA_VIGENCIA,REST_MOTIVO_CLIENTE,PRR_CODIGO) 
VALUES ('326407','1','RESTRICTIVO','LE CAIGO MAL AL JEFE','S_DEYCI',TO_DATE('14/03/07','DD/MM/RR'),NULL,NULL,'CC','1069760782','3',NULL,NULL,NULL,NULL,NULL,NULL);
/
SELECT * FROM PAR.HOJA_VIDA_RESTRICCIONES ;
/
SELECT * FROM PAR.HOJA_VIDA_RESTRICCIONES WHERE EPL_ND='1069760782';
DELETE FROM PAR.HOJA_VIDA_RESTRICCIONES WHERE EPL_ND='1069760782';

/
--DROP TRIGGER PAR.HV_REQUISICION_AUDIT;
CREATE OR REPLACE TRIGGER PAR.HV_REQUISICION_AUDIT
AFTER INSERT OR UPDATE ON PAR.REQUISICION_HOJA_VIDA
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear el trigger HV_REQUISICION_AUDIT en el esquema PAR para auditar las operaciones de inserción o actualización en la tabla REQUISICION, 
--**                        generando un registro en RHU.Replication_Detail con los detalles en formato JSON y marcándolo como pendiente de replicación.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************

    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER; 
BEGIN
    IF :NEW.STDO_ESTADO IN ('DISPONIBLE', 'APLICADO') THEN
    INSERT INTO RHU.Replication_Detail (
    ID_RD,
    DOCUMENT_TYPE,
    DOCUMENT_NUMBER,
    ID_CONFIG,
    STATE_RD,
    DATA_JSON,
    DATE_RD,
    USER_RD
        ) VALUES (                             
     NULL,
    :NEW.TDC_TD_EPL,                                   
    :NEW.EPL_ND,  
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' AND GCP_TABLE_REF = 'RequisitionData'), 
    'PENDING',                             
    '{
    "requisitionNumber": "' || :NEW.REQ_CONSECUTIVO || '",
    "deliveryDate": "' || TO_CHAR(:NEW.RFE_FECHA_ENTREGA, 'YYYY-MM-DD') || '",
    "requestDate": "' || TO_CHAR(:NEW.RQHV_FECHA_GRABA, 'YYYY-MM-DD') || '",
    "selectionStatus": "' || :NEW.STDO_ESTADO || '",
    "status": "' || :NEW.DCM_RADICACION || '"
    }',                                   
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;   
    
--    Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());
    -- Envío del mensaje a la cola AQ
    dbms_aq.enqueue (
        queue_name         => 'AQ_ADMIN.my_qu',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
       payload            => l_message,
        msgid              => l_msgid
    );
    END IF;
END;
/
--DROP TRIGGER PAR.HV_REQUISICION_AUDIT;
CREATE OR REPLACE TRIGGER RHU.HV_CONTRATO_AUDIT
AFTER INSERT OR UPDATE ON RHU.CONTRATO
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear el trigger RHU.HV_CONTRATO_AUDIT en el esquema RHU para auditar las operaciones de inserción o actualización en la tabla RHU.CONTRATO, 
--**                        generando un registro en RHU.Replication_Detail con los detalles en formato JSON y marcándolo como pendiente de replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER; 
BEGIN
    IF :NEW.ECT_SIGLA IN ('PRE', 'INA') THEN
    -- Inserción en la tabla RHU.Replication_Detail
    INSERT INTO RHU.Replication_Detail (
    ID_RD,
    DOCUMENT_TYPE,
    DOCUMENT_NUMBER,
    ID_CONFIG,
    STATE_RD,
    DATA_JSON,
    DATE_RD,
    USER_RD
        ) VALUES (
    NULL,                                   
    :NEW.TDC_TD_EPL,                        
    :NEW.EPL_ND,                            
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'RHU.CONTRATO' AND GCP_TABLE_REF = 'AgreementData'), -- Fetch related ID_CONFIG
    'PENDING',                             
    '{
    "agreementId": "' || :NEW.CTO_NUMERO || '",
    "status": "' || :NEW.ECT_SIGLA || '"
    }',                                  
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;              

    -- Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    -- Envío del mensaje a la cola AQ
    dbms_aq.enqueue (
        queue_name         => 'AQ_ADMIN.my_qu',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
       payload            => l_message,
        msgid              => l_msgid
    );
    END IF;

END;
/
--****************************************************************
--** OBJETIVO             : Actualizar un registro de prueba en la tabla CONTRATO, con valores representativos para validar el funcionamiento del 
--**                        trigger asociado y la integración con las configuraciones de replicación.
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
SELECT  * FROM CONTRATO WHERE ECT_SIGLA='PRE' ORDER BY CTO_FECHA DESC;
--SELECT * FROM CTOESTADO;
--UPDATE CONTRATO SET ECT_SIGLA='INA' WHERE EPL_ND='7895445722';
/
--DROP TRIGGER PAR.HV_REQUISICION_AUDIT;
CREATE OR REPLACE TRIGGER RHU.OBSERVACION_LINGRESO_AUDIT
AFTER INSERT OR UPDATE ON RHU.OBSERVACION_LINGRESO
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear el trigger RHU.OBSERVACION_LINGRESO_AUDIT en el esquema RHU para auditar las operaciones de inserción o actualización en la tabla RHU.OBSERVACION_LINGRESO, 
--**                        generando un registro en RHU.Replication_Detail con los detalles en formato JSON y marcándolo como pendiente de replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER;
    v_tdc_td_epl         VARCHAR2(100);
    v_epl_nd             NUMBER;
    v_req_consecutivo    NUMBER;
BEGIN

    IF :NEW.LIB_ESTADO IN ('OK_VALIDADO') THEN
    BEGIN
    SELECT TDC_TD_EPL, EPL_ND
    INTO v_tdc_td_epl, v_epl_nd
    FROM (
        SELECT TDC_TD_EPL, EPL_ND
        FROM LIBROINGRESO
        WHERE LIB_CONSECUTIVO = :NEW.LIB_CONSECUTIVO
        ORDER BY LIB_CONSECUTIVO DESC 
    )
    WHERE ROWNUM = 1; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN; 
    END;

    BEGIN
    SELECT REQ_CONSECUTIVO
    INTO v_req_consecutivo
    FROM (
        SELECT REQ_CONSECUTIVO
        FROM requisicion_hoja_vida
        WHERE TDC_TD_EPL = v_tdc_td_epl AND EPL_ND = v_epl_nd
        ORDER BY REQ_CONSECUTIVO DESC 
    )
    WHERE ROWNUM = 1; 
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN; 
    END;

        INSERT INTO RHU.Replication_Detail (
            ID_RD,
            DOCUMENT_TYPE,
            DOCUMENT_NUMBER,
            ID_CONFIG,
            STATE_RD,
            DATA_JSON,
            DATE_RD,
            USER_RD
        ) VALUES (
            NULL,
            v_tdc_td_epl,
            v_epl_nd,
            (SELECT ID_CONFIG FROM RHU.Replication_Config 
             WHERE LOCAL_TABLE_REF = 'RHU.OBSERVACION_LINGRESO' AND GCP_TABLE_REF = 'UserDocumentaryReview'),
            'PENDING',
            '{
                "requisitionNumber": "' || v_req_consecutivo || '",
                "updateDate": "' || TO_CHAR(:NEW.OBS_FECHA, 'YYYY-MM-DD HH24:MI:SS') || '"
            }',
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
            USER
        )
        RETURNING ID_RD INTO l_id_rd;

        -- Construcción del mensaje de la cola AQ
        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>' || l_id_rd || '</idEvento>').getClobVal());

        -- Envío del mensaje a la cola AQ
        dbms_aq.enqueue(
            queue_name         => 'AQ_ADMIN.my_qu',
            enqueue_options    => l_enqueue_options,
            message_properties => l_message_properties,
            payload            => l_message,
            msgid              => l_msgid
        );
    END IF;
END;
/
--****************************************************************
--** OBJETIVO             : Insertar un registro de prueba en la tabla RHU.OBSERVACION_LINGRESO del esquema PAR, para validar la funcionalidad del trigger asociado (RHU.OBSERVACION_LINGRESO_AUDIT) 
--**                        y comprobar la generación del registro correspondiente en RHU.Replication_Detail.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
SELECT * FROM RHU.OBSERVACION_LINGRESO;
SELECT * FROM LIBROINGRESO WHERE EPL_ND =1019002843;
SELECT * FROM REQUISICION;
UPDATE RHU.OBSERVACION_LINGRESO SET LIB_ESTADO='OK_VALIDADO' WHERE OBS_SECUENCIA = 939050;
/
--****************************************************************--****************************************************************--****************************************************************
--DROP TRIGGER TRG_ID_MASTER_AUTO;
--DROP SEQUENCE RHU.ID_MASTER_SEQ;
--DROP TABLE RHU.Replication_Master CASCADE CONSTRAINTS;
-- Crear la tabla RHU.Replication_Master
--****************************************************************
-- Crear la tabla RHU.Replication_Master
CREATE TABLE RHU.Replication_Master (
    ID_MASTER NUMBER PRIMARY KEY,          -- Unique identifier for each master record
    USER_MASTER VARCHAR2(100),             -- User performing the operation
    TOTAL_ROWS NUMBER,                     -- Total number of rows processed
    SUCCESSFUL_ROWS NUMBER,                -- Number of successful rows
    FAILED_ROWS NUMBER,                    -- Number of failed rows
    STATUS_MASTER VARCHAR2(50),            -- Status of the master record (e.g., 'Pending', 'Completed', 'Failed')
    URL_REPORT_LOAD VARCHAR2(4000),        -- URL for the load report
    URL_REPORT_ERROR VARCHAR2(4000),       -- URL for the error report
    OBSERVATION_MASTER VARCHAR2(4000),     -- Additional observations
    MASTER_DATE DATE NOT NULL              -- Date of the operation (must be provided)
);
/
GRANT ALL ON RHU.Replication_Master TO PUBLIC;
/
CREATE SEQUENCE RHU.ID_MASTER_SEQ
    START WITH 1                           
    INCREMENT BY 1                         
    NOCACHE;    
/
CREATE OR REPLACE TRIGGER RHU.TRG_ID_MASTER_AUTO
BEFORE INSERT ON RHU.Replication_Master
FOR EACH ROW
BEGIN
  IF :NEW.ID_MASTER IS NULL THEN
    SELECT RHU.ID_MASTER_SEQ.NEXTVAL INTO :NEW.ID_MASTER FROM DUAL;
  END IF;
END;
/
--DROP TRIGGER PAR.HV_REQUISICION_AUDIT;
CREATE OR REPLACE TRIGGER RHU.HV_REPLICATION_MASTER_AUDIT
AFTER INSERT OR UPDATE ON RHU.Replication_Master
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear el trigger Replication_Master en el esquema RHU para auditar las operaciones de inserción o actualización en la tabla REQUISICION, 
--**                        generando un registro en RHU.Replication_Detail con los detalles en formato JSON y marcándolo como pendiente de replicación.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************

    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER; 
BEGIN
    
--    Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||:NEW.ID_MASTER||'</idEvento>').getClobVal());
    -- Envío del mensaje a la cola AQ
    dbms_aq.enqueue (
        queue_name         => 'AQ_ADMIN.sq_masivo',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
       payload            => l_message,
        msgid              => l_msgid
    );
    
END;
/
-- Eliminar el trigger
DROP TRIGGER RHU.TRG_CBU_ID_AUTO;
/
-- Eliminar la secuencia
DROP SEQUENCE RHU.CBU_ID_SEQ;
/
-- Eliminar la tabla
DROP TABLE RHU.CANDIDATE_BULK_UPLOAD CASCADE CONSTRAINTS;
/
--****************************************************************
--** NOMBRE SCRIPT        : CBU_TRIGGER.SQL
--** OBJETIVO             : Crear el trigger TRG_CBU_ID_AUTO en el esquema RHU para asignar 
--**                        automáticamente un ID a los registros insertados en la tabla 
--**                        CANDIDATE_BULK_UPLOAD utilizando la secuencia CBU_ID_SEQ.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
-- Crear la tabla con ID como NUMBER sin autoincremento
CREATE TABLE RHU.CANDIDATE_BULK_UPLOAD (
    CBU_ID NUMBER PRIMARY KEY,  -- IDENTIFICADOR ÚNICO MANUALMENTE GENERADO
    CBU_IDENTIFICATION_TYPE VARCHAR2(3 BYTE) NOT NULL,  -- TIPO DE IDENTIFICACIÓN (CC, CE, ETC.)
    CBU_IDENTIFICATION_NUMBER NUMBER(20,0) NOT NULL UNIQUE,  -- NÚMERO DE IDENTIFICACIÓN (ÚNICO)
    CBU_EMAIL VARCHAR2(250 BYTE) NOT NULL,  -- CORREO ELECTRÓNICO DEL CANDIDATO
    CBU_STATUS VARCHAR2(10 BYTE) NOT NULL CHECK (CBU_STATUS IN ('PENDING', 'SENT', 'ERROR')),  -- ESTADO DE LA TRANSACCIÓN
    CBU_TRANSACTION_ID NUMBER NOT NULL,  -- ID ÚNICO DE LA TRANSACCIÓN (UUID)
    CBU_USER VARCHAR2(50 BYTE) NOT NULL,  -- USUARIO QUE REALIZA LA OPERACIÓN
    CBU_CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- FECHA DE CREACIÓN DEL REGISTRO
);
/

-- Otorgar permisos a PUBLIC para la tabla
GRANT ALL ON RHU.CANDIDATE_BULK_UPLOAD TO PUBLIC;
/
-- Crear la secuencia para el ID
CREATE SEQUENCE RHU.CBU_ID_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE;    
/

-- Crear el trigger para asignar automáticamente el ID
CREATE OR REPLACE TRIGGER RHU.TRG_CBU_ID_AUTO
BEFORE INSERT ON RHU.CANDIDATE_BULK_UPLOAD
FOR EACH ROW
BEGIN
  IF :NEW.CBU_ID IS NULL THEN
    SELECT RHU.CBU_ID_SEQ.NEXTVAL INTO :NEW.CBU_ID FROM DUAL;
  END IF;
END;
/
CREATE OR REPLACE PACKAGE BODY RHU.EMAIL_PKG AS
    PROCEDURE SEND_BULK_EMAILS IS
    vcDe                 VARCHAR2(200);
    vcError              VARCHAR2(4000);
    vcFirstName          VARCHAR2(200);

        CURSOR c_candidates IS
            SELECT CBU_IDENTIFICATION_TYPE, CBU_IDENTIFICATION_NUMBER,CBU_EMAIL
            FROM RHU.CANDIDATE_BULK_UPLOAD
            WHERE CBU_STATUS = 'PENDING';

        v_CBU_IDENTIFICATION_TYPE VARCHAR2(3);
        v_CBU_IDENTIFICATION_NUMBER NUMBER(20);
        v_CBU_EMAIL VARCHAR2(250);
        v_plantilla LONG; 
        vcPlantillaMove LONG;

    BEGIN           
        BEGIN
        
    v_plantilla := '<a href="https://www.activos.com.co/" target="_blank">
    <img src="https://i.imgur.com/CIwtI0I_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="https://reclutador-qa.partnerdavinci.com/sign-up" target="_blank">
    <img src="https://i.imgur.com/tHNETIb_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="https://www.activos.com.co/oficinas-activos/" target="_blank">
    <img src="https://i.imgur.com/G8mvTK7_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="https://www.activos.com.co/" target="_blank">
    <img src="https://i.imgur.com/Ba9LG5K_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="https://reclutador-qa.partnerdavinci.com/sign-up" target="_blank">
    <img src="https://i.imgur.com/apc6ahT_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="https://www.activos.com.co/preguntas-frecuentes-activos/" target="_blank">
    <img src="https://i.imgur.com/8Do66xC_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>
    <a href="http://apps.activos.com.co/SINMAReceiver/SinmaPolicySender?nbeId=8" target="_blank">
    <img src="https://i.imgur.com/cEmJ6R9_d.webp?maxwidth=760&fidelity=grand" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
    </a>';
                vcDe:='sinma@activate.com.co';
        END;

        FOR rec IN c_candidates LOOP
            v_CBU_IDENTIFICATION_TYPE := rec.CBU_IDENTIFICATION_TYPE;
            v_CBU_IDENTIFICATION_NUMBER := rec.CBU_IDENTIFICATION_NUMBER;
            v_CBU_EMAIL := rec.CBU_EMAIL;
            
            SELECT EPL_NOM1 INTO vcFirstName FROM RHU.EMPLEADO 
            WHERE EPL_ND=rec.CBU_IDENTIFICATION_NUMBER 
            AND TDC_TD=rec.CBU_IDENTIFICATION_TYPE ;
            
            vcPlantillaMove:=REPLACE(v_plantilla,'$EPL_NOM1',vcFirstName);

            pb_envia_x_e_delivery (
	                      vcDe    --vcde         
                          ,TRIM(rec.CBU_EMAIL)   --vcpara    
                          ,NULL     --vcccopia     
                          ,NULL   --vcc_oculta   
                          ,''||vcFirstName||', Tu futuro comienza aquí | Completa tu registro en Activos'       --vcasunto     
                          ,v_plantilla   --MENSAJE
						  ,null           --vcruta
                          ,null           --vcadjunto
                          ,null           --vcReporte 
                          ,null           --vcBuzonError
                          ,null           --nmrequerimiento
                          ,'JUFORERO'           --vcusuario    
                          ,vcerror        --vcerror IN OUT 
                          );
                          
            UPDATE RHU.CANDIDATE_BULK_UPLOAD
            SET CBU_STATUS = 'SENT'
            WHERE CBU_IDENTIFICATION_TYPE = v_CBU_IDENTIFICATION_TYPE
            AND v_CBU_IDENTIFICATION_NUMBER = CBU_IDENTIFICATION_NUMBER;

        END LOOP;

        COMMIT;

    END SEND_BULK_EMAILS;

END EMAIL_PKG;
