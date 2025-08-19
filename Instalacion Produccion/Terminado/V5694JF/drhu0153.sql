CREATE OR REPLACE TRIGGER rhu.db_limpiar_nombres
BEFORE INSERT OR UPDATE ON rhu.empleado
FOR EACH ROW
-- **********************************
-- SCRIPT        : DRHU0153.SQL
-- DIRECTORIO    : C:\FTES\V1\SQL
-- OBJETIVO      : Trigger para eliminar los espacios iniciales en nombres y validar correo electrónico
-- ESQUEMA       : RHU
-- CREACIÓN      : 2006/11/27
-- **********************************
--******************************************************************************
--** ACTUALIZACIÓN        : JUFORERO 2025/05/13
--** DESCRIPCIÓN          : Se actualiza el script con el desarrollo encontrado en producción y se procede a desactivarlo debido a que
--**                        realiza una consulta a toda la base de datos de Activos cada vez que se registra un nuevo candidato,
--**                        lo cual genera lentitud en el sistema. Se establece el número de identificación como registro único.
--******************************************************************************
DECLARE
  vcInstruccion VARCHAR2(510) := 'Error';
  vcError       VARCHAR2(2000);
  exnada        EXCEPTION;
BEGIN
  -- Limpieza de nombres y dirección
  :NEW.EPL_APELL1 := UPPER(fb_limpiar_cadena_inicio(1, :NEW.EPL_APELL1));
  :NEW.EPL_APELL2 := UPPER(fb_limpiar_cadena_inicio(1, :NEW.EPL_APELL2));
  :NEW.EPL_NOM1   := UPPER(fb_limpiar_cadena_inicio(1, :NEW.EPL_NOM1));
  :NEW.EPL_NOM2   := UPPER(fb_limpiar_cadena_inicio(1, :NEW.EPL_NOM2));
  :NEW.EPL_DIRECCION := fb_limpiar_cadena_inicio(5, :NEW.EPL_DIRECCION);

  -- Auditoría
  :NEW.fecha_modificacion   := SYSDATE;
  :NEW.usuario_modificacion := USER;

  -- Validación de correo electrónico
  IF INSERTING THEN
    IF :NEW.EPL_EMAIL IS NOT NULL THEN
      IF FB_VALIDAEMAIL(:NEW.EPL_EMAIL) = 0 THEN
        RAISE exnada;
      END IF;
    END IF;
  END IF;

  IF UPDATING THEN
    IF :NEW.EPL_EMAIL IS NOT NULL THEN
      IF FB_VALIDAEMAIL(LOWER(:NEW.EPL_EMAIL)) = 0 THEN
        RAISE exnada;
      END IF;
    END IF;
  END IF;

EXCEPTION
  WHEN exnada THEN
    vcError := 'Dirección de correo no válida. Revise la función FB_VALIDAEMAIL.';
    RAISE_APPLICATION_ERROR(-20500, 'Error: ' || vcError || ' ' || SQLERRM);
END;
/
--******************************************************************************
--** ACTUALIZACIÓN        : JUFORERO 2025/05/13
--** DESCRIPCIÓN          : Se actualiza el script con el desarrollo encontrado en producción y se procede a desactivarlo debido a que
--**                        realiza una consulta a toda la base de datos de Activos cada vez que se registra un nuevo candidato,
--**                        lo cual genera lentitud en el sistema. Se establece el número de identificación como registro único.
--******************************************************************************
ALTER TRIGGER RHU.DB_LIMPIAR_NOMBRES DISABLE;

