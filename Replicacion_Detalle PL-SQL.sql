--Trigger PAR.HV_RESTRICCIONES_AUDIT alterado.


--Trigger PAR.HV_REQUISICION_AUDIT alterado.


--Trigger RHU.HV_CONTRATO_AUDIT alterado.


--Trigger RHU.OBSERVACION_LINGRESO_AUDIT alterado.

SELECT * FROM RHU.Replication_Detail ORDER BY ID_RD DESC;
/
DELETE FROM RHU.Replication_Detail WHERE ID_RD = 9860;
/

/
UPDATE RHU.Replication_Detail SET DATA_JSON= '{
    "document_type": "CC",
    "document_number": "1010217",
    "requisitionNumber": "342928",
    "deliveryDate": "2025-02-21",
    "requestDate": "2025-06-12",
    "selectionStatus": "DISPONIBLE",
    "status": "2844522"
    }' WHERE ID_RD=9866;
UPDATE RHU.Replication_Detail SET DATA_JSON= '{
    "document_type": "CC",
    "document_number": "1010217",
    "requisitionNumber": "342928",
    "deliveryDate": "2025-02-21",
    "requestDate": "2025-06-12",
    "selectionStatus": "DISPONIBLE",
    "status": "2844522"
    }' WHERE ID_RD=9866;    
    
    
--DELETE FROM RHU.Replication_Detail WHERE ID_RD=108;
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
--**********************************************************************************************************
--** OBJETIVO             : Crear Colas de Mensajeria.
--**********************************************************************************************************
BEGIN
    dbms_aqadm.create_queue_table (
        queue_table        => 'queue_sel_masivo',
        queue_payload_type => 'sys.aq$_jms_text_message'
    );

    dbms_aqadm.create_queue (
        queue_name  => 'sq_masivo',
        queue_table => 'queue_sel_masivo'  
    );

    dbms_aqadm.start_queue (
        queue_name => 'sq_masivo'
    );
END;
/
--**********************************************************************************************************
--** OBJETIVO             : Probar la cola de mensajeria.
--**********************************************************************************************************
BEGIN

    DECLARE
        l_enqueue_options    dbms_aq.enqueue_options_t;
        l_message_properties dbms_aq.message_properties_t;
        l_message            sys.aq$_jms_text_message;
        l_msgid              RAW(16);
    BEGIN
        -- Construcción del mensaje
        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>01</idEvento>').getClobVal());
        -- Envío del mensaje a la cola AQ
        dbms_aq.enqueue (
                queue_name         => 'AQ_ADMIN.sq_masivo',
                enqueue_options    => l_enqueue_options,
                message_properties => l_message_properties,
                payload            => l_message,
                msgid              => l_msgid
        );

        -- Confirmación de la transacción
        COMMIT;
    END;

END;
/
BEGIN
    dbms_aqadm.start_queue(queue_name => 'SQ_MASIVO');
END;
/
SELECT * FROM AQ_ADMIN.queue_sel_masivo;
/
--**********************************************************************************************************
--** OBJETIVO             : Crear Colas de Mensajeria.
--**********************************************************************************************************
BEGIN
    dbms_aqadm.create_queue_table (
            queue_table        => 'queue_sel_replication',
            queue_payload_type => 'sys.aq$_jms_text_message'
    );

    dbms_aqadm.create_queue (
            queue_name  => 'sq_replication',
            queue_table => 'queue_sel_replication'--Begin
    );

    dbms_aqadm.start_queue (
            queue_name => 'sq_replication'
    );
END;
/
SELECT *
FROM dba_queues 
WHERE NAME = 'SQ_REPLICATION';
/
BEGIN
   DBMS_AQADM.STOP_QUEUE(queue_name => 'SQ_REPLICATION');
   DBMS_AQADM.PURGE_QUEUE_TABLE(queue_table => 'AQ_ADMIN.QUEUE_SEL_REPLICATION', purge_condition => '1=1');
   DBMS_AQADM.START_QUEUE(queue_name => 'SQ_REPLICATION');
END;
/

/
SELECT * FROM AQ_ADMIN.queue_sel_replication;
/
BEGIN
  DBMS_AQADM.START_QUEUE(
    queue_name => 'AQ_ADMIN.SQ_REPLICATION'
  );
