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
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'PAR.HOJA_VIDA_RESTRICCIONES' AND GCP_TABLE_REF = 'BlockData'), 
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
    
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
END;