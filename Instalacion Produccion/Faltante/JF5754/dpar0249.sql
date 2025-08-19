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
    IF :NEW.STDO_ESTADO IN ('DISPONIBLE', 'APLICADO') THEN--Solicitado Nuevamente 04/08/2025
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
    
    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());
    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
    END IF;
END;