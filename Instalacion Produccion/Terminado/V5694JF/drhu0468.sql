CREATE OR REPLACE TRIGGER RHU.DB_INSERTA_BARRIO
BEFORE INSERT OR UPDATE ON RHU.EMPLEADO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
-- ******************************************************************
-- ** SCRIPT       : DRHU0196.SQL
-- ** DIRECTORIO   : C:\FTES\V1\SQL
-- ** OBJETIVO     : Creación del trigger DB_INSERTA_BARRIO
-- ** ESQUEMA      : RHU
-- ** CREACIÓN     : Hugo Quintero Bertel
-- ** ACTUALIZACIÓN: 2014/03/04
-- ******************************************************************
-- ******************************************************************
-- ** SCRIPT       : DRHU0468.SQL
-- ** OBJETIVO     : Ajustar Consulta de DB_INSERTA_BARRIO
-- ** ESQUEMA      : RHU
-- ** CREACIÓN     : JUFORERO
-- ** ACTUALIZACIÓN: 2025/05/13
-- ** DESCRIPCIÓN  : Se crea nuevo registro en BMX debido al que se maneja no coincide en Fuentes,
-- **                Se ajusta la consulta para insertar el barrio únicamente si no existe en la base de datos,
-- **                debido a que este trigger se encuentra sobre la tabla principal RHU.EMPLEADO.
-- **                En caso de error, el dato no se replica en tiempo real hacia el proyecto DaVinci en GCP.
-- ******************************************************************
DECLARE
  v_count NUMBER := 0;
  vcError VARCHAR2(2000);
BEGIN
  SELECT COUNT(*)
  INTO v_count
  FROM BARRIO
  WHERE UPPER(PAI_NOMBRE) = UPPER(:NEW.PAI_NOMBRE_RES)
    AND UPPER(DPT_NOMBRE) = UPPER(:NEW.DPT_NOMBRE_RES)
    AND UPPER(CIU_NOMBRE) = UPPER(:NEW.CIU_NOMBRE_RES)
    AND UPPER(ZON_NOMBRE) = UPPER(:NEW.ZON_NOMBRE)
    AND UPPER(BAR_NOMBRE) = UPPER(:NEW.BAR_NOMBRE);

  IF v_count = 0 THEN
    INSERT INTO BARRIO (
      PAI_NOMBRE,
      DPT_NOMBRE,
      CIU_NOMBRE,
      ZON_NOMBRE,
      BAR_NOMBRE,
      BAR_DEFECTO
    ) VALUES (
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
    vcError := 'Error en el trigger RHU.DB_INSERTA_BARRIO: ' || SQLERRM;
    NULL;
END;
/
