create or replace PACKAGE BODY         RHU.QB_GEST_EMPLEADO IS

--** Insertar registros
    PROCEDURE INSERTAR (BLOCK_DATA IN GRP_EMPLEADO_TAB)  IS
      i NUMBER;
      cnt NUMBER;
    BEGIN
      cnt := block_data.count;
      FOR i IN 1..cnt  LOOP
        INSERT INTO EMPLEADO (  TDC_TD        ,
                                EPL_ND        ,
                                EPL_APELL1    ,
                                EPL_APELL2    ,
                                EPL_NOM1      ,
                                EPL_NOM2      ,
                                EPL_FECNACIM  ,
                                PAI_NOMBRE_NAC,
                                DPT_NOMBRE_NAC,
                                CIU_NOMBRE_NAC,
                                PAI_NOMBRE_RES,
                                DPT_NOMBRE_RES,
                                CIU_NOMBRE_RES,
                                ZON_NOMBRE    ,
                                BAR_NOMBRE    ,
                                EPL_DIRECCION ,
                                EPL_LIBMIL    ,
                                EPL_DISMIL    ,
                                EPL_CLAMIL    ,
                                ECV_SIGLA     ,
                                EPL_SEXO      ,
                                EPL_EMAIL     ,
                                EPL_FECRECEP  ,
                                DCM_RADICACION,
                                PAI_NOMBRE_CED,
                                DPT_NOMBRE_CED,
                                CIU_NOMBRE_CED,
                                ZONA_LMILITAR,
                                FEC_EXP_LMILITAR,
                                FEC_EXP_CEDULA,
                                FACTOR_RH,
                                GRUPO_SANGUINEO,
                                FUENTE
                                 )
                     VALUES (   BLOCK_DATA(I).TDC_TD        ,
                                BLOCK_DATA(I).EPL_ND        ,
                                BLOCK_DATA(I).EPL_APELL1    ,
                                BLOCK_DATA(I).EPL_APELL2    ,
                                BLOCK_DATA(I).EPL_NOM1      ,
                                BLOCK_DATA(I).EPL_NOM2      ,
                                BLOCK_DATA(I).EPL_FECNACIM  ,
                                BLOCK_DATA(I).PAI_NOMBRE_NAC,
                                BLOCK_DATA(I).DPT_NOMBRE_NAC,
                                BLOCK_DATA(I).CIU_NOMBRE_NAC,
                                BLOCK_DATA(I).PAI_NOMBRE_RES,
                                BLOCK_DATA(I).DPT_NOMBRE_RES,
                                BLOCK_DATA(I).CIU_NOMBRE_RES,
                                BLOCK_DATA(I).ZON_NOMBRE    ,
                                BLOCK_DATA(I).BAR_NOMBRE    ,
                                BLOCK_DATA(I).EPL_DIRECCION ,
                                BLOCK_DATA(I).EPL_LIBMIL    ,
                                BLOCK_DATA(I).EPL_DISMIL    ,
                                BLOCK_DATA(I).EPL_CLAMIL    ,
                                BLOCK_DATA(I).ECV_SIGLA     ,
                                BLOCK_DATA(I).EPL_SEXO      ,
                                BLOCK_DATA(I).EPL_EMAIL     ,
                                BLOCK_DATA(I).EPL_FECRECEP  ,
                                BLOCK_DATA(I).DCM_RADICACION,
                                BLOCK_DATA(I).PAI_NOMBRE_CED,
                                BLOCK_DATA(I).DPT_NOMBRE_CED,
                                BLOCK_DATA(I).CIU_NOMBRE_CED,
                                BLOCK_DATA(I).ZONA_LMILITAR,
                                BLOCK_DATA(I).FEC_EXP_LMILITAR,
                                BLOCK_DATA(I).FEC_EXP_CEDULA,
                                BLOCK_DATA(I).FACTOR_RH,
                                BLOCK_DATA(I).GRUPO_SANGUINEO,
                                'CONTRATO');
      END LOOP;
    END;


