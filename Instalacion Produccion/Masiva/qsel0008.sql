create or replace PACKAGE     SEL.QB_APLICATION_JSEL0029 as
  --**********************************************************************************************************
    --** nombre script        : QSEL0008
    --** objetivo             : contiene la logica de nogocio del portlet datos basicos hoja de vida
    --** esquema              : SEL
    --** nombre               : QB_JSEL0029 / header
    --** autor                : KEVIN SANTIAGO HERNANDEZ FRANCO
    --** fecha modificacion   : 2019/01/14
    --**********************************************************************************************************
    --******************************************************************************
    --** ACTUALIZACION		  : JOMONTANEZ 15/08/2023
    --** DESCRIPCION          : Se modifica los siguientes PL: guardadatosbasicos y se agrega el siguiente PL_LISTA_FUENTES_V2
    --******************************************************************************
    --******************************************************************************
    --** ACTUALIZACION		  : JUFORERO 05/12/2023
    --** DESCRIPCION          : Se crean PL de cargar datos Adicionales para BHV
    --****************************************************************************** 
    --****************************************************************
    --** MODIFICACIÓN         : Se implementa inserción condicional en la tabla RHU.CANDIDATE_BULK_UPLOAD cuando la fuente es 
    --**                        'COMPUTRABAJO_MASIVO' y se recibe un identificador válido (vcedfciunombreteletiqueta).
    --** AUTOR MODIFICACIÓN   : JUFORERO
    --** FECHA MODIFICACIÓN   : 13/04/2025
    --****************************************************************
    type refcursor is ref cursor;


    ---------- retorna los datos grabados en los datos basicos------------------
    PROCEDURE getdatosbasicospuntuales(vctdc_td     VARCHAR2
                                       ,nmepl_nd     NUMBER
                                       ,vcerror      OUT VARCHAR2
                                       ,vcconsulta   OUT refcursor);

    ---------- retorna los datos grabados en los datos basicos------------------
    PROCEDURE getdatosbasicos(vctdc_td     VARCHAR2
                             ,nmepl_nd     NUMBER
                             ,vcerror      OUT VARCHAR2
                             ,vcconsulta   OUT refcursor);

    ---------- retorna lista de valores tipos de identificaci¿¿n-------------------
    PROCEDURE gettipodocumento(vcerror      OUT VARCHAR2,
                               vcconsulta   OUT refcursor);

    ---------- retorna lista de valores lugar de expedicion del documento----------
    PROCEDURE getlugarexpedicion(vcerror      OUT VARCHAR2,
                                 vcconsulta   OUT refcursor);

    ---------- retorna lista de valores ciudad de nacimiento----------
    PROCEDURE getciudadnacimiento(vcerror      OUT VARCHAR2,
                                 vcconsulta   OUT refcursor);

    ---------- retorna lista de valores idiomas-----------------------
    PROCEDURE getidioma(vcerror      OUT VARCHAR2,
                        vcconsulta   OUT refcursor);

    ---------- retorna lista de valores estado civil-----------------------
    PROCEDURE getestadocivil(vcerror      OUT VARCHAR2,
                             vcconsulta   OUT refcursor);

    ---------- retorna lista de valores ciudad otro telefono----------
    PROCEDURE getciudadotrotelefono(vcerror      OUT VARCHAR2,
                                    vcconsulta   OUT refcursor);

    ---------- retorna lista de valores ciudad residencia----------
    PROCEDURE getciudadresidencia(vcerror      OUT VARCHAR2,
                                  vcconsulta   OUT refcursor);

    ---------- retorna lista de valores barrio ciudad residencia----------
    PROCEDURE getbarriociudadresidencia(vcpai_nombre VARCHAR2,
                                        vcdpt_nombre VARCHAR2,
                                        vcciu_nombre VARCHAR2,
                                        vcerror      OUT VARCHAR2,
                                        vcconsulta   OUT refcursor);

    ---------- guarda datos basicos----------
    PROCEDURE guardadatosbasicos(vceplnom1                    VARCHAR2
                                 ,vceplapell1                 VARCHAR2
                                 ,vctdctd                     VARCHAR2
                                 ,nmeplnd                     NUMBER
                                 ,vcepl_email                 VARCHAR2
                                 ,vcedociuexpedicionetiqueta  VARCHAR2
                                 ,vcedopaiexpedicion          VARCHAR2
                                 ,vcedodptexpedicion          VARCHAR2
                                 ,vcedociuexpedicion          VARCHAR2
                                 ,dtedofecexpedicion          date
                                 ,vceplsexo                   VARCHAR2
                                 ,dteplfecnacim               date
                                 ,vcciunombrenacetiqueta      VARCHAR2
                                 ,vcpainombrenac              VARCHAR2
                                 ,vcdptnombrenac              VARCHAR2
                                 ,vcciunombrenac              VARCHAR2
                                 ,vcedfidiomanativo           VARCHAR2
                                 ,vcecvsigla                  VARCHAR2
                                 ,vcedfeplemailalterno        VARCHAR2
                                 ,vccelular                   VARCHAR2
                                 ,vcotrocelular               VARCHAR2
                                 ,vctelefonocontacto          VARCHAR2
                                 ,vcotrotelefonofijo          VARCHAR2
                                 ,vcedfciunombreotfetiqueta   VARCHAR2
                                 ,vcedfpainombreotf           VARCHAR2
                                 ,vcedfdptnombreotf           VARCHAR2
                                 ,vcedfciunombreotf           VARCHAR2
                                 ,vcciunombreresetiqueta      VARCHAR2
                                 ,vcpainombreres              VARCHAR2
                                 ,vcdptnombreres              VARCHAR2
                                 ,vcciunombreres              VARCHAR2
                                 ,vcbarnombreetiqueta         VARCHAR2
                                 ,vcpainombrebar              VARCHAR2
                                 ,vcdptnombrebar              VARCHAR2
                                 ,vcciunombrebar              VARCHAR2
                                 ,vczonnombrebar              VARCHAR2
                                 ,vcbarnombrebar              VARCHAR2
                                 ,vcepldireccion              VARCHAR2
                                 ,vceplnom2                   VARCHAR2
                                 ,vceplapell2                 VARCHAR2
                                 ,vcedfciunombreteletiqueta   VARCHAR2
                                 ,vcedfpainombretel           VARCHAR2
                                 ,vcedfdptnombretel           VARCHAR2
                                 ,vcedfciunombretel           VARCHAR2
                                 ,vceplgruposanguineo         VARCHAR2
                                 ,vceplfactorrh               VARCHAR2
                                 ,vcunidadorg                 VARCHAR2
                                 ,vcusuUsuario                VARCHAR2
                                 ,vcerror      OUT            VARCHAR2
                                 ,vcFuente                    VARCHAR2);


    ---------- retorna lista de telefono-------------------
    FUNCTION gettelefepl(vctdc_td VARCHAR2
                        ,nmepl_nd NUMBER
                        ,vctep_ubicacion VARCHAR2
                        ,nmtco_id_tipcom NUMBER) return VARCHAR2;

    ---------- retorna lista de paises-------------------
    PROCEDURE getpais(vcerror   OUT VARCHAR2,
                      vcconsulta OUT refcursor);

    ---------- retorna lista de ciudades segun el pais por parametro-------------------
    PROCEDURE getciudadpais(vcpais       VARCHAR2,
                            vcerror      OUT VARCHAR2,
                            vcconsulta   OUT refcursor);

    PROCEDURE getvalidarestrricciones(vctdctd           VARCHAR2
                                      ,nmeplnd          NUMBER
                                      ,vceplapell1      VARCHAR2
                                      ,vceplapell2      VARCHAR2
                                      ,vceplnom1        VARCHAR2
                                      ,vceplnom2        VARCHAR2
                                      ,vcerror      OUT VARCHAR2);

    FUNCTION getdescripcionequiverror(vcdescripcionori VARCHAR2) return VARCHAR2;

    FUNCTION fl_telefonos(vctdc_td_epl VARCHAR2
                         ,vcepl_nd     VARCHAR2) return VARCHAR2;

    PROCEDURE getciudadlike(vcpatron    VARCHAR2,
                            vcerror      OUT VARCHAR2,
                            vcconsulta   OUT refcursor);

    PROCEDURE setusuarioweb(nmestado NUMBER);


    FUNCTION getexisteempleado(vctdc_td     VARCHAR2
                              ,nmepl_nd     NUMBER) return NUMBER;


    FUNCTION getbloqueaitems(vctdctd VARCHAR2
                             ,nmeplnd NUMBER) return NUMBER;

    FUNCTION getprogreso(vctdc_td     VARCHAR2
                        ,nmepl_nd     NUMBER) return NUMBER;

    FUNCTION getusuarioactivate(vctdctd  VARCHAR2
                                ,nmeplnd NUMBER) return NUMBER;

    FUNCTION getvalidapopuppreguntas(vctdctd VARCHAR2
                                    ,nmeplnd NUMBER) return NUMBER;

    PROCEDURE getbarriolike(vcpatronciudad    VARCHAR2,
                            vcpatronbarrio    VARCHAR2,
                            vcerror      OUT VARCHAR2,
                            vcconsulta   OUT refcursor);


    PROCEDURE getdefinicionciudad(vcetiqueta VARCHAR2,
                                  vcerror    OUT VARCHAR2,
                                  vcconsulta OUT refcursor);

    PROCEDURE getdefinicionbarrio(vcetiqueta     VARCHAR2,
                                  vcpais         VARCHAR2,
                                  vcdepartamento VARCHAR2,
                                  vcciudad       VARCHAR2,
                                  vcerror        OUT VARCHAR2,
                                  vcconsulta     OUT refcursor);

    PROCEDURE setsession(vctdc_td     VARCHAR2
                        ,nmepl_nd     NUMBER
                        ,vcepl_email  VARCHAR2
                        ,vctipo       VARCHAR2
                        ,vcmodulo     VARCHAR2);


    FUNCTION get_activate_aplicadas return NUMBER;

    FUNCTION get_activate_enviadas return NUMBER;

    FUNCTION get_activate_aceptadas return NUMBER;

    FUNCTION get_activate_contratadas return NUMBER;

    FUNCTION get_tiene_lab_aca(vctdc_td     VARCHAR2
                              ,nmepl_nd     NUMBER
                              ,vctipo       VARCHAR2) return varchar;

    blusuarioweb boolean := false;
  --------------------------------------------------------------------------------------
  ---------------------- AJUSTES PORTAL ACTIVATE VERSION COMPLETA ----------------------
  ---------------------------  FECHA : 19 / ABRIL / 2013--------------------------------
  -------------------------- DESARROLLADOR: JAIRO ANDRES RIVERA-------------------------
  --------------------------------------------------------------------------------------
     -------------------------------------------------------------------------------
     -------------- RETORNA LA CIUDAD ASOCIADA AL TELEFONO DEL EMPLEADO ------------
     -------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_LLAVE_CIUDAD_TEL(VCTDC_TD_EPL      IN  VARCHAR2,
                                          NMEPLD_ND         IN  NUMBER,
                                          NMTEP_ID_TIPO_COM IN  NUMBER,
                                          VCTEP_UBICACION   IN  VARCHAR2,
                                          VCTEP_NUMERO      IN  VARCHAR2,
                                          VCERROR           OUT VARCHAR2,
                                          VCCONSULTA        OUT REFCURSOR);

     -------------------------------------------------------------------------------
     -- RETORNA EL SEGMENTO DE LA LLAVE CIUDAD ASOCIADA AL TELEFONO DEL EMPLEADO ---
     -------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_SEG_CIUDAD_TELEFEPL(VCTDC_TD_EPL      IN  VARCHAR2,
                                             NMEPLD_ND         IN  NUMBER,
                                             NMTEP_ID_TIPO_COM IN  NUMBER,
                                             VCTEP_UBICACION   IN  VARCHAR2,
                                             VCTEP_NUMERO      IN  VARCHAR2,
                                             VCSEGMENTO        IN  VARCHAR2) RETURN VARCHAR2;
     -------------------------------------------------------------------------------
     -------------- ACTUALIZA LA INFORMACION DEL TELEFONO DEL EMPLEADO- ------------
     -------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_TEL_EPL(VCTDC_TD_EPL      IN  VARCHAR2,
                                     NMEPLD_ND         IN  NUMBER,
                                     NMTEP_ID_TIPO_COM IN  NUMBER,
                                     VCTEP_UBICACION   IN  VARCHAR2,
                                     VCTEP_NUMERO      IN  VARCHAR2,
                                     VCPAI_NOMBRE      IN  VARCHAR2,
                                     VCDPT_NOMBRE      IN  VARCHAR2,
                                     VCCIU_NOMBRE      IN  VARCHAR2);
     --------------------------------------------------------------------------------
     --- BORRADO DE TELEFONO EMPLEADO PROVENIENTE DE ACTUALIZACION PORTAL ACTIVATE --
     --------------------------------------------------------------------------------
      PROCEDURE PL_ELIMINAR_TEL_EPL(VCTDC_TD_EPL      IN  VARCHAR2,
                                     NMEPLD_ND         IN  NUMBER,
                                     NMTEP_ID_TIPO_COM IN  NUMBER,
                                     VCTEP_UBICACION   IN  VARCHAR2,
                                     VCTEP_NUMERO      IN  VARCHAR2,
                                     VCERROR           OUT VARCHAR2);
     -----------------------------------------------------------------------------------
     ----- RETORNA EL ESTADO ACTUAL DE LA SITUACION MILITAR DEL EMPLEADO EN LA BD-------
     -----------------------------------------------------------------------------------
     FUNCTION  FL_CARGAR_SITUACION_MIL_EPL(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMERIC) RETURN VARCHAR2;

     -----------------------------------------------------------------------------------
     ----- GUARDA/ACTULIZA EL NUEVO ESTADO DE LA SITUACION MILITAR DEL EMPLEADO---------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_SITUACION_MIL(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,VCSITUACION_MILITAR IN VARCHAR2,VCERROR OUT VARCHAR2);

     -----------------------------------------------------------------------------------
     ----- RETORNA 0 SI EL EMPLEADO NO TIENE PASAPORTE DE LO CONTRARIO DIFERENTE--------
     -----------------------------------------------------------------------------------
     FUNCTION  FL_VERIFICAR_INCLUS_PASAPORTE(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMERIC) RETURN NUMBER;

     -----------------------------------------------------------------------------------
     ----- RETORNA 0 SI EL EMPLEADO NO TIENE CARNET DE MANIPULACION DE ALIMENTOS-------
     -----------------------------------------------------------------------------------
     FUNCTION  FL_VERIFICAR_INCLUS_CAM(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMERIC) RETURN NUMBER;

     -----------------------------------------------------------------------------------
     -------- CONSULTA INFORMACION DE PASAPORTE RELACIONADA CON EL EMPLEADO-------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_INFO_DOCUMENTO(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,NMCODIGO_DOCUMENTO IN NUMBER,VCERROR OUT VARCHAR2,VCCONSULTA OUT REFCURSOR);

     -----------------------------------------------------------------------------------
     --- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO DE INFORMACION DE PASAPORTE---
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_PASAPORTE(VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                            DT_FECHA_VENCIMIENTO    IN DATE,
                                            VCERROR                 OUT VARCHAR2);

     -----------------------------------------------------------------------------------
     ----------------- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO -----------------
     ---------------DE INFORMACION DE CARNET DE MANIPULACION DE ALIMENTOS---------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_CAM(VCTDC_TD                IN VARCHAR,
                                      NMEPL_ND                IN NUMBER,
                                      NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                      DT_FECHA_EXPEDICION     IN DATE,
                                      VCERROR                 OUT VARCHAR2);

     -----------------------------------------------------------------------------------
     ------------- ELIMINA REGISTROS DE PASAPORTE ASOCIADOS AL EMPLEADO-----------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_PASAPORTE(VCTDC_TD                IN VARCHAR,
                                          NMEPL_ND                IN NUMBER,
                                          VCERROR                 OUT VARCHAR2);

     -----------------------------------------------------------------------------------
     --------------- ELIMINA REGISTROS DE CARNET DE MANIPULACION DE ALIMENTOS-----------
     ----------------------------ASOCIADOS AL EMPLEADO----------------------------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_CAM(VCTDC_TD                IN VARCHAR,
                                    NMEPL_ND                IN NUMBER,
                                    VCERROR                 OUT VARCHAR2);

     -----------------------------------------------------------------------------------
     ----- CONSULTA INFORMACION DE LICENCIAS DE CONDUCCION ASOCIADAS AL EMPLEADO--------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_INFO_LICENCIAS(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,VCERROR OUT VARCHAR2,VCCONSULTA OUT REFCURSOR);

     -----------------------------------------------------------------------------------
     --- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO DE INFORMACION DE LICENCIAS ---
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_LICENCIA (VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                            NMEDO_SEQ               IN NUMBER,
                                            VCCATEGORIA             IN VARCHAR2,
                                            DT_FECHA_VENCIMIENTO    IN DATE,
                                            VCERROR                 OUT VARCHAR2);
     -----------------------------------------------------------------------------------
     ------------- ELIMINA REGISTROS DE LICENCIAS ASOCIADAS AL EMPLEADO-----------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_LICENCIA (VCTDC_TD                IN VARCHAR,
                                          NMEPL_ND                IN NUMBER,
                                          NMEDO_SEQ               IN NUMBER,
                                          VCERROR                 OUT VARCHAR2);
     -----------------------------------------------------------------------------------
     ----------- RETORNA EL CODIGO DEL LA IMAGEN DEL USUARIO EN EL SGED-----------------
     -----------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_COD_IMG_PERFIL(VCTDC_TD                IN VARCHAR,
                                       NMEPL_ND                IN NUMBER) RETURN VARCHAR2;

     ------------------------------------------------------------------------------------
     ------ ALMACENA LA INFORMACION RELACIONADA CON LA IMG DE PERFIL DEL USUARIO---------
     ------------------------------------------------------------------------------------
     PROCEDURE PL_GUARDAR_INFO_IMG_PERFIL (VCTDC_TD                IN VARCHAR,
                                           NMEPL_ND                IN NUMBER,
                                           VCID_GESTOR_DOC         IN VARCHAR2,
                                           VCERROR                 OUT VARCHAR2);
     ------------------------------------------------------------------------------------
     ------ ELIMINA LA INFORMACION RELACIONADA CON LA IMG DE PERFIL DEL USUARIO---------
     ------------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_IMG_PERFIL (VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            VCERROR                 OUT VARCHAR2);
     ------------------------------------------------------------------------------------
     --------------------------- RETORNA EL GENERO DEL EMPLEADO--------------------------
     ------------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_GENERO_EPL(VCTDC_TD  IN VARCHAR,
                                   NMEPL_ND  IN NUMBER) RETURN VARCHAR2;
     -----------------------------------------------------------------------------------
     ----------- RETORNA EL VALOR ENCONTRADO PARA LA CONSTANTE INGRESADA----------------
     -----------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_ID_CONSTANTE(VCCONSTANTE IN VARCHAR2) RETURN NUMBER;

     -----------------------------------------------------------------------------
     ----------------- RETORNA LA LISTA DE SITUACION MILITAR----------------------
     -----------------------------------------------------------------------------
      PROCEDURE PL_CARGAR_SITUACIONMIL(REFC_SITMILITAR OUT REFCURSOR);

    -----------------------------------------------------------------------------
     -------------------- RETORNA LA LISTA DE LOCALIDADES-------------------------
     -----------------------------------------------------------------------------
      PROCEDURE PL_CARGAR_LOCALIDADES(REFC_LOCALIDADES OUT REFCURSOR);

     -----------------------------------------------------------------------------
     ------------ RETORNA LA CANTIDAD DE CONTRATOS ACTIVOS DEL EMPLEADO-----------
     -----------------------------------------------------------------------------
      PROCEDURE PL_VALIDA_CTOACT(VCEPL_TDC_TD IN VARCHAR2,
                                 NMEPL_ND IN NUMBER,
                                 NMCTO_ACT OUT NUMBER);

     -----------------------------------------------------------------------------
     ------------------- RETORNA EL LISTADO DE FUENTES  --------------------------
     -----------------------------------------------------------------------------

    PROCEDURE PL_LISTA_FUENTES_V2      (VCCONSULTA          OUT refcursor,
                                       VCESTADO_PROCESO      OUT VARCHAR2,
                                       VCMENSAJE_PROCESO     OUT VARCHAR2);

	PROCEDURE PL_CARGAR_DATOSBHV_ADD   (VCTDC_TD             IN VARCHAR2,
                                       NMEPL_ND             IN NUMBER,
                                       VCRAZA               IN VARCHAR2,
                                       VCSISBEN             IN VARCHAR2,
                                       VCDISCAPACIDAD       IN VARCHAR2,
                                       NMESTRATO            IN NUMBER,
                                       VCAUD_USUARIO        IN VARCHAR2,
                                       VCESTADO_PROCESO     OUT VARCHAR2,
                                       VCMENSAJE_PROCESO    OUT VARCHAR2);

    PROCEDURE PL_OBTENER_DATOSBHV_ADD  (VCTDC_TD             IN VARCHAR2,
                                       NMEPL_ND             IN NUMBER,
                                       VCRAZA               OUT VARCHAR2,
                                       VCSISBEN             OUT VARCHAR2,
                                       VCDISCAPACIDAD       OUT VARCHAR2,
                                       NMESTRATO            OUT VARCHAR2,
                                       VCESTADO_PROCESO     OUT VARCHAR2,
                                       VCMENSAJE_PROCESO    OUT VARCHAR2);							  

  end QB_APLICATION_JSEL0029;
