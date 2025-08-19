CREATE OR REPLACE TRIGGER PAR.HV_REQUISICION_AUDIT
AFTER INSERT OR UPDATE ON PAR.REQUISICION_HOJA_VIDA
FOR EACH ROW
DECLARE
--****************************************************************
--** NOMBRE SCRIPT        : DPAR0249.SQL
--** OBJETIVO             : Crear el trigger HV_REQUISICION_AUDIT en el esquema PAR para auditar las operaciones de inserci�n o actualizaci�n en la tabla REQUISICION_HOJA_VIDA, 
--**                        generando registros en RHU.Replication_Detail con los detalles en formato JSON y marc�ndolos como pendientes de replicaci�n.
--** ESQUEMA              : PAR
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 14/01/2025
--****************************************************************
    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER;
    l_cto_numero         LIBROINGRESO.CTO_NUMERO%TYPE;
    l_lib_consecutivo libroingreso.lib_consecutivo%TYPE;
    PROCEDURE encolar_mensaje (p_id_rd IN NUMBER) IS
        l_enqueue_options    dbms_aq.enqueue_options_t;
        l_message_properties dbms_aq.message_properties_t;
        l_message            sys.aq$_jms_text_message;
        l_msgid              RAW(16);
    BEGIN
        l_message := sys.aq$_jms_text_message.construct;
        l_message.set_text(xmltype('<idEvento>'|| p_id_rd ||'</idEvento>').getClobVal());

        DBMS_AQ.ENQUEUE (
            queue_name         => 'AQ_ADMIN.SQ_REPLICATION',
            enqueue_options    => l_enqueue_options,
            message_properties => l_message_properties,
            payload            => l_message,
            msgid              => l_msgid
        );
    END encolar_mensaje;
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
            (SELECT ID_CONFIG 
               FROM RHU.Replication_Config 
              WHERE LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' 
                AND GCP_TABLE_REF = 'RequisitionData'), 
            'PENDING',                             
            '{
                "document_type": "'     || :NEW.TDC_TD_EPL || '",
                "document_number": "'   || :NEW.EPL_ND || '",
                "requisitionNumber": "' || :NEW.REQ_CONSECUTIVO || '",
                "deliveryDate": "'      || TO_CHAR(:NEW.RFE_FECHA_ENTREGA, 'YYYY-MM-DD') || '",
                "requestDate": "'       || TO_CHAR(:NEW.RQHV_FECHA_GRABA, 'YYYY-MM-DD') || '",
                "selectionStatus": "'   || :NEW.STDO_ESTADO || '",
                "status": "'            || :NEW.REQ_ESTADO || '"
            }',                                   
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
            USER                                   
        )
        RETURNING ID_RD INTO l_id_rd;   

        encolar_mensaje(l_id_rd);
    END IF;

    BEGIN
        SELECT cto_numero, lib_consecutivo
          INTO l_cto_numero, l_lib_consecutivo
          FROM (
              SELECT cto_numero, lib_consecutivo
                FROM libroingreso
               WHERE nro_requisicion = :NEW.req_consecutivo
               ORDER BY lib_consecutivo DESC
          )
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_cto_numero := NULL;
            l_lib_consecutivo := NULL;
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
        :NEW.TDC_TD_EPL,                                   
        :NEW.EPL_ND,  
        (SELECT ID_CONFIG 
           FROM RHU.Replication_Config 
          WHERE LOCAL_TABLE_REF = 'PAR.REQUISICION_HOJA_VIDA' 
            AND GCP_TABLE_REF = 'StatusChangesUserOffer'), 
        'PENDING',                             
           '{
            "document_type": "'     || :NEW.TDC_TD_EPL || '",
            "document_number": "'   || TO_CHAR(:NEW.EPL_ND) || '",
            "requisitionNumber": "' || TO_CHAR(:NEW.REQ_CONSECUTIVO) || '",
            "deliveryDate": "'      || TO_CHAR(:NEW.RFE_FECHA_ENTREGA, 'YYYY-MM-DD') || '",
            "requestDate": "'       || TO_CHAR(:NEW.RQHV_FECHA_GRABA, 'YYYY-MM-DD') || '",
            "status": "'            || TO_CHAR(:NEW.DCM_RADICACION) || '",
            "agreementId": "'       || NVL(TO_CHAR(l_cto_numero), 'N/A') || '",
            "stateSource": "SELECCION",
            "bookId": "'            || NVL(TO_CHAR(l_lib_consecutivo), 'N/A') || '"
            }',                                    
        TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
        USER                                   
    )
    RETURNING ID_RD INTO l_id_rd;    
    encolar_mensaje(l_id_rd);
END;