END;
/
--Eliminar Colas de Mensajerias con un Loop (Procedimiento Almacenado)
 SET SERVEROUTPUT ON
 DECLARE
   l_dequeue_options   DBMS_AQ.DEQUEUE_OPTIONS_T;
   l_message_props     DBMS_AQ.MESSAGE_PROPERTIES_T;
   l_msgid             RAW(16);
   l_payload           SYS.AQ$_JMS_TEXT_MESSAGE;
   l_total_eliminados  NUMBER := 0;
BEGIN
   l_dequeue_options.wait := DBMS_AQ.NO_WAIT;
   l_dequeue_options.dequeue_mode := DBMS_AQ.REMOVE;

   LOOP
      BEGIN
         DBMS_AQ.DEQUEUE(
            queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
            dequeue_options    => l_dequeue_options,
            message_properties => l_message_props,
            payload            => l_payload,
            msgid              => l_msgid
         );

         l_total_eliminados := l_total_eliminados + 1;
         DBMS_OUTPUT.PUT_LINE('Mensaje eliminado. Total: ' || l_total_eliminados);

      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No hay más mensajes en la cola.');
            EXIT;
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
            EXIT;
      END;
   END LOOP;

   DBMS_OUTPUT.PUT_LINE('Total de mensajes eliminados: ' || l_total_eliminados);
END;
/

/

/

/

/

/

/
--**********************************************************************************************************
--** OBJETIVO             : Probar la cola de mensajeria.
--**********************************************************************************************************
BEGIN

    DECLARE
        l_enqueue_options    dbms_aq.enqueue_options_t;
        l_message_properties dbms_aq.message_properties_t;
        l_message            sys.aq$_jms_text_message;
        l_msgid              RAW(16);
    BEGIN
        -- Construcción del mensaje
        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>9866</idEvento>').getClobVal());
        -- Envío del mensaje a la cola AQ
        dbms_aq.enqueue (
                queue_name         => 'AQ_ADMIN.sq_replication',
                enqueue_options    => l_enqueue_options,
                message_properties => l_message_properties,
                payload            => l_message,
                msgid              => l_msgid
        );

        -- Confirmación de la transacción
        COMMIT;
    END;

END;
/
BEGIN

    DECLARE
        l_enqueue_options    dbms_aq.enqueue_options_t;
        l_message_properties dbms_aq.message_properties_t;
        l_message            sys.aq$_jms_text_message;
        l_msgid              RAW(16);
    BEGIN
        -- Construcción del mensaje
        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>001</idEvento>').getClobVal());
        -- Envío del mensaje a la cola AQ
        dbms_aq.enqueue (
                queue_name         => 'AQ_ADMIN.SQ_MASIVO',
                enqueue_options    => l_enqueue_options,
                message_properties => l_message_properties,
                payload            => l_message,
                msgid              => l_msgid
        );

        -- Confirmación de la transacción
        COMMIT;
    END;

END;
/
BEGIN
    dbms_aqadm.start_queue(queue_name => 'SQ_REPLICATION');
END;
/
<<<<<<< HEAD
SELECT * FROM AQ_ADMIN.queue_sel_replication;
=======
SELECT COUNT(*) FROM AQ_ADMIN.queue_sel_masivo;
>>>>>>> 881ac0ffe60537651b3bd138deb24aa2e246d04d
/
--****************************************************************
--** OBJETIVO             : Dar Privilegios de la Cola de Mensaria a los Esquemas correspondientes
--** ESQUEMA              : RHU-PAR-SEL-ADM
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
SET SERVEROUTPUT ON;

BEGIN
    -- Otorgar privilegios en SQ_REPLICATION para ADM, RHU, SEL y PAR
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'PAR');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'PAR');

    -- Otorgar privilegios en SQ_MASIVO para ADM, RHU, SEL y PAR
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'PAR');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'PAR');
    
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_MASIVO', 'PAR');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_MASIVO', 'PAR');

    DBMS_OUTPUT.PUT_LINE('Privilegios asignados correctamente a ADM, RHU, SEL y PAR.');
END;
/
BEGIN
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'ADM', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'RHU', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'SEL', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'PAR', FALSE);
END;
/
BEGIN
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'ADM', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'RHU', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'SEL', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'PAR', FALSE);
END;
/
BEGIN
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'AQ_ADMIN', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'INTRAUSER', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'JUFORERO', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'CMP', FALSE);
    
