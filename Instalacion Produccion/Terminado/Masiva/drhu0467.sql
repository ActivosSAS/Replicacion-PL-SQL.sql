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
    (SELECT ID_CONFIG FROM RHU.Replication_Config WHERE LOCAL_TABLE_REF = 'RHU.EMPLEADO' AND GCP_TABLE_REF = 'EmployeeData'), -- Ajuste a tabla RHU.EMPLEADO
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

    l_message := sys.aq$_jms_text_message.construct;
    l_message.set_text(xmltype('<idEvento>'||l_id_rd||'</idEvento>').getClobVal());

    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_MASIVO',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
    END IF;
END;