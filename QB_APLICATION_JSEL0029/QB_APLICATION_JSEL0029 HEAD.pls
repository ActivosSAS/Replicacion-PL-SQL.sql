create or replace PACKAGE         SEL.QB_APLICATION_JSEL0029 as
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
    --****************************************************************
    --** MODIFICACIÓN         : Se implementa una validacion cuando llega por replicacion cuando la fuente es 
    --**                        'COMPUTRABAJO_MASIVO', se valida Zona, Ciudad, Barrio
    --** AUTOR MODIFICACIÓN   : JUFORERO
    --** FECHA MODIFICACIÓN   : 07/05/2025
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
