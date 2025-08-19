create or replace PACKAGE     RHU.QB_DATA_REPLICATION AS
--**********************************************************************************************************
--** nombre script        : QRHU0345.sql
--** objetivo             : Realizar la Replicacion en Tiempo Real Con Davinci
--** esquema              : RHU
--** nombre               : QB_DATA_REPLICATION / BODY
--** autor                : Juan Sebastian Forero S.
--** fecha modificacion   : 2025/05/08
--**********************************************************************************************************
TYPE vcrefcursor IS REF CURSOR;

PROCEDURE update_native_language(
    p_tdc_td_epl    VARCHAR2, 
    p_epl_nd        NUMBER, 
    p_new_language  VARCHAR2,
    p_status        OUT VARCHAR2, 
    p_message       OUT VARCHAR2
);

PROCEDURE update_marital_status(
    p_tdc_td        VARCHAR2, 
    p_epl_nd        NUMBER, 
    p_new_status    VARCHAR2,
    p_status        OUT VARCHAR2, 
    p_message       OUT VARCHAR2
);

PROCEDURE guardarexperiencialaboral(
    vctdctd               VARCHAR2,
    nmeplnd               NUMBER,
    vcepl_email           VARCHAR2,
    vcnombreempresa       VARCHAR2,
    dtfechaingreso        DATE,
    vcnombretemporal      VARCHAR2,
    vcactualmente         VARCHAR2,
    vccargodesempenado    VARCHAR2,
    dtfecharetiro         DATE,
    nmnivelcargo          NUMBER,
    nmcargoequivalente    NUMBER,
    nmarea                NUMBER,
    nmpersonascargo       NUMBER,
    nmsalario             NUMBER,
    nmmotivoretiro        NUMBER,
    nmsector              NUMBER,
    nmsubsector           NUMBER,
    vcpainombre           VARCHAR2,
    vcdptnombre           VARCHAR2,
    vcciunombre           VARCHAR2,
    vcjefeinmediato       VARCHAR2,
    vccargojefe           VARCHAR2,
    vctelefono            VARCHAR2,
    vcotrotelefono        VARCHAR2,
    vcresumenfunciones    VARCHAR2,
    nmcodigo              NUMBER,
    nmtelefono_ext        NUMBER,
    nmotro_telefono_ext   NUMBER,
    vcerror               OUT VARCHAR2,
    vcgeneradocodigo      OUT NUMBER
);

PROCEDURE guardainFORMacionacademica(
    vctdctd               VARCHAR2,
    nmeplnd               NUMBER,
    nmcodigo              NUMBER,
    vcepl_email           VARCHAR2,
    nmtte_codigo          NUMBER,
    vcpainombre           VARCHAR2,
    vcdptnombre           VARCHAR2,
    vcciunombre           VARCHAR2,
    nmtprcodigo           NUMBER,
    vctprdescripcion      VARCHAR2,
    vcotrotitulo          VARCHAR2,
    nmtincodigo           NUMBER,
    vcotrainstitucion     VARCHAR2,
    nmten_codigo          NUMBER,
    vcnivelalcanzado      VARCHAR2,
    nmtmo_codigo          NUMBER,
    nmtho_codigo          NUMBER,
    vcthodescripcion      VARCHAR2,
    dtfechainicioestudio  DATE,
    dtfechafinalestudio   DATE,
    vctienetarjeta        VARCHAR2,
    vcnumerotarjeta       VARCHAR2,
    vcerror               OUT VARCHAR2,
    vcgeneradocodigo      OUT NUMBER
);


PROCEDURE pl_buscar_usuario (
    vcusu_usuario    IN VARCHAR2,
    vcmensajeproceso OUT VARCHAR2,
    vcestado_proceso OUT VARCHAR2,
     vcconsulta       OUT SYS_REFCURSOR 
) ;

PROCEDURE PL_CARGAR_INFOUSUARIO(VCUSU_USUARIO     IN   VARCHAR2,
                                  VCERROR           OUT  VARCHAR2,
                                  VCUSUARIO         OUT  VARCHAR2) ;

PROCEDURE PL_GUARDAR_OTROS_CONOCIMIENTOS(
    VCTDC_TD              IN  VARCHAR2,
    NMEPL_ND              IN  NUMBER,
    NMEAP_ITEM            IN  NUMBER,
    NMTSA_CODIGO          IN  NUMBER,
    VCEAP_NOMBRE_APTITUD  IN  VARCHAR2,
    NMEAP_NIVEL           IN  NUMBER,
    VCEAP_OBSERVACION     IN  VARCHAR2,
    VCERROR               OUT VARCHAR2,
    NMGENERADOCODIGO      OUT NUMBER);

PROCEDURE PL_GUARDAR_NUCLEO_FAMILIAR(VCTDC_TD             IN  VARCHAR2,
                                       NMEPL_ND             IN  NUMBER,
                                       NMITEM               IN  NUMBER,
                                       NMEDAD               IN  NUMBER,
                                       VCPAR_SIGLA          IN  VARCHAR2,
                                       NMTOCU_ID            IN  NUMBER,
                                       VCNOMBRES            IN  VARCHAR2,
                                       VCAPELLIDOS          IN  VARCHAR2,
                                       DTFECHA_NACIMIENTO   IN  DATE,
                                       NMCELULAR            IN  NUMBER,
                                       VCVIVE_CON_CANDIDATO IN  VARCHAR2,
                                       NMTTE_CODIGO         IN  NUMBER,
                                       VC_TNFGENERO         IN VARCHAR2,
                                       VCERROR              OUT VARCHAR2,
                                       NMGENERADOCODIGO     OUT NUMBER);


PROCEDURE PL_CONSULTAR_REQUISICION(n_concecutivo IN NUMBER,
                                   var_cursor_requisicion OUT VCREFCURSOR,
                                   vcmensajeproceso OUT VARCHAR2,
                                   vcestado_proceso OUT VARCHAR2);
                                       
