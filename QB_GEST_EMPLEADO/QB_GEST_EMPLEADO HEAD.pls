create or replace PACKAGE     QB_GEST_EMPLEADO  IS

--** SCRIPT               : QRHU0100.SQL

--** Tipo de registro para manejar las filas de la tabla EMPLEADO
TYPE GRP_EMPLEADO_REC IS RECORD(    TDC_TD          EMPLEADO.TDC_TD%TYPE,
                                    EPL_ND          EMPLEADO.EPL_ND%TYPE,
                                    EPL_APELL1      EMPLEADO.EPL_APELL1%TYPE,
                                    EPL_APELL2      EMPLEADO.EPL_APELL2%TYPE,
                                    EPL_NOM1        EMPLEADO.EPL_NOM1%TYPE,
                                    EPL_NOM2        EMPLEADO.EPL_NOM2%TYPE,
                                    EPL_FECNACIM    EMPLEADO.EPL_FECNACIM%TYPE,
                                    PAI_NOMBRE_NAC  EMPLEADO.PAI_NOMBRE_NAC%TYPE,
                                    DPT_NOMBRE_NAC  EMPLEADO.DPT_NOMBRE_NAC%TYPE,
                                    CIU_NOMBRE_NAC  EMPLEADO.CIU_NOMBRE_NAC%TYPE,
                                    PAI_NOMBRE_RES  EMPLEADO.PAI_NOMBRE_RES%TYPE,
                                    DPT_NOMBRE_RES  EMPLEADO.DPT_NOMBRE_RES%TYPE,
                                    CIU_NOMBRE_RES  EMPLEADO.CIU_NOMBRE_RES%TYPE,
                                    ZON_NOMBRE      EMPLEADO.ZON_NOMBRE%TYPE,
                                    BAR_NOMBRE      EMPLEADO.BAR_NOMBRE%TYPE,
                                    EPL_DIRECCION   EMPLEADO.EPL_DIRECCION%TYPE,
                                    EPL_LIBMIL      EMPLEADO.EPL_LIBMIL%TYPE,
                                    EPL_DISMIL      EMPLEADO.EPL_DISMIL%TYPE,
                                    EPL_CLAMIL      EMPLEADO.EPL_CLAMIL%TYPE,
                                    ECV_SIGLA       EMPLEADO.ECV_SIGLA%TYPE,
                                    EPL_SEXO        EMPLEADO.EPL_SEXO%TYPE,
                                    EPL_EMAIL       EMPLEADO.EPL_EMAIL%TYPE,
                                    EPL_FECRECEP    EMPLEADO.EPL_FECRECEP%TYPE,
                                    DCM_RADICACION  EMPLEADO.DCM_RADICACION%TYPE,
                                    PAI_NOMBRE_CED  EMPLEADO.PAI_NOMBRE_CED%TYPE,
                                    DPT_NOMBRE_CED  EMPLEADO.DPT_NOMBRE_CED%TYPE,
                                    CIU_NOMBRE_CED  EMPLEADO.CIU_NOMBRE_CED%TYPE,
                                    ZONA_LMILITAR   EMPLEADO.ZONA_LMILITAR%TYPE,
                                    FEC_EXP_LMILITAR    EMPLEADO.FEC_EXP_LMILITAR%TYPE,
                                    FEC_EXP_CEDULA   EMPLEADO.FEC_EXP_CEDULA%TYPE,
                                    FACTOR_RH        EMPLEADO.FACTOR_RH%TYPE,
                                    GRUPO_SANGUINEO  EMPLEADO.GRUPO_SANGUINEO%TYPE
                                );

--** Tipo tabla de resgistros para las filas de la tabla EMPLEADO
  TYPE GRP_EMPLEADO_TAB IS TABLE OF GRP_EMPLEADO_REC INDEX BY BINARY_INTEGER;

--** Tipo de registro para manejar los pk de la tabla empleado
  TYPE GRP_EMPLEADO_PK IS RECORD (   TDC_TD      EMPLEADO.TDC_TD%TYPE,
                                     EPL_ND      EMPLEADO.EPL_ND%TYPE
                                  );

--** Tipo tabla de resgistros para los pk de la tabla  empleado
  TYPE GRP_EMPLEADO_PKTAB IS TABLE OF GRP_EMPLEADO_PK INDEX BY BINARY_INTEGER;

--** Procedimientos usados para operaciones DML
--** en estos procedimientos solo colocar validaciones de
--** negocio que se cumaplan en todos los casos en aplicaci¿n.
  PROCEDURE INSERTAR (BLOCK_DATA IN GRP_EMPLEADO_TAB);

  PROCEDURE ACTUALIZAR (BLOCK_DATA IN GRP_EMPLEADO_TAB);

  PROCEDURE BORRAR (BLOCK_DATA IN GRP_EMPLEADO_PKTAB);

  PROCEDURE BLOQUEAR (BLOCK_DATA IN GRP_EMPLEADO_PKTAB);

END QB_GEST_EMPLEADO;