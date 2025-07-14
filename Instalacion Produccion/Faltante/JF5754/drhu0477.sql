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
--    IF :NEW.ECT_SIGLA IN ('PRE', 'INA') THEN
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

    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
--    END IF;
END;