END QB_DATA_REPLICATION;
/
create or replace PACKAGE BODY     RHU.QB_DATA_REPLICATION AS
--**********************************************************************************************************
--** nombre script        : QRHU0345.sql
--** objetivo             : Realizar la Replicacion en Tiempo Real Con Davinci
--** esquema              : RHU
--** nombre               : QB_DATA_REPLICATION / BODY
--** autor                : Juan Sebastian Forero S.
--** fecha modificacion   : 2025/05/08
--**********************************************************************************************************
    FUNCTION Fl_Obtener_rol(vcusu_usuario VARCHAR2
    , nmRodId NUMBER)
        RETURN NUMBER IS

        nmSalida NUMBER(20) := 0;

    BEGIN

        SELECT COUNT(rod_id)
        INTO nmSalida
        FROM (SELECT ROD_ID
              FROM USUARIOS
              WHERE USU_USUARIO = UPPER(vcusu_usuario)
              UNION
              SELECT ROD_ID
              FROM USUARIOS_DOMINIO
              WHERE USU_USUARIO = UPPER(vcusu_usuario)
              UNION
              SELECT ROD_ID
              FROM ROLES_CARGO
              WHERE USU_CARGO = ((SELECT USU_CARGO FROM USUARIOS WHERE USU_USUARIO = UPPER(vcusu_usuario))))
        WHERE rod_id = nmRodId;

        RETURN nmSalida;

    EXCEPTION
        WHEN OTHERS THEN
            nmSalida := 0;

    END Fl_Obtener_rol;


    PROCEDURE update_native_language(
        p_tdc_td_epl VARCHAR2,
        p_epl_nd NUMBER,
        p_new_language VARCHAR2,
        p_status OUT VARCHAR2,
        p_message OUT VARCHAR2
    ) IS
    BEGIN
    
    PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: update_native_language, p_tdc_td_epl: ' || p_tdc_td_epl || 
        ', p_epl_nd: ' || TO_CHAR(p_epl_nd) || 
        ', p_new_language: ' || p_new_language
    );
    
        -- Intentar actualizar la tabla
        UPDATE tsel_entrevista_datfijo
        SET edf_idioma_nativo = p_new_language
        WHERE tdc_td_epl = p_tdc_td_epl
          AND epl_nd = p_epl_nd;

        -- Verificar si la actualización afectó alguna fila
        IF SQL%rowcount > 0 THEN
            p_status := 'SUCCESS';
            p_message := 'El idioma nativo fue actualizado correctamente.';
        ELSE
            p_status := 'FAILURE';
            p_message := 'No se encontró ningún registro que coincidiera con los criterios especificados.';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'ERROR';
            p_message := 'Ocurrió un error durante la actualización: ' || sqlerrm;
    END update_native_language;

    PROCEDURE update_marital_status(
        p_tdc_td VARCHAR2,
        p_epl_nd NUMBER,
        p_new_status VARCHAR2,
        p_status OUT VARCHAR2,
        p_message OUT VARCHAR2
    ) IS
    BEGIN
    
    PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: update_marital_status, p_tdc_td: ' || p_tdc_td || 
        ', p_epl_nd: ' || TO_CHAR(p_epl_nd) || 
        ', p_new_status: ' || p_new_status
    );
    
        UPDATE empleado
        SET ecv_sigla = p_new_status
        WHERE tdc_td = p_tdc_td
          AND epl_nd = p_epl_nd;

        IF SQL%rowcount > 0 THEN
            p_status := 'SUCCESS';
            p_message := 'El estado civil fue actualizado correctamente.';
        ELSE
            p_status := 'FAILURE';
            p_message := 'No se encontró ningún registro que coincidiera con los criterios especificados.';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'ERROR';
            p_message := 'Ocurrió un error durante la actualización: ' || sqlerrm;
    END update_marital_status;

    PROCEDURE guardarexperiencialaboral(
        vctdctd VARCHAR2,
        nmeplnd NUMBER,
        vcepl_email VARCHAR2,
        vcnombreempresa VARCHAR2,
        dtfechaingreso DATE,
        vcnombretemporal VARCHAR2,
        vcactualmente VARCHAR2,
        vccargodesempenado VARCHAR2,
        dtfecharetiro DATE,
        nmnivelcargo NUMBER,
        nmcargoequivalente NUMBER,
        nmarea NUMBER,
        nmpersonascargo NUMBER,
        nmsalario NUMBER,
        nmmotivoretiro NUMBER,
        nmsector NUMBER,
        nmsubsector NUMBER,
        vcpainombre VARCHAR2,
        vcdptnombre VARCHAR2,
        vcciunombre VARCHAR2,
        vcjefeinmediato VARCHAR2,
        vccargojefe VARCHAR2,
        vctelefono VARCHAR2,
        vcotrotelefono VARCHAR2,
        vcresumenfunciones VARCHAR2,
        nmcodigo NUMBER,
        nmtelefono_ext NUMBER,
        nmotro_telefono_ext NUMBER,
        vcerror OUT VARCHAR2,
        vcgeneradocodigo OUT NUMBER
    ) AS
        nmcodigotmp NUMBER := 0;
    BEGIN
        PB_SEGUIMIENTO_LONG('REPLICACION2', 
                    'guardarexperiencialaboral - ' || 
                    'vctdctd: ' || vctdctd || ', ' ||
                    'nmeplnd: ' || TO_CHAR(nmeplnd) || ', ' ||
                    'vcepl_email: ' || vcepl_email || ', ' ||
                    'vcnombreempresa: ' || vcnombreempresa || ', ' ||
                    'dtfechaingreso: ' || TO_CHAR(dtfechaingreso, 'YYYY-MM-DD') || ', ' ||
                    'vcnombretemporal: ' || vcnombretemporal || ', ' ||
                    'vcactualmente: ' || vcactualmente || ', ' ||
                    'vccargodesempenado: ' || vccargodesempenado || ', ' ||
                    'dtfecharetiro: ' || TO_CHAR(dtfecharetiro, 'YYYY-MM-DD') || ', ' ||
                    'nmnivelcargo: ' || TO_CHAR(nmnivelcargo) || ', ' ||
                    'nmcargoequivalente: ' || TO_CHAR(nmcargoequivalente) || ', ' ||
                    'nmarea: ' || TO_CHAR(nmarea) || ', ' ||
                    'nmpersonascargo: ' || TO_CHAR(nmpersonascargo) || ', ' ||
                    'nmsalario: ' || TO_CHAR(nmsalario) || ', ' ||
                    'nmmotivoretiro: ' || TO_CHAR(nmmotivoretiro) || ', ' ||
                    'nmsector: ' || TO_CHAR(nmsector) || ', ' ||
                    'nmsubsector: ' || TO_CHAR(nmsubsector) || ', ' ||
                    'vcpainombre: ' || vcpainombre || ', ' ||
                    'vcdptnombre: ' || vcdptnombre || ', ' ||
                    'vcciunombre: ' || vcciunombre || ', ' ||
                    'vcjefeinmediato: ' || vcjefeinmediato || ', ' ||
                    'vccargojefe: ' || vccargojefe || ', ' ||
                    'vctelefono: ' || vctelefono || ', ' ||
                    'vcotrotelefono: ' || vcotrotelefono || ', ' ||
                    'vcresumenfunciones: ' || vcresumenfunciones || ', ' ||
                    'nmcodigo: ' || TO_CHAR(nmcodigo) || ', ' ||
                    'nmtelefono_ext: ' || TO_CHAR(nmtelefono_ext) || ', ' ||
                    'nmotro_telefono_ext: ' || TO_CHAR(nmotro_telefono_ext));
    PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , 'nmcodigo : ' || nmcodigo);
    
        IF nvl(nmcodigo, 0) = 0 THEN
            PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '1. nmcodigo : ' || nmcodigo);
            SELECT nvl(MAX(codigo),
                       0) + 1
            INTO nmcodigotmp
            FROM tsel_experiencia_laboral
            WHERE tdc_td_epl = vctdctd
              AND epl_nd = nmeplnd;

            INSERT INTO tsel_experiencia_laboral (tdc_td_epl,
                                                  epl_nd,
                                                  codigo,
                                                  nombre_empresa,
                                                  fecha_ingreso,
                                                  nombre_empresa_temporal,
                                                  actual,
                                                  nombre_cargo,
                                                  fecha_retiro,
                                                  tnc_codigo,
                                                  tce_codigo,
                                                  tsa_codigo,
                                                  numero_personas,
                                                  salario,
                                                  tmr_codigo,
                                                  tse_codigo,
                                                  tss_codigo,
                                                  cid_pai_nombre,
                                                  cid_dpt_nombre,
                                                  cid_ciu_nombre,
                                                  jefe_inmediato,
                                                  cargo_jefe,
                                                  telefono,
                                                  otro_telefono,
                                                  funciones,
                                                  telefono_ext,
                                                  otro_telefono_ext)
            VALUES (vctdctd,
                    upper(nmeplnd),
                    nmcodigotmp,
                    upper(vcnombreempresa),
                    dtfechaingreso,
                    upper(vcnombretemporal),
                    upper(vcactualmente),
                    upper(vccargodesempenado),
                    dtfecharetiro,
                    nmnivelcargo,
                    nmcargoequivalente,
                    nmarea,
                    nmpersonascargo,
                    nmsalario,
                    nmmotivoretiro,
                    nmsector,
                    nmsubsector,
                    upper(vcpainombre),
                    upper(vcdptnombre),
                    upper(vcciunombre),
                    fb_limpiar_cadena_nue(6,
                                          upper(vcjefeinmediato)),
                    upper(vccargojefe),
                    upper(vctelefono),
                    upper(vcotrotelefono),
                    upper(vcresumenfunciones),
                    nmtelefono_ext,
                    nmotro_telefono_ext);
                        PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '2. nmcodigo : ' || nmcodigo);

        ELSE
                       PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '3. nmcodigo : ' || nmcodigo);
            UPDATE tsel_experiencia_laboral
            SET nombre_empresa          = upper(vcnombreempresa),
                fecha_ingreso           = dtfechaingreso,
                nombre_empresa_temporal = upper(vcnombretemporal),
                actual                  = upper(vcactualmente),
                nombre_cargo            = upper(vccargodesempenado),
                fecha_retiro            = dtfecharetiro,
                tnc_codigo              = nmnivelcargo,
                tce_codigo              = nmcargoequivalente,
                tsa_codigo              = nmarea,
                numero_personas         = nmpersonascargo,
                salario                 = nmsalario,
                tmr_codigo              = nmmotivoretiro,
                tse_codigo              = nmsector,
                tss_codigo              = nmsubsector,
                cid_pai_nombre          = upper(vcpainombre),
                cid_dpt_nombre          = upper(vcdptnombre),
                cid_ciu_nombre          = upper(vcciunombre),
                jefe_inmediato          = fb_limpiar_cadena_nue(6,
                                                                upper(vcjefeinmediato)),
                cargo_jefe              = upper(vccargojefe),
                telefono                = upper(vctelefono),
                otro_telefono           = upper(vcotrotelefono),
                funciones               = upper(vcresumenfunciones),
                telefono_ext            = nmtelefono_ext,
                otro_telefono_ext       = nmotro_telefono_ext,
                aud_user                = user,
                aud_fecha               = sysdate
            WHERE tdc_td_epl = vctdctd
              AND epl_nd = nmeplnd
              AND codigo = nmcodigo;

            nmcodigotmp := nmcodigo;
        END IF;

        qb_jsel0003.setsession(vctdctd, nmeplnd, lower(vcepl_email), 'G', 'INFORMACION LABORAL');
        vcgeneradocodigo := nmcodigotmp;
                       PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '4. nmcodigo : ' || nmcodigo);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF (sqlcode = -02291) THEN
                vcerror := 'Estimado usuario, primero debe guardar los datos basicos de su hoja de vida';
                  PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '5. nmcodigo : ' || 'Estimado usuario, primero debe guardar los datos basicos de su hoja de vida');
                RETURN;
            END IF;
            vcerror := qb_jsel0003.getdescripcionequiverror(
                    'ERROR GUARDANDO EXPERIENCIA LABORAL (qb_jsel0006.guardarexperiencialaboral) '
                        || sqlerrm);
                       PB_SEGUIMIENTO_LONG('seguimiento_masivo_hv' , '5. nmcodigo : ' || sqlerrm);
    END guardarexperiencialaboral;

    PROCEDURE guardainformacionacademica(
        vctdctd VARCHAR2,
        nmeplnd NUMBER,
        nmcodigo NUMBER,
        vcepl_email VARCHAR2,
        nmtte_codigo NUMBER,
        vcpainombre VARCHAR2,
        vcdptnombre VARCHAR2,
        vcciunombre VARCHAR2,
        nmtprcodigo NUMBER,
        vctprdescripcion VARCHAR2,
        vcotrotitulo VARCHAR2,
        nmtincodigo NUMBER,
        vcotrainstitucion VARCHAR2,
        nmten_codigo NUMBER,
        vcnivelalcanzado VARCHAR2,
        nmtmo_codigo NUMBER,
        nmtho_codigo NUMBER,
        vcthodescripcion VARCHAR2,
        dtfechainicioestudio DATE,
        dtfechafinalestudio DATE,
        vctienetarjeta VARCHAR2,
        vcnumerotarjeta VARCHAR2,
        vcerror OUT VARCHAR2,
        vcgeneradocodigo OUT NUMBER
    ) AS
        nmcodigotmp NUMBER := 0;
        nmcount     NUMBER := 0;
        exepl EXCEPTION;
    BEGIN
    
    PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: guardainformacionacademica, ' ||
        'vctdctd: ' || vctdctd || ', ' ||
        'nmeplnd: ' || TO_CHAR(nmeplnd) || ', ' ||
        'nmcodigo: ' || TO_CHAR(nmcodigo) || ', ' ||
        'vcepl_email: ' || vcepl_email || ', ' ||
        'nmtte_codigo: ' || TO_CHAR(nmtte_codigo) || ', ' ||
        'vcpainombre: ' || vcpainombre || ', ' ||
        'vcdptnombre: ' || vcdptnombre || ', ' ||
        'vcciunombre: ' || vcciunombre || ', ' ||
        'nmtprcodigo: ' || TO_CHAR(nmtprcodigo) || ', ' ||
        'vctprdescripcion: ' || vctprdescripcion || ', ' ||
        'vcotrotitulo: ' || vcotrotitulo || ', ' ||
        'nmtincodigo: ' || TO_CHAR(nmtincodigo) || ', ' ||
        'vcotrainstitucion: ' || vcotrainstitucion || ', ' ||
        'nmten_codigo: ' || TO_CHAR(nmten_codigo) || ', ' ||
        'vcnivelalcanzado: ' || vcnivelalcanzado || ', ' ||
        'nmtmo_codigo: ' || TO_CHAR(nmtmo_codigo) || ', ' ||
        'nmtho_codigo: ' || TO_CHAR(nmtho_codigo) || ', ' ||
        'vcthodescripcion: ' || vcthodescripcion || ', ' ||
        'dtfechainicioestudio: ' || TO_CHAR(dtfechainicioestudio, 'YYYY-MM-DD') || ', ' ||
        'dtfechafinalestudio: ' || TO_CHAR(dtfechafinalestudio, 'YYYY-MM-DD') || ', ' ||
        'vctienetarjeta: ' || vctienetarjeta || ', ' ||
        'vcnumerotarjeta: ' || vcnumerotarjeta
    );
        -- SE VALIDA EXISTENCIA EMPLEADO
        BEGIN
            SELECT COUNT(*)
            INTO nmcount
            FROM empleado
            WHERE tdc_td = vctdctd
              AND epl_nd = nmeplnd;

        EXCEPTION
            WHEN OTHERS THEN
                nmcount := 0;
                RAISE exepl;
        END;

        -- Nivel educativo
        IF nmcount > 0 THEN
            IF nvl(nmcodigo, 0) = 0 THEN
                SELECT nvl(MAX(codigo) + 1,
                           1)
                INTO nmcodigotmp
                FROM tsel_nivel_educativo
                WHERE tdc_td_epl = vctdctd
                  AND epl_nd = nmeplnd;

                BEGIN
                    INSERT INTO tsel_nivel_educativo (tdc_td_epl,
                                                      epl_nd,
                                                      codigo,
                                                      tte_codigo,
                                                      pai_nombre,
                                                      dpt_nombre,
                                                      ciu_nombre,
                                                      tpr_codigo,
                                                      area_curso,
                                                      otro_titulo_obtenido,
                                                      tin_codigo,
                                                      otra_institucion,
                                                      ten_codigo,
                                                      nivel,
                                                      tmo_codigo,
                                                      tho_codigo,
                                                      horario,
                                                      fecha_ingreso,
                                                      fecha_finalizacion,
                                                      tiene_tarjeta,
                                                      tarjeta_profesional)
                    VALUES (upper(vctdctd),
                            nmeplnd,
                            nmcodigotmp,
                            nmtte_codigo,
                            upper(vcpainombre),
                            upper(vcdptnombre),
                            upper(vcciunombre),
                            nmtprcodigo,
                            upper(vctprdescripcion),
                            upper(vcotrotitulo),
                            nmtincodigo,
                            upper(vcotrainstitucion),
                            nmten_codigo,
                            upper(vcnivelalcanzado),
                            nmtmo_codigo,
                            nmtho_codigo,
                            upper(vcthodescripcion),
                            dtfechainicioestudio,
                            dtfechafinalestudio,
                            upper(vctienetarjeta),
                            vcnumerotarjeta);

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        vcerror := 'ERROR GUARDANDO INFORMACION ACADEMICA (qb_jsel0005.guardainFORMacionacademica) ' ||
                                   sqlerrm;
                        pb_seguimiento('NV_ESCOLAR', 'guardainFORMacionacademica insert '
                            || 'vctdctd: '
                            || vctdctd
                            || 'nmeplnd: '
                            || nmeplnd
                            || 'error: '
                            || sqlerrm);

                END;

            ELSE
                BEGIN
                    UPDATE tsel_nivel_educativo
                    SET tte_codigo           = nmtte_codigo,
                        pai_nombre           = upper(vcpainombre),
                        dpt_nombre           = upper(vcdptnombre),
                        ciu_nombre           = upper(vcciunombre),
                        tpr_codigo           = nmtprcodigo,
                        area_curso           = upper(vctprdescripcion),
                        otro_titulo_obtenido = upper(vcotrotitulo),
                        tin_codigo           = nmtincodigo,
                        otra_institucion     = upper(vcotrainstitucion),
                        ten_codigo           = nmten_codigo,
                        nivel                = upper(vcnivelalcanzado),
                        tmo_codigo           = nmtmo_codigo,
                        tho_codigo           = nmtho_codigo,
                        horario              = upper(vcthodescripcion),
                        fecha_ingreso        = dtfechainicioestudio,
                        fecha_finalizacion   = dtfechafinalestudio,
                        tiene_tarjeta        = upper(vctienetarjeta),
                        tarjeta_profesional  = vcnumerotarjeta,
                        aud_user             = user,
                        aud_fecha            = sysdate
                    WHERE tdc_td_epl = vctdctd
                      AND epl_nd = nmeplnd
                      AND codigo = nmcodigo;

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        vcerror :=
                                'ERROR ACTUALIZANDO INFORMACION ACADEMICA - (qb_jsel0005.guardainFORMacionacademica) ' ||
                                sqlerrm;
                        pb_seguimiento('NV_ESCOLAR', 'guardainFORMacionacademica update '
                            || 'vctdctd: '
                            || vctdctd
                            || 'nmeplnd: '
                            || nmeplnd
                            || 'error: '
                            || sqlerrm);

                END;

                nmcodigotmp := nmcodigo;
            END IF;

            qb_jsel0003.setsession(vctdctd, nmeplnd, lower(vcepl_email), 'G', 'INFORMACION ACADEMICA');
            vcgeneradocodigo := nmcodigotmp;
        ELSE
            RAISE exepl;
        END IF;

    EXCEPTION
        WHEN exepl THEN
            vcerror := 'Estimado usuario, primero debe guardar los datos basicos de su hoja de vida';
            RETURN;
        WHEN OTHERS THEN
            vcerror := 'ERROR INFORMACION ACADEMICA (qb_jsel0005.guardainFORMacionacademica) ' || sqlerrm;
    END guardainformacionacademica;

    PROCEDURE pl_buscar_usuario(
        vcusu_usuario IN VARCHAR2,
        vcmensajeproceso OUT VARCHAR2,
        vcestado_proceso OUT VARCHAR2,
        vcconsulta OUT SYS_REFCURSOR
    ) IS
        vcusuario         VARCHAR2(1000);
        nmRolUsuarioAdmin NUMBER(20)    := 0;
        nmRolUsuarioCoord NUMBER(20)    := 0;
        nmRolUsuarioComuni NUMBER(20)    := 0;
        vcRolUsuario      VARCHAR2(100) := NULL;

        -- Declaración de tipo de registro para los resultados de la consulta
        TYPE T_CU_RESULT IS RECORD
                            (
                                name                  VARCHAR2(100),
                                email                 VARCHAR2(100),
                                documenttype          VARCHAR2(50),
                                idnumber              VARCHAR2(50),
                                companyDocumentType   VARCHAR2(50),
                                companyDocumentNumber VARCHAR2(50),
                                filialDocumentType    VARCHAR2(50),
                                filialDocumentNumber  VARCHAR2(50),
                                role                  VARCHAR2(20)
                            );
        cu_result         T_CU_RESULT; -- Variable para almacenar los resultados

        CURSOR CU_CONSULTAR_INFORMACION (usuario VARCHAR2) IS
            SELECT initcap(usr.usu_nombre) AS name,
                   usr.usu_mail            AS email,
                   usr.tdc_td              AS documenttype,
                   usr.epl_nd              AS idnumber,
                   uss.TDC_TD              AS companyDocumentType,
                   uss.EMP_ND              AS companyDocumentNumber,
                   uss.TDC_TD_FIL          AS filialDocumentType,
                   uss.EMP_ND_FIL          AS filialDocumentNumber,
                   vcRolUsuario            AS roleAnalista
            FROM usuarios usr,
                 USUARIO_SESION uss
            WHERE usr.usu_usuario = usuario
              AND uss.USU_USUARIO = usuario
              AND uss.USS_ID = (SELECT MAX(USS_ID) FROM USUARIO_SESION WHERE USU_USUARIO = vcusuario);
    BEGIN
        -- Llamada al procedimiento para cargar la información del usuario
        PL_CARGAR_INFOUSUARIO(vcusu_usuario, vcmensajeproceso, vcusuario);

        -- Validación del rol del usuario
        nmRolUsuarioAdmin := Fl_Obtener_rol(vcusu_usuario, 140); -- ROD_ID = 140 COORD. ADMIN
        nmRolUsuarioCoord := Fl_Obtener_rol(vcusu_usuario, 40);
        nmRolUsuarioComuni := Fl_Obtener_rol(vcusu_usuario, 149);


        -- ROD_ID = 40 COORD. SELECCION

        -- Asignar el rol basado en los resultados de la validación
        IF nmRolUsuarioAdmin > 0 THEN
            vcRolUsuario := 'ADMINISTRADOR';
        ELSIF nmRolUsuarioCoord > 0 THEN
            vcRolUsuario := 'COORDINADOR';
        ELSIF nmRolUsuarioComuni > 0 THEN
            vcRolUsuario := 'COMUNICACION';
        ELSE
            vcRolUsuario := 'ANALISTA';
        END IF;
        
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario, vcusu_usuario: ' || vcusu_usuario ||
        ' nmRolUsuarioAdmin: '|| nmRolUsuarioAdmin ||
        ' nmRolUsuarioCoord: '|| nmRolUsuarioCoord ||
        ' nmRolUsuarioComuni: '|| nmRolUsuarioComuni ||
        ' vcRolUsuario: '|| vcRolUsuario
        );       

        -- Validar si vcusuario está vacío
        IF vcusuario IS NULL OR vcusuario = '' THEN
            RAISE NO_DATA_FOUND;
        END IF;
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario,1');     
        -- Abrir el cursor para la consulta de información del usuario
        OPEN CU_CONSULTAR_INFORMACION(vcusuario);
        FETCH CU_CONSULTAR_INFORMACION INTO cu_result;
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario,2');  
        -- Validar si no se encontraron registros
        IF CU_CONSULTAR_INFORMACION%NOTFOUND THEN
            CLOSE CU_CONSULTAR_INFORMACION; -- Cerrar el cursor si no hay registros
            RAISE NO_DATA_FOUND;
        END IF;
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario,3');  
        -- Validar campos críticos
        IF cu_result.companyDocumentType IS NULL
            OR cu_result.companyDocumentNumber IS NULL
            OR cu_result.filialDocumentType IS NULL
            OR cu_result.filialDocumentNumber IS NULL
        THEN
            CLOSE CU_CONSULTAR_INFORMACION; -- Cerrar el cursor si la validación falla
            RAISE NO_DATA_FOUND;
        END IF;
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario,4');  
        -- Cerrar el cursor después de la validación
        CLOSE CU_CONSULTAR_INFORMACION;

        -- Abrir el cursor de salida para la consulta final
        OPEN vcconsulta FOR
            SELECT initcap(usr.usu_nombre) AS name,
                   usr.usu_mail            AS email,
                   usr.tdc_td              AS documenttype,
                   usr.epl_nd              AS idnumber,
                   uss.TDC_TD              AS companyDocumentType,
                   uss.EMP_ND              AS companyDocumentNumber,
                   uss.TDC_TD_FIL          AS filialDocumentType,
                   uss.EMP_ND_FIL          AS filialDocumentNumber,
                   vcRolUsuario            AS roleAnalista
            FROM usuarios usr,
                 USUARIO_SESION uss
            WHERE usr.usu_usuario = vcusuario
              AND uss.USU_USUARIO = vcusuario
              AND uss.USS_ID = (SELECT MAX(USS_ID) FROM USUARIO_SESION WHERE USU_USUARIO = vcusuario);
                PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: pl_buscar_usuario,5');  

        -- Establecer el estado y mensaje de proceso exitoso
        vcestado_proceso := 'S';
        vcmensajeproceso := 'Consulta realizada con éxito';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         OPEN vcconsulta FOR SELECT NULL FROM DUAL WHERE 1=0;
            vcestado_proceso := 'N';
            vcmensajeproceso := 'No se encontraron datos para el usuario especificado';
        WHEN OTHERS THEN
         OPEN vcconsulta FOR SELECT NULL FROM DUAL WHERE 1=0;
            vcestado_proceso := 'N';
            vcmensajeproceso := 'Error no controlado: ' || SQLERRM || ' - ' || dbms_utility.format_error_backtrace();
    END pl_buscar_usuario;


    PROCEDURE PL_CARGAR_INFOUSUARIO(
        VCUSU_USUARIO IN VARCHAR2,
        VCERROR OUT VARCHAR2,
        VCUSUARIO OUT VARCHAR2
    ) IS
    BEGIN
        VCERROR := NULL;
        VCUSUARIO := NULL;

        BEGIN
        
        PB_SEGUIMIENTO_LONG(
        'REPLICACION',  -- La primera variable siempre es 'REPLICACION'
        'Procedimiento: PL_CARGAR_INFOUSUARIO, VCUSU_USUARIO: ' || VCUSU_USUARIO
        );
            -- Primer intento de buscar el usuario por USU_LDAP
            BEGIN
                SELECT UPPER(USU_USUARIO)
                INTO VCUSUARIO
                FROM USUARIOS
                WHERE UPPER(USU_LDAP) = TRIM(UPPER(VCUSU_USUARIO));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    VCUSUARIO := NULL;
            END;

            -- Verificar si se encontró un usuario, si no, intentar buscar por USU_USUARIO
            IF VCUSUARIO IS NULL OR VCUSUARIO = '' THEN
                BEGIN
                    SELECT UPPER(USU_USUARIO)
                    INTO VCUSUARIO
                    FROM USUARIOS
                    WHERE UPPER(USU_USUARIO) = TRIM(UPPER(VCUSU_USUARIO));
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        VCUSUARIO := NULL;
                END;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                VCERROR := 'ERROR CARGANDO INFORMACION DEL USUARIO CAUSADO POR ' || SQLERRM;
        END;
    END PL_CARGAR_INFOUSUARIO;


    PROCEDURE PL_GUARDAR_OTROS_CONOCIMIENTOS(VCTDC_TD IN VARCHAR2,
                                             NMEPL_ND IN NUMBER,
                                             NMEAP_ITEM IN NUMBER,
                                             NMTSA_CODIGO IN NUMBER,
                                             VCEAP_NOMBRE_APTITUD IN VARCHAR2,
                                             NMEAP_NIVEL IN NUMBER,
                                             VCEAP_OBSERVACION IN VARCHAR2,
                                             VCERROR OUT VARCHAR2,
                                             NMGENERADOCODIGO OUT NUMBER) IS
        NMEAP_NEXT_ITEM NUMBER;
    BEGIN
        PB_SEGUIMIENTO_LONG(
        'REPLICACION',  -- La primera variable siempre es 'REPLICACION'
        'Procedimiento: PL_GUARDAR_OTROS_CONOCIMIENTOS, ' ||
        'VCTDC_TD: ' || VCTDC_TD || ', ' ||
        'NMEPL_ND: ' || TO_CHAR(NMEPL_ND) || ', ' ||
        'NMEAP_ITEM: ' || TO_CHAR(NMEAP_ITEM) || ', ' ||
        'NMTSA_CODIGO: ' || TO_CHAR(NMTSA_CODIGO) || ', ' ||
        'VCEAP_NOMBRE_APTITUD: ' || VCEAP_NOMBRE_APTITUD || ', ' ||
        'NMEAP_NIVEL: ' || TO_CHAR(NMEAP_NIVEL) || ', ' ||
        'VCEAP_OBSERVACION: ' || VCEAP_OBSERVACION
        );
        -- INSERTAMOS EL VALOR
        IF NMEAP_ITEM = 0 OR NMEAP_ITEM IS NULL THEN
            SELECT (NVL(MAX(EAP_ITEM), 0) + 1)
            INTO NMEAP_NEXT_ITEM
            FROM TSEL_EMPLEADO_APTITUD
            WHERE TDC_TD = VCTDC_TD
              AND EPL_ND = NMEPL_ND;
            INSERT INTO TSEL_EMPLEADO_APTITUD (TDC_TD, EPL_ND, EAP_ITEM, TSA_CODIGO, EAP_NOMBRE_APTITUD, EAP_NIVEL,
                                               EAP_OBSERVACION)
            VALUES (VCTDC_TD, NMEPL_ND, NMEAP_NEXT_ITEM, NMTSA_CODIGO, UPPER(VCEAP_NOMBRE_APTITUD), NMEAP_NIVEL,
                    UPPER(VCEAP_OBSERVACION));
            NMGENERADOCODIGO := NMEAP_NEXT_ITEM;
        ELSE
            UPDATE TSEL_EMPLEADO_APTITUD
            SET TSA_CODIGO=NMTSA_CODIGO,
                EAP_NOMBRE_APTITUD=UPPER(VCEAP_NOMBRE_APTITUD),
                EAP_NIVEL=NMEAP_NIVEL,
                EAP_OBSERVACION=UPPER(VCEAP_OBSERVACION)
            WHERE TDC_TD = VCTDC_TD
              AND EPL_ND = NMEPL_ND
              AND EAP_ITEM = NMEAP_ITEM;
            NMGENERADOCODIGO := NMEAP_ITEM;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF (SQLCODE = -02291) THEN
                VCERROR := 'Estimado usuario, primero debe guardar los datos basicos de su hoja de vida';
                RETURN;
            END IF;
            VCERROR := 'ERROR GUARDANDO INFORMACION OTROS CONOCIMIENTOS, CAUSADO POR : ' || SQLERRM;
    END PL_GUARDAR_OTROS_CONOCIMIENTOS;

    PROCEDURE PL_GUARDAR_NUCLEO_FAMILIAR(VCTDC_TD IN VARCHAR2,
                                         NMEPL_ND IN NUMBER,
                                         NMITEM IN NUMBER,
                                         NMEDAD IN NUMBER,
                                         VCPAR_SIGLA IN VARCHAR2,
                                         NMTOCU_ID IN  NUMBER ,
                                         VCNOMBRES IN VARCHAR2,
                                         VCAPELLIDOS IN VARCHAR2,
                                         DTFECHA_NACIMIENTO IN DATE,
                                         NMCELULAR IN NUMBER,
                                         VCVIVE_CON_CANDIDATO IN VARCHAR2,
                                         NMTTE_CODIGO IN NUMBER ,
                                         VC_TNFGENERO IN VARCHAR2,
                                         VCERROR OUT VARCHAR2,
                                         NMGENERADOCODIGO OUT NUMBER) IS
        NMCONTADOR       NUMBER := 0;
        NMSQITEM         NUMBER := 0;
        NMDCM_RADICACION NUMBER := 0;
        NMTTE_CODIGOVAL NUMBER;
        NMTOCU_IDVAL NUMBER;
    BEGIN
    
        PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: PL_GUARDAR_NUCLEO_FAMILIAR, ' ||
        'VCTDC_TD: ' || VCTDC_TD || ', ' ||
        'NMEPL_ND: ' || TO_CHAR(NMEPL_ND) || ', ' ||
        'NMITEM: ' || TO_CHAR(NMITEM) || ', ' ||
        'NMEDAD: ' || TO_CHAR(NMEDAD) || ', ' ||
        'VCPAR_SIGLA: ' || VCPAR_SIGLA || ', ' ||
        'NMTOCU_ID: ' || TO_CHAR(NMTOCU_ID) || ', ' ||
        'VCNOMBRES: ' || VCNOMBRES || ', ' ||
        'VCAPELLIDOS: ' || VCAPELLIDOS || ', ' ||
        'DTFECHA_NACIMIENTO: ' || TO_CHAR(DTFECHA_NACIMIENTO, 'YYYY-MM-DD') || ', ' ||
        'NMCELULAR: ' || TO_CHAR(NMCELULAR) || ', ' ||
        'VCVIVE_CON_CANDIDATO: ' || VCVIVE_CON_CANDIDATO || ', ' ||
        'NMTTE_CODIGO: ' || TO_CHAR(NMTTE_CODIGO) || ', ' ||
        'VC_TNFGENERO: ' || VC_TNFGENERO
        );
	    
	    NMTTE_CODIGOVAL:= NVL(NMTTE_CODIGO,1);
	    NMTOCU_IDVAL :=NVL(NMTOCU_ID,6);

        -- SI EL ITEM ES NULO o 0 ENTONCES SE INSERTA EL VALOR
        IF NMITEM IS NULL OR NMITEM = 0 THEN
            SELECT (NVL(MAX(ITEM), 0) + 1)
            INTO NMSQITEM
            FROM TSEL_NUCLEO_FAMILIAR
            WHERE TDC_TD_EPL = VCTDC_TD
              AND EPL_ND = NMEPL_ND;
            SELECT DCM_RADICACION INTO NMDCM_RADICACION FROM EMPLEADO WHERE TDC_TD = VCTDC_TD AND EPL_ND = NMEPL_ND;
            -- INSERTAR REGISTRO
            INSERT INTO TSEL_NUCLEO_FAMILIAR (TDC_TD_EPL, EPL_ND, DCM_RADICACION, ITEM, EDAD, PAR_SIGLA, TOCU_ID,
                                              NOMBRES, APELLIDOS, FECHA_NACIMIENTO, CELULAR, VIVE_CON_CANDIDATO,
                                              TTE_CODIGO, TNF_GENERO)
            VALUES (VCTDC_TD, NMEPL_ND, NMDCM_RADICACION, NMSQITEM, NMEDAD, VCPAR_SIGLA, NMTOCU_IDVAL, UPPER(VCNOMBRES),
                    UPPER(VCAPELLIDOS), DTFECHA_NACIMIENTO, NMCELULAR, VCVIVE_CON_CANDIDATO, NMTTE_CODIGOVAL,
                    VC_TNFGENERO);
            NMGENERADOCODIGO := NMSQITEM;
        ELSE
            -- ACTUALIZAR REGISTRO
            UPDATE TSEL_NUCLEO_FAMILIAR
            SET EDAD=NMEDAD,
                PAR_SIGLA=VCPAR_SIGLA,
                TOCU_ID=NMTOCU_IDVAL,
                NOMBRES=UPPER(VCNOMBRES),
                APELLIDOS=UPPER(VCAPELLIDOS),
                FECHA_NACIMIENTO=DTFECHA_NACIMIENTO,
                CELULAR=NMCELULAR,
                VIVE_CON_CANDIDATO=VCVIVE_CON_CANDIDATO,
                TTE_CODIGO=NMTTE_CODIGOVAL,
                TNF_GENERO=VC_TNFGENERO
            WHERE TDC_TD_EPL = VCTDC_TD
              AND EPL_ND = NMEPL_ND
              AND ITEM = NMITEM;

            NMGENERADOCODIGO := NMITEM;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF (SQLCODE = -02291) THEN
                VCERROR := 'Estimado usuario, primero debe guardar los datos basicos de su hoja de vida';
                RETURN;
            END IF;
            VCERROR := 'ERROR GUARDANDO INFORMACION NUCLEO FAMILIAR CAUSADO POR ' || SQLERRM;
            pb_seguimiento('NCLFAMHV', SQLERRM);
    END PL_GUARDAR_NUCLEO_FAMILIAR;

    PROCEDURE PL_CONSULTAR_REQUISICION(n_concecutivo IN NUMBER,
                                       var_cursor_requisicion OUT VCREFCURSOR,
                                       vcmensajeproceso OUT VARCHAR2,
                                       vcestado_proceso OUT VARCHAR2) IS
        VCXESTADO VARCHAR2(500);
        EXESTADO EXCEPTION;
    BEGIN
    
       BEGIN
       PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: PL_CONSULTAR_REQUISICION, ' ||
        'n_consecutivo: ' || n_concecutivo
        );
       
            SELECT REQ_ESTADO
            INTO VCXESTADO
            FROM REQUISICION
            WHERE REQ_CONSECUTIVO = n_concecutivo;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                VCXESTADO := NULL;

        END;


        IF VCXESTADO IN ('CANCELADA',
                         'ANULADA_ACTIVOS',
                         'ANULADA',
                         'ANULADO',
                         'SIN_RETROALIMENTACION',
                         'VENCIDA',
                         'CANCELADA_CLIENTE',
                         'CANCELA_CLIENTE',
                         'CULMINADA')
        THEN
            RAISE EXESTADO;
        END IF;

        OPEN var_cursor_requisicion FOR
            SELECT REQ_CONSECUTIVO,
                   TDC_TD,
                   EMP_ND,
                   CNO_CODIGO,
                   PAI_NOMBRE,
                   DPT_NOMBRE,
                   CIU_NOMBRE,
                   JORN_JORNADA,
                   REQ_MODALIDAD_CONTRATO,
                   REQ_FECHA_SOLICITUD,
                   REQ_SOLICITANTE,
                   REQ_NUMERO_VACANTES,
                   REQ_NUMERO_A_ENVIAR,
                   REQ_DIAS_PLAZO,
                   REQ_HORARIO,
                   REQ_TIPO_CONTRATO,
                   REQ_DURACION_CONTRATO,
                   REQ_SALARIO,
                   REQ_ENTREVISTADOR,
                   REQ_OBSERVACIONES_EXTERNAS,
                   REQ_OBSERVACIONES_INTERNAS,
                   REQ_USUARIO_GRABA,
                   REQ_FECHA_GRABA,
                   REQ_FACTURABLE,
                   REQ_ESTADO,
                   REQ_FECHA_VENCIMIENTO,
                   REQ_FECHA_CIERRE,
                   AU_CAUSAL,
                   AU_NOTA,
                   REQ_PUBLICA,
                   REQ_TEXTO_PUBLICA,
                   ID_CAMPANA,
                   ID_SEDE,
                   FECHA_PRESENTACION,
                   DIM_SERVICIO,
                   REQ_VER_REFERENCIAS,
                   REQ_FECHA_ENTREGA,
                   RCO_COMPLEJIDAD,
                   TDC_TD_PPAL,
                   EMP_ND_PPAL,
                   TTR_ID_TIPO_REQUISICION,
                   REQ_FECHA_CONTRATACION,
                   TDC_ID_DURACION_CONTRATO,
                   REQ_SUC_NOMBRE,
                   TREQ_CODIGO,
                   TNC_CODIGO,
                   TCE_CODIGO,
                   TSA_CODIGO,
                   REQ_REQUISITO_APLICAR,
                   REQ_VIGENCIA,
                   REQ_FECHA_PUBLICACION,
                   REQ_SALARIO_VARIABLE,
                   REQ_ORDEN_CLIENTE,
                   REQ_FECHA_APROBACION,
                   REQ_USU_APROBACION,
                   REQ_FEC_APROBACION,
                   REQ_CONSECUTIVO_REF,
                   REQ_TELENTREV,
                   REQ_DATEENTREV,
                   REQ_DIRECCIONENT,
                   NVL(TFE_CODIGO, 1)         TFE_CODIGO,
                   fb_empresa(TDC_TD, EMP_ND) VCNOMEMPRESA
            FROM REQUISICION
            WHERE REQ_CONSECUTIVO = n_concecutivo;

        vcestado_proceso := 'S';
        vcmensajeproceso := 'Consulta realizada con éxito';

    EXCEPTION


        WHEN EXESTADO THEN
         OPEN var_cursor_requisicion FOR SELECT NULL FROM DUAL WHERE 1=0;
            vcestado_proceso := 'N';
            vcmensajeproceso := 'No es posible aplicar el candidato, porque la requisición se encuentra en un estado : ' ||
                    VCXESTADO;
        WHEN NO_DATA_FOUND THEN
         OPEN var_cursor_requisicion FOR SELECT NULL FROM DUAL WHERE 1=0;
            vcestado_proceso := 'N';
            vcmensajeproceso := 'No se encontro la requisición con el consecutivo : ' || n_concecutivo;

        WHEN OTHERS THEN
         OPEN var_cursor_requisicion FOR SELECT NULL FROM DUAL WHERE 1=0;
            vcestado_proceso := 'N';
            vcmensajeproceso := 'Error en el PL_CONSULTAR_REQUISICION: ' || SQLERRM;

    END PL_CONSULTAR_REQUISICION;


END QB_DATA_REPLICATION;