SET SERVEROUTPUT ON
DECLARE
  v_msg   VARCHAR2(4000);
  v_est   VARCHAR2(10);
  v_cur   SYS_REFCURSOR;

  v_name                  VARCHAR2(100);
  v_email                 VARCHAR2(100);
  v_documenttype          VARCHAR2(50);
  v_idnumber              VARCHAR2(50);
  v_companyDocumentType   VARCHAR2(50);
  v_companyDocumentNumber VARCHAR2(50);
  v_filialDocumentType    VARCHAR2(50);
  v_filialDocumentNumber  VARCHAR2(50);
  v_role                  VARCHAR2(20);
BEGIN
  -- Llamada al procedimiento con el usuario a probar
  RHU.QB_DATA_REPLICATION.PL_BUSCAR_USUARIO(
    vcusu_usuario    => 'JUFORERO',
    vcmensajeproceso => v_msg,
    vcestado_proceso => v_est,
    vcconsulta       => v_cur
  );

  DBMS_OUTPUT.PUT_LINE('ESTADO='||v_est);
  DBMS_OUTPUT.PUT_LINE('MENSAJE='||v_msg);

  IF v_est = 'S' THEN
    LOOP
      FETCH v_cur INTO
        v_name, v_email, v_documenttype, v_idnumber,
        v_companyDocumentType, v_companyDocumentNumber,
        v_filialDocumentType, v_filialDocumentNumber,
        v_role;
      EXIT WHEN v_cur%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE(
        v_name||' | '||v_email||' | '||v_documenttype||' | '||v_idnumber||' | '||
        v_companyDocumentType||' | '||v_companyDocumentNumber||' | '||
        v_filialDocumentType||' | '||v_filialDocumentNumber||' | '||v_role
      );
    END LOOP;
    CLOSE v_cur;
  END IF;
END;
/
SELECT * FROM ROLES_DOMINIO WHERE ROD_NOMBRE='SELROL ADMIN OFERTAS RECLUTADOR';
SELECT * FROM ROLES_DOMINIO WHERE ROD_NOMBRE='SELROL COMUNICACIONES OFERTAS RECLUTADOR';

Insert into USUARIOS_DOMINIO (UDS_ID,ROD_ID,USU_USUARIO,UDS_ESTADO,AUD_FECHA,AUD_USUARIO) 
values ((select MAX(UDS_ID)+1 from usuarios_dominio),149,'JUFORERO','S',SYSDATE,'DESIERRA');

INSERT INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
VALUES (NULL, 715, UPPER('JUFORERO'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703);
/
SELECT COUNT(rod_id)
FROM (
    SELECT ROD_ID
    FROM USUARIOS
    WHERE USU_USUARIO = UPPER('JUFORERO')
    UNION
    SELECT ROD_ID
    FROM USUARIOS_DOMINIO
    WHERE USU_USUARIO = UPPER('JUFORERO')
    UNION
    SELECT ROD_ID
    FROM ROLES_CARGO
    WHERE USU_CARGO = (
        SELECT USU_CARGO
        FROM USUARIOS
        WHERE USU_USUARIO = UPPER('JUFORERO')
    )
)
WHERE rod_id = 149;
/
SELECT * FROM USUARIOS WHERE USU_USUARIO = UPPER('JUFORERO');
/
 SELECT *
    FROM USUARIOS_DOMINIO
    WHERE USU_USUARIO = UPPER('JUFORERO')
/
 SELECT *
        FROM USUARIOS
        WHERE USU_USUARIO = UPPER('JUFORERO')
/
SELECT initcap(usr.usu_nombre) AS name,
       usr.usu_mail            AS email,
       usr.tdc_td              AS documenttype,
       usr.epl_nd              AS idnumber,
       uss.TDC_TD              AS companyDocumentType,
       uss.EMP_ND              AS companyDocumentNumber,
       uss.TDC_TD_FIL          AS filialDocumentType,
       uss.EMP_ND_FIL          AS filialDocumentNumber
FROM usuarios usr
JOIN USUARIO_SESION uss
  ON uss.USU_USUARIO = usr.usu_usuario
WHERE usr.usu_usuario = UPPER('JUFORERO')
  AND uss.USS_ID = (
       SELECT MAX(USS_ID)
       FROM USUARIO_SESION
       WHERE USU_USUARIO = UPPER('JUFORERO')
  );
/
SELECT vcusuario
FROM (
  SELECT UPPER(USU_LDAP) ldap_user,
         UPPER(USU_USUARIO) usu_user
  FROM USUARIOS
  WHERE UPPER(USU_LDAP) = 'JUFORERO'
     OR UPPER(USU_USUARIO) = 'JUFORERO'
);
/
SELECT MAX(USS_ID)
FROM USUARIO_SESION
WHERE USU_USUARIO = 'JOCOLMENARES';
/
SELECT initcap(usr.usu_nombre) AS name,
       usr.usu_mail            AS email,
       usr.tdc_td              AS documenttype,
       usr.epl_nd              AS idnumber,
       uss.TDC_TD              AS companyDocumentType,
       uss.EMP_ND              AS companyDocumentNumber,
       uss.TDC_TD_FIL          AS filialDocumentType,
       uss.EMP_ND_FIL          AS filialDocumentNumber,
       'ANALISTA'              AS roleAnalista
FROM usuarios usr
JOIN USUARIO_SESION uss
  ON uss.USU_USUARIO = usr.usu_usuario
WHERE usr.usu_usuario = 'JOCOLMENARES'
  AND uss.USS_ID = (
    SELECT MAX(USS_ID)
    FROM USUARIO_SESION
    WHERE USU_USUARIO = 'JOCOLMENARES'
  );

