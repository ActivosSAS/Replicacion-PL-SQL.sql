CREATE OR REPLACE TRIGGER RHU.HV_REPLICATION_MASTER_AUDIT
AFTER INSERT ON RHU.REPLICATION_MASTER
FOR EACH ROW
-- ******************************************************************
-- ** NOMBRE SCRIPT        : DRHU0469.SQL
-- ** OBJETIVO             : Crear el trigger HV_REPLICATION_MASTER_AUDIT en el esquema RHU para auditar las operaciones de inserción
-- **                        en la tabla REPLICATION_MASTER, generando un mensaje en formato XML y enviándolo a la cola AQ_ADMIN.SQ_MASIVO.
-- ** ESQUEMA              : RHU
-- ** AUTOR                : JUFORERO
-- ** FECHA CREACIÓN       : 2025/05/13
-- ******************************************************************
DECLARE
    l_enqueue_options    DBMS_AQ.enqueue_options_t;
    l_message_properties DBMS_AQ.message_properties_t;
    l_message            SYS.AQ$_JMS_TEXT_MESSAGE;
    l_msgid              RAW(16);
BEGIN
    l_message := SYS.AQ$_JMS_TEXT_MESSAGE.construct;
    l_message.set_text(XMLTYPE('<idEvento>' || :NEW.ID_MASTER || '</idEvento>').getClobVal());

    DBMS_AQ.ENQUEUE (
        queue_name         => 'AQ_ADMIN.SQ_MASIVO',
        enqueue_options    => l_enqueue_options,
        message_properties => l_message_properties,
        payload            => l_message,
        msgid              => l_msgid
    );
END;
/
