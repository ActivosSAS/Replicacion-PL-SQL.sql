CREATE OR REPLACE TRIGGER RHU.OBS_LINGRESO_AUDIT
AFTER INSERT OR UPDATE ON RHU.OBSERVACION_LINGRESO
FOR EACH ROW
DECLARE
--******************************************************************
--** NOMBRE SCRIPT        : drhu0478.sql
--** OBJETIVO             : Crear el trigger OBS_LINGRESO_AUDIT en el esquema RHU para auditar inserciones o actualizaciones en OBSERVACION_LINGRESO,
--**                        generando un registro en RHU.REPLICATION_DETAIL con la información en formato JSON y encolándola para replicación.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 04/07/2025
--******************************************************************

    l_enqueue_options    dbms_aq.enqueue_options_t;
    l_message_properties dbms_aq.message_properties_t;
    l_message            sys.aq$_jms_text_message;
    l_msgid              RAW(16);
    l_id_rd              NUMBER;

    v_td_epl     RHU.LIBROINGRESO.TDC_TD_EPL%TYPE;
    v_nd_epl     RHU.LIBROINGRESO.EPL_ND%TYPE;
    v_td_ppal    RHU.LIBROINGRESO.TDC_TD_PPAL%TYPE;
    v_nd_ppal    RHU.LIBROINGRESO.EMP_ND_PPAL%TYPE;
    v_td_fil     RHU.LIBROINGRESO.TDC_TD_FIL%TYPE;
    v_nd_fil     RHU.LIBROINGRESO.EMP_ND_FIL%TYPE;
    v_nd_req     RHU.LIBROINGRESO.NRO_REQUISICION%TYPE;

BEGIN
    SELECT TDC_TD_EPL, EPL_ND, TDC_TD_PPAL, EMP_ND_PPAL, TDC_TD_FIL, EMP_ND_FIL, NRO_REQUISICION
    INTO v_td_epl, v_nd_epl, v_td_ppal, v_nd_ppal, v_td_fil, v_nd_fil, v_nd_req
    FROM RHU.LIBROINGRESO
    WHERE LIB_CONSECUTIVO = :NEW.LIB_CONSECUTIVO;

    IF v_nd_req IS NOT NULL THEN

        INSERT INTO RHU.REPLICATION_DETAIL (
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
            v_td_epl,
            v_nd_epl,
            (SELECT ID_CONFIG 
             FROM RHU.REPLICATION_CONFIG 
             WHERE LOCAL_TABLE_REF = 'RHU.OBSERVACION_LINGRESO' 
               AND GCP_TABLE_REF = 'RequisitionStatus'), 
            'PENDING',
            '{
                "requisitionNumber": "' || v_nd_req || '",
                "status": "' || :NEW.CODIGO_CAUSAL || '"
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