END;
/
BEGIN
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'AQ_ADMIN', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'JUFORERO', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_REPLICATION', 'INTRAUSER', FALSE);
    dbms_aqadm.grant_queue_privilege('ALL', 'AQ_ADMIN.SQ_MASIVO', 'CMP', FALSE);    
END;
/
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "GSMADMIN_INTERNAL";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "GSMCATUSER";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "RHU";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "PAR";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "ADM";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "SEL";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "OEM_MONITOR";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "OWBSYS";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "WMSYS";
GRANT EXECUTE ON "SYS"."DBMS_AQ" TO "AQ_USER_ROLE";
/
GRANT EXECUTE ON DBMS_AQADM TO ADM;
GRANT EXECUTE ON DBMS_AQADM TO RHU;
GRANT EXECUTE ON DBMS_AQADM TO SEL;
GRANT EXECUTE ON DBMS_AQADM TO PAR;
/
GRANT EXECUTE ON SYS.DBMS_AQADM TO JUFORERO;
GRANT EXECUTE ON SYS.DBMS_AQADM TO aq_admin;
GRANT EXECUTE ON SYS.DBMS_AQADM TO intrauser;

/
--****************************************************************
--** NOMBRE SCRIPT        : .SQL
--** OBJETIVO             : Crear la tabla Replication_Config en el esquema RHU para almacenar la configuración de replicación entre la base de datos local y GCP.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
--SELECT * FROM RHU.Replication_Config;
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
--SELECT * FROM RHU.Replication_Detail;
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
--INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) **********Pendiente por Validar
--VALUES (NULL, 'RHU.OBSERVACION_LINGRESO', 'UserDocumentaryReview', 'Active');
--UPDATE RHU.Replication_Config SET LOCAL_TABLE_REF = 'RHU.OBSERVACION_LINGRESO' WHERE ID_CONFIG = '4'; 
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'Observaciones', 'RemarkData', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.REQUISICION_HOJA_VIDA', 'UserDocumentaryReview', 'Active');
--UPDATE RHU.Replication_Config SET LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' WHERE ID_CONFIG = '11'; 
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'RHU.OBSERVACION_LINGRESO', 'ValidarNombreDavinciStatus', 'Active');

/
SELECT * FROM RHU.Replication_Config;
/
SELECT * FROM REQUISICION ORDER BY REQ_CONSECUTIVO DESC;
/
--DROP TRIGGER PAR.HV_RESTRICCIONES_AUDIT;
CREATE OR REPLACE TRIGGER PAR.HV_RESTRICCIONES_AUDIT
AFTER INSERT OR UPDATE ON PAR.HOJA_VIDA_RESTRICCIONES
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : DPAR0248.SQL
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
    (SELECT * FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'PAR.HOJA_VIDA_RESTRICCIONES' AND GCP_TABLE_REF = 'BlockData'), 
    'PENDING',                             
    '{
        "document_type": "' || :NEW.TDC_TD_EPL || '",
        "document_number": "' || :NEW.EPL_ND || '",
        "cause": "' || :NEW.CAU_SECUENCIA || '",
        "company": "' || :NEW.EMP_ND || '",
        "companyDocumentNumber": "' || :NEW.EMP_ND || '",
        "companyDocumentType": "' || :NEW.TDC_TD || '",
        "description": "' || :NEW.REST_MOTIVO || '",
        "itBlocks": "' || 'true'/*:NEW.REST_TIPO*/ || '"
    }',                                   
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;
    
--    Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    -- Envío del mensaje a la cola AQ
    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
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
VALUES ('1069760782','1','RESTRICTIVO','LE CAIGO MAL AL JEFE','S_DEYCI',TO_DATE('14/03/07','DD/MM/RR'),NULL,NULL,'CC','1069760782','3',NULL,NULL,NULL,NULL,NULL,NULL);
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
--** NOMBRE SCRIPT        : DPAR0249.SQL
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
--    IF :NEW.STDO_ESTADO IN ('DISPONIBLE', 'APLICADO') THEN
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
    "document_type": "' || :NEW.TDC_TD_EPL || '",
    "document_number": "' || :NEW.EPL_ND || '",
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
    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
