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
    l_nro_requisicion    libroingreso.nro_requisicion%TYPE;
    l_lib_consecutivo    libroingreso.lib_consecutivo%TYPE;
    l_fecha_entrega     requisicion_hoja_vida.rfe_fecha_entrega%TYPE;
    l_fecha_graba       requisicion_hoja_vida.rqhv_fecha_graba%TYPE;
    
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
    -- Solicitado Nuevamente 04/08/2025: solo auditar si estado es PRE o INA
    IF :NEW.ECT_SIGLA IN ('PRE', 'INA') THEN
    
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
              WHERE LOCAL_TABLE_REF = 'RHU.CONTRATO' 
                AND GCP_TABLE_REF   = 'AgreementData'), 
            'PENDING',                             
            '{
                "document_type": "'     || :NEW.TDC_TD_EPL || '",
                "document_number": "'   || :NEW.EPL_ND || '",    
                "agreementId": "'       || :NEW.CTO_NUMERO || '",
                "status": "'            || :NEW.ECT_SIGLA || '"
            }',                                  
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 
            USER                                   
        )
        RETURNING ID_RD INTO l_id_rd;
        encolar_mensaje(l_id_rd);
    END IF;
    
    BEGIN
        SELECT nro_requisicion, lib_consecutivo
          INTO l_nro_requisicion, l_lib_consecutivo
          FROM (
              SELECT nro_requisicion, lib_consecutivo
                FROM libroingreso
               WHERE cto_numero = :NEW.CTO_NUMERO
               ORDER BY lib_consecutivo DESC
          )
         WHERE ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_nro_requisicion := NULL;
            l_lib_consecutivo := NULL;
    END;
    
    IF l_nro_requisicion IS NOT NULL THEN
        BEGIN
            SELECT rfe_fecha_entrega, rqhv_fecha_graba
              INTO l_fecha_entrega, l_fecha_graba
              FROM requisicion_hoja_vida
             WHERE req_consecutivo = l_nro_requisicion
             and TDC_TD_EPL=:NEW.TDC_TD_EPL
             and EPL_ND= :NEW.EPL_ND;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_fecha_entrega := NULL;
                l_fecha_graba   := NULL;
        END;
    ELSE
        l_fecha_entrega := NULL;
        l_fecha_graba   := NULL;
    END IF;
    
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
          WHERE LOCAL_TABLE_REF = 'RHU.CONTRATO'
            AND GCP_TABLE_REF   = 'StatusChangesUserOffer'),
        'PENDING',
        '{
            "document_type": "'     || :NEW.TDC_TD_EPL || '",
            "document_number": "'   || TO_CHAR(:NEW.EPL_ND) || '",
            "requisitionNumber": "' || NVL(TO_CHAR(l_nro_requisicion),'N/A') || '",
            "deliveryDate": "'      || NVL(TO_CHAR(l_fecha_entrega, 'YYYY-MM-DD'), 'N/A') || '",
            "requestDate": "'       || NVL(TO_CHAR(l_fecha_graba, 'YYYY-MM-DD'), 'N/A') || '",
            "status": "'            || TO_CHAR(:NEW.ECT_SIGLA) || '",
            "agreementId": "'       || NVL(TO_CHAR(:NEW.CTO_NUMERO),'N/A') || '",
            "stateSource": "CONTRATO",
            "bookId": "'            || NVL(TO_CHAR(l_lib_consecutivo),'N/A') || '"
        }',
        TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'),
        USER
    )
    RETURNING ID_RD INTO l_id_rd;
    encolar_mensaje(l_id_rd); 
END;