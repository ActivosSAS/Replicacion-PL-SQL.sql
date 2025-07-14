--**********************************************************************************************************
--** OBJETIVO             : Crear Colas de Mensajeria. --sq_masivo
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
--** OBJETIVO             : Activación de las Cola Mensajeria. --sq_masivo
--**********************************************************************************************************
BEGIN
    dbms_aqadm.start_queue(queue_name => 'SQ_MASIVO');
END;
/
--**********************************************************************************************************
--** OBJETIVO             : Crear Colas de Mensajeria. --SQ_REPLICATION
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
--**********************************************************************************************************
--** OBJETIVO             : Activación de las Cola Mensajeria. --SQ_REPLICATION
--**********************************************************************************************************
BEGIN
    dbms_aqadm.start_queue(queue_name => 'SQ_REPLICATION');
END;
/
--****************************************************************
--** OBJETIVO             : Dar Privilegios de la Cola de Mensaria a los Esquemas correspondientes
--** ESQUEMA              : RHU-PAR
--****************************************************************
SET SERVEROUTPUT ON;

BEGIN
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'ADM');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'RHU');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'SEL');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('ENQUEUE', 'SQ_REPLICATION', 'PAR');
    DBMS_AQADM.GRANT_QUEUE_PRIVILEGE('DEQUEUE', 'SQ_REPLICATION', 'PAR');

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