--    END IF;
END;
/
--DROP TRIGGER PAR.HV_REQUISICION_AUDIT;
CREATE OR REPLACE TRIGGER RHU.HV_CONTRATO_AUDIT
AFTER INSERT OR UPDATE ON RHU.CONTRATO
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : DRHU0477.SQL
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
    "document_type": "' || :NEW.TDC_TD_EPL || '",
    "document_number": "' || :NEW.EPL_ND || '",    
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
    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
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
--****************************************************************
--** OBJETIVO             : Guardar la Ruta en el Servidor donde van los documentos  
--** ESQUEMA              : PAR
--** AUTOR                : DESIERRA
--** FECHA CREACION       : 14/01/2025
--****************************************************************
INSERT INTO ADM.RUTA (RTA_NOMBRE,RTA_CODIGO,RTA_RUTA,RTA_REPLACEPATH)
VALUES ('PRO_MASIVO_HV','TEST','/opt/SGD/reportes_test/hoja_de_vida
','N');
/
select * from RUTA WHERE RTA_NOMBRE='PRO_MASIVO_HV';
/
SELECT * 
               FROM RHU.Replication_Config
               /
CREATE OR REPLACE TRIGGER PAR.REQ_OKVAL_DOCS_REPLICATE
AFTER INSERT OR UPDATE ON PAR.REQUISICION_HOJA_VIDA
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : DPAR0250.SQL
--** OBJETIVO             : Crear el trigger RHU.HV_CONTRATO_AUDIT en el esquema RHU para auditar las operaciones de inserción o actualización en la tabla RHU.CONTRATO, 
--**                        generando un registro en RHU.Replication_Detail con los detalles en formato JSON y marcándolo como pendiente de replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************

    TYPE t_tpd_list IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_tpd_found t_tpd_list;
    v_tpd_required t_tpd_list;
    v_tpd_code NUMBER;

    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER; 

    CURSOR c_documents IS
        SELECT TO_NUMBER(adm.QB_LGC_GESTOR_DOCUMENTAL.fl_rtn_tipo_document(prd.tpd_codigo, 'TPD_CODIGO')) AS tpd_codigo
          FROM ADM.taxonomia_param txp,
               ADM.data_erp_az dea,
               ADM.propiedades_documento prd
         WHERE dea.txp_codigo = txp.txp_codigo
           AND dea.prd_codigo = prd.prd_codigo
           AND (txp.txp_descripcion LIKE 'BHV ' || :NEW.TDC_TD_EPL || ' ' || :NEW.EPL_ND)
           AND dea.prd_codigo IS NOT NULL
           AND dea.dea_estado <> 2
        UNION
        SELECT TO_NUMBER(adm.QB_LGC_GESTOR_DOCUMENTAL.fl_rtn_tipo_document(prd.tpd_codigo, 'TPD_CODIGO')) AS tpd_codigo
          FROM ADM.taxonomia_param txp,
               ADM.data_erp_az dea,
               ADM.propiedades_documento prd
         WHERE dea.txp_codigo = txp.txp_codigo
           AND dea.prd_codigo = prd.prd_codigo
           AND dea.txp_codigo IN (
               SELECT txp_codigo
                 FROM adm.taxonomia_param
                WHERE txp_codigo_ref IN (
                      SELECT txp_codigo
                        FROM adm.taxonomia_param
                       WHERE txp_descripcion = 'SEL ' || :NEW.TDC_TD_EPL || ' ' || :NEW.EPL_ND
                 )
           )
           AND dea.prd_codigo IS NOT NULL
           AND dea.dea_estado <> 2;

BEGIN
    DECLARE
        v_idx PLS_INTEGER := 1;
    BEGIN
        FOR r IN (SELECT DOCUMENT_CODE FROM RHU.REQUIRED_DOCUMENTS) LOOP
            v_tpd_required(v_idx) := r.DOCUMENT_CODE;
            v_idx := v_idx + 1;
        END LOOP;
    END;

    IF :NEW.STDO_ESTADO = 'OK_VALIDADO' THEN
        FOR r_doc IN c_documents LOOP
            v_tpd_code := r_doc.tpd_codigo;
            v_tpd_found(v_tpd_code) := 1;
        END LOOP;

        FOR i IN 1 .. v_tpd_required.COUNT LOOP
            IF v_tpd_found.EXISTS(v_tpd_required(i)) = FALSE THEN
                RETURN; 
            END IF;
        END LOOP;

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
            (SELECT ID_CONFIG 
               FROM RHU.Replication_Config 
              WHERE LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' 
                AND GCP_TABLE_REF = 'UserDocumentaryReview'),
            'PENDING',
            '{
                "document_type": "' || :NEW.TDC_TD_EPL || '",
                "document_number": "' || :NEW.EPL_ND || '",
                "requisitionNumber": "' || :NEW.REQ_CONSECUTIVO || '",
                "updateDate": "' || TO_CHAR(:NEW.RQHV_FECHA_GRABA, 'YYYY-MM-DD') || '"
            }',
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
            USER
        )
        RETURNING ID_RD INTO l_id_rd;

        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>' || l_id_rd || '</idEvento>').getClobVal());

        DBMS_AQ.ENQUEUE (
            queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
            enqueue_options    => l_enqueue_options,
            message_properties => l_message_properties,
            payload            => l_message,
            msgid              => l_msgid
        );
    END IF;
