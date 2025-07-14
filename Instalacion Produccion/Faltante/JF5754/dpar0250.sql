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