--** Actualizar registros
    PROCEDURE ACTUALIZAR (BLOCK_DATA IN GRP_EMPLEADO_TAB)
    IS
      I   NUMBER;
      CNT NUMBER;
    BEGIN
      CNT := BLOCK_DATA.COUNT;
      FOR I IN 1..CNT  LOOP
         UPDATE EMPLEADO
         SET   EPL_APELL1    =BLOCK_DATA(I).EPL_APELL1    ,
               EPL_APELL2    =BLOCK_DATA(I).EPL_APELL2    ,
               EPL_NOM1      =BLOCK_DATA(I).EPL_NOM1      ,
               EPL_NOM2      =BLOCK_DATA(I).EPL_NOM2      ,
               EPL_FECNACIM  =BLOCK_DATA(I).EPL_FECNACIM  ,
               PAI_NOMBRE_NAC=BLOCK_DATA(I).PAI_NOMBRE_NAC,
               DPT_NOMBRE_NAC=BLOCK_DATA(I).DPT_NOMBRE_NAC,
               CIU_NOMBRE_NAC=BLOCK_DATA(I).CIU_NOMBRE_NAC,
               PAI_NOMBRE_RES=BLOCK_DATA(I).PAI_NOMBRE_RES,
               DPT_NOMBRE_RES=BLOCK_DATA(I).DPT_NOMBRE_RES,
               CIU_NOMBRE_RES=BLOCK_DATA(I).CIU_NOMBRE_RES,
               ZON_NOMBRE    =BLOCK_DATA(I).ZON_NOMBRE    ,
               BAR_NOMBRE    =BLOCK_DATA(I).BAR_NOMBRE    ,
               EPL_DIRECCION =BLOCK_DATA(I).EPL_DIRECCION ,
               EPL_LIBMIL    =BLOCK_DATA(I).EPL_LIBMIL    ,
               EPL_DISMIL    =BLOCK_DATA(I).EPL_DISMIL    ,
               EPL_CLAMIL    =BLOCK_DATA(I).EPL_CLAMIL    ,
               ECV_SIGLA     =BLOCK_DATA(I).ECV_SIGLA     ,
               EPL_SEXO      =BLOCK_DATA(I).EPL_SEXO      ,
               EPL_EMAIL     =BLOCK_DATA(I).EPL_EMAIL     ,
               EPL_FECRECEP  =BLOCK_DATA(I).EPL_FECRECEP  ,
               DCM_RADICACION=BLOCK_DATA(I).DCM_RADICACION,
               PAI_NOMBRE_CED=BLOCK_DATA(I).PAI_NOMBRE_CED,
               DPT_NOMBRE_CED=BLOCK_DATA(I).DPT_NOMBRE_CED,
               CIU_NOMBRE_CED=BLOCK_DATA(I).CIU_NOMBRE_CED,
               ZONA_LMILITAR   =BLOCK_DATA(I).ZONA_LMILITAR ,
               FEC_EXP_LMILITAR=BLOCK_DATA(I).FEC_EXP_LMILITAR,
               FEC_EXP_CEDULA= BLOCK_DATA(I).FEC_EXP_CEDULA,
               GRUPO_SANGUINEO=BLOCK_DATA(I).GRUPO_SANGUINEO,
               FACTOR_RH=BLOCK_DATA(I).FACTOR_RH
         WHERE    TDC_TD= BLOCK_DATA(I).TDC_TD
           AND    EPL_ND= BLOCK_DATA(I).EPL_ND;
      END LOOP;
    END;


--**Borrar registros
    PROCEDURE BORRAR (BLOCK_DATA IN GRP_EMPLEADO_PKTAB)
    IS
      i NUMBER;
      cnt NUMBER;
    BEGIN
      cnt := block_data.count;
      FOR i IN 1..cnt  LOOP
         DELETE FROM EMPLEADO
         WHERE TDC_TD = BLOCK_DATA(I).TDC_TD
         AND   EPL_ND=  BLOCK_DATA(I).EPL_ND;
      END LOOP;
    END;


--** bloquear
PROCEDURE  BLOQUEAR (BLOCK_DATA IN GRP_EMPLEADO_PKTAB)
    IS
      i NUMBER;
      cnt NUMBER;
      block_rec GRP_EMPLEADO_REC;
    BEGIN
      cnt := block_data.count;
      FOR i IN 1..cnt  LOOP
        SELECT  TDC_TD,
                EPL_ND,
                EPL_APELL1,
                EPL_APELL2,
                EPL_NOM1,
                EPL_NOM2,
                EPL_FECNACIM,
                PAI_NOMBRE_NAC,
                DPT_NOMBRE_NAC,
                CIU_NOMBRE_NAC,
                PAI_NOMBRE_RES,
                DPT_NOMBRE_RES,
                CIU_NOMBRE_RES,
                ZON_NOMBRE,
                BAR_NOMBRE,
                EPL_DIRECCION,
                EPL_LIBMIL,
                EPL_DISMIL,
                EPL_CLAMIL,
                ECV_SIGLA,
                EPL_SEXO,
                EPL_EMAIL,
                EPL_FECRECEP,
                DCM_RADICACION,
                PAI_NOMBRE_CED,
                DPT_NOMBRE_CED,
                CIU_NOMBRE_CED,
                ZONA_LMILITAR,
                FEC_EXP_LMILITAR ,
                FEC_EXP_CEDULA,
                GRUPO_SANGUINEO,
                FACTOR_RH
          INTO block_rec
          FROM EMPLEADO
          WHERE TDC_TD=BLOCK_DATA(I).TDC_TD
          AND   EPL_ND=BLOCK_DATA(I).EPL_ND
          FOR UPDATE OF TDC_TD,
                EPL_ND,
                EPL_APELL1,
                EPL_APELL2,
                EPL_NOM1,
                EPL_NOM2,
                EPL_FECNACIM,
                PAI_NOMBRE_NAC,
                DPT_NOMBRE_NAC,
                CIU_NOMBRE_NAC,
                PAI_NOMBRE_RES,
                DPT_NOMBRE_RES,
                CIU_NOMBRE_RES,
                ZON_NOMBRE,
                BAR_NOMBRE,
                EPL_DIRECCION,
                EPL_LIBMIL,
                EPL_DISMIL,
                EPL_CLAMIL,
                ECV_SIGLA,
                EPL_SEXO,
                EPL_EMAIL,
                EPL_FECRECEP,
                DCM_RADICACION,
                PAI_NOMBRE_CED,
                DPT_NOMBRE_CED,
                CIU_NOMBRE_CED,
                ZONA_LMILITAR,
                FEC_EXP_LMILITAR,
                FEC_EXP_CEDULA,
                GRUPO_SANGUINEO,
                FACTOR_RH
          NOWAIT;
      END LOOP;
    END;

END QB_GEST_EMPLEADO;