END;
/
--****************************************************************--****************************************************************--****************************************************************
--DROP TRIGGER TRG_ID_MASTER_AUTO;
--DROP SEQUENCE RHU.ID_MASTER_SEQ;
--DROP TABLE RHU.Replication_Master CASCADE CONSTRAINTS;
-- Crear la tabla RHU.Replication_Master
SELECT * FROM RHU.Replication_Master;
--****************************************************************
-- Crear la tabla RHU.Replication_Master
CREATE TABLE RHU.Replication_Master (
    ID_MASTER NUMBER PRIMARY KEY,          
    USER_MASTER VARCHAR2(100),             
    TOTAL_ROWS NUMBER,                     
    SUCCESSFUL_ROWS NUMBER,                
    FAILED_ROWS NUMBER,                    
    STATUS_MASTER VARCHAR2(50),            
    URL_REPORT_LOAD VARCHAR2(4000),        
    URL_REPORT_ERROR VARCHAR2(4000),       
    OBSERVATION_MASTER VARCHAR2(4000),     
    MASTER_DATE DATE NOT NULL              
);
/
--SELECT * FROM RHU.Replication_Master;
--DELETE RHU.Replication_Master;
/

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
DROP TRIGGER RHU.HV_REPLICATION_MASTER_AUDIT;
/
CREATE OR REPLACE TRIGGER RHU.HV_REPLICATION_MASTER_AUDIT
AFTER INSERT ON RHU.Replication_Master
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
CREATE OR REPLACE TRIGGER RHU.HV_EMPLEADO_MASV
AFTER INSERT OR UPDATE ON RHU.EMPLEADO
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : drhu0467.sql
--** OBJETIVO             : trigger encargador para Replicar las operaciones de inserción o actualización de la tabla RHU.EMPLEADO a GCP, 
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
    IF :NEW.FUENTE IN ('COMPUTRABAJO_MASIVO') THEN
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
    :NEW.TDC_TD,                        
    :NEW.EPL_ND,                            
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'RHU.EMPLEADO' AND GCP_TABLE_REF = 'BasicData'), -- Ajuste a tabla RHU.EMPLEADO
    'PENDING',                             
    '{
        "address": "'|| :NEW.EPL_DIRECCION ||'",
        "birthCountry": "'|| :NEW.PAI_NOMBRE_NAC ||'",
        "birthDate": "'|| TO_CHAR(:NEW.EPL_FECNACIM, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') ||'",
        "birthDepartment": "'|| :NEW.DPT_NOMBRE_NAC ||'",
        "birthMunicipality": "'|| :NEW.CIU_NOMBRE_NAC ||'",
        "bloodGroup": "'|| :NEW.GRUPO_SANGUINEO || :NEW.FACTOR_RH ||'",
        "cellphoneOne": {
            "hasWhatsapp": false,
            "number": NULL
        },
        "cellphoneTwo": {
            "hasWhatsapp": false,
            "number": NULL
        },
        "documentType": "'|| :NEW.TDC_TD ||'",
        "lastName": "'|| :NEW.EPL_APELL1 ||' '|| :NEW.EPL_APELL2 ||'",
        "locality": "'|| DECODE(:NEW.ZON_NOMBRE, 'NO APLICA', 'N.N.', :NEW.ZON_NOMBRE) ||'",
        "mailOne": {
            "address": "'|| :NEW.EPL_EMAIL ||'",
            "isNotification": true
        },
        "mailTwo": NULL,
        "name": "'|| :NEW.EPL_NOM1 ||' '|| :NEW.EPL_NOM2 ||'",
        "neighborhood": "'|| :NEW.BAR_NOMBRE ||'",
        "noDocument": "'|| :NEW.EPL_ND ||'",
        "originNacionality": "Colombiano/a",
        "residenceCountry": "'|| :NEW.PAI_NOMBRE_RES ||'",
        "residenceDepartment": "'|| :NEW.DPT_NOMBRE_RES ||'",
        "residenceDetails": "'|| :NEW.EPL_DIRECCION ||'",
        "residenceMunicipality": "'|| :NEW.CIU_NOMBRE_RES ||'",
        "sex": "'|| :NEW.EPL_SEXO ||'",
        "sexBirth": "'|| :NEW.EPL_SEXO ||'"
        }',                                  
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;              

    -- Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    -- Envío del mensaje a la cola AQ
