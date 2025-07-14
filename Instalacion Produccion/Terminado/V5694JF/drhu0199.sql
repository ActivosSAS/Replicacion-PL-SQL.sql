CREATE OR REPLACE TRIGGER RHU.db_valida_nombres
BEFORE INSERT  ON rhu.empleado
REFERENCING OLD AS OLD NEW AS NEW FOR EACH ROW
--hugo quintero
--scripts drhu0199
--******************************************************************************
--** ACTUALIZACIÓN        : JUFORERO 2025/05/13
--** DESCRIPCIÓN          : Se actualiza el script con el desarrollo encontrado en producción y se procede a desactivarlo debido a que
--**                        realiza una consulta a toda la base de datos de Activos cada vez que se registra un nuevo candidato,
--**                        lo cual genera lentitud en el sistema. Se establece el número de identificación como registro único.
--******************************************************************************
BEGIN
 DECLARE
  vcInstruccion  varchar2(510):='Error';
  vcError        varchar2(2000);
  exError        Exception;
  vcsalida        varchar2(2000);
  vcerror_proc    varchar2(2000);
  --
   ROWDEMPLEADO empleado%rowtype;
   NMSECUENCIA NUMBER;
BEGIN
ROWDEMPLEADO.TDC_TD           :=:NEW.TDC_TD                 ;
ROWDEMPLEADO.EPL_ND           :=:NEW.EPL_ND                 ;
ROWDEMPLEADO.EPL_APELL1       :=:NEW.EPL_APELL1             ;
ROWDEMPLEADO.EPL_APELL2       :=:NEW.EPL_APELL2             ;
ROWDEMPLEADO.EPL_NOM1         :=:NEW.EPL_NOM1               ;
ROWDEMPLEADO.EPL_NOM2         :=:NEW.EPL_NOM2               ;
ROWDEMPLEADO.EPL_FECNACIM     :=:NEW.EPL_FECNACIM           ;
ROWDEMPLEADO.PAI_NOMBRE_NAC   :=:NEW.PAI_NOMBRE_NAC         ;
ROWDEMPLEADO.DPT_NOMBRE_NAC   :=:NEW.DPT_NOMBRE_NAC         ;
ROWDEMPLEADO.CIU_NOMBRE_NAC   :=:NEW.CIU_NOMBRE_NAC         ;
ROWDEMPLEADO.PAI_NOMBRE_RES   :=:NEW.PAI_NOMBRE_RES         ;
ROWDEMPLEADO.DPT_NOMBRE_RES   :=:NEW.DPT_NOMBRE_RES         ;
ROWDEMPLEADO.CIU_NOMBRE_RES   :=:NEW.CIU_NOMBRE_RES         ;
ROWDEMPLEADO.ZON_NOMBRE       :=:NEW.ZON_NOMBRE             ;
ROWDEMPLEADO.BAR_NOMBRE       :=:NEW.BAR_NOMBRE             ;
ROWDEMPLEADO.EPL_DIRECCION    :=:NEW.EPL_DIRECCION          ;
ROWDEMPLEADO.EPL_LIBMIL       :=:NEW.EPL_LIBMIL             ;
ROWDEMPLEADO.EPL_DISMIL       :=:NEW.EPL_DISMIL             ;
ROWDEMPLEADO.EPL_CLAMIL       :=:NEW.EPL_CLAMIL             ;
ROWDEMPLEADO.ECV_SIGLA        :=:NEW.ECV_SIGLA              ;
ROWDEMPLEADO.EPL_SEXO         :=:NEW.EPL_SEXO               ;
ROWDEMPLEADO.EPL_EMAIL        :=:NEW.EPL_EMAIL              ;
ROWDEMPLEADO.EPL_FECRECEP     :=:NEW.EPL_FECRECEP           ;
ROWDEMPLEADO.DCM_RADICACION   :=:NEW.DCM_RADICACION         ;
ROWDEMPLEADO.FEC_EXP_CEDULA   :=:NEW.FEC_EXP_CEDULA         ;
ROWDEMPLEADO.FEC_EXP_LMILITAR :=:NEW.FEC_EXP_LMILITAR       ;
ROWDEMPLEADO.ZONA_LMILITAR    :=:NEW.ZONA_LMILITAR          ;
ROWDEMPLEADO.PAI_NOMBRE_CED   :=:NEW.PAI_NOMBRE_CED         ;
ROWDEMPLEADO.DPT_NOMBRE_CED   :=:NEW.DPT_NOMBRE_CED         ;
ROWDEMPLEADO.CIU_NOMBRE_CED   :=:NEW.CIU_NOMBRE_CED         ;

pb_validaHvida(ROWDEMPLEADO,vcerror_proc);

IF USER <> 'INTRAUSER' THEN
    :NEW.USUARIO_CREACION := USER;
END IF;

/*
IF :NEW.DCM_RADICACION IS NULL THEN
  SELECT DOC_RADICACION.NEXTVAL INTO NMSECUENCIA FROM DUAL;
  :NEW.DCM_RADICACION := NMSECUENCIA;
END IF;
*/

IF   vcerror_proc is not null THEN
      raise exError;
 End if;
--
Exception
 when exError then
  vcError:=vcerror_proc;
  raise_application_error(-20000,vcError);
End;
End;
/
--******************************************************************************
--** ACTUALIZACIÓN        : JUFORERO 2025/05/13
--** DESCRIPCIÓN          : Se actualiza el script con el desarrollo encontrado en producción y se procede a desactivarlo debido a que
--**                        realiza una consulta a toda la base de datos de Activos cada vez que se registra un nuevo candidato,
--**                        lo cual genera lentitud en el sistema. Se establece el número de identificación como registro único.
--******************************************************************************
ALTER TRIGGER RHU.DB_VALIDA_NOMBRES DISABLE;
