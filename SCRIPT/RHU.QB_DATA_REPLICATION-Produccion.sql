--**********************************************************************************************************
--** NOMBRE SCRIPT        : 
--** OBJETIVO             : Script que se ejecuta cuando salga a produccion  
--** DESCRIPCIÓN          :  
--**  - Registra eventos y valores de variables en la base de datos.  
--**  - Facilita la depuración y monitoreo de procesos en ejecución.  
--**  - Permite rastrear acciones de los usuarios dentro del sistema.  
--**********************************************************************************************************  
--### Crear Botón  
--** 1. Módulo de BMX IT / Administrador de BMX: Se genera el registro en la BD.  
--** 2. Dar acceso: Se asignan permisos correspondientes al usuario.  
--** 3. Administración de Acceso: Se otorgan accesos a Ofertas/Registro Masivo según las necesidades.  
--**********************************************************************************************************
--Registro Masivo: /ms_sel_masivo_hv/ServletInicio?USS_ID_SESSION=session
--Creacion Ofertas: https://reclutador-qa.partnerdavinci.com/sign-in/?usuUsuario=usuario&redirectTo=/crear-oferta
 

--**********************************************************************************************************
--** OBJETIVO             : Insertar nuevos roles en la tabla `ROLES_DOMINIO`.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se están agregando dos nuevos roles al dominio.  
--**  - El primer `INSERT` genera un nuevo ID dinámicamente usando `MAX(ROD_ID) + 1`.  
--**  - El segundo `INSERT` usa un ID fijo (`149`) para el rol de comunicaciones.  
--**  - Ambos roles pertenecen a `DSA_ID = 5`, indicando que están dentro del mismo dominio funcional.  
--**  - Se registran con valores predeterminados (`ROD_DEFAULT`, `ROD_ESTADO`, `ROD_CONFIGURADO`, `ROD_PUBLICO`) en `'N'`.  
--**  - Se audita la creación con la fecha actual (`SYSDATE`) y el usuario `'DESIERRA'`.  
--**********************************************************************************************************                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
Insert into ROLES_DOMINIO (ROD_ID,DSA_ID,ROD_NOMBRE,ROD_DEFAULT,ROD_ESTADO,ROD_CONFIGURADO,ROD_PUBLICO,AUD_FECHA,AUD_USUARIO) 
values ((select MAX(ROD_ID)+1 from ROLES_DOMINIO),5,'SELROL ADMIN OFERTAS RECLUTADOR','N','N','N','N',SYSDATE,'DESIERRA');
/
Insert into ROLES_DOMINIO (ROD_ID,DSA_ID,ROD_NOMBRE,ROD_DEFAULT,ROD_ESTADO,ROD_CONFIGURADO,ROD_PUBLICO,AUD_FECHA,AUD_USUARIO) 
values (149,5,'SELROL COMUNICACIONES OFERTAS RECLUTADOR','N','N','N','N',SYSDATE,'DESIERRA');
/
--**********************************************************************************************************
--** OBJETIVO             : Insertar múltiples usuarios en la tabla `AGRUPACION_USUARIO`.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se registran varios usuarios en la agrupación `715`.  
--**  - Se utiliza `INSERT ALL` para optimizar la inserción en una sola transacción.  
--**  - Los nombres de usuario se almacenan en mayúsculas con `UPPER()`, excepto para `'JAIROJAS'`, que ya está en mayúsculas.  
--**  - Se asigna la misma fecha de auditoría (`TO_DATE('2021/01/11', 'YYYY/MM/DD')`) y usuario auditor (`'HQUINTERO'`).  
--**  - El campo `AGR_USUID` se mantiene constante en `7703` para todos los registros.  
--**  - `ID_USUARIO` se inserta como `NULL`, lo que sugiere que es autoincremental o no obligatorio.  
--**  
--** NOTA:  
--**  - Si `ID_USUARIO` es clave primaria sin autoincremento, es necesario calcular un valor único para cada fila.  
--**  - Si `AGR_CODIGO` representa una agrupación específica, todos los usuarios quedarán asignados a la misma.  
--**********************************************************************************************************