--    DBMS_AQ.ENQUEUE (
--        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
--        enqueue_options    => l_enqueue_options,
--        message_properties => l_message_properties,
--        payload            => l_message,
--        msgid              => l_msgid
--    );
    END IF;
END;
/
CREATE OR REPLACE TRIGGER RHU.HV_EMPLEADO_REPL
AFTER INSERT OR UPDATE ON RHU.EMPLEADO
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : .sql
--** OBJETIVO             : trigger encargador para Replicar las operaciones de inserción o actualización de la tabla RHU.EMPLEADO a GCP, 
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
    IF :NEW.FUENTE IN ('CONTRATO') THEN
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
    :NEW.TDC_TD,                        
    :NEW.EPL_ND,                            
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'RHU.EMPLEADO' AND GCP_TABLE_REF = 'BasicData'), -- Ajuste a tabla RHU.EMPLEADO
    'PENDING',                             
    '{
        "address": "'|| :NEW.EPL_DIRECCION ||'",
        "birthCountry": "'|| :NEW.PAI_NOMBRE_NAC ||'",
        "birthDate": "'|| TO_CHAR(:NEW.EPL_FECNACIM, 'YYYY-MM-DD"T"HH24:MI:SS"Z"') ||'",
        "birthDepartment": "'|| :NEW.DPT_NOMBRE_NAC ||'",
        "birthMunicipality": "'|| :NEW.CIU_NOMBRE_NAC ||'",
        "bloodGroup": "'|| :NEW.GRUPO_SANGUINEO || :NEW.FACTOR_RH ||'",
        "cellphoneOne": {
            "hasWhatsapp": false,
            "number": NULL
        },
        "cellphoneTwo": {
            "hasWhatsapp": false,
            "number": NULL
        },
        "documentType": "'|| :NEW.TDC_TD ||'",
        "lastName": "'|| :NEW.EPL_APELL1 ||' '|| :NEW.EPL_APELL2 ||'",
        "locality": "'|| DECODE(:NEW.ZON_NOMBRE, 'NO APLICA', 'N.N.', :NEW.ZON_NOMBRE) ||'",
        "mailOne": {
            "address": "'|| :NEW.EPL_EMAIL ||'",
            "isNotification": true
        },
        "mailTwo": NULL,
        "name": "'|| :NEW.EPL_NOM1 ||' '|| :NEW.EPL_NOM2 ||'",
        "neighborhood": "'|| :NEW.BAR_NOMBRE ||'",
        "noDocument": "'|| :NEW.EPL_ND ||'",
        "originNacionality": "Colombiano/a",
        "residenceCountry": "'|| :NEW.PAI_NOMBRE_RES ||'",
        "residenceDepartment": "'|| :NEW.DPT_NOMBRE_RES ||'",
        "residenceDetails": "'|| :NEW.EPL_DIRECCION ||'",
        "residenceMunicipality": "'|| :NEW.CIU_NOMBRE_RES ||'",
        "sex": "'|| :NEW.EPL_SEXO ||'",
        "sexBirth": "'|| :NEW.EPL_SEXO ||'"
        }',                                  
    TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
    USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;              

    -- Construcción del mensaje de la cola AQ
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    -- Envío del mensaje a la cola AQ
    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
    END IF;
END;
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
SELECT * FROM RHU.CANDIDATE_BULK_UPLOAD;
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
create or replace PACKAGE  RHU.EMAIL_PKG AS
    PROCEDURE SEND_BULK_EMAILS;