/
create or replace PACKAGE BODY SEL.QB_APLICATION_JSEL0029 as
  --**********************************************************************************************************
    --** nombre script        : QSEL0008
    --** objetivo             : contiene la logica de nogocio del portlet datos basicos hoja de vida
    --** esquema              : SEL
    --** nombre               : QB_JSEL0029 / header
    --** autor                : KEVIN SANTIAGO HERNANDEZ FRANCO
    --** fecha modificacion   : 2019/01/14
    --**********************************************************************************************************
    --******************************************************************************
    --** ACTUALIZACION		  : JOMONTANEZ 15/08/2023
    --** DESCRIPCION          : Se modifica los siguientes PL: guardadatosbasicos y se agrega el siguiente PL_LISTA_FUENTES_V2
    --******************************************************************************
	--******************************************************************************
    --** ACTUALIZACION		  : JUFORERO 05/12/2023
    --** DESCRIPCION          : Se crean PL de cargar datos Adicionales para BHV
    --******************************************************************************
    --****************************************************************
    --** MODIFICACIÓN         : Se implementa inserción condicional en la tabla RHU.CANDIDATE_BULK_UPLOAD cuando la fuente es 
    --**                        'COMPUTRABAJO_MASIVO' y se recibe un identificador válido (vcedfciunombreteletiqueta).
    --** AUTOR MODIFICACIÓN   : JUFORERO
    --** FECHA MODIFICACIÓN   : 13/04/2025
    --****************************************************************
    FUNCTION get_tiene_lab_aca(vctdc_td     VARCHAR2
                              ,nmepl_nd     NUMBER
                              ,vctipo       VARCHAR2)
    RETURN VARCHAR
    IS
      nmconteo NUMBER;
      vcresult VARCHAR2(1);
    BEGIN
    vcresult:='N';

      IF upper(vctipo) = 'L' THEN
        SELECT COUNT(1)
        INTO nmconteo
        FROM tsel_experiencia_laboral
        WHERE tdc_td_epl=vctdc_td
        AND epl_nd=nmepl_nd
        AND aud_user<>'LIFERAY';

        IF nmconteo > 0 THEN
          vcresult:='S';
        END IF;
      END IF;


      IF upper(vctipo) = 'A' THEN
        SELECT COUNT(1)
        INTO nmconteo
        FROM tsel_nivel_educativo
        WHERE tdc_td_epl=vctdc_td
        AND epl_nd=nmepl_nd
        AND aud_user<>'LIFERAY';

        IF nmconteo > 0 THEN
          vcresult:='S';
        END IF;
      END IF;

    RETURN vcresult;
    EXCEPTION
      WHEN OTHERS THEN
        null;
    END;


    FUNCTION get_activate_aplicadas
    RETURN NUMBER
    IS
      nmresult NUMBER:=0;
    BEGIN
      SELECT COUNT(dIStinct e.dcm_radicacion) conteo
      INTO nmresult
      FROM empleado e, requISicion_hoja_vida_estado rhve
      WHERE e.dcm_radicacion=rhve.dcm_radicacion
      AND rhve.dcm_radicacion    =e.dcm_radicacion
      AND e.fuente               ='ACTIVATE'
      AND rhve.rqst_fecha_graba  >=greatest(e.epl_fecrecep,e.fecha_modIFicacion)
      AND rhve.stdo_estado       in ('APLICADO');

    RETURN nmresult;
    EXCEPTION
       WHEN OTHERS THEN
         RETURN 0;
    END;

    FUNCTION get_activate_enviadas
    RETURN NUMBER
    IS
      nmresult NUMBER:=0;
    BEGIN
      SELECT COUNT(dIStinct e.dcm_radicacion) conteo
      INTO nmresult
      FROM empleado e, requISicion_hoja_vida_estado rhve
      WHERE e.dcm_radicacion=rhve.dcm_radicacion
      AND rhve.dcm_radicacion    =e.dcm_radicacion
      AND e.fuente               ='ACTIVATE'
      AND rhve.rqst_fecha_graba  >=greatest(e.epl_fecrecep,e.fecha_modIFicacion)
      AND rhve.stdo_estado       in ('CLIENTE','HV_CLIENTE');

    RETURN nmresult;
    EXCEPTION
       WHEN OTHERS THEN
         RETURN 0;
    END;

    FUNCTION get_activate_aceptadas
    RETURN NUMBER
    IS
      nmresult NUMBER:=0;
    BEGIN
      SELECT COUNT(dIStinct e.dcm_radicacion) conteo
      INTO nmresult
      FROM empleado e, requISicion_hoja_vida_estado rhve
      WHERE e.dcm_radicacion=rhve.dcm_radicacion
      AND rhve.dcm_radicacion    =e.dcm_radicacion
      AND e.fuente               ='ACTIVATE'
      AND rhve.rqst_fecha_graba  >=greatest(e.epl_fecrecep,e.fecha_modIFicacion)
      AND rhve.stdo_estado       in ('ACEPTADO');

    RETURN nmresult;
    EXCEPTION
       WHEN OTHERS THEN
         RETURN 0;
    END;

    FUNCTION get_activate_contratadas
    RETURN NUMBER
    IS
      nmresult NUMBER:=0;
    BEGIN
     /* SELECT COUNT(dIStinct e.epl_nd) conteo
      INTO nmresult
      FROM empleado e, contrato c
      WHERE e.tdc_td =c.tdc_td_epl
      AND e.epl_nd   =c.epl_nd
      AND e.fuente   ='ACTIVATE'
      AND c.cto_fechasys >=greatest(e.epl_fecrecep,e.fecha_modIFicacion)
      AND c.ect_sigla in ('ACT');
  */
     SELECT COUNT(dIStinct e.dcm_radicacion) conteo
      INTO nmresult
      FROM empleado e, requISicion_hoja_vida_estado rhve, contrato c
      WHERE e.dcm_radicacion=rhve.dcm_radicacion
      AND rhve.dcm_radicacion    =e.dcm_radicacion
      AND e.tdc_td =c.tdc_td_epl
      AND e.epl_nd   =c.epl_nd
      AND e.fuente               ='ACTIVATE'
      AND rhve.rqst_fecha_graba  >=greatest(e.epl_fecrecep,e.fecha_modIFicacion)
      AND rhve.stdo_estado       in ('AUTORIZADO')
      AND c.ect_sigla  in ('ACT');
    RETURN nmresult;
    EXCEPTION
       WHEN OTHERS THEN
         RETURN 0;
    END;
    --
    PROCEDURE setsession(vctdc_td     VARCHAR2
                        ,nmepl_nd     NUMBER
                        ,vcepl_email  VARCHAR2
                        ,vctipo       VARCHAR2
                        ,vcmodulo     VARCHAR2)
    as
    BEGIN
      insert INTO tsel_activate_sesion (tas_codigo,tdc_td,epl_nd,epl_email,tas_tipo,tas_ini_sesion,tas_fin_sesion,aud_user,aud_fecha,tas_modulo)
      values(1,VCTDC_TD,NMEPL_ND,lower(VCEPL_EMAIL),VCTIPO,SYSDATE,null,user,SYSDATE,VCMODULO);

      --update empleado set fuente = 'PORTALHV' ,FECHA_MODIFICACION=SYSDATE WHERE tdc_td=vctdc_td AND epl_nd=nmepl_nd; Se comenta ya que ahora si se agrega la fuente
    commit;
    EXCEPTION
          WHEN OTHERS THEN
          pb_seguimiento('JSEL0029setsession','ERRROR QB_APLICATION_JSEL0029.setsession INSERTANDO EN tsel_activate_sesion: ' || SQLERRM);
      END;

    PROCEDURE getdefinicionbarrio(vcetiqueta     VARCHAR2,
                                  vcpaIS         VARCHAR2,
                                  vcdepartamento VARCHAR2,
                                  vcciudad       VARCHAR2,
                                  vcerror        out VARCHAR2,
                                  vcconsulta     out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT pai_nombre
              ,dpt_nombre
              ,ciu_nombre
              ,zon_nombre
              ,bar_nombre
        FROM barrio
        WHERE pai_nombre=vcpaIS
        AND dpt_nombre=vcdepartamento
        AND upper(ciu_nombre)=upper(vcciudad)
        AND upper((bar_nombre || ' - ' ||zon_nombre)) = upper(vcetiqueta)
        AND zon_nombre not in ('N.N.');
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE BARRIO (qb_jsel0003.getdefinicionbarrio) '||sqlerrm;
    END;


    PROCEDURE getdefinicionciudad(vcetiqueta VARCHAR2,
                                  vcerror    out VARCHAR2,
                                  vcconsulta out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT pai_nombre
              ,dpt_nombre
              ,ciu_nombre
        FROM ciudad
        WHERE upper(qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' ||dpt_nombre) = upper(vcetiqueta);
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD (qb_jsel0003.getdefinicionciudad) '||sqlerrm;
    END;


    PROCEDURE getdatosbasicos(vctdc_td     VARCHAR2
                             ,nmepl_nd     NUMBER
                             ,vcerror      out VARCHAR2
                             ,vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
      lvctdc_td VARCHAR2(2):=null;
      lnmepl_nd NUMBER:=null;
    BEGIN
      open vcconsulta for
          SELECT epl_nom1 vceplnom1
                ,epl_apell1 vceplapell1
                ,e.tdc_td vctdctd
                ,e.epl_nd nmeplnd
                ,decode(ted.edo_ciu_expedicion,null,null,qb_jsel0003.getdescripcionequiverror(ted.edo_ciu_expedicion) || ' - ' || edo_dpt_expedicion) vcedociuexpedicionetiqueta
                ,edo_pai_expedicion vcedopaiexpedicion
                ,edo_dpt_expedicion vcedodptexpedicion
                ,edo_ciu_expedicion vcedociuexpedicion
                ,edo_fec_expedicion dtedofecexpedicion
                ,epl_sexo vceplsexo
                ,epl_fecnacim dteplfecnacim
                ,decode(ciu_nombre_nac,null,null,qb_jsel0003.getdescripcionequiverror(ciu_nombre_nac) || ' - ' || dpt_nombre_nac) vcciunombrenacetiqueta
                ,pai_nombre_nac vcpainombrenac
                ,dpt_nombre_nac vcdptnombrenac
                ,ciu_nombre_nac vcciunombrenac
                ,edf_idioma_nativo vcedfidiomanativo
                ,ecv_sigla vcecvsigla
                ,lower(epl_email) vceplemail
                ,lower(edf_epl_email_alterno) vcedfeplemailalterno
                ,gettelefepl(e.tdc_td,e.epl_nd,'CELULAR',3) vccelular
                ,gettelefepl(e.tdc_td,e.epl_nd,'OTRO CELULAR',3) vcotrocelular
                ,gettelefepl(e.tdc_td,e.epl_nd,'TELEFONO FIJO',1) vctelefonocontacto
                ,gettelefepl(e.tdc_td,e.epl_nd,'OTRO TELEFONO FIJO',1) vcotrotelefonofijo
                ,decode(ciu_nombre_res,null,null,qb_jsel0003.getdescripcionequiverror(ciu_nombre_res) || ' - ' || dpt_nombre_res) vcciunombreresetiqueta
                ,pai_nombre_res vcpainombreres
                ,dpt_nombre_res vcdptnombreres
                ,ciu_nombre_res vcciunombreres
                ,bar_nombre || ' - ' || zon_nombre vcbarnombreetiqueta
                ,pai_nombre_res vcpainombrebar
                ,dpt_nombre_res vcdptnombrebar
                ,ciu_nombre_res vcciunombrebar
                ,zon_nombre vczonnombrebar
                ,bar_nombre vcbarnombrebar
                ,epl_direccion vcepldireccion
                ,epl_nom2 vceplnom2
                ,epl_apell2 vceplapell2
                ,qb_jsel0003.getusuarioactivate(e.tdc_td,e.epl_nd) exISteactivate
                ,e.grupo_sanguineo
                ,e.factor_rh
                ,e.fuente
          FROM empleado e, tsel_empleado_documento ted, tsel_entrevISta_datfijo tdf
          WHERE e.tdc_td= ted.tdc_td(+)
          AND e.epl_nd=ted.epl_nd(+)
          AND FB_CONSTANTE_NUM('HV_ID_CC',SYSDATE,'',NULL,'',NULL,'','')=ted.tdo_id_tipo_documento(+)
          AND e.tdc_td=tdf.tdc_td_epl(+)
          AND e.epl_nd=tdf.epl_nd(+)
          AND e.tdc_td=vctdc_td
          AND e.epl_nd=nmepl_nd;
          pb_seguimiento('JSEL0029',vctdc_td);
          pb_seguimiento('JSEL0029',nmepl_nd);
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO DATOS BASICOS (qb_jsel0003.getDatosBasicos) '||sqlerrm;
        pb_seguimiento('JSEL0029',vcerror);
    END;

    PROCEDURE guardadatosbasicos(vceplnom1                    VARCHAR2
                                 ,vceplapell1                 VARCHAR2
                                 ,vctdctd                     VARCHAR2
                                 ,nmeplnd                     NUMBER
                                 ,vcepl_email                 VARCHAR2
                                 ,vcedociuexpedicionetiqueta  VARCHAR2
                                 ,vcedopaiexpedicion          VARCHAR2
                                 ,vcedodptexpedicion          VARCHAR2
                                 ,vcedociuexpedicion          VARCHAR2
                                 ,dtedofecexpedicion          date
                                 ,vceplsexo                   VARCHAR2
                                 ,dteplfecnacim               date
                                 ,vcciunombrenacetiqueta      VARCHAR2
                                 ,vcpainombrenac              VARCHAR2
                                 ,vcdptnombrenac              VARCHAR2
                                 ,vcciunombrenac              VARCHAR2
                                 ,vcedfidiomanativo           VARCHAR2
                                 ,vcecvsigla                  VARCHAR2
                                 ,vcedfeplemailalterno        VARCHAR2
                                 ,vccelular                   VARCHAR2
                                 ,vcotrocelular               VARCHAR2
                                 ,vctelefonocontacto          VARCHAR2
                                 ,vcotrotelefonofijo          VARCHAR2
                                 ,vcedfciunombreotfetiqueta   VARCHAR2
                                 ,vcedfpainombreotf           VARCHAR2
                                 ,vcedfdptnombreotf           VARCHAR2
                                 ,vcedfciunombreotf           VARCHAR2
                                 ,vcciunombreresetiqueta      VARCHAR2
                                 ,vcpainombreres              VARCHAR2
                                 ,vcdptnombreres              VARCHAR2
                                 ,vcciunombreres              VARCHAR2
                                 ,vcbarnombreetiqueta         VARCHAR2
                                 ,vcpainombrebar              VARCHAR2
                                 ,vcdptnombrebar              VARCHAR2
                                 ,vcciunombrebar              VARCHAR2
                                 ,vczonnombrebar              VARCHAR2
                                 ,vcbarnombrebar              VARCHAR2
                                 ,vcepldireccion              VARCHAR2
                                 ,vceplnom2                   VARCHAR2
                                 ,vceplapell2                 VARCHAR2
                                 ,vcedfciunombreteletiqueta   VARCHAR2
                                 ,vcedfpainombretel           VARCHAR2
                                 ,vcedfdptnombretel           VARCHAR2
                                 ,vcedfciunombretel           VARCHAR2
                                 ,vceplgruposanguineo         VARCHAR2
                                 ,vceplfactorrh               VARCHAR2
                                 ,vcunidadorg                 VARCHAR2
                                 ,vcusuUsuario                VARCHAR2
                                 ,vcerror      out            VARCHAR2
                                 ,vcFuente                    VARCHAR2)
    IS
      vc_info                 VARCHAR2(250);
      nmtdo_id_tipo_documento NUMBER;
      dtedo_fecha             date;
      nmconteo                NUMBER:=0;
      exnohacernada           EXCEPTION;
      NMCOUNT                 NUMBER := 0;
      vcNewFuente             VARCHAR2(250);

      --EXCEPTION
      EXCEMPLEADO             EXCEPTION;
      EXCEMPLEADO_UPD         EXCEPTION;
      EXCEMPLEADO_DOC         EXCEPTION;
      EXCEMPLEADO_DOC_UPD     EXCEPTION;
      EXCENT_DAT_FIJO         EXCEPTION;
      EXCENT_DAT_FIJO_UPD     EXCEPTION;
      VCERROR_DET             VARCHAR2(4000);

      zona_count NUMBER := 0;
      barrio_count NUMBER := 0;


    BEGIN

      nmconteo:=0;
      SELECT COUNT(1) INTO nmconteo FROM empleado WHERE tdc_td=upper(vctdctd) AND epl_nd=nmeplnd;

--      IF upper(vczonnombrebar) = 'CENTRO' THEN
        BEGIN
        SELECT COUNT(*)
            INTO zona_count
            FROM zona
            WHERE upper(pai_nombre) = upper(vcpainombrebar)
         AND upper(dpt_nombre) = upper(vcdptnombrebar)
         AND upper(ciu_nombre) = upper(vcciunombrebar)
         AND upper(zon_nombre) = upper(vczonnombrebar);

         IF zona_count = 0 THEN
      BEGIN
        INSERT INTO zona (pai_nombre, dpt_nombre, ciu_nombre, zon_nombre, zon_codigo, zon_defecto)
        VALUES (vcpainombrebar, vcdptnombrebar, vcciunombrebar, vczonnombrebar, 0, 'N');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN ZONA: ' || SQLERRM;
          pb_seguimiento('DATBASHV', vcerror || ': ' || SQLERRM);
      END;
      END IF;     
        EXCEPTION
          WHEN OTHERS THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN ZONA: ' || SQLERRM;
              pb_seguimiento('DATBASHV', vcerror ||': '|| SQLERRM);
        END;

        BEGIN
            SELECT COUNT(*)
        INTO barrio_count
        FROM barrio
        WHERE upper(pai_nombre) = upper(vcpainombrebar)
            AND upper(dpt_nombre) = upper(vcdptnombrebar)
            AND upper(ciu_nombre) = upper(vcciunombrebar)
            AND upper(zon_nombre) = upper(vczonnombrebar)
            AND upper(bar_nombre) = upper(vcbarnombrebar);

          IF barrio_count = 0 THEN
      BEGIN
        INSERT INTO barrio (pai_nombre, dpt_nombre, ciu_nombre, zon_nombre, bar_nombre, bar_defecto)
        VALUES (vcpainombrebar, vcdptnombrebar, vcciunombrebar, vczonnombrebar, upper(vcbarnombrebar), 'N');
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN BARRIO: ' || SQLERRM;
          pb_seguimiento('DATBASHV', vcerror || ': ' || SQLERRM);
      END;
    END IF;

        EXCEPTION
          WHEN OTHERS THEN
            vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN BARRIO: ' || SQLERRM;
            pb_seguimiento('DATBASHV', vcerror ||': '||SQLERRM);
        END;

--      END IF;

      IF nmconteo = 0 THEN
        vcNewFuente := NVL(vcFuente, 'PORTALHV');
        --getvalidarestrricciones(vctdctd,nmeplnd,vceplapell1,vceplapell2,vceplnom1,vceplnom2,vcerror);
        IF vcerror IS not null THEN raISe exnohacernada; END IF;

          BEGIN
              insert INTO empleado (tdc_td,epl_nd,epl_apell1,epl_apell2,epl_nom1,epl_nom2
                                  ,epl_fecnacim,pai_nombre_nac,dpt_nombre_nac,ciu_nombre_nac,pai_nombre_res,dpt_nombre_res
                                  ,ciu_nombre_res,zon_nombre,bar_nombre,epl_direccion,ecv_sigla,epl_sexo
                                  ,epl_email,epl_fecrecep,usuario_creacion,fuente,grupo_sanguineo,factor_rh)
              values(upper(vctdctd),nmeplnd ,upper(vceplapell1),upper(vceplapell2),upper(vceplnom1),upper(vceplnom2)
                      ,dteplfecnacim,upper(vcpainombrenac),upper(vcdptnombrenac),upper(vcciunombrenac),upper(vcpainombreres),upper(vcdptnombreres)
                      ,upper(vcciunombreres)
                      ,upper(DECODE(vczonnombrebar,'NO APLICA','N.N.',vczonnombrebar))
                      ,upper(VCBARNOMBREBAR),upper(VCEPLDIRECCION),upper(VCECVSIGLA),upper(VCEPLSEXO)
                      ,lower(vcepl_email),sysdate,vcusuUsuario,vcNewFuente,vceplgruposanguineo,vceplfactorrh);
              COMMIT;
          EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                  BEGIN
                      SELECT COUNT(*)
                      INTO NMCOUNT
                      FROM NTF_BLOQUE_LOG
                      WHERE NBL_TIPO_DOC = upper(vctdctd)
                      AND NBL_NUMERO_DOC = nmeplnd
                      AND NBL_RESPUESTA = 'NO_ACEPTO';
                  EXCEPTION 
                      WHEN OTHERS THEN
                          NMCOUNT := 0;
                  END;

                  IF NMCOUNT > 0 THEN
                      IF vcunidadorg = 'PERSONA' THEN
                          vcerror := 'Estimado candidato en oportunidades anteriores usted solicito dar de baja a su cuenta, por lo que es necesario que se contacte con el callcenter, y se habilite el registro de sus datos.';
                      ELSIF vcunidadorg = 'INTRANET' THEN
                          vcerror := 'El empleado no acepto la politica de proteccion de datos, no se puede consultar, por favor contacte al candidato';
                      END IF;
                  END IF;

              WHEN OTHERS THEN            
          IF(sqlcode=-02291)THEN
                      vcerror:='estimado candidato si su lugar de residencia es DIFERENTE a Santa fe de Bogotá, en el campo: Localidad seleccione: NO APLICA. Si reside en Santa Fe de Bogotá, verifique que el barrio coincida con la localidad seleccionada.';
                      RETURN;
                  ELSE
            vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN EMPLEADO: ' || SQLERRM;
            pb_seguimiento('DATBASHV', vcerror ||': '|| SQLERRM ||': '|| vctdctd ||': '||nmeplnd);
                      RETURN;
          END IF;
                  VCERROR_DET := SQLERRM;
                  RAISE EXCEMPLEADO;
          END;
      else
          vcNewFuente := NVL(vcFuente, 'ACTIVATE');
          BEGIN
              update empleado
              set epl_apell1=upper(vceplapell1)
                  ,epl_apell2=upper(vceplapell2)
                  ,epl_nom1=upper(vceplnom1)
                  ,epl_nom2=upper(vceplnom2)
                  ,epl_fecnacim=dteplfecnacim
                  ,pai_nombre_nac=upper(vcpainombrenac)
                  ,dpt_nombre_nac=upper(vcdptnombrenac)
                  ,ciu_nombre_nac=upper(vcciunombrenac)
                  ,pai_nombre_res=upper(vcpainombreres)
                  ,dpt_nombre_res=upper(vcdptnombreres)
                  ,ciu_nombre_res=upper(vcciunombreres)
                  ,zon_nombre=upper(DECODE(vczonnombrebar,'NO APLICA','N.N.',vczonnombrebar))
                  ,bar_nombre=upper(vcbarnombrebar)
                  ,epl_direccion=upper(vcepldireccion)
                  ,ecv_sigla=upper(vcecvsigla)
                  ,epl_sexo=upper(vceplsexo)
                  ,epl_email=lower(vcepl_email)
                  ,grupo_sanguineo=vceplgruposanguineo
                  ,factor_rh=vceplfactorrh
                  ,fuente=upper(vcNewFuente)
              WHERE tdc_td=vctdctd
              AND epl_nd=nmeplnd;
              COMMIT;
          EXCEPTION
              WHEN OTHERS THEN
          IF(sqlcode=-02291)THEN
                      vcerror:='update empleado: estimado candidato si su lugar de residencia es DIFERENTE a Santa fe de Bogotá, en el campo: Localidad seleccione: NO APLICA. Si reside en Santa Fe de Bogotá, verifique que el barrio coincida con la localidad seleccionada.';
                      RETURN;
                  ELSE
            vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos ACTUALIZANDO EMPLEADO: ' || SQLERRM;
            pb_seguimiento('DATBASHV', vcerror ||': '|| SQLERRM);
                      RETURN;
          END IF;
                  VCERROR_DET := SQLERRM;
                  RAISE EXCEMPLEADO_UPD;
          END;
      END IF;
    --****************************************************************
    --** AUTOR MODIFICACIÓN   : JUFORERO
    --** FECHA MODIFICACIÓN   : 13/04/2025
    --****************************************************************
      BEGIN
        IF vcFuente = 'COMPUTRABAJO_MASIVO' AND vcedfciunombreteletiqueta IS NOT NULL THEN
        INSERT INTO RHU.CANDIDATE_BULK_UPLOAD (
            CBU_ID, CBU_IDENTIFICATION_TYPE, CBU_IDENTIFICATION_NUMBER, 
            CBU_EMAIL, CBU_STATUS, CBU_TRANSACTION_ID, CBU_USER, CBU_CREATED_AT
        ) 
        VALUES (
            null, vctdctd, nmeplnd, 
            vcepl_email, 'PENDING', vcedfciunombreteletiqueta, USER, SYSDATE
        );
        END IF;
    EXCEPTION
    WHEN OTHERS THEN
    INSERT INTO RHU.CANDIDATE_BULK_UPLOAD (
            CBU_ID, CBU_IDENTIFICATION_TYPE, CBU_IDENTIFICATION_NUMBER, 
            CBU_EMAIL, CBU_STATUS, CBU_TRANSACTION_ID, CBU_USER, CBU_CREATED_AT
        ) 
        VALUES (
            null, vctdctd, nmeplnd, 
            vcepl_email, 'ERROR', vcedfciunombreteletiqueta, USER, SYSDATE
        );
    END;
    
      ---------------------------------------documentos------------------------------------------------------
      SELECT tdo_id_tipo_documento INTO nmtdo_id_tipo_documento FROM tsel_tipo_documento WHERE tdo_abreviatura = vctdctd;
      SELECT COUNT(1) INTO nmconteo FROM tsel_empleado_documento WHERE tdc_td=upper(vctdctd) AND epl_nd=nmeplnd AND tdo_id_tipo_documento = nmtdo_id_tipo_documento;

      IF nmconteo = 0 THEN
          BEGIN
              insert INTO tsel_empleado_documento (tdc_td,epl_nd,edo_fecha,tdo_id_tipo_documento,edo_pai_expedicion,edo_dpt_expedicion,edo_ciu_expedicion,edo_fec_expedicion)
              values (upper(vctdctd), nmeplnd, trunc(sysdate),nmtdo_id_tipo_documento,upper(vcedopaiexpedicion),upper(vcedodptexpedicion),upper(vcedociuexpedicion),trunc(dtedofecexpedicion));
              COMMIT;
          EXCEPTION
              WHEN OTHERS THEN
                  vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN tsel_empleado_documento: ' || SQLERRM;
                  pb_seguimiento('DATBASHV', vcerror ||': '|| SQLERRM);
                  VCERROR_DET := SQLERRM;
                  RAISE EXCEMPLEADO_DOC;
          END;
      else
      BEGIN
        update tsel_empleado_documento
        set edo_pai_expedicion=upper(vcedopaiexpedicion)
           ,edo_dpt_expedicion=upper(vcedodptexpedicion)
           ,edo_ciu_expedicion=upper(vcedociuexpedicion)
           ,edo_fec_expedicion=trunc(dtedofecexpedicion)
        WHERE tdc_td=vctdctd
        AND epl_nd=nmeplnd
        AND tdo_id_tipo_documento=nmtdo_id_tipo_documento;
        COMMIT;
      EXCEPTION
          WHEN OTHERS THEN
                  vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos ACTUALIZANDO tsel_empleado_documento:' || SQLERRM;
                  VCERROR_DET := SQLERRM;
                  RAISE EXCEMPLEADO_DOC_UPD;
      END;
      END IF;

      ---------------------------------------entrevISta-------------------------------------------------------
      BEGIN
        insert INTO tsel_entrevISta_datfijo(tdc_td_epl,epl_nd,edf_idioma_nativo,edf_epl_email_alterno)
        values (upper(vctdctd),nmeplnd,upper(vcedfidiomanativo),vcedfeplemailalterno);
        COMMIT;
      EXCEPTION
            WHEN dup_val_on_index THEN
              update tsel_entrevISta_datfijo
              set edf_idioma_nativo=upper(vcedfidiomanativo)
                 ,edf_epl_email_alterno=vcedfeplemailalterno
              WHERE tdc_td_epl=vctdctd
              AND epl_nd=nmeplnd;
              COMMIT;
          WHEN OTHERS THEN 
              VCERROR_DET := SQLERRM;
              RAISE EXCENT_DAT_FIJO;
      END;

      --------------------- ACTUALIZAR TELEFONOS DEL EMPLEADO --------------
      -- ACTUALIZACION CELULAR
      PL_ACTUALIZAR_TEL_EPL(vctdctd,nmeplnd,3,'CELULAR',vccelular,NULL,NULL,NULL);
      -- ACTUALIZACION OTRO CELULAR
      PL_ACTUALIZAR_TEL_EPL(vctdctd,nmeplnd,3,'OTRO CELULAR',vcotrocelular,NULL,NULL,NULL);
      -- ACTUALIZACION TELEFONO FIJO
      PL_ACTUALIZAR_TEL_EPL(vctdctd,nmeplnd,1,'TELEFONO FIJO',vctelefonocontacto,vcedfpainombretel,vcedfdptnombretel,vcedfciunombretel);
      -- ACTUALIZACION OTRO TELEFONO FIJO
      PL_ACTUALIZAR_TEL_EPL(vctdctd,nmeplnd,1,'OTRO TELEFONO FIJO',vcotrotelefonofijo,vcedfpainombreotf,vcedfdptnombreotf,vcedfciunombreotf);

      ---------------------------------------telefonos-------------------------------------------------------
      -------- LOGICA NO FUNCIONA, BORRA LOS DATOS ACUTALIZADOS POR EL ERP Y SOLO DEJA LOS QUE LLEGAN POR ACTIVATE
      /*
      delete FROM telefepl WHERE tdc_td=vctdctd AND epl_nd=nmeplnd;
      -- AND tep_ubicacion in ('CELULAR','OTRO_CELULAR','TELEFONO_CONTACTO','TELEFONO_FIJO');
      IF vccelular IS not null THEN
        insert INTO telefepl(tdc_td,epl_nd,tep_numero,tep_ubicacion,tco_id_tipcom,aud_user,aud_fecha)
        values(vctdctd,nmeplnd,upper(vccelular),'CELULAR',1,user,sysdate);
      END IF;
      IF vcotrocelular IS not null THEN
        insert INTO telefepl(tdc_td,epl_nd,tep_numero,tep_ubicacion,tco_id_tipcom,aud_user,aud_fecha)
        values(vctdctd,nmeplnd,upper(vcotrocelular),'OTRO_CELULAR',1,user,sysdate);
      END IF;
      IF vctelefonocontacto IS not null THEN
        insert INTO telefepl(tdc_td,epl_nd,tep_numero,tep_ubicacion,tco_id_tipcom,aud_user,aud_fecha)
        values(vctdctd,nmeplnd,upper(vctelefonocontacto),'TELEFONO_CONTACTO',1,user,sysdate);
      END IF;
      IF vcotrotelefonofijo IS not null THEN
        insert INTO telefepl(tdc_td,epl_nd,tep_numero,tep_ubicacion,tco_id_tipcom,aud_user,aud_fecha)
        values(vctdctd,nmeplnd,upper(vcotrotelefonofijo),'TELEFONO_FIJO',1,user,sysdate);
      END IF;
      */


    IF vcepl_email IS NOT NULL THEN
      ---------------------------------------comunicacion unIFicadad------------------------------------------
          delete FROM tsel_comunicacion_unIFicada WHERE tdc_td=vctdctd AND epl_nd=nmeplnd AND tco_id_tipcom=4 AND cun_nombre_canal='EMAIL';
          COMMIT;
          BEGIN
              insert INTO tsel_comunicacion_unIFicada(tdc_td,epl_nd,tco_id_tipcom,cun_nombre_canal,cun_contacto,aud_user,aud_fecha)
              values(vctdctd,nmeplnd,4,'EMAIL',lower(vcepl_email),user,sysdate);
              COMMIT;              
          EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
              UPDATE tsel_comunicacion_unIFicada 
              SET cun_contacto=UPPER(vcepl_email) WHERE tdc_td=vctdctd AND epl_nd=nmeplnd AND tco_id_tipcom=4 AND cun_nombre_canal='EMAIL';       
              COMMIT;
              WHEN OTHERS THEN
          IF(SQLCODE=-01400)THEN
            vcerror := 'Estimado usuario debe ingresar un correo electronico';
          ELSE
            vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN tsel_comunicacion_unIFicada: ' || SQLERRM;
            pb_seguimiento('DATBASHV', vcerror ||': '|| SQLERRM);
                  END IF;
          RETURN;
          END;

          ---------------------------------------guarda informacion de sesion------------------------------------------
          setsession(vctdctd,nmeplnd,lower(vcepl_email),'G','DATOS BASICOS');

      END IF;

    EXCEPTION
      WHEN exnohacernada THEN
        vcerror:=getdescripcionequiverror(vcerror);

      WHEN EXCEMPLEADO THEN
          vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN EMPLEADO: ' || VCERROR_DET;
          pb_seguimiento('EXCEMPLEADO', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN EXCEMPLEADO_UPD THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos ACTUALIZANDO EN EMPLEADO: ' || VCERROR_DET;
          pb_seguimiento('EXCEMPLEADO_UPD', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN EXCEMPLEADO_DOC THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN tsel_empleado_documento: ' || VCERROR_DET;
          pb_seguimiento('EXCEMPLEADO_DOC', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN EXCEMPLEADO_DOC_UPD THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos ACTUALIZANDO EN tsel_empleado_documento: ' || VCERROR_DET;
          pb_seguimiento('EXCEMPLEADO_DOC_UPD', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN EXCENT_DAT_FIJO THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos INSERTANDO EN tsel_entrevISta_datfijo: ' || VCERROR_DET;
          pb_seguimiento('EXCENT_DAT_FIJO', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN EXCENT_DAT_FIJO_UPD THEN
              vcerror := 'ERROR QB_APLICATION_JSEL0029.guardadatosbasicos ACTUALIZANDO EN tsel_entrevISta_datfijo: ' || VCERROR_DET;
          pb_seguimiento('EXCENT_DAT_FIJO_UPD', 'CC ' || nmeplnd || ' vcerror: '|| VCERROR_DET);
      WHEN OTHERS THEN
        vcerror:=sqlerrm;
        vcerror:=getdescripcionequiverror(vcerror);
    END;



    PROCEDURE getdatosbasicospuntuales(vctdc_td    VARCHAR2
                                       ,nmepl_nd   NUMBER
                                       ,vcerror    out VARCHAR2
                                       ,vcconsulta out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
          SELECT initcap(epl_nom1) ||' '|| initcap(epl_nom2) nombres
                ,initcap(epl_apell1) ||' '|| initcap(epl_apell2) apellidos
                ,tdc_td tipo_documento
                ,epl_nd numero_documento
                ,nvl(lower(epl_email),'NO ASIGNADO') email
                ,qb_jsel0003.gettelefepl(tdc_td,epl_nd,'CELULAR',3) celular
                ,epl_direccion direccion
                ,'NO ASIGNADO' cargo
          FROM empleado
          WHERE tdc_td=vctdc_td
          AND epl_nd=nmepl_nd
          ;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO DATOS BASICOS (qb_jsel0003.getDatosBasicosPuntuales) '||sqlerrm;
    END;

    FUNCTION getvalidapopuppreguntas(vctdctd VARCHAR2
                                   ,nmeplnd NUMBER)
    RETURN NUMBER
    IS
    nmRETURN          NUMBER:=0;
    nmexIStdcepl      NUMBER:=0;
    nmexIStnoactivate NUMBER:=0;
    BEGIN
      ---
      SELECT COUNT(1)
      INTO nmexIStdcepl
      FROM empleado
      WHERE tdc_td=vctdctd
      AND epl_nd=nmeplnd;


      IF (nmexIStdcepl>0) THEN
        nmRETURN:=1;
      else
        SELECT COUNT(1)
        INTO nmexIStnoactivate
        FROM empleado
        WHERE getusuarioactivate(vctdctd,nmeplnd)=0;

        IF (nmexIStnoactivate>0) THEN
          nmRETURN:=1;
        END IF;
      END IF;

    RETURN nmRETURN;
    END;


    FUNCTION getusuarioactivate(vctdctd  VARCHAR2
                                ,nmeplnd NUMBER)
    RETURN NUMBER
    IS
      cursor datempleado IS
        SELECT *
        FROM tsel_activate_sesion
        WHERE tdc_td=vctdctd
        AND epl_nd=nmeplnd;
    nmRETURN NUMBER:=0;
    BEGIN
      for cu in datempleado loop
        nmRETURN:=1;
      END loop;

    RETURN nmRETURN;
    END;

    -----------------------------------------------------------------------------
    ---------------- Retorna el progreso de llenado HV Activate -----------------
    ----------------------------- ANDres Rivera ---------------------------------
    -- Actualizacion:  Maikol Arley Cucunuba Salazar 2014/12/16
    -----------------------------------------------------------------------------
    FUNCTION getprogreso(vctdc_td     VARCHAR2,nmepl_nd     NUMBER) return NUMBER IS
      nmRETURN      NUMBER := 0;
      nmcontador    NUMBER;
      nmTtt_Codigo  NUMBER;
    BEGIN
      -- verIFicar que el empleado tenga al menos datos basicos
      SELECT COUNT(1) INTO nmcontador FROM empleado WHERE tdc_td=vctdc_td AND epl_nd=nmepl_nd;

      --
      IF nmcontador>0 THEN
        nmRETURN:=20;
      END IF;

      -- verIFicacion de porcentaje por Experiencia laboral
      SELECT COUNT(1) INTO nmcontador FROM  tsel_experiencia_laboral WHERE tdc_td_epl=vctdc_td AND epl_nd=nmepl_nd;
      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+20;
      END IF;

      -- verIFicacion de porcentaje por educacion y otra educacion no formal
      SELECT COUNT(1) INTO nmcontador FROM tsel_nivel_educativo  WHERE tdc_td_epl=vctdc_td AND epl_nd=nmepl_nd;

      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+20;
      END IF;

      -- VerIFica otros conocimientos
      SELECT (SELECT COUNT(1)  FROM TSEL_EMPLEADO_APTITUD WHERE tdc_td=vctdc_td AND epl_nd=nmepl_nd)
              +(SELECT COUNT(1) FROM TSEL_IDIOMA TI,TSEL_IDIOMA_ACTIVATE TA
      WHERE TDC_TD_EPL=vctdc_td AND EPL_ND=nmepl_nd AND TA.TID_CODIGO=TI.TID_CODIGO) INTO nmcontador FROM DUAL;

      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+10;
      END IF;

      -- VerIFica si tiene texto en la hoja de vida
      SELECT FB_CONSTANTE_NUM('HV_TXT',SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL) INTO nmTtt_Codigo FROM DUAL;
      BEGIN
        SELECT NVL(LENGTH(ETE_TEXTO),0) INTO nmcontador FROM TSEL_EMPLEADO_TEXTO WHERE TDC_TD_EPL=VCTDC_TD AND EPL_ND=NMEPL_ND AND TTT_CODIGO=NMTTT_CODIGO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            nmcontador:=0;
      END;

      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+10;
      END IF;

      -- VerIFica si tiene informacion de viviENDa y familiares
      SELECT (SELECT COUNT(1) FROM tsel_viviENDa WHERE tdc_td_epl=vctdc_td AND epl_nd=nmepl_nd)
             +(SELECT COUNT(1) FROM tsel_nucleo_familiar WHERE tdc_td_epl=vctdc_td AND epl_nd=nmepl_nd) suma INTO nmcontador FROM dual;

      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+10;
      END IF;

      -- verIFicacion de porcentaje para informacion complementaria.
      SELECT (SELECT COUNT(1) FROM tsel_empleado_transporte WHERE tdc_td=vctdc_td AND epl_nd=nmepl_nd)
             +(SELECT COUNT(1) FROM tsel_empleado_sgss WHERE tdc_td_epl=vctdc_td AND epl_nd=nmepl_nd) suma  INTO nmcontador FROM dual;

      --
      IF nmcontador>0 THEN
        nmRETURN:=nmRETURN+10;
      END IF;

      --
      RETURN NVL(nmRETURN,0);
    END;
    -----------------------------------------------------------------------------

    FUNCTION getbloqueaitems(vctdctd  VARCHAR2
                             ,nmeplnd NUMBER)
    RETURN NUMBER
    IS
      cursor data IS      
          SELECT 'X'
          FROM requISicion_hoja_vida_estado
          WHERE dcm_radicacion IN (SELECT dcm_radicacion
                                   FROM empleado
                                   WHERE tdc_td=vctdctd
                                   AND epl_nd=nmeplnd)
                                   AND stdo_estado in (SELECT stdo_estado
                                                       FROM requISicion_hoja_vida_estado
                                                       WHERE (RQST_ITEM,REQ_CONSECUTIVO,dcm_radicacion) IN (SELECT MAX(RQST_ITEM), REQ_CONSECUTIVO,dcm_radicacion
                                                                                                            FROM requISicion_hoja_vida_estado
                                                                                                            WHERE dcm_radicacion in (SELECT dcm_radicacion
                                                                                                                                     FROM empleado
                                                                                                                                     WHERE tdc_td=vctdctd
                                                                                                                                     AND epl_nd=nmeplnd)
                                                                                                            GROUP BY REQ_CONSECUTIVO,dcm_radicacion)
                                  AND stdo_estado='CLIENTE')
          UNION
          SELECT 'X'
          FROM contrato
          WHERE tdc_td_epl=vctdctd
          AND epl_nd=nmeplnd
          AND ect_sigla IN ('ACT','PRE');

    nmRETURN NUMBER:=0;
    BEGIN
      for cu in data loop
        nmRETURN:=1;
      END loop;

    RETURN nmRETURN;
    END;

    FUNCTION getexISteempleado(vctdc_td     VARCHAR2
                              ,nmepl_nd     NUMBER)
    RETURN NUMBER
    IS
      nmconteo NUMBER:=0;
    BEGIN
      SELECT COUNT(1)
      INTO nmconteo
      FROM empleado
      WHERE tdc_td=vctdc_td
      AND epl_nd=nmepl_nd;

      IF nmconteo = 0 THEN
        RETURN 0;
      else
        RETURN 1;
      END IF;
    END;


    PROCEDURE setusuarioweb(nmestado NUMBER)
    as
    BEGIN
      IF nmestado = 1 THEN
        qb_jsel0003.blusuarioweb:=true;
      else
        qb_jsel0003.blusuarioweb:=false;
      END IF;
    END;

    PROCEDURE getciudadlike(vcpatron    VARCHAR2,
                            vcerror      out VARCHAR2,
                            vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
              ,pai_nombre edopaiexpedicion
              ,dpt_nombre edodptexpedicion
              ,ciu_nombre edociuexpedicion
        FROM ciudad
        WHERE upper(qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre) like '%'||upper(vcpatron)||'%'
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD SEGUN PATRON (qb_jsel0003.getciudadlike) '||sqlerrm;
    END;


    PROCEDURE getbarriociudadresidencia(vcpai_nombre VARCHAR2,
                                        vcdpt_nombre VARCHAR2,
                                        vcciu_nombre VARCHAR2,
                                        vcerror      out VARCHAR2,
                                        vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT dIStinct (bar_nombre || ' - ' || zon_nombre) etiqueta
              ,pai_nombre
              ,dpt_nombre
              ,ciu_nombre
              ,zon_nombre
              ,bar_nombre
        FROM barrio b
        WHERE pai_nombre = vcpai_nombre
        AND dpt_nombre  = vcdpt_nombre
        AND ciu_nombre  = vcciu_nombre
        AND zon_nombre not in ('N.N.')
        order by etiqueta asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE BARRIO CIUDADES DE RESIDENCIA (qb_jsel0003.getbarriociudadresidencia) '||sqlerrm;
    END;


    PROCEDURE getbarriolike(vcpatronciudad    VARCHAR2,
                            vcpatronbarrio    VARCHAR2,
                            vcerror      out VARCHAR2,
                            vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT dIStinct (bar_nombre || ' - ' || zon_nombre) etiqueta
              ,pai_nombre
              ,dpt_nombre
              ,ciu_nombre
              ,zon_nombre
              ,bar_nombre
        FROM barrio
        WHERE zon_nombre not in ('N.N.')
        AND upper(bar_nombre) like '%'||upper(vcpatronbarrio)||'%'
        AND upper(qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre) like '%'||upper(vcpatronciudad)||'%'
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE BARRIO SEGUN PATRON (qb_jsel0003.getbarriolike) '||sqlerrm;
    END;



    FUNCTION fl_telefonos(vctdc_td_epl VARCHAR2
                         ,vcepl_nd     VARCHAR2)
    RETURN VARCHAR2
    IS
     cursor telefonos IS
       SELECT tep_numero
       FROM telefepl
       WHERE tdc_td = vctdc_td_epl
       AND epl_nd   = vcepl_nd
       AND tco_id_tipcom = 1;

    vresult VARCHAR2(4000);
    BEGIN
       for curtelefonos in telefonos loop
         vresult := curtelefonos.tep_numero|| ', ' ||vresult ;
       END loop;

      RETURN vresult;
    EXCEPTION WHEN OTHERS THEN
      RETURN null;
    END;

    FUNCTION getdescripcionequiverror(vcdescripcionori VARCHAR2)
    RETURN VARCHAR2
    IS
      vcresult VARCHAR2(4000);
    BEGIN
      SELECT tae_descripcion_equiv
      INTO vcresult
      FROM tsel_activate_equiverror
      WHERE upper(vcdescripcionori) like '%'||upper(tae_descripcion_ori)||'%';

    RETURN vcresult;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN vcdescripcionori;
    END;


    PROCEDURE getvalidarestrricciones(vctdctd           VARCHAR2
                                      ,nmeplnd          NUMBER
                                      ,vceplapell1      VARCHAR2
                                      ,vceplapell2      VARCHAR2
                                      ,vceplnom1        VARCHAR2
                                      ,vceplnom2        VARCHAR2
                                      ,vcerror      out VARCHAR2)
    IS
      rowdempleado empleado%rowtype;
    BEGIN
      --validacion homonimo
      --vcerror := qb_sel_migraciondatos.get_homonimo(vctdctd, nmeplnd, vceplnom1, vceplnom2, vceplapell1, vceplnom2);

      --valida prn
      pb_valida_lnegra(null,null,vctdctd,nmeplnd,null,vcerror);
    END;


    PROCEDURE getciudadpaIS(vcpaIS       VARCHAR2,
                            vcerror      out VARCHAR2,
                            vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
              ,pai_nombre edopaiexpedicion
              ,dpt_nombre edodptexpedicion
              ,ciu_nombre edociuexpedicion
        FROM ciudad
        WHERE pai_nombre = vcpaIS
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD SEGUN UN PAIS (qb_jsel0003.getCiudadPaIS) '||sqlerrm;
    END;

    PROCEDURE getpaIS(vcerror      out VARCHAR2,
                     vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT pai_nombre etiqueta
              ,rownum valor
        FROM paIS
        order by pai_nombre asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA PAIS (qb_jsel0003.getPaIS) '||sqlerrm;
    END;


    FUNCTION gettelefepl(vctdc_td VARCHAR2
                        ,nmepl_nd NUMBER
                        ,vctep_ubicacion VARCHAR2
                        ,nmtco_id_tipcom NUMBER)
    RETURN VARCHAR2
    IS
      vcresult VARCHAR2(250);
    BEGIN
      SELECT tep_numero
      INTO vcresult
      FROM telefepl
      WHERE tdc_td=vctdc_td
      AND epl_nd=nmepl_nd
      AND tep_ubicacion=vctep_ubicacion
      AND tco_id_tipcom=nmtco_id_tipcom
      AND rownum<=1 order by aud_fecha desc;
    RETURN vcresult;
    EXCEPTION
      WHEN OTHERS THEN
        RETURN null;
    END;

    PROCEDURE gettipodocumento(vcerror      out VARCHAR2,
                               vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT TDC_NOMBRE
              ,TDC_TD
        FROM TIPODOC;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE TIPOS DE IDENTIFICACION (qb_jsel0003.getTipoDocumento) '||sqlerrm;
    END;


    PROCEDURE getlugarexpedicion(vcerror      out VARCHAR2,
                                 vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
              ,pai_nombre edopaiexpedicion
              ,dpt_nombre edodptexpedicion
              ,ciu_nombre edociuexpedicion
        FROM ciudad
        WHERE pai_nombre = 'COLOMBIA'
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA LUGAR DE EXPEDICION (qb_jsel0003.getLugarExpedicion) '||sqlerrm;
    END;


    PROCEDURE getciudadnacimiento(vcerror      out VARCHAR2,
                                 vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT etiqueta
              ,painombre
              ,dptnombre
              ,ciunombre
        FROM (SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
                    ,pai_nombre painombre
                    ,dpt_nombre dptnombre
                    ,ciu_nombre ciunombre
                    ,0 orden
              FROM ciudad
              WHERE pai_nombre = 'COLOMBIA'
              AND ciu_nombre = 'SANTAFE DE BOGOTA'
              union
              SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
                    ,pai_nombre painombre
                    ,dpt_nombre dptnombre
                    ,ciu_nombre ciunombre
                    ,rownum orden
              FROM ciudad
              WHERE pai_nombre = 'COLOMBIA'
              AND ciu_nombre <> 'SANTAFE DE BOGOTA')
        order by orden asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD DE NACIMIENTO (qb_jsel0003.getCiudadNacimiento) '||sqlerrm;
    END;

    PROCEDURE getidioma(vcerror      out VARCHAR2,
                        vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT tid_descripcion etiqueta
        FROM tsel_idioma_activate
        order by tid_codigo asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE IDIOMAS (qb_jsel0003.getIdioma) '||sqlerrm;
    END;

    PROCEDURE getestadocivil(vcerror      out VARCHAR2,
                             vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT ecv_nombre
              ,ecv_sigla
        FROM estadocivil
        WHERE ecv_nombre <> 'NO APLICA'
        order by ecv_orden_activate asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE ESTADO CIVIL (qb_jsel0003.getestadocivil) '||sqlerrm;
    END;

    PROCEDURE getciudadotrotelefono(vcerror      out VARCHAR2,
                                    vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
              ,pai_nombre painombre
              ,dpt_nombre dptnombre
              ,ciu_nombre ciunombre
        FROM ciudad
        WHERE pai_nombre = 'COLOMBIA'
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD OTRO TELEFONO (qb_jsel0003.getciudadotrotelefono) '||sqlerrm;
    END;


    PROCEDURE getciudadresidencia(vcerror      out VARCHAR2,
                                  vcconsulta   out refcursor)
    IS
      vc_info VARCHAR2(250);
    BEGIN
      open vcconsulta for
        SELECT dIStinct qb_jsel0003.getdescripcionequiverror(ciu_nombre) || ' - ' || dpt_nombre etiqueta
              ,pai_nombre painombre
              ,dpt_nombre dptnombre
              ,ciu_nombre ciunombre
        FROM barrio
        WHERE pai_nombre = 'COLOMBIA'
        order by qb_jsel0003.getdescripcionequiverror(ciu_nombre) asc;
      RETURN;
      CLOSE vcconsulta;
    EXCEPTION
      WHEN OTHERS THEN
        vcerror:='ERROR CARGANDO LISTA DE CIUDAD DE RESIDENCIA (qb_jsel0003.getCiudadResidencia) '||sqlerrm;
    END;

    --------------------------------------------------------------------------------------
  ---------------------- AJUSTES PORTAL ACTIVATE VERSION COMPLETA ----------------------
  ---------------------------  FECHA : 19 / ABRIL / 2013--------------------------------
  -------------------------- DESARROLLADOR: JAIRO ANDRES RIVERA-------------------------
  --------------------------------------------------------------------------------------
     -------------------------------------------------------------------------------
     -------------- RETORNA LA CIUDAD ASOCIADA AL TELEFONO DEL EMPLEADO ------------
     -------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_LLAVE_CIUDAD_TEL(VCTDC_TD_EPL      IN  VARCHAR2,
                                          NMEPLD_ND         IN  NUMBER,
                                          NMTEP_ID_TIPO_COM IN  NUMBER,
                                          VCTEP_UBICACION   IN  VARCHAR2,
                                          VCTEP_NUMERO      IN  VARCHAR2,
                                          VCERROR           OUT VARCHAR2,
                                          VCCONSULTA        OUT REFCURSOR) IS
      BEGIN
        OPEN VCCONSULTA FOR
            SELECT (QB_JSEL0003.GETDESCRIPCIONEQUIVERROR(CIU_NOMBRE) || ' - ' || DPT_NOMBRE) ETIQUETA,PAI_NOMBRE,DPT_NOMBRE,CIU_NOMBRE
              FROM TELEFEPL WHERE TDC_TD=VCTDC_TD_EPL AND EPL_ND=NMEPLD_ND AND TCO_ID_TIPCOM=NMTEP_ID_TIPO_COM AND TEP_UBICACION=VCTEP_UBICACION AND TEP_NUMERO=VCTEP_NUMERO;
       RETURN;
       CLOSE VCCONSULTA;
      EXCEPTION
         WHEN OTHERS THEN
           VCERROR:='ERROR CARGANDO LLAVE CIUDAD PARA TELEFONO EMPLEADO CAUSADO POR '||SQLERRM;
     END;

     -------------------------------------------------------------------------------
     -- RETORNA EL SEGMENTO DE LA LLAVE CIUDAD ASOCIADA AL TELEFONO DEL EMPLEADO ---
     -------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_SEG_CIUDAD_TELEFEPL( VCTDC_TD_EPL      IN  VARCHAR2,
                                             NMEPLD_ND         IN  NUMBER,
                                             NMTEP_ID_TIPO_COM IN  NUMBER,
                                             VCTEP_UBICACION   IN  VARCHAR2,
                                             VCTEP_NUMERO      IN  VARCHAR2,
                                             VCSEGMENTO        IN  VARCHAR2) RETURN VARCHAR2 IS
      VC_VALOR_SEGMENTO VARCHAR2(500);
      VC_QUERY_DINAMICO VARCHAR2(1000);
        BEGIN
           VC_QUERY_DINAMICO:='SELECT '||VCSEGMENTO||' FROM TELEFEPL WHERE TDC_TD=:b1 AND EPL_ND=:b2 AND TCO_ID_TIPCOM=:b3 AND TEP_UBICACION=:b4 AND TEP_NUMERO=:b5';

           EXECUTE IMMEDIATE VC_QUERY_DINAMICO
            INTO VC_VALOR_SEGMENTO USING IN VCTDC_TD_EPL,IN NMEPLD_ND,IN NMTEP_ID_TIPO_COM,IN VCTEP_UBICACION,IN VCTEP_NUMERO;
           RETURN VC_VALOR_SEGMENTO;
        EXCEPTION
          WHEN OTHERS THEN
             VC_VALOR_SEGMENTO:=NULL;
             RETURN VC_VALOR_SEGMENTO;
     END FL_CARGAR_SEG_CIUDAD_TELEFEPL;

     -------------------------------------------------------------------------------
     -------------- ACTUALIZA LA INFORMACION DEL TELEFONO DEL EMPLEADO- ------------
     -------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_TEL_EPL(VCTDC_TD_EPL      IN  VARCHAR2,
                                     NMEPLD_ND         IN  NUMBER,
                                     NMTEP_ID_TIPO_COM IN  NUMBER,
                                     VCTEP_UBICACION   IN  VARCHAR2,
                                     VCTEP_NUMERO      IN  VARCHAR2,
                                     VCPAI_NOMBRE      IN  VARCHAR2,
                                     VCDPT_NOMBRE      IN  VARCHAR2,
                                     VCCIU_NOMBRE      IN  VARCHAR2) IS
        NMCONTADOR  NUMBER:=0;
       BEGIN
          SELECT COUNT(1) INTO NMCONTADOR
             FROM TELEFEPL WHERE TDC_TD=VCTDC_TD_EPL AND EPL_ND=NMEPLD_ND AND TCO_ID_TIPCOM=NMTEP_ID_TIPO_COM AND TEP_UBICACION=VCTEP_UBICACION AND TEP_NUMERO=VCTEP_NUMERO;

          IF NMCONTADOR=0 AND VCTEP_NUMERO IS NOT NULL THEN
              BEGIN
                  INSERT INTO TELEFEPL (TDC_TD,EPL_ND,TEP_NUMERO,TEP_UBICACION,TCO_ID_TIPCOM,PAI_NOMBRE,DPT_NOMBRE,CIU_NOMBRE,AUD_USER,AUD_FECHA)
                  VALUES (VCTDC_TD_EPL,NMEPLD_ND,VCTEP_NUMERO,VCTEP_UBICACION,NMTEP_ID_TIPO_COM,VCPAI_NOMBRE,VCDPT_NOMBRE,VCCIU_NOMBRE,USER,SYSDATE);
              EXCEPTION
                  WHEN OTHERS THEN
                     pb_seguimiento('JSEL0029TELEFEPL','ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_TEL_EPL INSERTANDO EN TELEFEPL: ' || SQLERRM);
              END;
            ELSE
              BEGIN
               UPDATE TELEFEPL SET PAI_NOMBRE=PAI_NOMBRE,DPT_NOMBRE=VCDPT_NOMBRE,CIU_NOMBRE=VCCIU_NOMBRE WHERE
                  TDC_TD=VCTDC_TD_EPL AND EPL_ND=NMEPLD_ND AND TCO_ID_TIPCOM=NMTEP_ID_TIPO_COM AND TEP_UBICACION=VCTEP_UBICACION AND TEP_NUMERO=VCTEP_NUMERO;
              EXCEPTION
                  WHEN OTHERS THEN
                     pb_seguimiento('JSEL0029TELEFEPL','ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_TEL_EPL ACTUALIZANDO TELEFEPL: ' || SQLERRM);
              END;
          END IF;
        COMMIT;
     END PL_ACTUALIZAR_TEL_EPL;

     --------------------------------------------------------------------------------
     --- BORRADO DE TELEFONO EMPLEADO PROVENIENTE DE ACTUALIZACION PORTAL ACTIVATE --
     --------------------------------------------------------------------------------
      PROCEDURE PL_ELIMINAR_TEL_EPL(VCTDC_TD_EPL      IN  VARCHAR2,
                                     NMEPLD_ND         IN  NUMBER,
                                     NMTEP_ID_TIPO_COM IN  NUMBER,
                                     VCTEP_UBICACION   IN  VARCHAR2,
                                     VCTEP_NUMERO      IN  VARCHAR2,
                                     VCERROR           OUT VARCHAR2) IS
        BEGIN
           DELETE FROM TELEFEPL
             WHERE TDC_TD=VCTDC_TD_EPL AND EPL_ND=NMEPLD_ND AND TCO_ID_TIPCOM=NMTEP_ID_TIPO_COM AND TEP_UBICACION=VCTEP_UBICACION AND TEP_NUMERO=VCTEP_NUMERO;
           COMMIT;
        EXCEPTION
           WHEN OTHERS THEN
             VCERROR:='ERROR ELIMINANDO TELEFONOS EMPLEADO, CAUSADO POR '||SQLERRM;
     END PL_ELIMINAR_TEL_EPL;

     -------------------------------------------------------------------------------
     ------------------ RETORNA LA SITUACION MILITAR DEL EMPLEADO ------------------
     -------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_SITUACION_MIL_EPL(VCTDC_TD IN VARCHAR,
                                          NMEPL_ND IN NUMERIC) RETURN VARCHAR2 IS
      VC_SITUACION_MILITAR   VARCHAR2(45);
      BEGIN
        VC_SITUACION_MILITAR:=NULL;
        SELECT EPL_SITUACION_MILITAR INTO VC_SITUACION_MILITAR
            FROM EMPLEADO WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND;
        RETURN VC_SITUACION_MILITAR;
      EXCEPTION
         WHEN OTHERS THEN
            VC_SITUACION_MILITAR:='';
            RETURN VC_SITUACION_MILITAR;
     END FL_CARGAR_SITUACION_MIL_EPL;

     -----------------------------------------------------------------------------------
     ----- GUARDA/ACTULIZA EL NUEVO ESTADO DE LA SITUACION MILITAR DEL EMPLEADO---------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_SITUACION_MIL(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,VCSITUACION_MILITAR IN VARCHAR2,VCERROR OUT VARCHAR2) IS
      BEGIN
         UPDATE EMPLEADO SET EPL_SITUACION_MILITAR=VCSITUACION_MILITAR WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD;
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            VCERROR:='ERROR PROCESANDO GUARDADO SITUACION MILITAR CAUSADO POR '||SQLERRM;
     END PL_ACTUALIZAR_SITUACION_MIL;

     -----------------------------------------------------------------------------------
     ----- RETORNA 0 SI EL EMPLEADO NO TIENE PASAPORTE DE LO CONTRARIO DIFERENTE--------
     -----------------------------------------------------------------------------------
     FUNCTION  FL_VERIFICAR_INCLUS_PASAPORTE(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMERIC) RETURN NUMBER IS
        NMCONTADOR                 NUMBER;
        NM_ID_PASAPORTE_CONSTANTE  NUMBER;
     BEGIN
        NM_ID_PASAPORTE_CONSTANTE:=FB_CONSTANTE_NUM('HV_ID_PASS',SYSDATE,'',NULL,'',NULL,'','');
        SELECT COUNT(1) INTO NMCONTADOR FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NM_ID_PASAPORTE_CONSTANTE;
        RETURN NMCONTADOR;
     END FL_VERIFICAR_INCLUS_PASAPORTE;

    -----------------------------------------------------------------------------------
     ----- RETORNA 0 SI EL EMPLEADO NO TIENE CARNET DE MANIPULACION DE ALIMENTOS-------
     -----------------------------------------------------------------------------------
     FUNCTION  FL_VERIFICAR_INCLUS_CAM(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMERIC) RETURN NUMBER IS
        NMCONTADOR                 NUMBER;
        NM_ID_CMA  NUMBER;
     BEGIN
        NM_ID_CMA:=FB_CONSTANTE_NUM('HV_CM_ALI',SYSDATE,'',NULL,'',NULL,'','');
        SELECT COUNT(1) INTO NMCONTADOR FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NM_ID_CMA;
        RETURN NMCONTADOR;
     END FL_VERIFICAR_INCLUS_CAM;

     -----------------------------------------------------------------------------------
     -------- CONSULTA INFORMACION DE PASAPORTE RELACIONADA CON EL EMPLEADO-------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_INFO_DOCUMENTO(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,NMCODIGO_DOCUMENTO IN NUMBER,VCERROR OUT VARCHAR2,VCCONSULTA OUT REFCURSOR) IS
     BEGIN
       OPEN
          VCCONSULTA FOR
             SELECT * FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMCODIGO_DOCUMENTO;
       RETURN;
       CLOSE VCCONSULTA;
       EXCEPTION
         WHEN OTHERS THEN
            VCERROR:='ERROR CARGANDO INFORMACION DE DOCUMENTO POR EMPLEADO:  '||SQLERRM;
     END PL_CARGAR_INFO_DOCUMENTO;

     -----------------------------------------------------------------------------------
     --- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO DE INFORMACION DE PASAPORTE---
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_PASAPORTE(VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                            DT_FECHA_VENCIMIENTO    IN DATE,
                                            VCERROR                 OUT VARCHAR2) IS
          NMCONTADOR NUMBER;
        BEGIN
          -- VERIFICAR SI EXISTEN PASAPORTES ASOCIADOS
          SELECT COUNT(1) INTO NMCONTADOR FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMTDO_ID_TIPO_DOCUMENTO;
          -- INSERTAR SI NO EXISTE DE LO CONTRARIO ACTUALIZAR
          IF NMCONTADOR=0 THEN
              BEGIN
                  INSERT INTO TSEL_EMPLEADO_DOCUMENTO (TDC_TD,EPL_ND,EDO_FECHA,TDO_ID_TIPO_DOCUMENTO,EDO_FEC_VENCIMIENTO,EDO_MOSTRAR_EN_INTERFAZ,AUD_USER,AUD_FECHA)
                  VALUES (VCTDC_TD,NMEPL_ND,SYSDATE,NMTDO_ID_TIPO_DOCUMENTO,DT_FECHA_VENCIMIENTO,'S',USER,SYSDATE);
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_PASAPORTE INSERTANDO EN TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
           ELSE
              BEGIN
                  UPDATE TSEL_EMPLEADO_DOCUMENTO SET EDO_FEC_VENCIMIENTO=DT_FECHA_VENCIMIENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMTDO_ID_TIPO_DOCUMENTO;
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_PASAPORTE ACTUALIZANDO TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
          END IF;
          COMMIT;
     END PL_ACTUALIZAR_INFO_PASAPORTE;

     -----------------------------------------------------------------------------------
     ----------------- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO -----------------
     ---------------DE INFORMACION DE CARNET DE MANIPULACION DE ALIMENTOS---------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_CAM(VCTDC_TD                IN VARCHAR,
                                      NMEPL_ND                IN NUMBER,
                                      NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                      DT_FECHA_EXPEDICION     IN DATE,
                                      VCERROR                 OUT VARCHAR2) IS
          NMCONTADOR NUMBER;
        BEGIN
          -- VERIFICAR SI EXISTEN PASAPORTES ASOCIADOS
          SELECT COUNT(1) INTO NMCONTADOR FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMTDO_ID_TIPO_DOCUMENTO;
          -- INSERTAR SI NO EXISTE DE LO CONTRARIO ACTUALIZAR
          IF NMCONTADOR=0 THEN
              BEGIN
                  INSERT INTO TSEL_EMPLEADO_DOCUMENTO (TDC_TD,EPL_ND,EDO_FECHA,TDO_ID_TIPO_DOCUMENTO,EDO_FEC_EXPEDICION,EDO_MOSTRAR_EN_INTERFAZ,AUD_USER,AUD_FECHA)
                  VALUES (VCTDC_TD,NMEPL_ND,SYSDATE,NMTDO_ID_TIPO_DOCUMENTO,DT_FECHA_EXPEDICION,'S',USER,SYSDATE);
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_CAM INSERTANDO EN TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
           ELSE
              BEGIN
                  UPDATE TSEL_EMPLEADO_DOCUMENTO SET EDO_FEC_EXPEDICION=DT_FECHA_EXPEDICION WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMTDO_ID_TIPO_DOCUMENTO;
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_CAM ACTUALIZANDO TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
          END IF;
          COMMIT;
     END PL_ACTUALIZAR_INFO_CAM;

     -----------------------------------------------------------------------------------
     ------------- ELIMINA REGISTROS DE PASAPORTE ASOCIADOS AL EMPLEADO-----------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_PASAPORTE(VCTDC_TD                IN VARCHAR,
                                          NMEPL_ND                IN NUMBER,
                                          VCERROR                 OUT VARCHAR2) IS
        NM_ID_CONSTANTE  NUMBER;
       BEGIN
          NM_ID_CONSTANTE:=FB_CONSTANTE_NUM('HV_ID_PASS',SYSDATE,'',NULL,'',NULL,'','');
          DELETE FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NM_ID_CONSTANTE;
        COMMIT;
     END PL_ELIMINAR_INFO_PASAPORTE;

     -----------------------------------------------------------------------------------
     --------------- ELIMINA REGISTROS DE CARNET DE MANIPULACION DE ALIMENTOS-----------
     ----------------------------ASOCIADOS AL EMPLEADO----------------------------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_CAM(VCTDC_TD                IN VARCHAR,
                                    NMEPL_ND                IN NUMBER,
                                    VCERROR                 OUT VARCHAR2) IS
        NM_ID_CONSTANTE  NUMBER;
       BEGIN
          NM_ID_CONSTANTE:=FB_CONSTANTE_NUM('HV_CM_ALI',SYSDATE,'',NULL,'',NULL,'','');
          DELETE FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NM_ID_CONSTANTE;
        COMMIT;
     END PL_ELIMINAR_INFO_CAM;

     -----------------------------------------------------------------------------------
     ----- CONSULTA INFORMACION DE LICENCIAS DE CONDUCCION ASOCIADAS AL EMPLEADO--------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_INFO_LICENCIAS(VCTDC_TD IN VARCHAR,NMEPL_ND IN NUMBER,VCERROR OUT VARCHAR2,VCCONSULTA OUT REFCURSOR) IS
       NM_ID_PASE_CONSTANTE  NUMBER;
     BEGIN
       NM_ID_PASE_CONSTANTE:=FB_CONSTANTE_NUM('HV_ID_PASE',SYSDATE,'',NULL,'',NULL,'','');
       OPEN
          VCCONSULTA FOR
             SELECT * FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NM_ID_PASE_CONSTANTE;
       RETURN;
       CLOSE VCCONSULTA;
       EXCEPTION
         WHEN OTHERS THEN
            VCERROR:='ERROR CARGANDO INFORMACION DE LICENCIAS CONDUCCION POR EMPLEADO:  '||SQLERRM;
     END PL_CARGAR_INFO_LICENCIAS;

     -----------------------------------------------------------------------------------
     --- REALIZA EL PROCESO DE PERSISTENCIA DEL REGISTRO DE INFORMACION DE LICENCIAS ---
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ACTUALIZAR_INFO_LICENCIA (VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            NMTDO_ID_TIPO_DOCUMENTO IN NUMBER,
                                            NMEDO_SEQ               IN NUMBER,
                                            VCCATEGORIA             IN VARCHAR2,
                                            DT_FECHA_VENCIMIENTO    IN DATE,
                                            VCERROR                 OUT VARCHAR2) IS
        BEGIN
          -- INSERTAR SI NO EXISTE DE LO CONTRARIO ACTUALIZAR
          IF NMEDO_SEQ=0 THEN
              BEGIN
                  INSERT INTO TSEL_EMPLEADO_DOCUMENTO (TDC_TD,EPL_ND,EDO_FECHA,TDO_ID_TIPO_DOCUMENTO,EDO_FEC_VENCIMIENTO,EDO_MOSTRAR_EN_INTERFAZ,EDO_CATEGORIA,AUD_USER,AUD_FECHA)
                  VALUES (VCTDC_TD,NMEPL_ND,SYSDATE,NMTDO_ID_TIPO_DOCUMENTO,DT_FECHA_VENCIMIENTO,'S',VCCATEGORIA,USER,SYSDATE);
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_LICENCIA INSERTANDO EN TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
           ELSE
              BEGIN
                  UPDATE TSEL_EMPLEADO_DOCUMENTO SET EDO_FEC_VENCIMIENTO=DT_FECHA_VENCIMIENTO,EDO_CATEGORIA=VCCATEGORIA WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND TDO_ID_TIPO_DOCUMENTO=NMTDO_ID_TIPO_DOCUMENTO AND EDO_SEQ=NMEDO_SEQ;
              EXCEPTION
                  WHEN OTHERS THEN
                     VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_ACTUALIZAR_INFO_LICENCIA ACTUALIZANDO TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
              END;
          END IF;
          COMMIT;
       EXCEPTION
          WHEN  OTHERS THEN
              VCERROR:=SQLERRM;
     END PL_ACTUALIZAR_INFO_LICENCIA;

     -----------------------------------------------------------------------------------
     ------------- ELIMINA REGISTROS DE LICENCIAS ASOCIADAS AL EMPLEADO-----------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_LICENCIA (VCTDC_TD                IN VARCHAR,
                                          NMEPL_ND                IN NUMBER,
                                          NMEDO_SEQ               IN NUMBER,
                                          VCERROR                 OUT VARCHAR2) IS
       BEGIN
          DELETE FROM TSEL_EMPLEADO_DOCUMENTO WHERE EPL_ND=NMEPL_ND AND TDC_TD=VCTDC_TD AND EDO_SEQ=NMEDO_SEQ;
        COMMIT;
     END PL_ELIMINAR_INFO_LICENCIA;
     -----------------------------------------------------------------------------------
     ----------- RETORNA EL CODIGO DEL LA IMAN DEL USUARIO EN EL SGED-----------------
     -----------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_COD_IMG_PERFIL(VCTDC_TD                IN VARCHAR,
                                       NMEPL_ND                IN NUMBER) RETURN VARCHAR2 IS
      VCCODIGO_IMAGEN      VARCHAR2(30);
      NM_CONSTANTE_IMAGEN  NUMBER;
     BEGIN
        VCCODIGO_IMAGEN:='';
        SELECT FB_CONSTANTE_NUM('HV_ID_FOTO',SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL) INTO NM_CONSTANTE_IMAGEN FROM DUAL;
        SELECT MAX(ID_GESTOR_DOCUMENTAL) INTO VCCODIGO_IMAGEN FROM TSEL_EMPLEADO_DOCUMENTO WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND AND TDO_ID_TIPO_DOCUMENTO=NM_CONSTANTE_IMAGEN;
        RETURN VCCODIGO_IMAGEN;
     EXCEPTION
       WHEN OTHERS THEN
          VCCODIGO_IMAGEN:=NULL;
        RETURN VCCODIGO_IMAGEN;
     END FL_CARGAR_COD_IMG_PERFIL;

     ------------------------------------------------------------------------------------
     ------ ALMACENA LA INFORMACION RELACIONADA CON LA IMG DE PERFIL DEL USUARIO---------
     ------------------------------------------------------------------------------------
     PROCEDURE PL_GUARDAR_INFO_IMG_PERFIL (VCTDC_TD                IN VARCHAR,
                                           NMEPL_ND                IN NUMBER,
                                           VCID_GESTOR_DOC         IN VARCHAR2,
                                           VCERROR                 OUT VARCHAR2) IS
      NM_CONSTANTE_IMAGEN  NUMBER;
      NM_CONTADOR          NUMBER;
       BEGIN
        SELECT FB_CONSTANTE_NUM('HV_ID_FOTO',SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL) INTO NM_CONSTANTE_IMAGEN FROM DUAL;
        SELECT COUNT(1) INTO NM_CONTADOR FROM TSEL_EMPLEADO_DOCUMENTO WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND AND TDO_ID_TIPO_DOCUMENTO=NM_CONSTANTE_IMAGEN;

        --- VERIFICAMOS SI EXISTE YA ASOCIADA UNA IMAGEN SI ES ASI SE ACTUALIZA DE LO CONTRARIO DE INSERTA LA NUEVA REFERENCIA DE LA IMAGEN
        IF NM_CONTADOR=0 THEN
          BEGIN
              INSERT INTO TSEL_EMPLEADO_DOCUMENTO (TDC_TD,EPL_ND,EDO_FECHA,TDO_ID_TIPO_DOCUMENTO,ID_GESTOR_DOCUMENTAL,EDO_MOSTRAR_EN_INTERFAZ,AUD_USER,AUD_FECHA)
              VALUES (VCTDC_TD,NMEPL_ND,SYSDATE,NM_CONSTANTE_IMAGEN,VCID_GESTOR_DOC,'S',USER,SYSDATE);
          EXCEPTION
              WHEN OTHERS THEN
                VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_GUARDAR_INFO_IMG_PERFIL INSERTANDO EN TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
          END;
         ELSE
          BEGIN
             UPDATE TSEL_EMPLEADO_DOCUMENTO SET ID_GESTOR_DOCUMENTAL=VCID_GESTOR_DOC WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND AND TDO_ID_TIPO_DOCUMENTO=NM_CONSTANTE_IMAGEN;
          EXCEPTION
              WHEN OTHERS THEN
                VCERROR := 'ERRROR QB_APLICATION_JSEL0029.PL_GUARDAR_INFO_IMG_PERFIL ACTUALIZANDO TSEL_EMPLEADO_DOCUMENTO: ' || SQLERRM;
          END;
        END IF;
        COMMIT;
       EXCEPTION
          WHEN OTHERS THEN
             VCERROR:='ERROR GUARDANDO INFORMACION DE IMAGEN PERFIL USUARIO, CAUSADO POR: '||SQLERRM;
     END PL_GUARDAR_INFO_IMG_PERFIL;

     ------------------------------------------------------------------------------------
     ------ ELIMINA LA INFORMACION RELACIONADA CON LA IMG DE PERFIL DEL USUARIO---------
     ------------------------------------------------------------------------------------
     PROCEDURE PL_ELIMINAR_INFO_IMG_PERFIL (VCTDC_TD                IN VARCHAR,
                                            NMEPL_ND                IN NUMBER,
                                            VCERROR                 OUT VARCHAR2) IS
        NM_CONSTANTE_IMAGEN  NUMBER;
      BEGIN
        SELECT FB_CONSTANTE_NUM('HV_ID_FOTO',SYSDATE,NULL,NULL,NULL,NULL,NULL,NULL) INTO NM_CONSTANTE_IMAGEN FROM DUAL;
        --- BORRADO DE LA IMAGEN DE PERFIL DEL USUARIO
        DELETE FROM TSEL_EMPLEADO_DOCUMENTO WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND AND TDO_ID_TIPO_DOCUMENTO=NM_CONSTANTE_IMAGEN;
        COMMIT;
       EXCEPTION
          WHEN OTHERS THEN
             VCERROR:='ERROR ELIMINANDO INFORMACION DE IMAGEN PERFIL USUARIO, CAUSADO POR: '||SQLERRM;
     END PL_ELIMINAR_INFO_IMG_PERFIL;

     ------------------------------------------------------------------------------------
     --------------------------- RETORNA EL GENERO DEL EMPLEADO--------------------------
     ------------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_GENERO_EPL(VCTDC_TD  IN VARCHAR,
                                   NMEPL_ND  IN NUMBER) RETURN VARCHAR2 IS
        VCEPL_GENERO   VARCHAR2(4);
       BEGIN
          SELECT EPL_SEXO INTO VCEPL_GENERO
              FROM EMPLEADO WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND;
          RETURN VCEPL_GENERO;
       EXCEPTION
          WHEN OTHERS THEN
             RETURN '';
     END FL_CARGAR_GENERO_EPL;
     -----------------------------------------------------------------------------------
     ----------- RETORNA EL VALOR ENCONTRADO PARA LA CONSTANTE INGRESADA----------------
     -----------------------------------------------------------------------------------
     FUNCTION FL_CARGAR_ID_CONSTANTE(VCCONSTANTE IN VARCHAR2) RETURN NUMBER IS
        NM_ID_CONSTANTE  NUMBER;
       BEGIN
        NM_ID_CONSTANTE:=FB_CONSTANTE_NUM(VCCONSTANTE,SYSDATE,'',NULL,'',NULL,'','');
        RETURN NM_ID_CONSTANTE;
     END FL_CARGAR_ID_CONSTANTE;

     -----------------------------------------------------------------------------------
     ----------------- RETORNA LOS VALORES DE SITUACION MILITAR-------------------------
     -----------------------------------------------------------------------------------
     PROCEDURE PL_CARGAR_SITUACIONMIL(REFC_SITMILITAR OUT REFCURSOR)IS

      BEGIN
          OPEN REFC_SITMILITAR FOR
              SELECT 'NO APLICA' DESCRIPCION
              FROM dual
              UNION
        SELECT 'NO DEFINIDA' DESCRIPCION
              FROM dual
              UNION
              SELECT 'SITUACION DEFINIDA - PRIMERA CLASE' DESCRIPCION
              FROM DUAL
              UNION
              SELECT 'SITUACION DEFINIDA - SEGUNDA CLASE' DESCRIPCION
              FROM dual
              UNION
              SELECT 'CEDULA MILITAR' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'RESERVISTA - PRIMERA CLASE Y SEGUNDA CLASE' DESCRIPCION
              FROM dual
              UNION
              SELECT 'EN LIQUIDACION - PAGADO' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'EN LIQUIDACION - POR LIQUIDAR' DESCRIPCION
              FROM dual
              UNION
              SELECT 'EN LIQUIDACION - POR PAGAR' DESCRIPCION
              FROM dual
              UNION
              SELECT 'EN LIQUIDACION - CON RECIBO' DESCRIPCION
              FROM dual
              UNION
              SELECT 'NO APTO O EXENTO' DESCRIPCION
              FROM dual;
      END PL_CARGAR_SITUACIONMIL;

    -----------------------------------------------------------------------------------
      -------------------- RETORNA LOS VALORES DE LOCALIDADES----------------------------
      -----------------------------------------------------------------------------------
      PROCEDURE PL_CARGAR_LOCALIDADES(REFC_LOCALIDADES OUT REFCURSOR)IS

      BEGIN

          OPEN REFC_LOCALIDADES FOR
              SELECT 'NO APLICA' DESCRIPCION
              FROM dual
              UNION
        SELECT 'USAQUEN' DESCRIPCION
              FROM dual
              UNION
              SELECT 'CHAPINERO' DESCRIPCION
              FROM DUAL
              UNION
              SELECT 'SANTA FE' DESCRIPCION
              FROM dual
              UNION
              SELECT 'SAN CRISTOBAL' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'USME' DESCRIPCION
              FROM dual
              UNION
              SELECT 'TUNJUELITO' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'BOSA' DESCRIPCION
              FROM dual
              UNION
              SELECT 'KENNEDY' DESCRIPCION
              FROM dual
              UNION
              SELECT 'FONTIBON' DESCRIPCION
              FROM dual
              UNION
              SELECT 'ENGATIVA' DESCRIPCION
              FROM dual
              UNION
              SELECT 'SUBA' DESCRIPCION
              FROM dual
              UNION
              SELECT 'BARRIOS UNIDOS' DESCRIPCION
              FROM DUAL
              UNION
              SELECT 'TEUSAQUILLO' DESCRIPCION
              FROM dual
              UNION
              SELECT 'LOS MARTIRES' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'ANTONIO NARINO' DESCRIPCION
              FROM dual
              UNION
              SELECT 'PUENTE ARANDA' DESCRIPCION
              FROM Dual
              UNION
              SELECT 'LA CANDELARIA' DESCRIPCION
              FROM dual
              UNION
              SELECT 'RAFAEL URIBE URIBE' DESCRIPCION
              FROM dual
              UNION
              SELECT 'CIUDAD BOLIVAR' DESCRIPCION
              FROM dual
              UNION
              SELECT 'SUMAPAZ' DESCRIPCION
              FROM dual;

      END PL_CARGAR_LOCALIDADES;

     -----------------------------------------------------------------------------
     ------------ RETORNA LA CANTIDAD DE CONTRATOS ACTIVOS DEL EMPLEADO-----------
     -----------------------------------------------------------------------------
      PROCEDURE PL_VALIDA_CTOACT(VCEPL_TDC_TD IN VARCHAR2,
                                 NMEPL_ND IN NUMBER,
                                 NMCTO_ACT OUT NUMBER)IS

      BEGIN

          SELECT COUNT(*)
          INTO NMCTO_ACT
          FROM contrato cto
          WHERE cto.EPL_ND = NMEPL_ND
          AND cto.TDC_TD_EPL = VCEPL_TDC_TD
          AND cto.ECT_SIGLA = 'ACT';

      END PL_VALIDA_CTOACT;

      -----------------------------------------------------------------------------
     ------------ RETORNA EL LISTADO DE FUENTES  ---------------------------------
     -----------------------------------------------------------------------------

      PROCEDURE PL_LISTA_FUENTES_V2(VCCONSULTA          OUT refcursor,
                                  VCESTADO_PROCESO      OUT VARCHAR2,
                                  VCMENSAJE_PROCESO     OUT VARCHAR2)	IS

      BEGIN
      OPEN VCCONSULTA FOR
        SELECT *
        FROM FUENTE_HOJA_VIDA;
        vcestado_proceso := 'S';
        vcmensaje_proceso := 'Consulta ejecutada correctamente';
        RETURN;
      EXCEPTION
          WHEN OTHERS THEN
              VCESTADO_PROCESO := 'N';
              VCMENSAJE_PROCESO := 'HA OCURRIDO UN ERROR AL EJECUTAR PL_LISTA_FUENTES_V2, MOTIVO: '||SQLERRM;
      END PL_LISTA_FUENTES_V2;


      PROCEDURE PL_CARGAR_DATOSBHV_ADD(VCTDC_TD         IN VARCHAR2,
                                       NMEPL_ND         IN NUMBER,
                                       VCRAZA           IN VARCHAR2,
                                       VCSISBEN         IN VARCHAR2,
                                       VCDISCAPACIDAD   IN VARCHAR2,
                                       NMESTRATO        IN NUMBER,
                                       VCAUD_USUARIO    IN VARCHAR2,
                                       VCESTADO_PROCESO     OUT VARCHAR2,
                                       VCMENSAJE_PROCESO    OUT VARCHAR2) IS
     NMVALIDADOR NUMBER(3);                                  
     BEGIN

     PB_SEGUIMIENTO_LONG(
        'REPLICACION',  
        'Procedimiento: PL_CARGAR_DATOSBHV_ADD, ' ||
        'VCTDC_TD: ' || VCTDC_TD || ', ' ||
        'NMEPL_ND: ' || TO_CHAR(NMEPL_ND) || ', ' ||
        'VCRAZA: ' || VCRAZA || ', ' ||
        'VCSISBEN: ' || VCSISBEN || ', ' ||
        'VCDISCAPACIDAD: ' || VCDISCAPACIDAD || ', ' ||
        'NMESTRATO: ' || TO_CHAR(NMESTRATO) || ', ' ||
        'VCAUD_USUARIO: ' || VCAUD_USUARIO
        );

        SELECT COUNT(*) INTO NMVALIDADOR FROM rhu.tsel_emp_dat WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND;

        IF(NMVALIDADOR >= 1) THEN
            UPDATE rhu.tsel_emp_dat 
            SET RAZA=VCRAZA, 
            SISBEN=VCSISBEN, 
            DISCAPACIDAD=VCDISCAPACIDAD, 
            ESTRATO=NMESTRATO, 
            AUD_USUARIO=VCAUD_USUARIO, 
            AUD_FECHA=SYSDATE
            WHERE TDC_TD=VCTDC_TD AND 
            EPL_ND =NMEPL_ND;
            VCMENSAJE_PROCESO := 'Actualizado Correctamente';
        ELSE            
            INSERT INTO rhu.tsel_emp_dat (
            TDC_TD,
            EPL_ND,
            RAZA,
            SISBEN,
            DISCAPACIDAD,
            ESTRATO,
            AUD_USUARIO,
            AUD_FECHA)
            VALUES(
            VCTDC_TD,
            NMEPL_ND,
            VCRAZA,
            VCSISBEN,
            VCDISCAPACIDAD,
            NMESTRATO,
            VCAUD_USUARIO,
            SYSDATE);
            VCMENSAJE_PROCESO := 'Creado Correctamente';            
        END IF;
              VCESTADO_PROCESO := 'S';
        COMMIT;


     EXCEPTION
          WHEN OTHERS THEN
              VCESTADO_PROCESO := 'N';
              VCMENSAJE_PROCESO := 'HA OCURRIDO UN ERROR AL EJECUTAR PL_CARGAR_DATOSBHV_ADD, MOTIVO: '||SQLERRM;   
     END PL_CARGAR_DATOSBHV_ADD;

         PROCEDURE PL_OBTENER_DATOSBHV_ADD(VCTDC_TD         IN VARCHAR2,
                                       NMEPL_ND             IN NUMBER,
                                       VCRAZA               OUT VARCHAR2,
                                       VCSISBEN             OUT VARCHAR2,
                                       VCDISCAPACIDAD       OUT VARCHAR2,
                                       NMESTRATO            OUT VARCHAR2,
                                       VCESTADO_PROCESO     OUT VARCHAR2,
                                       VCMENSAJE_PROCESO    OUT VARCHAR2)IS
     NMVALIDADOR NUMBER(3);                                  

     BEGIN

     SELECT COUNT(*) INTO NMVALIDADOR FROM rhu.tsel_emp_dat WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND;

    IF(NMVALIDADOR >= 1) THEN
        SELECT RAZA, SISBEN, DISCAPACIDAD, ESTRATO
        INTO VCRAZA, VCSISBEN,VCDISCAPACIDAD,NMESTRATO
        FROM rhu.tsel_emp_dat WHERE TDC_TD=VCTDC_TD AND EPL_ND=NMEPL_ND;
        VCMENSAJE_PROCESO := 'Consultado Correctamente';
    ELSE
        --PLANTILLA:
        VCRAZA          :='No Aplica';
        VCSISBEN        :='No Aplica';
        VCDISCAPACIDAD  := '';
        NMESTRATO       := 1;
        VCMENSAJE_PROCESO := 'Plantilla Enviada Correctamente';    
    END IF;

    VCESTADO_PROCESO := 'S';
    EXCEPTION
          WHEN OTHERS THEN
              VCESTADO_PROCESO := 'N';
              VCMENSAJE_PROCESO := 'HA OCURRIDO UN ERROR AL EJECUTAR PL_OBTENER_DATOSBHV_ADD, MOTIVO: '||SQLERRM;                                     

END PL_OBTENER_DATOSBHV_ADD;

  end QB_APLICATION_JSEL0029;