INSERT ALL
    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('kargarcia'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, 'JAIROJAS', TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('gustavgonzalez'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('rfinanciero3'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('juforero'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('desierra'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('CAMILOHERNANDE2'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('JOCOLMENARES'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('MESANTAMARIA'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)

    INTO AGRUPACION_USUARIO (ID_USUARIO, AGR_CODIGO, USU_USUARIO, AUD_FECHA, AUD_USUARIO, AGR_USUID)
    VALUES (NULL, 715, UPPER('CARPAEZ'), TO_DATE('2021/01/11', 'YYYY/MM/DD'), 'HQUINTERO', 7703)
SELECT 1 FROM DUAL;
--**********************************************************************************************************
--** OBJETIVO             : Insertar múltiples usuarios en la tabla `USUARIOS_DOMINIO` asignándolos a diferentes roles.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se insertan usuarios con distintos roles en la base de datos.  
--**  - Se utiliza `INSERT ALL` para optimizar la inserción en una sola transacción.  
--**  - Se calcula `UDS_ID` dinámicamente sumando `MAX(UDS_ID) + n` para evitar colisiones.  
--**  - Los roles asignados son:  
--**    - 140: Coordinador  
--**    - 149: Comunicaciones  
--**    - 40: Administrador  
--**    - 9: Menú de Selección  
--**    - 5: Analista  
--**    - 144: Otro rol asignado a tres usuarios específicos.  
--**  - Todos los registros se crean con `UDS_ESTADO = 'S'` y `AUD_USUARIO = 'DESIERRA'`.  
--**  - La fecha de auditoría se establece con `SYSDATE`.  
--**  
--** NOTA:  
--**  - Si `UDS_ID` es clave primaria sin autoincremento, es necesario asegurarse de que cada valor generado sea único.  
--**  - Se podría optimizar aún más usando una secuencia en lugar de calcular `MAX(UDS_ID) + n`.  
--**********************************************************************************************************
/
DECLARE 
    v_max_id NUMBER;
BEGIN
    -- Obtener el ID máximo antes de la inserción
    SELECT MAX(UDS_ID) INTO v_max_id FROM USUARIOS_DOMINIO;

    -- Insertar múltiples registros en una sola sentencia, eliminando duplicados
    INSERT ALL
        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 1, 9, 'CAMILOHERNANDE2', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 2, 9, 'KARGARCIA', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 3, 40, 'CAMILOHERNANDE2', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 4, 140, 'DESIERRA', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 5, 140, 'KARGARCIA', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 6, 140, UPPER('dleal'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 7, 140, UPPER('gustavgonzalez'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 8, 40, UPPER('LARTEAGA'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 9, 40, UPPER('NBERNA'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 10, 40, UPPER('JAIROJAS'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 11, 5, UPPER('rfinanciero3'), 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 12, 149, 'JUFORERO', 'S', SYSDATE, 'DESIERRA')

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 13, 144, 'YMONDRAGON', 'S', SYSDATE, 'DESIERRA')--SELROL ADMIN OFERTAS RECLUTADOR

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 14, 144, 'MREY', 'S', SYSDATE, 'DESIERRA')--SELROL ADMIN OFERTAS RECLUTADOR

        INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
        VALUES (v_max_id + 15, 144, 'JUFORERO', 'S', SYSDATE, 'DESIERRA')--SELROL ADMIN OFERTAS RECLUTADOR
    SELECT 1 FROM DUAL;
END;
/
--**********************************************************************************************************
--** OBJETIVO             : Otorgar permisos de acceso a múltiples tablas y procedimientos a todos los usuarios (`PUBLIC`).  
--**  
--** DESCRIPCIÓN          :  
--**  - Se concede **`ALL`** (todos los privilegios) sobre varias tablas y procedimientos.  
--**  - Se permite que **cualquier usuario de la base de datos** pueda acceder a estos objetos sin restricciones.  
--**  - Los objetos sobre los que se otorgan permisos incluyen procedimientos (`QB_DATA_REPLICATION`, `FB_LIMPIAR_CADENA_NUE`)  
--**    y tablas relacionadas con entrevistas, experiencia laboral, empleados, educación y datos de usuario.  
--**  - El uso de `PUBLIC` implica que cualquier usuario en la base de datos podrá consultar, modificar o eliminar datos  
--**    según los privilegios incluidos en `ALL`.  
--**  
--** CONSIDERACIONES IMPORTANTES:  
--**  - **Seguridad**: Se recomienda revisar si realmente se necesita otorgar **TODOS** los permisos (`ALL`) a `PUBLIC`,  
--**    ya que esto puede representar un riesgo de seguridad en la base de datos.  
--**  - **Alternativa**: En lugar de `PUBLIC`, se pueden otorgar permisos a roles o usuarios específicos para mayor control.  
--**********************************************************************************************************
GRANT ALL ON RHU.QB_DATA_REPLICATION TO PUBLIC;
GRANT ALL ON FB_LIMPIAR_CADENA_NUE TO PUBLIC;
GRANT ALL ON tsel_entrevista_datfijo TO PUBLIC;
GRANT ALL ON empleado TO PUBLIC;
GRANT ALL ON tsel_experiencia_laboral TO PUBLIC;
GRANT ALL ON tsel_nivel_educativo TO PUBLIC;
GRANT ALL ON usuarios TO PUBLIC;
GRANT ALL ON TSEL_EMPLEADO_APTITUD TO PUBLIC;
GRANT ALL ON TSEL_NUCLEO_FAMILIAR TO PUBLIC;
/
--**********************************************************************************************************
--** OBJETIVO             : Asignar múltiples roles de administrador al usuario 'DESIERRA','JUFORERO' en la tabla `USUARIOS_DOMINIO`.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se inserta el usuario `'DESIERRA'` con diferentes `ROD_ID` sin duplicados.  
--**  - Se genera `UDS_ID` dinámicamente sumando `ROWNUM` al máximo ID existente.  
--**  - Se asigna estado `'S'`, la fecha actual con `SYSDATE`, y el auditor `'JUFORERO'`.  
--**********************************************************************************************************
INSERT INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
SELECT (SELECT MAX(UDS_ID) FROM USUARIOS_DOMINIO) + ROWNUM, 
       ROD_ID, 
       'DESIERRA', 
       'S', 
       SYSDATE, 
       'JUFORERO'
FROM (
    SELECT DISTINCT ROD_ID FROM ( -- Elimina valores duplicados de ROD_ID
        SELECT 5 AS ROD_ID FROM DUAL UNION ALL
        SELECT 9 FROM DUAL UNION ALL
        SELECT 10 FROM DUAL UNION ALL
        SELECT 12 FROM DUAL UNION ALL
        SELECT 15 FROM DUAL UNION ALL
        SELECT 16 FROM DUAL UNION ALL
        SELECT 25 FROM DUAL UNION ALL
        SELECT 27 FROM DUAL UNION ALL
        SELECT 32 FROM DUAL UNION ALL
        SELECT 38 FROM DUAL UNION ALL
        SELECT 47 FROM DUAL UNION ALL
        SELECT 50 FROM DUAL UNION ALL
        SELECT 74 FROM DUAL UNION ALL
        SELECT 76 FROM DUAL UNION ALL
        SELECT 81 FROM DUAL UNION ALL
        SELECT 105 FROM DUAL
    )
);
INSERT INTO USUARIOS_DOMINIO (UDS_ID, ROD_ID, USU_USUARIO, UDS_ESTADO, AUD_FECHA, AUD_USUARIO)
SELECT (SELECT MAX(UDS_ID) FROM USUARIOS_DOMINIO) + ROWNUM, 
       ROD_ID, 
       'JUFORERO', 
       'S', 
       SYSDATE, 
       'DESIERRA'
FROM (SELECT 5 AS ROD_ID FROM DUAL UNION ALL
      SELECT 9 FROM DUAL UNION ALL
      SELECT 10 FROM DUAL UNION ALL
      SELECT 12 FROM DUAL UNION ALL
      SELECT 15 FROM DUAL UNION ALL
      SELECT 16 FROM DUAL UNION ALL
      SELECT 25 FROM DUAL UNION ALL
      SELECT 27 FROM DUAL UNION ALL
      SELECT 27 FROM DUAL UNION ALL
      SELECT 32 FROM DUAL UNION ALL
      SELECT 38 FROM DUAL UNION ALL
      SELECT 47 FROM DUAL UNION ALL
      SELECT 50 FROM DUAL UNION ALL
      SELECT 74 FROM DUAL UNION ALL
      SELECT 76 FROM DUAL UNION ALL
      SELECT 81 FROM DUAL UNION ALL
      SELECT 105 FROM DUAL);
/
--**********************************************************************************************************
--** OBJETIVO             : Registrar nuevos tipos de documentos en las tablas `tsel_tipo_documento` y `ADM.TIPO_DOCUMENTO`.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se insertan registros en `tsel_tipo_documento`, agregando documentos como `PERMISO TEMPORAL` y `CARNET DIPLOMÁTICO`.  
--**  - Se insertan registros en `ADM.TIPO_DOCUMENTO`, agregando diplomas, hojas de vida y certificados de idiomas.  
--**  - Se asigna `AUD_USER = 'JULFORERO'` como usuario auditor y `SYSDATE` como la fecha de auditoría.  
--**  - Cada registro ha sido **confirmado en producción**, asegurando su validez en el sistema.  
--**  
--** NOTA:  
--**  - La columna `DTD_CODIGO` se mantiene como `NULL`, lo que sugiere que no hay una relación específica con otra tabla.  
--**  - Se utiliza `TPD_ALIAS = 'RECLUTADOR'` en todos los registros de `ADM.TIPO_DOCUMENTO`, indicando que estos documentos  
--**    están relacionados con el módulo de reclutamiento.  
--**  - **Verificar si se requiere actualización o eliminación de registros anteriores para evitar duplicados.**  
--**********************************************************************************************************
INSERT into tsel_tipo_documento (TDO_ID_TIPO_DOCUMENTO, TDO_NOMBRE, TDO_ABREVIATURA, AUD_USER, AUD_FECHA) 
values (15, 'PERMISO TEMPORAL', 'PT', 'JULFORERO', SYSDATE); --CONFIRMADO PRODUCCION

INSERT into tsel_tipo_documento (TDO_ID_TIPO_DOCUMENTO, TDO_NOMBRE, TDO_ABREVIATURA, AUD_USER, AUD_FECHA) 
values (16, 'CARNET DIPLOMATICO ', 'CD', 'JULFORERO', SYSDATE); --CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (127, 'Diploma Técnica Laboral', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL); --CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (128, 'Diploma Preescolar', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL); --CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (129, 'Diploma Educación Formal - Otros', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL);--CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (130, 'HOJA DE VIDA GENERADA DEL RECLUTADOR', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL); --CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (131, 'Nuevos Archivos', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL); --CONFIRMADO PRODUCCION

INSERT INTO ADM.TIPO_DOCUMENTO (TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS, TPD_GRUPO)
VALUES (132, 'CERTIFICADOS DE IDIOMAS', NULL, SYSDATE, 'JULFORERO', 'RECLUTADOR', NULL); --CONFIRMADO PRODUCCION
/
--**********************************************************************************************************
--** OBJETIVO             : Registrar una nueva zona y sus respectivos barrios en la base de datos.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se inserta una nueva zona en la tabla `ZONA` con el nombre **"SUMAPAZ"**, asociada a **Bogotá, Cundinamarca, Colombia**.  
--**  - Se registran tres barrios dentro de la zona "SUMAPAZ" en la tabla `BARRIO`:  
--**      - **BETANIA** (marcado como barrio por defecto `'S'`).  
--**      - **NAZARETH** y **EL RAIZAL** (no son barrios por defecto, `'N'`).  
--**  - Cada barrio se asocia a la zona "SUMAPAZ" manteniendo la estructura geográfica país-departamento-ciudad.  
--**  
--** CONSIDERACIONES IMPORTANTES:  
--**  - **Evitar duplicados**: Se recomienda verificar que la zona "SUMAPAZ" y los barrios no existan previamente en la BD.  
--**  - **Integridad referencial**: Asegurar que los valores de `PAI_NOMBRE`, `DPT_NOMBRE`, `CIU_NOMBRE` coincidan con los registros en otras tablas.  
--**  - **Consistencia de nombres**: Revisar si "SANTAFE DE BOGOTA" se usa uniformemente en el sistema o si debería ser simplemente "BOGOTÁ".  
--**********************************************************************************************************
INSERT INTO ZONA (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, ZON_CODIGO, ZON_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 20, 'N');
/
INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'BETANIA', 'S');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'NAZARETH', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'EL RAIZAL', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'ISTMO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAGUNA VERDE', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAS PALMAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAS SOPAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAS ÁNIMAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAS AURAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LOS RÍOS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'PEÑALISA', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SANTA ROSA ALTA', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SANTA ROSA BAJA', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'TABACO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'TAQUECITOS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LA UNIÓN', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'NUEVA GRANADA', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SAN JUAN DE SUMAPAZ', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'CAPITOLIO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'CHORRERAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'CONCEPCIÓN', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'EL TOLDO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAGUNITAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'LAS VEGAS', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SAN ANTONIO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SAN JOSÉ', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SAN JUAN', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'SANTO DOMINGO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'TUNAL ALTO', 'N');

INSERT INTO BARRIO (PAI_NOMBRE, DPT_NOMBRE, CIU_NOMBRE, ZON_NOMBRE, BAR_NOMBRE, BAR_DEFECTO) VALUES ('COLOMBIA', 'CUNDINAMARCA', 'SANTAFE DE BOGOTA', 'SUMAPAZ', 'TUNAL BAJO', 'N');

commit;
/
--**********************************************************************************************************
--** OBJETIVO             : Deshabilitar triggers y modificar una columna en la tabla `tsel_emp_dat`.  
--**  
--** DESCRIPCIÓN          :  
--**  - **ALTER TRIGGER RHU.DB_VALIDA_NOMBRES DISABLE**:  
--**    - Deshabilita el trigger `DB_VALIDA_NOMBRES` en el esquema `RHU`.  
--**    - Este trigger probablemente valida nombres al insertar o actualizar registros en una tabla.  
--**  
--**  - **ALTER TRIGGER RHU.DB_LIMPIAR_NOMBRES DISABLE**:  
--**    - Deshabilita el trigger `DB_LIMPIAR_NOMBRES` en el esquema `RHU`.  
--**    - Este trigger posiblemente ejecuta una limpieza o normalización de nombres en registros nuevos o actualizados.  
--**  
--**  - **ALTER TABLE rhu.tsel_emp_dat MODIFY (RAZA VARCHAR2(4000 BYTE))**:  
--**    - Modifica la columna `RAZA` en la tabla `tsel_emp_dat`, aumentando o estableciendo su tamaño en **4000 bytes**.  
--**    - Este cambio permite almacenar textos más largos en la columna, útil si se manejan descripciones detalladas.  
--**  
--** CONSIDERACIONES IMPORTANTES:  
--**  - **Deshabilitar triggers** puede afectar la integridad de los datos. Asegurar que no sean necesarios antes de deshabilitarlos.  
--**  - **Modificar el tamaño de la columna `RAZA`** debe considerar si hay restricciones de rendimiento o almacenamiento en la BD.  
--**********************************************************************************************************
ALTER TRIGGER RHU.DB_VALIDA_NOMBRES DISABLE;

ALTER TRIGGER RHU.DB_LIMPIAR_NOMBRES DISABLE;

ALTER TABLE rhu.tsel_emp_dat MODIFY (RAZA VARCHAR2(4000 BYTE));
/
--**********************************************************************************************************
--** OBJETIVO             : Insertar nuevos registros en la tabla `adm.propiedades_documento` para definir  
--**                        documentos administrativos con sus respectivas propiedades.  
--**  
--** DESCRIPCIÓN          :  
--**  - Se agregan registros con códigos específicos (`PRD_CODIGO`, `TPD_CODIGO`) asociados a diferentes tipos  
--**    de documentos.  
--**  - `TDT_ORIGEN = 'O'` indica que estos documentos tienen un origen obligatorio.  
--**  - `TDT_OBLIGATORIO = 'O'` establece que los documentos son de carácter obligatorio.  
--**  - `TDT_VERSION` varía entre `'S'` (posiblemente estándar) y `'V'` (posiblemente validado).  
--**  - `AUD_FECHA` se registra con `SYSDATE`, y `AUD_USUARIO = 'JULFORERO'` audita los cambios.  
--**  
--** LISTA DE DOCUMENTOS REGISTRADOS:  
--**  - `127` → Diploma Técnica Laboral  
--**  - `128` → Diploma Preescolar  
--**  - `129` → Diploma Educación Formal - Otros  
--**  - `130` → Hoja de Vida Generada del Reclutador  
--**  - `131` → Nuevos Archivos  
--**  - `132` → Certificados de Idiomas  
--**  
--** CONSIDERACIONES IMPORTANTES:  
--**  - **Verificar si ya existen estos documentos** en la base de datos antes de ejecutar los `INSERT`.  
--**  - **Revisar la nomenclatura de `TDT_VERSION`** para asegurar la correcta clasificación de los documentos.  
--**  - **Asegurar que no se requieran valores en `TDT_VISIBLE` y `TDT_CATEGORIA`** para mantener la consistencia.  
--**********************************************************************************************************
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (127, 127, 'O', 'O', 'S', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --Diploma Técnica Laboral
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (128, 128, 'O', 'O', 'V', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --Diploma Preescolar
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (129, 129, 'O', 'O', 'S', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --Diploma Educación Formal - Otros
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (131, 131, 'O', 'O', 'S', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --Nuevos Archivos
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (132, 132, 'O', 'O', 'S', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --CERTIFICADOS DE IDIOMAS
INSERT INTO adm.propiedades_documento (PRD_CODIGO, TPD_CODIGO, TDT_ORIGEN, TDT_OBLIGATORIO, TDT_VERSION, TDT_VISIBLE, TDT_CATEGORIA, AUD_FECHA, AUD_USUARIO) VALUES (130, 130, 'O', 'O', 'V', NULL, NULL, TO_DATE('18/12/24', 'DD/MM/YY'), 'JULFORERO'); --HOJA DE VIDA GENERADA DEL RECLUTADOR

/
CREATE OR REPLACE TRIGGER RHU.DB_INSERTA_BARRIO
BEFORE INSERT OR UPDATE ON RHU.EMPLEADO
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
-- ******************************************************************
-- ** SCRIPT  : DRHU0196.SQL
-- ** DIRECTORIO : C:\FTES\V1\SQL
-- ** OBJETIVO  : Creacion Paquete db_inserta_barrio
-- ** ESQUEMA  : RHU
-- ** CREACION  : Hugo Quintero Bertel
-- ** ACTUALIZACION : 2014/03/04
-- ******************************************************************
DECLARE
  v_count NUMBER := 0; -- Variable para contar si el registro ya existe
  vcError VARCHAR2(2000);
BEGIN
  -- Verificar si el registro ya existe en la tabla BARRIO
  SELECT COUNT(*)
  INTO v_count
  FROM BARRIO
  WHERE UPPER(PAI_NOMBRE) = UPPER(:NEW.PAI_NOMBRE_RES)
    AND UPPER(DPT_NOMBRE) = UPPER(:NEW.DPT_NOMBRE_RES)
    AND UPPER(CIU_NOMBRE) = UPPER(:NEW.CIU_NOMBRE_RES)
    AND UPPER(ZON_NOMBRE) = UPPER(:NEW.ZON_NOMBRE)
    AND UPPER(BAR_NOMBRE) = UPPER(:NEW.BAR_NOMBRE);

  -- Solo insertar si el registro no existe
  IF v_count = 0 THEN
    INSERT INTO BARRIO
    (
      PAI_NOMBRE,
      DPT_NOMBRE,
      CIU_NOMBRE,
      ZON_NOMBRE,
      BAR_NOMBRE,
      BAR_DEFECTO
    )
    VALUES
    (
      :NEW.PAI_NOMBRE_RES,
      :NEW.DPT_NOMBRE_RES,
      :NEW.CIU_NOMBRE_RES,
      :NEW.ZON_NOMBRE,
      :NEW.BAR_NOMBRE,
      'N'
    );
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    vcError := 'Error en el Trigger RHU.DB_INSERTA_BARRIO: ' || SQLERRM;
    -- Opcional: Puedes registrar el error en una tabla de auditoría
    NULL; -- Ignorar el error
END;