END EMAIL_PKG;
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
        
    v_plantilla := '<table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/BANNER.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="http://apps.activos.com.co/JADM0017/outside/Registro.xhtml" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/Hola.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/oficinas-activos/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/VISITANOS.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/PORQUE%20_.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="http://apps.activos.com.co/JADM0017/outside/Registro.xhtml" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/TU%20PROXIMO.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/preguntas-frecuentes-activos/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/Equipo.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://storage.googleapis.com/bucket_prueba_grupo/POL%C3%8DTICAS%20DE%20MANEJO%20DE%20INFORMACI%C3%93N%20Y%20PRIVACIDAD.pdf" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/TRATAMIENTO.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
</table>';
        vcDe:='notificacion@activos.com.co';
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
/
DROP TABLE ADM.REQUIRED_DOCUMENTS;

CREATE TABLE RHU.REQUIRED_DOCUMENTS (
    DOCUMENT_CODE NUMBER PRIMARY KEY,
    DOCUMENT_NAME VARCHAR2(100)
);
GRANT ALL ON RHU.REQUIRED_DOCUMENTS TO PUBLIC;

/
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (23, 'DOCUMENTO DE IDENTIDAD');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (25, 'CERTIFICADO ANTECEDENTES JUDICIALES POLICIA');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (26, 'CERTIFICADO ANTECEDENTES JUDICIALES PROCURADURIA');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (27, 'CERTIFICADO ANTECEDENTES JUDICIALES CONTRALORIA');

/

/
SELECT * FROM PAR.REQUISICION_HOJA_VIDA ORDER BY REQ_CONSECUTIVO DESC;
SELECT COUNT(*) FROM AQ_ADMIN.QUEUE_SEL_REPLICATION;
/
SELECT * FROM RHU.KMS_KEYS;
--DELETE FROM RHU.KMS_KEYS WHERE KEY_ID = 1;
--DROP TRIGGER RHU.TRG_KMS_KEYS_AUTO_ID;
--DROP TABLE RHU.KMS_KEYS CASCADE CONSTRAINTS;
--DROP SEQUENCE RHU.SEQ_KMS_KEYS;

/
CREATE TABLE RHU.KMS_KEYS (
    KEY_ID              NUMBER           PRIMARY KEY, 
    KMS_KEY_NAME        VARCHAR2(1024)   NOT NULL,    
    STATUS              VARCHAR2(20)     DEFAULT 'ACTIVE'
                                         CHECK (STATUS IN ('ACTIVE', 'INACTIVE', 'REVOKED')),
    CREATED_BY          VARCHAR2(100)    NOT NULL,
    CREATED_AT          DATE             DEFAULT SYSDATE,
    MODIFIED_BY         VARCHAR2(100),
    MODIFIED_AT         DATE,
    DESCRIPTION         VARCHAR2(255),
    ASSOCIATED_USE      VARCHAR2(100),               -- e.g., RECRUITMENT, HR, PAYROLL
    IS_DEFAULT          CHAR(1)          DEFAULT 'N'
                                         CHECK (IS_DEFAULT IN ('Y', 'N'))
);
/
GRANT ALL ON RHU.KMS_KEYS TO PUBLIC;
/
CREATE SEQUENCE RHU.SEQ_KMS_KEYS
  START WITH 1
  INCREMENT BY 1
  NOCACHE
  NOCYCLE;
/
CREATE OR REPLACE TRIGGER RHU.TRG_KMS_KEYS_AUTO_ID
BEFORE INSERT ON RHU.KMS_KEYS
FOR EACH ROW
BEGIN
  IF :NEW.KEY_ID IS NULL THEN
    SELECT RHU.SEQ_KMS_KEYS.NEXTVAL INTO :NEW.KEY_ID FROM DUAL;
  END IF;
END;
/
INSERT INTO RHU.KMS_KEYS (
    KMS_KEY_NAME,
    STATUS,
    CREATED_BY,
    DESCRIPTION,
    ASSOCIATED_USE,
    IS_DEFAULT
) VALUES (
    '',
    'ACTIVE',
    'JUFORERO',
    'Llave utilizada para acceder al modulo de Ofertas en GCP desde BMX',
    'https://reclutador-qa.partnerdavinci.com/sign-in/?usuUsuario=usuario&redirectTo=/crear-oferta',
    'Y'
);


