CREATE OR REPLACE TRIGGER SEL.TR_TSEL_NUCLEO_FAMILIAR_DEL
BEFORE DELETE ON SEL.TSEL_NUCLEO_FAMILIAR
REFERENCING OLD AS OLD
FOR EACH ROW
-- ******************************************************************
-- SCRIPT        : DRHU0470.SQL
-- OBJETIVO      : Desactivar el trigger que impide la eliminación del último familiar.
-- ESQUEMA       : SEL
-- CREACIÓN      : JUFORERO
-- FECHA         : 2025-05-13
-- DESCRIPCIÓN   : Se desactiva el trigger SEL.TR_TSEL_NUCLEO_FAMILIAR_DEL debido a que bloquea
--                 la eliminación del último familiar registrado por candidato, generando inconsistencias
--                 con el sistema en GCP. Este trigger lanza un error local, pero la eliminación sí ocurre
--                 en la base de datos de DaVinci, provocando desincronización de datos durante la replicación.
-- ******************************************************************
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;
  NMCONTEO NUMBER := 0;
BEGIN
  BEGIN
    SELECT COUNT(*)
    INTO NMCONTEO
    FROM SEL.TSEL_NUCLEO_FAMILIAR F
    WHERE F.EPL_ND = :OLD.EPL_ND
      AND F.DCM_RADICACION = :OLD.DCM_RADICACION;
  EXCEPTION
    WHEN OTHERS THEN
      PB_SEGUIMIENTO2('ERRORTRIGGER', 'ERROR TR_TSEL_NUCLEO_FAMILIAR_DEL: ' || SQLERRM);
      NMCONTEO := 0;
  END;

  IF NMCONTEO <= 1 THEN
    RAISE_APPLICATION_ERROR(-20000, 'No se puede borrar, debe dejar por lo menos un contacto o familiar para el candidato.');
  END IF;
END;
/
-- ******************************************************************
-- SCRIPT        : DRHU0470.SQL
-- OBJETIVO      : Desactivar el trigger que impide la eliminación del último familiar.
-- ESQUEMA       : SEL
-- CREACIÓN      : JUFORERO
-- FECHA         : 2025-05-13
-- DESCRIPCIÓN   : Se desactiva el trigger SEL.TR_TSEL_NUCLEO_FAMILIAR_DEL debido a que bloquea
--                 la eliminación del último familiar registrado por candidato, generando inconsistencias
--                 con el sistema en GCP. Este trigger lanza un error local, pero la eliminación sí ocurre
--                 en la base de datos de DaVinci, provocando desincronización de datos durante la replicación.
-- ******************************************************************
ALTER TRIGGER SEL.TR_TSEL_NUCLEO_FAMILIAR_DEL DISABLE;
