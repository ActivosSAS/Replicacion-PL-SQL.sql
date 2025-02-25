create or replace PACKAGE     QB_DATA_REPLICATION AS
--**********************************************************************************************************
--** nombre script        : 
--** objetivo             : 
--** esquema              : RHU
--** nombre               : QB_DATA_REPLICATION / HEADER
--** autor                : Juan Sebastian Forero S.
--** fecha modificacion   : 2024/05/22
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