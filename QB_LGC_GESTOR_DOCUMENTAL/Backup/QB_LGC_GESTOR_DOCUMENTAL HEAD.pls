create or replace PACKAGE BODY                         QB_LGC_GESTOR_DOCUMENTAL AS
--**********************************************************************************************************
--** NOMBRE SCRIPT        : QADM0170.sql
--** OBJETIVO             : logica del proceso de cargue del gestor documental
--** ESQUEMA              : ADM
--** NOMBRE               : adm.QB_LGC_GESTOR_DOCUMENTAL
--** AUTOR                : KEVRODRIGUEZ
--** FECHA CREACION       : 07/10/2020
--**********************************************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : DESIERRA 10/03/2022
--** DESCRIPCION          : Se modifica procedimiento PL_OBTENER_TIPO  Y PL_DOCUMENTOS_BASICOS modificacion de parametros y forma de ejecucion.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : DESIERRA 25/08/2022
--** DESCRIPCION          : Se modifica procedimiento pl_cslt_BancoHV  debido a que la consulta que se estaba realizando estaba trayendo mas de un registro y
--** ocacionando error en el bmx.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : DESIERRA 25/08/2022
--** DESCRIPCION          : Se modifica procedimiento pl_ins_respuesta_ws  debido a que la respuesta que genera el servicio es distinta a la que anteriormente funcionaba
--** ya que para validad si el servicio responde con un 500 se tuvo que ajustar el proceso para sacar los parametros que llegan en la peticion.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : JUPATARROYO 15/11/2022
--** DESCRIPCION          : Se modifica procedimiento PL_OBTENER_TIPODOC, para quitar el cÃ³digo quemado, se hace uso de alias.
--******************************************************************************
--** ACTUALIZACION		  : MMENDIGANO 12/09/2023
--** DESCRIPCION          : Se modifica procedimiento PL_OBTENER_TIPODOC  para incluir el CERTIFICADO DE MEDIDAS CORRECTIVAS
--** y el CERTIFICADO DE DELITOS SEXUALES CONTRA MENORES DE EDAD al listado de documentos validos.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : MMENDIGANO 12/09/2023
--** DESCRIPCION          : Se modifica procedimiento PL_DOCUMENTOS_BASICOS para incluir el CERTIFICADO DE MEDIDAS CORRECTIVAS
--** y el CERTIFICADO DE DELITOS SEXUALES CONTRA MENORES DE EDAD a los documentos cargados.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : MMENDIGANO 12/09/2023
--** DESCRIPCION          : Se crea el procedimiento PL_DOCUMENTOS_ACUERDO encargado de generar
--** la lista de documentos obligatorios en el acuerdo.
--******************************************************************************
--******************************************************************************
--** ACTUALIZACION		  : DESIERRA 2023/12/07
--** DESCRIPCION          : Se modifica pl_ins_gestor y se adiciona el documento numero 105 Certificado De Custodia O Registro Civil
--******************************************************************************
/*<Crear procedimiento que realize la busqueda del ultimo id de la estructura de carpetas,
 segun la estructura padre que recibe; la cual seria la empresa principal y usuaria
 (taxionomia de seleccion y taxionomia de contratos)>
*/
     listaMap       LISTAHASHMAP;
--{pl_listaMap_add
PROCEDURE pl_listaMap_add(vcllave  IN VARCHAR2
                         ,clvalor  IN CLOB)
IS
     n_count NUMBER  :=0;
BEGIN
     n_count := listaMap.count()+1;
     listaMap(n_count).llave    := vcllave;
     listaMap(n_count).valor    := clvalor;
END;
--}pl_listaMap_add

/*<
     Pl encargado de leer de un objeto temporal cargado por la configuracion de la session que llama el procedimiento
     el cual adiciona cada atributo mediante el metodo pl_listaMap_add
>*/

--{pl_rtn_ID_cli_nos
PROCEDURE pl_rtn_ID_cli_nos(NMDEA_CODIGO_RTN       OUT NUMBER      --ID TABLA AZDIGITAL
                           ,NMAZ_CODIGO_CLI_RTN    OUT VARCHAR2    --ID PROVEEDOR
                           ,vcmensajeproceso       OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                           ,vcestadoproceso        OUT VARCHAR2    --ESTADO S/N
                           ,nmprd_codigo           IN NUMBER   DEFAULT NULL   --Valida si se busca un documento o una carpeta
                           )

IS
     nmtxp_codigo   NUMBER;
     nmdea_codigo   NUMBER;
     nmazd_codigo   NUMBER;
     nmvalida       NUMBER;
     n_count        NUMBER:=1;
     vcquery        VARCHAR2(4000);
     VCERROR        VARCHAR2(4000);
     vcinst         VARCHAR2(4000);
     exSalir	     EXCEPTION;
BEGIN
          --
     vcinst:='Crea query dinamico con una relacion de '||listaMap.count()||' Tablas';
     --
     PL_RTN_QUERY_NIVEL(listaMap.count()
                       ,VCQUERY
                       ,VCERROR);

     IF vcerror IS NOT NULL THEN

          vcinst := 'Fallo la creacion del vcquery';
          vcmensajeproceso := 'vcerror: '||vcerror;

          RAISE exSalir;
     END IF;
     --
     vcinst:='Reemplaza los valores encontrados en el hashmap';
     --
     FOR j IN 1..listaMap.count()
     LOOP
          --DBMS_OUTPUT.PUT_LINE('$'||listaMap(j).llave||'${'||listaMap(j).valor||'}');
           VCQUERY:=replace(VCQUERY,'$'||listaMap(j).llave||'$', listaMap(j).valor);
     END LOOP;
          --DBMS_OUTPUT.PUT_LINE(vcinst);
     BEGIN
          vcinst:='Extrae el valor TXP_CODIGO del vcquery';
          --pb_seguimiento2('lentitud_sel',VCQUERY);
          --pb_seguimiento_long('lentitud_sel',VCQUERY);
          EXECUTE IMMEDIATE VCQUERY INTO NMTXP_CODIGO;

     EXCEPTION
     WHEN OTHERS THEN
          vcmensajeproceso := 'la consulta realizada no contiene datos o retorna mas de una fila {'||vcquery||'}'||sqlerrm;
          RAISE exSalir;
     END;

     BEGIN
        --

        --
        IF nmtxp_codigo IS  NULL THEN
          vcmensajeproceso:='nmtxp_codigo nulo';
          RAISE exSalir;
        END IF;
        --
        vcinst:='consulta los idcliente y id_nosotros';
        --

          SELECT dea_codigo,azd_codigo
          INTO nmdea_codigo,nmazd_codigo
          FROM ADM.data_erp_az
         WHERE txp_codigo = nmtxp_codigo
           AND prd_codigo IS NULL;--Cuando es nulo es por que es una carpeta y no un documento

        NMDEA_CODIGO_RTN := nmdea_codigo;
        NMAZ_CODIGO_CLI_RTN   := fl_rtn_az_digital(nmazd_codigo,'AZD_CODIGO_CLI');
     EXCEPTION
     WHEN OTHERS THEN
          vcinst:='Error consultando ID no se encontro asociacion nmtxp_codigo '||nmtxp_codigo||'en la tabla ADM.data_erp_az. Error generico oracle:'||sqlerrm;
          vcmensajeproceso := vcinst;
          RAISE exSalir;
     END;

     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';

EXCEPTION
WHEN exSalir THEN
     vcestadoproceso  := 'N';
WHEN OTHERS THEN
     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_rtn_ID_cli_nos causado por:'||sqlerrm||'Ultima instruccion almacenada'||vcinst;
END pl_rtn_ID_cli_nos;
--}pl_rtn_ID_cli_nos

--{pl_cslt_ContratacionOC
PROCEDURE pl_cslt_ContratacionOC(VCtdc_td_ppal          IN VARCHAR2    --PRINCIPAL
                                ,NMemp_nd               IN NUMBER      --PRINCIPAL
                                ,VCtdc_td_fil           IN VARCHAR2    --FILIAL
                                ,NMemp_nd_fil           IN NUMBER      --FIALIAL
                                ,vcCarpetagen           IN VARCHAR2--oRDENES cONTRATACIoN (OC)
                                ,dtfecha                IN DATE
                                ,vcSede		           IN VARCHAR2
                                ,vcEstado	           IN VARCHAR2
                                ,vcFechaOC	           IN VARCHAR2
                                ,NMDEA_CODIGO_RTN      OUT NUMBER      --ID TABLA AZDIGITAL
                                ,NMAZ_CODIGO_CLI_RTN   OUT VARCHAR2    --ID PROVEEDOR
                                ,vcmensajeproceso      OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                                ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N

                                )
IS
    --
     nmtxp_codigo   NUMBER;
     nmdea_codigo   NUMBER;
     nmazd_codigo   NUMBER;
     nmanio         NUMBER;
     n_count        NUMBER:=1;
     vcinst         VARCHAR2(4000);
     exSalir	     EXCEPTION;

	CURSOR CU_TXP_CODIGO IS
		SELECT txp_codigo
            FROM adm.taxonomia_param
           WHERE txp_descripcion =vcFechaOC
		   ORDER BY AUD_FECHA DESC FETCH FIRST ROW ONLY;

	CURSOR CU_DATA_ERP (nmtxp_codigo NUMBER) IS
		SELECT dea_codigo,azd_codigo
             FROM ADM.data_erp_az
            WHERE txp_codigo = nmtxp_codigo
			ORDER BY AUD_FECHA DESC FETCH FIRST ROW ONLY;
BEGIN
     listaMap.delete();
     IF VCtdc_td_ppal IS NULL AND NMemp_nd IS NULL AND vcFechaOC IS NULL THEN
          vcmensajeproceso :='No se ingreso una principal para realizar el proceso.';
          RAISE exSalir	 ;
     END IF;

     vcinst:='Valida requerimiento.';
     IF vcFechaOC IS NOT NULL  THEN
          --
			OPEN CU_TXP_CODIGO;
			FETCH CU_TXP_CODIGO INTO nmtxp_codigo;
			CLOSE CU_TXP_CODIGO;

			OPEN CU_DATA_ERP (nmtxp_codigo);
			FETCH CU_DATA_ERP INTO nmdea_codigo,nmazd_codigo;
			CLOSE CU_DATA_ERP;

			NMDEA_CODIGO_RTN := nmdea_codigo;
			NMAZ_CODIGO_CLI_RTN     :=fl_rtn_az_digital(nmazd_codigo,'AZD_CODIGO_CLI');

			vcestadoproceso   := 'S';
			vcmensajeproceso  :='Procedimiento ejecutado con exito.';
			RETURN;
			--
     END IF;

     vcinst:='Adicion de valores al hashmap';


     IF vcestado IS NOT NULL  THEN
          --
            vcinst:='Agrega vcestado al mapa'||vcestado;

          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,vcestado);
          --
     END IF;

     IF vcsede IS NOT NULL  THEN
          --
          vcinst:='Agrega vcsede al mapa'||vcsede;

          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,vcsede);
          --
     END IF;

     IF dtfecha IS NOT NULL  THEN
          --
          SELECT to_char(dtfecha,'YYYY')
            INTO   nmanio
            FROM dual;

          vcinst:='Agrega nmanio al mapa'||nmanio;

          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,to_char(nmanio));
     END IF;

    IF vccarpetagen IS NOT NULL  THEN
          --
          vcinst:='Agrega vccarpetagen al mapa'||vccarpetagen;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,to_char(vccarpetagen));
          --
     END IF;


     IF VCtdc_td_fil IS NOT NULL AND NMemp_nd_fil IS NOT NULL  THEN
          --

          vcinst:='Agrega la filial al mapa'||VCtdc_td_fil||' '||NMemp_nd_fil;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,VCtdc_td_fil||' '||NMemp_nd_fil);
          --
     END IF;

     IF VCtdc_td_ppal IS NOT NULL AND NMemp_nd IS NOT NULL  THEN
          --
          vcinst:='Agrega la Principal al mapa'||VCtdc_td_ppal||' '||NMemp_nd;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,VCtdc_td_ppal||' '||NMemp_nd);

          --
     END IF;

     pl_rtn_ID_cli_nos(NMDEA_CODIGO_RTN
                      ,NMAZ_CODIGO_CLI_RTN
                      ,vcmensajeproceso
                      ,vcestadoproceso);

     listaMap.delete();
EXCEPTION
WHEN exSalir THEN
     vcestadoproceso  := 'N';
     --DBMS_OUTPUT.PUT_LINE(vcinst);
WHEN OTHERS THEN
     --DBMS_OUTPUT.PUT_LINE(vcinst);
     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_cslt_ContratacionOC causado por:'||sqlerrm||'Ultima instruccion almacenada'||vcinst;

END pl_cslt_ContratacionOC;
--}pl_cslt_ContratacionOC

--{pl_cslt_SEL_PC
PROCEDURE pl_cslt_SEL_PC(VCtdc_td_ppal         IN VARCHAR2    --PRINCIPAL
                        ,NMemp_nd              IN NUMBER      --PRINCIPAL
                        ,VCtdc_td_fil          IN VARCHAR2    --FILIAL
                        ,NMemp_nd_fil          IN NUMBER      --FIALIAL
                        ,vccarpetagen          IN VARCHAR2    --Carpeta generica (Requisiciones cliente (RC))
                        ,vcCarpetaCandito      IN VARCHAR2    --CArpeta candidato
                        ,vcproceso             IN VARCHAR2    --NOMBRE PROCESO
                        ,NMDEA_CODIGO_RTN     OUT NUMBER      --ID TABLA AZDIGITAL
                        ,NMAZ_CODIGO_CLI_RTN  OUT VARCHAR2    --ID PROVEEDOR
                        ,vcmensajeproceso     OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                        ,vcestadoproceso      OUT VARCHAR2)   --ESTADO S/N
IS
    --
     nmtxp_codigo   NUMBER;
     nmdea_codigo   NUMBER;
     nmazd_codigo   NUMBER;
     n_count        NUMBER:=1;
     vcinst         VARCHAR2(4000);
     exSalir	     EXCEPTION;

	CURSOR CU_TAXONOMIA_PARAM IS
		SELECT txp_codigo
             FROM adm.taxonomia_param
             WHERE txp_codigo_REF  IN (SELECT txp_codigo
                                    FROM adm.taxonomia_param
                                   WHERE txp_descripcion = vcCarpetaCandito)
              AND  txp_descripcion  = vcproceso
			  ORDER BY AUD_FECHA DESC FETCH FIRST ROW ONLY;

	CURSOR CU_DATA_ERP (nmtxp_codigo NUMBER) IS
		SELECT dea_codigo,azd_codigo
             FROM ADM.data_erp_az
            WHERE txp_codigo = nmtxp_codigo
              AND prd_codigo IS NULL;
BEGIN
     listaMap.delete();

     IF VCtdc_td_ppal IS NULL AND NMemp_nd IS NULL AND vcproceso IS NULL THEN
          vcmensajeproceso :='No se ingreso una principal para realizar el proceso.';
          RAISE exSalir	 ;
     END IF;

	 vcinst:='Valida requerimiento.';
     IF vcproceso IS NOT NULL  AND vcCarpetaCandito IS NOT NULL THEN
			--
			vcinst:='Calcula nmtxp_codigo con vcproceso:'||vcproceso||'- carpeta_Candidato: '||vcCarpetaCandito;
			OPEN CU_TAXONOMIA_PARAM;
			FETCH CU_TAXONOMIA_PARAM INTO nmtxp_codigo;
			CLOSE CU_TAXONOMIA_PARAM;

			vcinst:='Calcula ea_codigo,azd_codigo  con vcproceso:'||nmtxp_codigo;

			OPEN CU_DATA_ERP (nmtxp_codigo);
			FETCH CU_DATA_ERP INTO nmdea_codigo,nmazd_codigo;
			CLOSE CU_DATA_ERP;

			NMDEA_CODIGO_RTN := nmdea_codigo;
			NMAZ_CODIGO_CLI_RTN     :=fl_rtn_az_digital(nmazd_codigo,'AZD_CODIGO_CLI');

			IF NMAZ_CODIGO_CLI_RTN=0 THEN
				vcmensajeproceso :='No se pudo relacionar el identificador del cliente para la carpeta candidato '||vcCarpetaCandito|| 'Proceso '||vcproceso||' posible error en la creacion Dea_codigo'||NMDEA_CODIGO_RTN;
				RAISE exSalir	 ;
			END IF;

			vcestadoproceso   := 'S';
			vcmensajeproceso  := 'procedimiento ejecutado con exito.';

			RETURN;
          --
     END IF;

     vcinst:='Adicion de valores al hashmap';

     IF vcCarpetaCandito IS NOT NULL  THEN
          --
          vcinst:='Agrega vcCarpetaCandito al mapa'||vcCarpetaCandito;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,to_char(vcCarpetaCandito));
          --
     END IF;

    IF vccarpetagen IS NOT NULL  THEN
          --
          vcinst:='Agrega vccarpetagen al mapa'||vccarpetagen;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,to_char(vccarpetagen));
          --
     END IF;


     IF VCtdc_td_fil IS NOT NULL AND NMemp_nd_fil IS NOT NULL  THEN
          --

          vcinst:='Agrega la filial al mapa'||VCtdc_td_fil||' '||NMemp_nd_fil;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,VCtdc_td_fil||' '||NMemp_nd_fil);
          --
     END IF;

     IF VCtdc_td_ppal IS NOT NULL AND NMemp_nd IS NOT NULL  THEN
          --
          vcinst:='Agrega la Principal al mapa'||VCtdc_td_ppal||' '||NMemp_nd;
          n_count:=listaMap.count()+1;
          pl_listaMap_add('x'||n_count,VCtdc_td_ppal||' '||NMemp_nd);

          --
     END IF;

     pl_rtn_ID_cli_nos(NMDEA_CODIGO_RTN
                      ,NMAZ_CODIGO_CLI_RTN
                      ,vcmensajeproceso
                      ,vcestadoproceso);

     listaMap.delete();



EXCEPTION
WHEN exSalir THEN
     vcestadoproceso  := 'N';
WHEN OTHERS THEN

     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_cslt_SEL_PC causado por:'||sqlerrm||'Ultima instruccion almacenada'||vcinst;

END pl_cslt_SEL_PC;
--}pl_cslt_SEL_PC

--{pl_cslt_SeleccionRC
PROCEDURE pl_cslt_SeleccionRC(VCtdc_td_ppal          IN  VARCHAR2    --PRINCIPAL
                             ,NMemp_nd               IN  NUMBER      --PRINCIPAL
                             ,VCtdc_td_fil           IN  VARCHAR2    --FILIAL
                             ,NMemp_nd_fil           IN  NUMBER      --FIALIAL
                             ,vccarpetagen           IN  VARCHAR2    --Carpeta generica (Requisiciones cliente (RC))
                             ,dtfecha                IN  DATE        --AÃ`O ACTUAL
                             ,vcsede                 IN  VARCHAR2    --SEDE
                             ,vcestado               IN  VARCHAR2    --ESTADO
                             ,nmrequisicion          IN  NUMBER      --NUMERO REQUISICION
                             ,NMDEA_CODIGO_RTN      OUT NUMBER      --ID TABLA AZDIGITAL
                             ,NMAZ_CODIGO_CLI_RTN   OUT VARCHAR2    --ID PROVEEDOR
                             ,vcmensajeproceso      OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                             ,vcestadoproceso       OUT VARCHAR2)   --ESTADO S/N
IS
     --
     nmtxp_codigo   NUMBER;
     nmdea_codigo   NUMBER;
     nmazd_codigo   NUMBER;
     nmvalida       NUMBER;
     nmanio         NUMBER;
     n_count        NUMBER:=1;
     vcquery        clob;--VARCHAR2(4000);
     VCERROR        VARCHAR2(4000);
     vcinst         VARCHAR2(4000);
     exSalir	     EXCEPTION;
     listaMap       LISTAHASHMAP;

	CURSOR CU_TAXONOMIA_PARAM IS
		SELECT txp_codigo
            FROM adm.taxonomia_param
           WHERE txp_descripcion =TO_CHAR(nmrequisicion)
			  ORDER BY AUD_FECHA DESC FETCH FIRST ROW ONLY;

	CURSOR CU_DATA_ERP (nmtxp_codigo NUMBER) IS
		SELECT dea_codigo,azd_codigo
             FROM ADM.data_erp_az
            WHERE txp_codigo = nmtxp_codigo
              AND prd_codigo IS NULL;
BEGIN
	 vcinst:='Valida requerimiento.';
     IF nmrequisicion IS NOT NULL  THEN
		--
		OPEN CU_TAXONOMIA_PARAM;
		FETCH CU_TAXONOMIA_PARAM INTO nmtxp_codigo;
		CLOSE CU_TAXONOMIA_PARAM;

		OPEN CU_DATA_ERP (nmtxp_codigo);
		FETCH CU_DATA_ERP INTO nmdea_codigo,nmazd_codigo;
		CLOSE CU_DATA_ERP;

		NMDEA_CODIGO_RTN := nmdea_codigo;
		NMAZ_CODIGO_CLI_RTN     :=fl_rtn_az_digital(nmazd_codigo,'AZD_CODIGO_CLI');


           vcestadoproceso   := 'S';
           vcmensajeproceso  :='Procedimiento ejecutado con exito.';
		RETURN;
		--
     END IF;

     IF VCtdc_td_ppal IS NULL AND NMemp_nd IS NULL AND nmrequisicion IS NULL THEN
          vcmensajeproceso :='No se ingreso una principal para realizar el proceso.';
          RAISE exSalir	 ;
     END IF;

     vcinst:='Adicion de valores al hashmap';

     IF vcestado IS NOT NULL  THEN
          --
            vcinst:='Agrega vcestado al mapa'||vcestado;
            listaMap(n_count).llave    := 'x'||n_count;
            listaMap(n_count).valor    := vcestado;
            n_count:=n_count+1;
          --
     END IF;

     IF vcsede IS NOT NULL  THEN
          --
          vcinst:='Agrega vcsede al mapa'||vcsede;

          listaMap(n_count).llave    := 'x'||n_count;
          listaMap(n_count).valor    := vcsede;
          n_count:=n_count+1;
          --
     END IF;

     IF dtfecha IS NOT NULL  THEN
          --
          SELECT to_char(dtfecha,'YYYY')
            INTO nmanio
            FROM dual;

          vcinst:='Agrega nmanio al mapa'||nmanio;

          listaMap(n_count).llave    := 'x'||n_count;
          listaMap(n_count).valor    := to_char(nmanio);
          n_count:=n_count+1;
          --
     END IF;

    IF vccarpetagen IS NOT NULL  THEN
          --
          vcinst:='Agrega vccarpetagen al mapa'||vccarpetagen;

          listaMap(n_count).llave    := 'x'||n_count;
          listaMap(n_count).valor    := vccarpetagen;
          n_count:=n_count+1;
          --
     END IF;


     IF VCtdc_td_fil IS NOT NULL AND NMemp_nd_fil IS NOT NULL  THEN
          --

          vcinst:='Agrega la filial al mapa'||VCtdc_td_fil||' '||NMemp_nd_fil;
          listaMap(n_count).llave    := 'x'||n_count;
          listaMap(n_count).valor    := VCtdc_td_fil||' '||NMemp_nd_fil;
          n_count:=n_count+1;
          --
     END IF;

     IF VCtdc_td_ppal IS NOT NULL AND NMemp_nd IS NOT NULL  THEN
          --
           vcinst:='Agrega la Principal al mapa'||VCtdc_td_ppal||' '||NMemp_nd;

          listaMap(n_count).llave    := 'x'||n_count;
          listaMap(n_count).valor    := VCtdc_td_ppal||' '||NMemp_nd;
          n_count:=n_count+1;
          --
     END IF;

     n_count:=n_count-1;

     --
     vcinst:='Crea query dinamico con una relacion de '||n_count||' Tablas';
     PL_RTN_QUERY_NIVEL(n_count
                       ,VCQUERY
                       ,VCERROR);

     IF vcerror IS NOT NULL THEN

          vcinst:='Fallo la creacion del vcquery';
          vcmensajeproceso:= 'vcerror: '||vcerror;
          RAISE exSalir;

     END IF;
     --
     vcinst:='Reemplaza los valores encontrados en el hashmap';
     --
     FOR j IN 1..listaMap.count()
     LOOP
          --DBMS_OUTPUT.PUT_LINE('$'||listaMap(j).llave||'${'||listaMap(j).valor||'}');
           VCQUERY:=replace(VCQUERY,'$'||listaMap(j).llave||'$', listaMap(j).valor);

     END LOOP;
          --DBMS_OUTPUT.PUT_LINE(vcinst);
     BEGIN
          vcinst:='Extrae el valor TXP_CODIGO del vcquery';
          EXECUTE IMMEDIATE VCQUERY INTO NMTXP_CODIGO;
         /*
          OPEN c_datos_query FOR VCQUERY;
           FETCH c_datos_query
            INTO NMTXP_CODIGO;
            IF c_datos_query%FOUND THEN
               CLOSE c_datos_query;
            END IF;
          */

     EXCEPTION
     WHEN OTHERS THEN
 --pb_seguimiento_long('CONSUMORC',
          vcinst:='Error en execute immediate'||vcquery;
          --vcmensajeproceso := 'la consulta realizada no contiene datos o retorna mas de una fila { '||vcquery||' }'||sqlerrm;
          RAISE exSalir;
     END;

     BEGIN
        --
        vcinst:='consulta los idcliente y id_nosotros';
        --
        IF nmtxp_codigo IS  NULL THEN

          vcinst:='nmtxp_codigo nulo';
          RAISE exSalir;

        END IF;
        --
       -- DBMS_OUTPUT.PUT_LINE('***********'||nmtxp_codigo);
		OPEN CU_DATA_ERP (nmtxp_codigo);
		FETCH CU_DATA_ERP INTO nmdea_codigo,nmazd_codigo;
		CLOSE CU_DATA_ERP;

        NMDEA_CODIGO_RTN := nmdea_codigo;
        NMAZ_CODIGO_CLI_RTN   := fl_rtn_az_digital(nmazd_codigo,'AZD_CODIGO_CLI');


     EXCEPTION
     WHEN OTHERS THEN
          vcinst:='Error consultando ID no se encontro asociacion nmtxp_codigo '||nmtxp_codigo||'en la tabla ADM.data_erp_az. Error generico oracle:'||sqlerrm;
          vcmensajeproceso := vcinst;
          RAISE exSalir;
     END;

     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';
    -- pb_seguimiento_long('CONSUMORC',vcmensajeproceso);
EXCEPTION
WHEN exSalir THEN

    -- pb_seguimiento_long('CONSUMORC',vcmensajeproceso||vcinst);
     vcestadoproceso  := 'N';
WHEN OTHERS THEN
  --   pb_seguimiento_long('CONSUMORC',vcmensajeproceso);
     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_cslt_SeleccionRC causado por:'||sqlerrm||' Ultima instruccion almacenada'||vcinst;

END pl_cslt_SeleccionRC;
--}pl_cslt_SeleccionRC

--{pl_cslt_BancoHV
PROCEDURE pl_cslt_BancoHV(vctdc_td_epl        IN VARCHAR2
                         ,nmepl_nd            IN NUMBER
                         ,vcestado            IN VARCHAR2
                         ,nmprd_codigo        IN NUMBER
                         ,NMDEA_CODIGO_RTN      OUT NUMBER
                         ,NMAZ_CODIGO_CLI_RTN   OUT VARCHAR2
                         ,vcmensajeproceso      OUT VARCHAR2
                         ,vcestadoproceso       OUT VARCHAR2)
IS

     vcinst             VARCHAR2(4000);
     NMVALTXP_CODIGO    NUMBER:=0;
     vcquery            VARCHAR2(4000);
     vcquery2           VARCHAR2(4000);
     vcjoin             VARCHAR2(4000):=' ';
     vcjoin2            VARCHAR2(4000):=' ';
     exSalir            EXCEPTION;
     vcselect           VARCHAR2(4000):=' ';
BEGIN


     IF vcselect IS NOT NULL THEN
          vcselect:= 'NVL(tp.TXP_CODIGO,0)';
     ELSE
          vcselect:= 'NVL(tp.TXP_CODIGO_REF,0)';
     END IF;
--SELECT NVL(tp.TXP_CODIGO_REF,0)
     vcquery :='SELECT NVL(tp.TXP_CODIGO,0)
                  FROM ADM.taxonomia_param TP
                 WHERE TIP_FLUJO = 1
                   ';

     vcinst :='Validacion cedula numero '||nmepl_nd;

     IF vctdc_td_epl IS NOT NULL AND nmepl_nd IS NOT NULL THEN
          --
          vcjoin:= vcjoin||'AND nomtabla = ''EMPLEADO'' AND txp_descripcion LIKE ''%'||vctdc_td_epl||' '||nmepl_nd||chr(39);
          --
     END IF;

     vcinst:='validacion estado ='||vcestado;

     IF vcestado IS NOT NULL THEN
          --
          vcjoin:= vcjoin||' AND txp_descripcion  =  UPPER('''||vcestado||''')';
          --vcjoin:= vcjoin||' AND UPPER(fl_rtn_taxonomia_param(tp.TXP_CODIGO_REF,''TXP_DESCRIPCION'')) = UPPER('||vcestado||')';
          --
     END IF;
     --
     vcquery:=vcquery||vcjoin;
     vcinst:='execute imediate query:='||vcquery;

     BEGIN
          EXECUTE IMMEDIATE vcquery INTO nmvaltxp_codigo;
     EXCEPTION WHEN NO_DATA_FOUND THEN
          NMVALTXP_CODIGO:=0;
     END;

     IF NMVALTXP_CODIGO = 0 THEN
          vcinst :='Error txp no encontrado';
          vcmensajeproceso  := 'No se encontro la carpeta asociada con la identificacion:'||vctdc_td_epl||' '||nmepl_nd||' o estado'||vcestado;
          RAISE exSalir;
     END IF;

     vcinst :='segundo vcquery con txp:codigo '||NMVALTXP_CODIGO;
     vcquery2 := 'SELECT DEA.DEA_CODIGO
                       , adm.QB_LGC_GESTOR_DOCUMENTAL.fl_rtn_az_digital(DEA.azd_codigo,''azd_codigo_cli'')
                   FROM adm.data_erp_az DEA
                   WHERE dea.txp_codigo ='||NMVALTXP_CODIGO;


     IF nmprd_CODIGO IS NOT NULL  THEN
          --
          vcjoin2:=' AND dea.prd_codigo ='||nmprd_codigo;
          --
     ELSE
          --
          vcjoin2:=' AND dea.prd_codigo IS NULL';
          --
     END IF;

     vcquery2:=vcquery2||vcjoin2;

     vcinst :='Segunda ejecucion executeimmediate '||vcquery2;

     EXECUTE IMMEDIATE vcquery2 INTO NMDEA_CODIGO_RTN , NMAZ_CODIGO_CLI_RTN;



    If NMAZ_CODIGO_CLI_RTN=0 Then
          vcmensajeproceso  := 'Ocurrio un error inesperado';
          RAISE exSalir;
    End If;

     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';
EXCEPTION
WHEN exSalir THEN
     vcestadoproceso  := 'N';

WHEN OTHERS THEN

     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_cslt_BancoHV causado por:'||sqlerrm||'Ultima instruccion almacenada'||vcinst;

END pl_cslt_BancoHV;
--}pl_cslt_BancoHV

--{fl_rtn_taxonomia_param
FUNCTION fl_rtn_taxonomia_param(nmtxp_codigo NUMBER
                          ,vccolumna    VARCHAR2
                          ) RETURN VARCHAR2
IS
     vcquery        VARCHAR2(4000);
     VCvalor        VARCHAR2(4000);
BEGIN

  IF nmtxp_codigo IS NULL  THEN
          RETURN NULL;
     END IF;

vcquery:='
      SELECT '||vccolumna||'
        FROM ADM.taxonomia_param
       WHERE txp_codigo = '||nmtxp_codigo;

     EXECUTE IMMEDIATE vcquery INTO  VCvalor;

      RETURN VCvalor;
EXCEPTION
WHEN OTHERS THEN
     RETURN SQLERRM;
END fl_rtn_taxonomia_param;
--}QB_LGC_GESTOR_DOCUMENTAL.fl_rtn_taxonomia_param

--{fl_rtn_data_erp_az
FUNCTION fl_rtn_data_erp_az(nmdea_codigo NUMBER
                          ,vccolumna    VARCHAR2
                          ) RETURN VARCHAR2
IS
     vcquery        VARCHAR2(4000);
     VCvalor        VARCHAR2(4000);
BEGIN

     IF nmdea_codigo IS NULL  THEN
          RETURN NULL;
     END IF;

vcquery:='
      SELECT '||vccolumna||'
        FROM ADM.data_erp_az
       WHERE dea_codigo = '||nmdea_codigo;

     EXECUTE IMMEDIATE vcquery INTO  VCvalor;

      RETURN VCvalor;
EXCEPTION
WHEN OTHERS THEN
     RETURN SQLERRM;
END fl_rtn_data_erp_az;
--}fl_rtn_data_erp_az

--{fl_rtn_az_digital
FUNCTION fl_rtn_az_digital(nmaz_codigo NUMBER
                          ,vccolumna    VARCHAR2
                          ) RETURN VARCHAR2
IS
     vcquery        VARCHAR2(4000);
     VCvalor        VARCHAR2(4000);
BEGIN

     IF nmaz_codigo IS NULL  THEN
          RETURN NULL;
     END IF;

     vcquery:='
      SELECT '||vccolumna||'
        FROM ADM.az_digital
       WHERE azd_codigo = '||nmaz_codigo;

     EXECUTE IMMEDIATE vcquery INTO  VCvalor;

      RETURN nvl(VCvalor,'0');
EXCEPTION
WHEN OTHERS THEN
     RETURN SQLERRM;
END fl_rtn_az_digital;
--}fl_rtn_az_digital

--{PL_RTN_QUERY_NIVEL
PROCEDURE PL_RTN_QUERY_NIVEL(n_count     IN NUMBER
                            ,VCQUERY    OUT VARCHAR2
                            ,VCERROR    OUT VARCHAR2
                            ) is
     vcselect       VARCHAR2(4000);
     vcfrom         VARCHAR2(4000);
     vcjoin         VARCHAR2(4000);
     vcvarant       VARCHAR2(4000);
     vcvarsig       VARCHAR2(4000);
     vcvalorfind    VARCHAR2(4000);
     n_temp         NUMBER:=0;

BEGIN

     FOR i IN 1..n_count LOOP
          n_temp:=i+1;
          vcvarant:= 'x'||i;
          vcvalorfind:= '$x'||i||'$';

          vcselect := vcselect||vcvarant||'.txp_descripcion, ';
          vcfrom   := vcfrom||' ADM.taxonomia_param '||vcvarant||', ';
          vcjoin   := vcjoin||' AND '||vcvarant||'.txp_descripcion LIKE ''%'||vcvalorfind||''''||chr(13);

          IF  i < n_count THEN
            --
              vcvarsig := 'x'||n_temp;
              vcjoin   := vcjoin||'AND '||vcvarant||'.txp_codigo_ref = '||vcvarsig||'.txp_codigo'||chr(13);
            --
          END IF;

     END LOOP;
     /*
     Campos para validar la ruta generada solo en seguimiento
     --, '||SUBSTR(vcselect, 1, Length(vcselect) - 2 )||chr(13)||
     */

     vcquery := 'SELECT  /*+ PARALLEL(0) */ x1.txp_codigo'||
                '  FROM '||SUBSTR(vcfrom, 1, length(vcfrom) - 2 )  ||chr(13)||
                ' WHERE 1=1 '||chr(13)||vcjoin;
     --

EXCEPTION
WHEN OTHERS THEN
     vcquery :='---';
     vcerror:='error causado por:'||sqlerrm;
END PL_RTN_QUERY_NIVEL;
--}PL_RTN_QUERY_NIVEL

--{pl_rtn_documentos
PROCEDURE pl_rtn_documentos(NMDEA_CODIGO_RTN      IN NUMBER
                           ,CSCONSULTA            OUT csCursor
                           ,vcmensajeproceso      OUT VARCHAR2  --DETALLE ESTADO DEL PROCESO
                           ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N
)IS
     vcquery varchar2(4000);
     vcerror  varchar2(4000);
BEGIN

     OPEN CSCONSULTA FOR
   SELECT dea2.dea_codigo
         ,ad.AZD_NOMBRE_RUTA
         ,td.tpd_descripcion
         ,ad.azd_codigo_cli
         ,dea2.dea_estado
         ,dea2.aud_usuario
         ,dea2.aud_fecha
         ,dea2.DEA_PERITAJE
         ,pd.*
     FROM adm.data_erp_az dea1
         ,ADM.az_digital ad
         ,adm.data_erp_az dea2
         ,ADM.propiedades_documento pd
         ,adm.tipo_documento td
    WHERE dea1.dea_codigo = NMDEA_CODIGO_RTN   --ID unico que hace referencia a la carpeta
      AND ad.azd_codigo = dea2.azd_codigo
      AND dea2.txp_codigo = dea1.txp_codigo
      AND dea2.prd_codigo = pd.prd_codigo
      AND pd.tpd_codigo   = td.tpd_codigo
      AND DEA2.dea_estado <> 2
      AND ad.azd_codigo_cli IS NOT NULL
    UNION
   SELECT d1.dea_codigo
          ,az.azd_nombre_ruta
          ,td.tpd_descripcion
          ,az.azd_codigo_cli
          ,d1.dea_estado
          ,d1.aud_usuario
          ,d1.aud_fecha
          ,d1.dea_peritaje
          ,pd.*
   FROM adm.data_erp_az d1
      ,adm.az_digital az
      ,adm.propiedades_documento pd
      ,adm.tipo_documento td
   WHERE d1.azd_codigo = az.azd_codigo
     AND d1.prd_codigo = pd.prd_codigo
     AND pd.tpd_codigo = td.tpd_codigo
     AND d1.dea_codigo IN (SELECT d2.dea_codigo
                           FROM adm.taxonomia_param tax
                                    INNER JOIN adm.data_erp_az d2 ON tax.txp_codigo = d2.txp_codigo
                           WHERE tax.txp_codigo_ref = (SELECT d3.txp_codigo
                                                       FROM adm.data_erp_az d3
                                                       WHERE d3.dea_codigo = NMDEA_CODIGO_RTN))
     AND d1.dea_estado <> 2
     AND az.azd_codigo_cli IS NOT NULL
   ORDER BY 1 DESC;

EXCEPTION
WHEN OTHERS THEN
 OPEN CSCONSULTA FOR SELECT NULL FROM DUAL WHERE 1=0;
     vcquery :='---';
     vcerror:='error causado por:'||sqlerrm;

END pl_rtn_documentos;
--}pl_rtn_documentos

--{pl_rtrn_lista_acuerdo Procedimiento que devuelve la lista de datos configurados en una agrupacion de acuerdos
PROCEDURE pl_rtrn_lista_acuerdo(nmagu_codigo           IN NUMBER
                               ,vctdc_td_fil           IN VARCHAR2
                               ,nmemp_nd_fil           IN NUMBER
                               ,CSCONSULTA            OUT csCursor
                               ,vcmensajeproceso      OUT VARCHAR2  --DETALLE ESTADO DEL PROCESO
                               ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N
                               )
IS
     nmemp_acu_codigo   NUMBER;
BEGIN

     SELECT c.emp_acu_codigo
       INTO nmemp_acu_codigo
       FROM ACR.empresa_acuerdo c
      WHERE c.tdc_td_fil = vctdc_td_fil
        AND c.EMP_ND_FIL = nmemp_nd_fil;

     OPEN CSCONSULTA FOR
          SELECT *
            FROM ACR.acuerdo_cliente
           WHERE AGA_CODIGO     = nmagu_codigo
             AND EMP_ACU_CODIGO = nmemp_acu_codigo;

     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';

     RETURN;
    CLOSE CSCONSULTA;
EXCEPTION
WHEN OTHERS THEN

     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_rtrn_lista_acuerdo causado por:'||sqlerrm;

END pl_rtrn_lista_acuerdo;
--}QB_LGC_GESTOR_DOCUMENTAL.pl_rtrn_lista_acuerdo

--{pl_ins_gestor
PROCEDURE pl_ins_gestor(nmTIP_FLUJO              IN NUMBER   --
                       ,vcNOMTABLA               IN VARCHAR2 --Nombre de la tabla
                       ,vcTXP_DESCRIPCION        IN VARCHAR2 --Nombre de la carpeta
                       ,nmdea_codigoPAdre        IN NUMBER   --codigo del padre
                       ,nmPRD_CODIGO             IN NUMBER   --SI NO ES NULO ES POR QUE ES LA PROPIEDAD DE UN ARCHIVO
                       ,vcNOM_ARCHIVO            IN OUT VARCHAR2
                       ,vcAUD_USUARIO            IN VARCHAR2
                       ,nmDEA_CODIGO            OUT VARCHAR2 --Registro que se acaba de crear
                       ,vcmensajeproceso        OUT VARCHAR2
                       ,vcestadoproceso         OUT VARCHAR2
) IS

     nmTXP_CODIGOtmp     NUMBER;
     nmAZD_CODIGOtmp     NUMBER;
     nmDEA_CODIGOtmp     NUMBER;
     nmtxp_codigo_ref    varchar2(4000);
     vcinst              varchar2(4000);
     vcNumeroArchivo     varchar2(12);
     nmTmpDEA_CODIGO     NUMBER:= NULL;
     nmvalida            NUMBER:= NULL;
     nmvalida1            NUMBER:= NULL;
     exSalir             EXCEPTION;
     PRAGMA autonomous_transaction;
BEGIN


     PB_SEGUIMIENTO_LONG('REPLICACION',
       'pl_ins_gestor: nmTIP_FLUJO:        '||nmTIP_FLUJO
     ||', vcNOMTABLA:         '||vcNOMTABLA
     ||', vcTXP_DESCRIPCION:  '||vcTXP_DESCRIPCION
     ||', nmdea_codigoPAdre:  '||nmdea_codigoPAdre
     ||', nmPRD_CODIGO:       '||nmPRD_CODIGO
     ||', nmDEA_CODIGO:       '||nmDEA_CODIGO
     ||', vcmensajeproceso:   '||vcmensajeproceso
     ||', vcestadoproceso:    '||vcestadoproceso
     ||', vcAUD_USUARIO:      '||vcAUD_USUARIO
     ||', vcNOM_ARCHIVO:      '||vcNOM_ARCHIVO
     );

     vcNOM_ARCHIVO:= INITCAP(vcNOM_ARCHIVO);

     IF  nmdea_codigoPAdre IS NULL THEN
          vcmensajeproceso   := 'No se Ingreso un identificador padre al cual asociar un hijo.';
          RAISE exSalir;
     END IF;

     --Sio ingresa a este if es por que el documento es de tipo carpeta
     IF nmTIP_FLUJO   IS NOT NULL       AND      vcTXP_DESCRIPCION  IS NOT NULL    THEN

          vcinst:='consulta txp_codigo_ref';
          nmtxp_codigo_ref := fl_rtn_data_erp_az(nmdea_codigoPAdre,'TXP_CODIGO');

          vcinst:='obtinene nmtxp_codigo_ref '||nmtxp_codigo_ref;

          BEGIN
               vcinst:=' prepara inserta en taxonomia TAXONOMIA_PARAM';
               INSERT INTO "ADM"."TAXONOMIA_PARAM" (TXP_CODIGO, TIP_FLUJO, NOMTABLA, TXP_CODIGO_REF, TXP_DESCRIPCION,AUD_USUARIO)
                                   VALUES (nmTXP_CODIGOtmp
                                   , nmTIP_FLUJO
                                   , vcNOMTABLA
                                   , nmtxp_codigo_ref
                                   , vcTXP_DESCRIPCION
                                   , vcAUD_USUARIO);
          EXCEPTION
          WHEN OTHERS THEN
               vcinst:='Error insertando en la tabla TAXONOMIA_PARAM';
               vcmensajeproceso   := 'Se esta tratando de duplicar una carpeta ya creada.'||sqlerrm;

                PB_SEGUIMIENTO_LONG('PL_INS_GESTOR',
                                   'nmTIP_FLUJO        '||nmTIP_FLUJO
                                 ||'vcNOMTABLA         '||vcNOMTABLA
                                 ||'vcTXP_DESCRIPCION  '||vcTXP_DESCRIPCION
                                 ||'nmdea_codigoPAdre  '||nmdea_codigoPAdre
                                 ||'nmPRD_CODIGO       '||nmPRD_CODIGO
                                 ||'nmDEA_CODIGO       '||nmDEA_CODIGO
                                 ||'vcmensajeproceso   '||vcmensajeproceso
                                 ||'vcestadoproceso    '||vcestadoproceso
                                 ||'vcAUD_USUARIO      '||vcAUD_USUARIO
                                 ||'vcNOM_ARCHIVO      '||vcNOM_ARCHIVO
                                 );
               RAISE exSalir;

          END;

          vcinst:='inserta en taxonomia nmTXP_CODIGOtmp'||ADM.SEC_TAXONOMIA_P.currval;
          nmTXP_CODIGOtmp  :=ADM.SEC_TAXONOMIA_P.currval;

     END IF;

     IF nmPRD_CODIGO IS NOT NULL THEN

     --{Consulta la existencia de la propiedad
          BEGIN
             SELECT count(prd_codigo)
               INTO nmvalida1
               FROM adm.propiedades_documento
              WHERE prd_codigo = nmPRD_CODIGO
                AND prd_codigo  in (11	--Otros si, adendas, acuerdos, politicas, manuales, constancias entrega
                                    ,33	--Diploma / Acta de grado tecnico
                                    ,34	--Diploma / Acta de grado tecnologico
                                    ,35	--Diploma / Acta de grado profesional - pregrado
                                    ,36	--Diploma / Acta de grado especializacion o equivalentes
                                    ,37	--Diploma / Acta de grado maestria o equivalentes
                                    ,38	--Diploma / Acta de grado doctorado o equivalentes
                                    ,39	--Tarjeta profesional
                                    ,40	--Certificados de estudios no formales
                                    ,41	--Referencias laborales
                                    ,42	--Referencias personales
                                    ,48	--Pruebas psicotecnicas
                                    ,49	--Pruebas tecnicas especificas del cargo
                                    ,50	--Pruebas cliente
                                    ,57	--Procesos de seguridad
                                    ,68	--Resultados de examenes medicos
                                    ,69	--Documentos beneficiaros
                                    ,70	--Documentos adicionales
									,74 --ARL
                                    ,105 --Certificado De Custodia O Registro Civil   
                                    ,123 --Diploma Técnica Laboral
                                    ,125 --Diploma Educación Formal - Otros
                                    ,126 --Nuevos Archivos
                                    ,128 --CERTIFICADOS DE IDIOMAS
                                       );  
                                       --Los documentos que van serializados
          EXCEPTION
          WHEN OTHERS THEN
               vcmensajeproceso   := 'No se encontro el tipo de archivo que se desea cargar';
               RAISE exSalir;
          END;

          IF nmvalida1>0 THEN
               BEGIN
                    SELECT COUNT(DEA_CODIGO)+1
                      INTO nmvalida
                      FROM ADM.DATA_ERP_AZ dea
                         , adm.az_digital azd
                     WHERE dea.txp_codigo = fl_rtn_data_erp_az(nmdea_codigoPAdre,'TXP_CODIGO')
                       AND dea.PRD_CODIGO = nmPRD_CODIGO
                       AND dea.azd_codigo = azd.azd_codigo;
               EXCEPTION
               WHEN OTHERS THEN
                    nmvalida:=1;
               END;

               IF LENGTH(nmvalida) = 1 THEN
                    vcNumeroArchivo:='0'||nmvalida;
                    ELSE
                    vcNumeroArchivo:=''||nmvalida;
               END IF;
               
               PB_SEGUIMIENTO_LONG('REPLICACION',
                'pl_ins_gestor: nmvalida:        '||nmvalida
                ||', vcNumeroArchivo:         '||vcNumeroArchivo);

               vcNOM_ARCHIVO := vcNOM_ARCHIVO||' '|| vcNumeroArchivo;

          ELSE

            BEGIN
                 SELECT DEA_CODIGO
                 INTO nmDEA_CODIGO
                 FROM ADM.DATA_ERP_AZ dea
                    , adm.az_digital azd
                WHERE dea.txp_codigo = ADM.QB_LGC_GESTOR_DOCUMENTAL.fl_rtn_data_erp_az(nmdea_codigoPAdre,'TXP_CODIGO')
                  AND dea.azd_codigo = azd.azd_codigo
                  AND dea.PRD_CODIGO = nmPRD_CODIGO
                  and dea.dea_estado <> 2
                  and rownum < 2;

                vcestadoproceso   := 'S';
                vcmensajeproceso  :='Creado con exito.';
                COMMIT;
               RETURN;
             EXCEPTION
             WHEN OTHERS THEN
                 vcinst:='No existe documento';
              END;


          END IF;


          nmTXP_CODIGOtmp := fl_rtn_data_erp_az(nmdea_codigoPAdre,'TXP_CODIGO');
     --}
     END IF;

     --{az_digital
     vcinst:='Prepara insert AZ_DIGITAL';
     INSERT INTO "ADM"."AZ_DIGITAL" (AZD_CODIGO,AUD_USUARIO) VALUES (nmAZD_CODIGOtmp,vcAUD_USUARIO);
     nmAZD_CODIGOtmp:=ADM.SEC_AZ_DIGITAL.currval;
     --}

     vcinst:='Prepara insert data_erp_az';
     INSERT INTO "ADM"."DATA_ERP_AZ" (DEA_CODIGO, TXP_CODIGO, AZD_CODIGO, PRD_CODIGO,AUD_USUARIO) VALUES (nmDEA_CODIGOtmp, nmTXP_CODIGOtmp,nmAZD_CODIGOtmp, nmPRD_CODIGO,vcAUD_USUARIO);
     nmDEA_CODIGOtmp:= ADM.SEC_DATA_ERP_AZ.currval;
     nmDEA_CODIGO := nmDEA_CODIGOtmp;

     vcinst:='consulta siguiente secuencia nmDEA_CODIGOtmp  '||nmDEA_CODIGOtmp||'nmTXP_CODIGOtmp'||nmTXP_CODIGOtmp||'nmAZD_CODIGOtmp'||nmAZD_CODIGOtmp  ;

     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Creado con exito.';
     COMMIT;
   --  pb_seguimiento_long('PL_INS_GESTOR',vcmensajeproceso);
EXCEPTION
WHEN exSalir THEN
     vcestadoproceso  := 'N';
     ROLLBACK;
WHEN OTHERS THEN
     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento pl_ins_gestor causado por:'||sqlerrm||' vcinst: '||vcinst;
    -- pb_seguimiento_long('PL_INS_GESTOR',vcmensajeproceso);
     ROLLBACK;
END pl_ins_gestor;
--}pl_ins_gestor

--{PL_UPD_CODIGO_CLI
PROCEDURE PL_UPD_CODIGO_CLI(nmDEA_CODIGO             IN NUMBER
                           ,NMAZ_CODIGO_CLI          IN NUMBER
                           ,vcnombreArchivo          IN VARCHAR2
                           ,vcmensajeproceso        OUT VARCHAR2
                           ,vcestadoproceso         OUT VARCHAR2)

IS
     NMAZD_CODIGO varchar2(4000);
     PRAGMA autonomous_transaction;
     vcazd_tipo VARCHAR2(1);
BEGIN

     BEGIN
     
     
     PB_SEGUIMIENTO_LONG('REPLICACION',
                                   'PL_UPD_CODIGO_CLI: nmDEA_CODIGO        '||nmDEA_CODIGO
                                 ||'NMAZ_CODIGO_CLI         '||NMAZ_CODIGO_CLI
                                 ||'vcnombreArchivo  '||vcnombreArchivo);

          SELECT   CASE WHEN dea.prd_codigo IS NULL THEN
           'C'
            ELSE 'A'  END
            INTO vcazd_tipo
            FROM adm.data_erp_Az dea
           WHERE dea_codigo=nmDEA_CODIGO;

     EXCEPTION
     WHEN OTHERS THEN
         vcazd_tipo := NULL;
     END;
    -- pb_seguimiento_long('UPD_VAL',nmDEA_CODIGO||' - '||NMAZ_CODIGO_CLI);
     NMAZD_CODIGO := fl_rtn_data_erp_az(nmDEA_CODIGO,'AZD_CODIGO');




     UPDATE "ADM"."AZ_DIGITAL"
        SET AZD_CODIGO_CLI = NMAZ_CODIGO_CLI
          , AZD_NOMBRE_RUTA = vcnombreArchivo
          , AZD_TIPO    = vcazd_tipo
      WHERE AZD_CODIGO = NMAZD_CODIGO;

     commit;
     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';

EXCEPTION
WHEN OTHERS THEN

     vcestadoproceso  := 'N';
     vcmensajeproceso := 'Error en el procedimiento PL_UPD_CODIGO_CLI causado por:'||sqlerrm;

END PL_UPD_CODIGO_CLI;
--}PL_UPD_CODIGO_CLI

--{pl_ins_respuesta_ws
PROCEDURE pl_ins_respuesta_ws(cltramaEnviaXML             IN CLOB
                             ,cltramaRespuestaXML         IN CLOB
                             ,CSCONSULTA                 OUT csCursor
                             ,vcestadoproceso            OUT VARCHAR2
                             ,vcmensajeproceso           OUT VARCHAR2
                            ) IS
    CLXML                     CLOB;
    CLSQL_BLOQUE              CLOB;
    exSalir                   EXCEPTION;
    cltramaRespuestaXMLtmp    CLOB;
     cltramaRespuestaXMLtmp1    CLOB;

    vcfaultCode               VARCHAR2(400);
    vcfaultMessage            VARCHAR2(400);
    PRAGMA autonomous_transaction;
BEGIN
/*
     DELETE FROM SEGUIMIENTO_LONG
      WHERE SGL_CLAVE in ('CLXML_entrada','CLXML_salida','CLXML');

     COMMIT;
*/


     IF length(cltramaRespuestaXML)<10 or cltramaRespuestaXML IS NULL THEN
          pb_seguimiento2('ESB_RESP_XML',cltramaRespuestaXML);
          vcmensajeproceso := 'valor de respuesta es nulo';
          raise exSalir;
     END IF;

     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXML,'soapenv:','soapenv_');


     IF INSTR(cltramaRespuestaXMLtmp,'HTTP response code:')  >0 THEN
          vcmensajeproceso := 'Consumo Servicio:'||dbms_lob.substr( cltramaRespuestaXML,3000,1);
          raise exSalir;
     END IF ;

     cltramaRespuestaXMLtmp1 := replace(cltramaRespuestaXMLtmp,'NS2:ErrorMessage','ErrorMessage');
     IF  INSTR(cltramaRespuestaXMLtmp,'ErrorMessage')  >0 THEN
          cltramaRespuestaXMLtmp1 := replace(cltramaRespuestaXMLtmp1,'NS2:fault','fault');
            pb_seguimiento_long('ingresa_xml',cltramaRespuestaXMLtmp1);

              SELECT  xmlt.faultCode           faultCode
                    , xmlt.faultMessage        faultMessage
                INTO  vcfaultCode
                    , vcfaultMessage
                FROM XMLTABLE('/soapenv_Envelope/soapenv_Body//ErrorMessage'
                PASSING XMLType(cltramaRespuestaXMLtmp1)
                COLUMNS
                  faultCode              VARCHAR2(255)    PATH 'faultCode'
                 ,faultMessage           VARCHAR2(255)    PATH 'faultMessage'
                 ) xmlt;


          vcmensajeproceso := 'Codigo de Error AZ : '||vcfaultCode||' DescripciÃ³n: '||vcfaultMessage;
          RAISE exSalir;
     END IF;





     --{eXTRAE RESPUESTA EXITOSA
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out:','out_');
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out_ResCrearLink','out_operacion');
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out_ResCargarArchivo','out_operacion');
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out_ResCrear','out_operacion');
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out_ResEliminar','out_operacion');
     cltramaRespuestaXMLtmp := replace(cltramaRespuestaXMLtmp,'out_ResMover','out_operacion');



    CLXML := 'SELECT  xmlt.ESTADO               ESTADO
                     ,xmlt.idArchivoNuevo       IDARCHIVONUEVO
                     ,xmlt.idCarpetaNueva       IDCARPETANUEVA
                     ,xmlt.IDLINK               IDLINK
                FROM XMLTABLE(''/soapenv_Envelope/soapenv_Body/out_operacion''
                PASSING XMLType('||chr(39)||cltramaRespuestaXMLtmp||chr(39)||')
                COLUMNS
                  ESTADO              VARCHAR2(255)    PATH ''out_estado''
                 ,IDARCHIVONUEVO      VARCHAR2(255)    PATH ''out_idArchivoNuevo''
                 ,IDCARPETANUEVA      VARCHAR2(255)    PATH ''out_idCarpetaNueva''
                 ,IDLINK              VARCHAR2(255)    PATH ''out_idLink''
                 ) xmlt';




     OPEN CSCONSULTA FOR CLXML;
    -- OPEN CSCONSULTA FOR 'SELECT SYSDATE FROM DUAL';
     vcestadoproceso   := 'S';
     vcmensajeproceso  :='Procedimiento ejecutado con exito.';
     --}

    EXCEPTION
    WHEN exSalir THEN
           pb_seguimiento_long('CLXML_Seg',' exSalir'||vcmensajeproceso||'cltramaEnviaXML'||cltramaEnviaXML||'cltramaRespuestaXML'||cltramaRespuestaXML);
           vcestadoproceso  := 'N';
    WHEN OTHERS THEN
          vcestadoproceso  := 'N';
          vcmensajeproceso := 'Error en el procedimiento pl_ins_respuesta_ws causado por:'||sqlerrm||' Trama enviada'||dbms_lob.substr( cltramaRespuestaXML, 254, 1 );
          pb_seguimiento_long('CLXML_Seg',vcmensajeproceso||cltramaRespuestaXML);
END ;
--}

--{PL_VAL_DOCUMENTO
PROCEDURE PL_VAL_DOCUMENTO(vctpd_descripcion  IN VARCHAR2 --nOMBRE ARCHIVO
                          ,Vctxp_Descripcion  IN VARCHAR2 --NOMBRE CARPETA
                          ,vcestadoproceso   OUT VARCHAR2
                          ,vcmensajeproceso  OUT VARCHAR2)
IS
 NMVALIDA NUMBER;
BEGIN
     vcestadoproceso  := 'N';

     BEGIN
            SELECT COUNT(*)
             INTO NMVALIDA
              FROM ADM.data_erp_az dea
              WHERE TXP_CODIGO IN (SELECT TXP_CODIGO
                                     FROM ADM.taxonomia_param TP
                                    WHERE TIP_FLUJO = 1
                                      AND tp.txp_descripcion = Vctxp_Descripcion)--'BHV CC 1030576314')
            AND prd_codigo IN(SELECT pd.prd_codigo
                                FROM ADM.propiedades_documento PD
                                   , ADM.tipo_documento TD
                               WHERE pd.tpd_codigo=td.tpd_codigo
                                AND (upper(td.tpd_descripcion) =upper(vctpd_descripcion)))
               AND dea_estado <> 2;--'Documento de identidad' OR td.tpd_codigo='3'));
     EXCEPTION
     WHEN OTHERS THEN

          vcmensajeproceso := 'Error en el procedimiento PL_VAL_DOCUMENTO causado por:'||sqlerrm;

     END;
     IF NMVALIDA >0 THEN
          vcestadoproceso   := 'S';
          vcmensajeproceso  :='Procedimiento ejecutado con exito.';
     END IF;



    EXCEPTION
    WHEN OTHERS THEN
          vcestadoproceso  := 'N';
          vcmensajeproceso := 'Error en el procedimiento PL_VAL_DOCUMENTO causado por:'||sqlerrm;

END PL_VAL_DOCUMENTO;
--}

--{pl_eliminar_documento
PROCEDURE pl_eliminar_documento(nmdea_codigo       IN NUMBER
                               ,vcestadoproceso   OUT VARCHAR2
                               ,vcmensajeproceso  OUT VARCHAR2
) IS
    PRAGMA autonomous_transaction;
BEGIN

     UPDATE ADM.data_erp_az SET dea_estado = 2
     WHERE DEA_CODIGO = nmdea_codigo;

     COMMIT;
          vcestadoproceso   := 'S';
          vcmensajeproceso  :='Eliminado con exito.';


    EXCEPTION
    WHEN OTHERS THEN
          vcestadoproceso  := 'N';
          vcmensajeproceso := 'Error en el procedimiento pl_eliminar_documento causado por:'||sqlerrm;
end pl_eliminar_documento;
--}

--{PL_DIRPADRE_REQ
PROCEDURE PL_DIRPADRE_REQ(VCTXP_DESCRIPCION IN VARCHAR2
                         ,vcestadoproceso   OUT VARCHAR2
                         ,vcmensajeproceso  OUT VARCHAR2)IS

VCDESCRIPCION varchar2(30) := NULL;

BEGIN

    SELECT txp_descripcion
    INTO VCDESCRIPCION
    FROM adm.taxonomia_param
    WHERE txp_codigo = (SELECT tplc.TXP_CODIGO_REF
                        FROM adm.taxonomia_param tplc
                        WHERE tplc.txp_descripcion = VCTXP_DESCRIPCION);

    vcestadoproceso := 'S';
    vcmensajeproceso := VCDESCRIPCION;

    EXCEPTION
    WHEN OTHERS THEN
          vcestadoproceso  := 'N';
          vcmensajeproceso := 'Error en el procedimiento PL_DIRPADRE_REQ causado por:'||sqlerrm;

END PL_DIRPADRE_REQ;
--}

-- desierra 27/04/2022

    PROCEDURE PL_OBTENER_TIPO(
        vcdocumento      IN VARCHAR,
        rctipo_doc       OUT cscursor,
        vcestadoproceso  OUT VARCHAR,
        vcmensajeproceso OUT VARCHAR
    ) IS
    BEGIN

    IF vcdocumento IS NOT NULL THEN
            OPEN rctipo_doc FOR SELECT
                                    *
                                FROM
                                    adm.tipo_documento
                                WHERE
                                    tpd_codigo = vcdocumento;

            vcestadoproceso := 'S';
            vcmensajeproceso := 'Procedimiento ejecutado exitosamente';
        END IF;

    EXCEPTION
        WHEN no_data_found THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'No existe el tipo documento';
        WHEN OTHERS THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'Error en PL_OBTENER_TIPODOC: ' || sqlerrm;
    END pl_obtener_tipo;

-- desierra 27/04/2022
--{PL_OBTENER_TIPODOC
PROCEDURE PL_OBTENER_TIPODOC(VCDOCUMENTO       IN VARCHAR,
                             RCTIPO_DOC       OUT csCursor,
                             vcestadoproceso  OUT VARCHAR,
                             vcmensajeproceso OUT VARCHAR)IS

--CORRESPONDE AL TPD_CODIGO DE LA TABLA ADM.TIPO_DOCUMENTO
NMID_TIPODOC NUMBER := NULL;

BEGIN

    --CURSOR
	OPEN RCTIPO_DOC FOR
		SELECT TPD_CODIGO, TPD_DESCRIPCION, DTD_CODIGO, AUD_FECHA, AUD_USUARIO, TPD_ALIAS
			FROM ADM.TIPO_DOCUMENTO
		WHERE 	UPPER(TPD_DESCRIPCION) 	= UPPER(VCDOCUMENTO)
			OR	UPPER(TPD_ALIAS) 		= UPPER(VCDOCUMENTO);

		vcestadoproceso := 'S';
        vcmensajeproceso := 'Procedimiento ejecutado exitosamente';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'No existe el tipo documento';
        WHEN OTHERS THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'Error en PL_OBTENER_TIPODOC: ' || SQLERRM;

END PL_OBTENER_TIPODOC;
--}PL_OBTENER_TIPODOC


--{PL_OBTENER_TIPODOC
PROCEDURE PL_OBTENER_TIPODOC(VCDOCUMENTO       IN VARCHAR,
                             NMTIPO_ESTUDIO    IN NUMBER, --CORRESPONDE AL TTE_CODIGO DE LA TABLA tsel_tipo_estudio
                             RCTIPO_DOC       OUT csCursor,
                             vcestadoproceso  OUT VARCHAR,
                             vcmensajeproceso OUT VARCHAR)IS

--CORRESPONDE AL TPD_CODIGO DE LA TABLA ADM.TIPO_DOCUMENTO
NMID_TIPODOC NUMBER := NULL;

BEGIN

    --TTE_CODIGO TABLA tsel_tipo_estudio 2_BACHILLER

    --BASICA PRIMARIA (1Â° - 5Â°)
    IF NMTIPO_ESTUDIO = 15 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 30;
    END IF;

    --Diploma bachillerato basico (6Â° - 9Â°)
    IF NMTIPO_ESTUDIO = 2 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 31;
    END IF;

    --Diploma bachillerato media (10Â° - 11Â°)
    IF NMTIPO_ESTUDIO = 17 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 32;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio3_TECNICO
    IF NMTIPO_ESTUDIO = 3 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 33;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio4_TECNOLOGO
    IF NMTIPO_ESTUDIO = 4 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 34;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio5_PROFESIONAL
    IF NMTIPO_ESTUDIO = 5 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 35;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio6_ESPECIALIZACION
    IF NMTIPO_ESTUDIO = 6 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 36;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio7_MAESTRIA
    IF NMTIPO_ESTUDIO = 7 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 37;
    END IF;

    --TTE_CODIGO TABLA tsel_tipo_estudio8_PH_D
    IF NMTIPO_ESTUDIO = 8 AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 38;
    END IF;



    --TIPO ESTUDIO NO FORMAL
    IF NMTIPO_ESTUDIO IN (9,10,11,12,13,14,15) AND VCDOCUMENTO = 'CERTESTUDIO' THEN
        NMID_TIPODOC := 40;
    END IF;

    --CURSOR
    IF NMID_TIPODOC IS NOT NULL THEN

        OPEN RCTIPO_DOC FOR
            SELECT *
            FROM  ADM.TIPO_DOCUMENTO
            WHERE TPD_CODIGO = NMID_TIPODOC;

        vcestadoproceso := 'S';
        vcmensajeproceso := 'Procedimiento ejecutado exitosamente';

    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'No existe el tipo documento';
        WHEN OTHERS THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'Error en PL_OBTENER_TIPODOC: ' || SQLERRM;

END PL_OBTENER_TIPODOC;
--}

-------- PL_DOCUMENTOS_BASICOS--------desierra 2022-03-10
PROCEDURE PL_DOCUMENTOS_BASICOS(
                                 nmdea_codigo_rtn IN NUMBER,
                                 RCDOCUMENTOS  OUT csCursor,
                                 vcestadoproceso  OUT VARCHAR,
                                 vcmensajeproceso OUT VARCHAR)
                                 IS
BEGIN
    OPEN RCDOCUMENTOS FOR
                             SELECT tp.tip_codigo  VALOR, tp.tip_descripcion DESCRIPCION
from  tipo_archivo_gd tp
left JOIN (
                            select    td.tpd_codigo
                            FROM
                                adm.data_erp_az           dea1,
                                adm.az_digital            ad,
                                adm.data_erp_az           dea2,
                                adm.propiedades_documento pd,
                                adm.tipo_documento        td
                            WHERE
                                dea1.dea_codigo = nmdea_codigo_rtn   --ID unico que hace referencia a la carpeta
                                AND ad.azd_codigo = dea2.azd_codigo
                                AND dea2.txp_codigo = dea1.txp_codigo
                                AND dea2.prd_codigo = pd.prd_codigo
                                AND pd.tpd_codigo = td.tpd_codigo
                                AND dea2.dea_estado <> 2
                                AND ad.azd_codigo_cli IS NOT NULL
                            ORDER BY
                                dea1.aud_fecha DESC,
                                ad.aud_fecha DESC,
                                dea2.aud_fecha DESC ) t
                                on t.tpd_codigo = tp.tip_codigo
                                      where t.tpd_codigo  is  null ;
END PL_DOCUMENTOS_BASICOS;
-------- PL_DOCUMENTOS_BASICOS--------desierra 2022-03-10

--{PL_DOCUMENTOS_BASICOS
PROCEDURE PL_DOCUMENTOS_BASICOS(RCDOCUMENTOS       OUT csCursor,
                                 vcestadoproceso  OUT VARCHAR,
                                 vcmensajeproceso OUT VARCHAR)IS

BEGIN

    OPEN RCDOCUMENTOS FOR
        SELECT  'CUENTABANCARIA' AS VALOR,
                'Certificacion cuenta bancaria' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'SOAT' AS VALOR,
                'SOAT' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'TECNOMECANICA' AS VALOR,
                'Revision tecnomecanica' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'RUNT' AS VALOR,
                'RUNT' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'SIMIT' AS VALOR,
                'Estado en el SIMIT' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'CURSOALTURAS' AS VALOR,
                'Curso de alturas' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'CARNEVACUNAS' AS VALOR,
                'Carnet de vacunas' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT  'DOCADICIONALES' AS VALOR,
                'Documentos adicionales' AS DESCRIPCION
        FROM DUAL
		UNION
        SELECT 'DOCUMENTO DE IDENTIDAD' AS VALOR,
               'Documento de identidad' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA1_5' AS VALOR,
               'Diploma acta de grado basica primaria (1Â° - 5Â°)' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA6_9' AS VALOR,
               'Diploma acta de grado bachillerato basico (6Â° - 9Â°)' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA10_11' AS VALOR,
               'Diploma acta de grado bachillerato media (10Â° - 11Â°)' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_TEC' AS VALOR,
               'Diploma acta de grado tecnico' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_TECNG' AS VALOR,
               'Diploma acta de grado tecnologico' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_PREG' AS VALOR,
               'Diploma acta de grado profesional - pregrado' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_ESPC' AS VALOR,
               'Diploma acta de grado especializacion o equivalentes' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_MAES' AS VALOR,
               'Diploma acta de grado maestria o equivalentes' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_DOC' AS VALOR,
               'Diploma acta de grado doctorado o equivalentes' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'DIPLOMA_EST_NF'AS VALOR,
               'Certificados de estudios no formales' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_MED_CORRECTIVAS'AS VALOR,
               'Certificado de medidas correctivas' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_DEL_SEX__MENORES'AS VALOR,
               'Certificado de delitos sexuales contra menores' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_ANT_JUD_POLICIA'AS VALOR,
               'Certificado de antecedentes judiciales de policia' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_ANT_JUD_PROCURADURIA'AS VALOR,
               'Certificado de antecedentes judiciales de procuraduria' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_ANT_JUD_CONTRALORIA'AS VALOR,
               'Certificado de antecedentes judiciales de contraloria' AS DESCRIPCION
        FROM DUAL
        UNION
        SELECT 'CERT_ANT_JUD_PERSONERIA'AS VALOR,
               'Certificado de antecedentes judiciales de personeria' AS DESCRIPCION
        FROM DUAL
        ORDER BY VALOR ASC;

END PL_DOCUMENTOS_BASICOS;
--}PL_DOCUMENTOS_BASICOS

--{PL_OBTENER_TIPODOC_BASICO
PROCEDURE PL_OBTENER_TIPODOC_BASICO(NMTIPO_DOC       IN NUMBER,
                                     RCTIPO_DOC       OUT csCursor,
                                     vcestadoproceso  OUT VARCHAR,
                                     vcmensajeproceso OUT VARCHAR)IS

--CORRESPONDE AL TPD_CODIGO DE LA TABLA ADM.TIPO_DOCUMENTO
NMID_TIPODOC NUMBER := NULL;

BEGIN

    --CUENTA BANCARIA
    IF NMTIPO_DOC = 1 THEN
        NMID_TIPODOC := 20;
    END IF;

    --SOAT
    IF NMTIPO_DOC = 2 THEN
        NMID_TIPODOC := 21;
    END IF;

    --REVISION TECNO
    IF NMTIPO_DOC = 3 THEN
        NMID_TIPODOC := 22;
    END IF;

    --RUNT
    IF NMTIPO_DOC = 4 THEN
        NMID_TIPODOC := 23;
    END IF;

    --SIMIT
    IF NMTIPO_DOC = 5 THEN
        NMID_TIPODOC := 24;
    END IF;

    --CURSO ALTURAS
    IF NMTIPO_DOC = 6 THEN
        NMID_TIPODOC := 27;
    END IF;

    --CARNE_VACUNAS
    IF NMTIPO_DOC = 7 THEN
        NMID_TIPODOC := 28;
    END IF;

    --OTRO DOCUMENTO
    IF NMTIPO_DOC = 8 THEN
        NMID_TIPODOC := 29;
    END IF;

    --CURSOR
    IF NMID_TIPODOC IS NOT NULL THEN

        OPEN RCTIPO_DOC FOR
            SELECT *
            FROM  ADM.TIPO_DOCUMENTO
            WHERE TPD_CODIGO = NMID_TIPODOC;

        vcestadoproceso := 'S';
        vcmensajeproceso := 'Procedimiento ejecutado exitosamente';

    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'No existe el tipo documento';
        WHEN OTHERS THEN
            vcestadoproceso := 'N';
            vcmensajeproceso := 'Error en PL_OBTENER_TIPODOC: ' || SQLERRM;

END PL_OBTENER_TIPODOC_BASICO;
--}PL_OBTENER_TIPODOC_BASICO

--{pb_generar_HV_PDF
PROCEDURE pb_generar_HV_PDF(vctdc_td         IN VARCHAR2
                           ,nmepl_nd         IN NUMBER
                           ,nmrequisicion    IN NUMBER
                           ,VCurl            OUT VARCHAR2
                           ,VCERROR          OUT VARCHAR2) is

   vcDoc               VARCHAR2(4000);
   vcDocpath           VARCHAR2(4000);
   vcServidor          VARCHAR2(4000);
   vcContexto          VARCHAR2(4000);
   vcContextoSalida    VARCHAR2(4000);
   vcservlet           VARCHAR2(4000);
   vcSalida            VARCHAR2(4000);

nmreq number;

BEGIN

    IF nmrequisicion IS NULL THEN
        nmreq := 0;
    ELSE
        nmreq:=nmrequisicion;
    END IF;
    --
    --QB_GENERAR_REPORTE_V2.pb_generar_reporte('JSEL0060',vctdc_td||','||nmepl_nd||','||nmreq,'REP',vcSalida,vcError);
    --QB_GENERAR_REPORTE_V2.pb_generar_reporte('REP_HOJADEVIDA',vctdc_td||','||nmepl_nd||','||nmreq,USER,vcSalida,vcError);
    --QB_GENERAR_REPORTE_V2.pb_generar_reporte('NREP0099',vctdc_td||','||nmepl_nd||','||nmreq,USER,vcSalida,vcError);
    --
      PACKAGE_REPORTE.reporte('JSEL0060','REP',0,vcSalida,vcError,2);
      PACKAGE_REPORTE.parametro(vcSalida,'P_TDC_TD_EPL',vctdc_td,vcError);
      PACKAGE_REPORTE.parametro(vcSalida,'P_EPL_ND',nmepl_nd,vcError);
      PACKAGE_REPORTE.parametro(vcSalida,'P_REQ_CONSECUTIVO',nmreq,vcError);

pb_seguimiento2('SERVLET_HV','vcError'||vcError||'vctdc_td     '||vctdc_td         ||'nmepl_nd     '||nmepl_nd         ||'nmrequisicion'||nmrequisicion);
    BEGIN
        SELECT adp.QB_UTIL_DBJAVA.fl_ruta_servidor_imp(vcSalida)
        INTO vcservlet
        FROM DUAL;
        EXCEPTION WHEN OTHERS THEN
            PB_SEGUIMIENTO2('ERRORS','vcSalida'||vcSalida||SQLERRM);
    END;

    vcUrl:=vcservlet;
   PB_SEGUIMIENTO2('SERVLET_HV',vcservlet);
   /* IF vcError IS NULL THEN
        PB_RUTA_PROGRAMA('CL_APP_JSF2',NULL,SYSDATE,vcDocpath,vcServidor);
        PB_RUTA_PROGRAMA('URL_SERV_IMP',NULL,SYSDATE,vcContexto,vcContextoSalida);
        vcDoc := vcContexto||vcservlet||vcSalida||'';
        --
        --vcDoc := vcContexto||'servletArchivoPDF?RQR_REQUERIMIENTO='||vcSalida||'';
        PB_SEGUIMIENTO2('SERVLET',vcservlet);

        vcUrl :=  vcDocpath||vcDoc;
    END IF ;*/

EXCEPTION
WHEN OTHERS THEN
pb_seguimiento2('SERVLET_HV',sqlerrm||'vcservlet'||vcservlet||'vcError'||vcError||'vctdc_td     '||vctdc_td         ||'nmepl_nd     '||nmepl_nd         ||'nmrequisicion'||nmrequisicion);
     VCERROR:='eRROR EN pb_generar_HV_PDF causado por:'||sqlerrm;
END pb_generar_HV_PDF;
--}pb_generar_HV_PDF

--{pl_cslt_numero_sig
PROCEDURE pl_cslt_numero_sig(nmdea_codigoPAdre        IN NUMBER
                            ,nmPRD_CODIGO             IN NUMBER
                            ,vcNUMERO                OUT VARCHAR2
                            ,vcmensajeproceso        OUT VARCHAR2
                            ,vcestadoproceso         OUT VARCHAR2
                            )
IS
      exSalir	     EXCEPTION;
      nmTmpNUMERO   NUMBER;
BEGIN


     IF nmdea_codigoPAdre IS NULL OR nmPRD_CODIGO IS NULL THEN
           vcmensajeproceso := 'No se encontro documento paramtrizaco con dea_codigo: '||nmdea_codigoPAdre||' y propiedades_documento '||nmPRD_CODIGO;
          RAISE exSalir;
     END IF;


     BEGIN
        SELECT COUNT(*)
          INTO nmTmpNUMERO
          FROM ADM.DATA_ERP_AZ dea
             --, adm.az_digital azd
         WHERE dea.txp_codigo = fl_rtn_data_erp_az(nmdea_codigoPAdre,'TXP_CODIGO')
           AND dea.PRD_CODIGO = nmPRD_CODIGO
           --AND dea.azd_codigo = azd.azd_codigo
         GROUP BY dea.PRD_CODIGO;
      EXCEPTION
      WHEN OTHERS THEN
          vcNUMERO :='001';
      END;

     IF nmTmpNUMERO >0 THEN
          vcNUMERO := LPAD(nmTmpNUMERO,3,'0');
     END IF;

     vcestadoproceso  := 'S';
     vcmensajeproceso := 'Ejecutado con exito';
EXCEPTION
WHEN exsalir THEN
      vcestadoproceso  :='N';
WHEN OTHERS THEN
     vcestadoproceso  :='N';
     vcmensajeproceso :='Error causado en pl_cslt_numero_sig causado por'||sqlerrm;
END pl_cslt_numero_sig;
--}pl_cslt_numero_sig




--{pl_mover_az
PROCEDURE pl_mover_az(NMDEA_CODIGO_ACT         IN NUMBER
                  ,NMDEA_CODIGO_MOV         IN NUMBER
                  ,vcmensajeproceso        OUT VARCHAR2
                  ,vcestadoproceso         OUT VARCHAR2
                  ) IS

     regdea_codigo_act   ADM.data_erp_az%rowTYPE;
     regdea_codigo_mov   ADM.data_erp_az%rowTYPE;
    PRAGMA autonomous_transaction;
     CURSOR cs_data_erp_az(nmdeacodigo NUMBER) IS
     SELECT *
       FROM adm.data_erp_az
      WHERE dea_codigo = nmdeacodigo;

     exsalir EXCEPTION;
BEGIN

 /*Obtenemos la fila del registro donde se encuentra actualmente el objeto*/
        OPEN cs_data_erp_az(NMDEA_CODIGO_ACT);
       FETCH cs_data_erp_az
        INTO regdea_codigo_act;
       CLOSE cs_data_erp_az;
/*Obtenemos la fila del registro donde moveremos el objeto*/
     OPEN cs_data_erp_az(NMDEA_CODIGO_MOV);
       FETCH cs_data_erp_az
        INTO regdea_codigo_mov;
       CLOSE cs_data_erp_az;

      IF regdea_codigo_act.PRD_CODIGO IS NULL THEN
       /* Logica para mover una carpeta de una a otra*/
          UPDATE ADM.TAXONOMIA_PARAM
             SET TXP_CODIGO_REF = regdea_codigo_mov.txp_codigo
             , aud_usuario = 'Movido'
           WHERE txp_codigo = regdea_codigo_act.txp_codigo;

          vcestadoproceso  := 'S';
          vcmensajeproceso := 'Carpeta Movida con exito';
          commit;
          RETURN;

      END IF;

      IF regdea_codigo_act.PRD_CODIGO IS NOT NULL THEN
     /* Logica para mover undocumento a una nueva carpeta*/
          UPDATE ADM.data_erp_az
             SET txp_codigo = regdea_codigo_mov.txp_codigo
               , aud_usuario = 'Movido'
           WHERE dea_codigo = regdea_codigo_act.dea_codigo;

          vcestadoproceso  := 'S';
          vcmensajeproceso := 'Documento Movido con exito';
          commit;
          return;
      END IF;


     vcmensajeproceso := 'fallo causado por'||sqlerrm;
     raise exSalir;


EXCEPTION
WHEN exsalir THEN
      vcestadoproceso  :='N';
WHEN OTHERS THEN
     vcestadoproceso  :='N';
     vcmensajeproceso :='Error causado en pl_cslt_numero_sig causado por'||sqlerrm;
END pl_mover_az;
--}pl_mover_az

--{PL_DELETE_DATA_ERP
PROCEDURE PL_DELETE_DATA_ERP(NMDEA_CODIGO IN NUMBER  -- 17469636
                             ,VCESTADO_PROCESO  OUT VARCHAR2
                             ,VCMENSAJE_PROCESO OUT VARCHAR2)IS

    NMAZD_CODIGO    NUMBER;
    NMTXP_CODIGO    NUMBER;

    PRAGMA autonomous_transaction;
BEGIN

    SELECT AZD_CODIGO , TXP_CODIGO
    INTO NMAZD_CODIGO ,NMTXP_CODIGO
    FROM ADM.data_erp_Az
    WHERE DEA_CODIGO = NMDEA_CODIGO;

    DELETE ADM.TAXONOMIA_PARAM
    WHERE TXP_CODIGO = NMTXP_CODIGO;
   
     DELETE ADM.az_digital
    WHERE AZD_CODIGO = NMAZD_CODIGO;

    DELETE ADM.data_erp_Az
    WHERE DEA_CODIGO = NMDEA_CODIGO;


    COMMIT;

    VCESTADO_PROCESO := 'S';
    VCMENSAJE_PROCESO := 'Procedimiento ejecutado exitosamente';

    EXCEPTION
        WHEN OTHERS THEN
            VCESTADO_PROCESO := 'N';
            VCMENSAJE_PROCESO := 'Ocurrio un error en PL_DELETE_DATA_ERP: ' || SQLERRM;

END PL_DELETE_DATA_ERP;
--}PL_DELETE_DATA_ERP

--{procedimiento ejecutado desde el Bus de Integracion
PROCEDURE pl_consulta_iib_Az(vctdc_td_epl        IN VARCHAR2
                            ,nmepl_nd            IN NUMBER
                            ,nmtipo_prueba       IN NUMBER
                            ,nmaz_codigo_cli    OUT NUMBER
                            ,vcNombreArchivo    OUT VARCHAR2
                            ,vcestadoproceso    OUT VARCHAR2
                            ,vcmensajeproceso   OUT VARCHAR2
                            )
IS
     exSalir	         EXCEPTION;

     nmreq_consecutivo  NUMBER;
     vcBancoHV          VARCHAR2(300);
     vcSeleccion        VARCHAR2(300);
     vcProceso          VARCHAR2(300);
     nmtxp_codigo       NUMBER;

	CURSOR CU_TAXONOMIA_PARAM IS
		SELECT txp_codigo
			FROM adm.taxonomia_param
			WHERE txp_descripcion = vcProceso
			AND txp_codigo_REF  IN (SELECT txp_codigo
                                    FROM adm.taxonomia_param
                                   WHERE txp_descripcion = vcSeleccion)
			  ORDER BY AUD_FECHA DESC FETCH FIRST ROW ONLY;

	CURSOR CU_DATA_ERP (nmtxp_codigo NUMBER) IS
		SELECT fl_rtn_az_digital(azd_codigo,'AZD_CODIGO_CLI')
          FROM ADM.data_erp_az
         WHERE txp_codigo = nmtxp_codigo
           AND prd_codigo IS NULL;
BEGIN
     nmaz_codigo_cli:=0;
     BEGIN
          nmreq_consecutivo := acr.QB_GEST_PRUEBAS_PSICOTECNICAS.fb_requisicion_actual(UPPER(vctdc_td_epl), nmepl_nd);
     EXCEPTION
     WHEN OTHERS THEN
          vcmensajeproceso := 'No se encuentran reuisicion asignada para la cedula: '||nmepl_nd;
          RAISE exSalir;
     END;
     vcBancoHV   := 'BHV '||vctdc_td_epl||' '||nmepl_nd||'';
     vcSeleccion := 'SEL '||vctdc_td_epl||' '||nmepl_nd||'';
     vcProceso   := 'PROCESO '||nmreq_consecutivo;

     BEGIN
		OPEN CU_TAXONOMIA_PARAM;
		FETCH CU_TAXONOMIA_PARAM INTO nmtxp_codigo;
		CLOSE CU_TAXONOMIA_PARAM;

		IF nmtxp_codigo IS NULL THEN
			vcmensajeproceso := 'No se encuentran creadas las carpetas de Seleccion o proceso para el candidato con cedula '||nmepl_nd;
			RAISE exSalir;
		END IF;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
          vcmensajeproceso := 'No se encuentran creadas las carpetas de Seleccion o proceso para el candidato con cedula '||nmepl_nd;
          RAISE exSalir;
     END ;

     BEGIN
		OPEN CU_DATA_ERP (nmtxp_codigo);
		FETCH CU_DATA_ERP INTO nmaz_codigo_cli;
		CLOSE CU_DATA_ERP;

		IF nmaz_codigo_cli IS NULL THEN
			vcmensajeproceso := 'No se encontro el azd_codigo_cli Error interno.';
			RAISE exSalir;
		END IF;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
          vcmensajeproceso := 'No se encontro el azd_codigo_cli Error interno.';
          RAISE exSalir;
     END;


     BEGIN
          SELECT PRU_DESCRIPCION
            INTO vcNombreArchivo
            FROM PSI_PRUEBA
           WHERE PRU_CODIGO IN
                 (SELECT H.PRU_CODIGO
                   FROM HOMOLOGACION_PRU_PSI H
                  WHERE H.COD_TERCERO = nmtipo_prueba
                    AND H.ORI_ORIGEN = 1) -- [1] RHT
            AND ROWNUM<2;
     EXCEPTION
     WHEN NO_DATA_FOUND THEN
          vcNombreArchivo:=NULL;
     END;

     vcestadoproceso  := 'S';
     vcmensajeproceso := 'Ejecutado con exito';
EXCEPTION
WHEN exsalir THEN
     vcestadoproceso  :='N';
WHEN OTHERS THEN
     vcestadoproceso  :='N';
     vcmensajeproceso :='Error causado en pl causado por'||sqlerrm;
END pl_consulta_iib_Az;
--}

--{fl_rtn_tipo_document
FUNCTION fl_rtn_tipo_document(nmtpd_codigo NUMBER
                             ,vccolumna    VARCHAR2
                             ) RETURN VARCHAR2
IS
     vcquery        VARCHAR2(4000);
     VCvalor        VARCHAR2(4000);
BEGIN

     IF nmtpd_codigo IS NULL  THEN
          RETURN NULL;
     END IF;

     vcquery:='
      SELECT '||vccolumna||'
        FROM ADM.tipo_documento
       WHERE tpd_codigo = '||nmtpd_codigo;

     EXECUTE IMMEDIATE vcquery INTO  VCvalor;

      RETURN nvl(VCvalor,'0');
EXCEPTION
WHEN OTHERS THEN
     RETURN SQLERRM;
END fl_rtn_tipo_document;
--}fl_rtn_tipo_document
PROCEDURE PL_UPD_NOMBREDIR(NMDEA_CODIGO     NUMBER,
                        VCNOMBRE_DIR    VARCHAR2,
                        VCESTADO_PROCESO  OUT VARCHAR2,
                        VCMENSAJE_PROCESO OUT VARCHAR2)IS
 nmtxp_codigo    NUMBER;
 nmaz_codigo     NUMBER;
BEGIN
    select txp_codigo,azd_codigo
    into nmtxp_codigo,nmaz_codigo
    from adm.data_erp_az
    where dea_codigo = NMDEA_CODIGO;
    update adm.taxonomia_param
    set txp_descripcion =VCNOMBRE_DIR
    where txp_codigo =nmtxp_codigo;

    update adm.az_digital
    set AZD_NOMBRE_RUTA =VCNOMBRE_DIR
    where azd_codigo =nmaz_codigo;

    COMMIT;

    VCESTADO_PROCESO := 'S';
    VCMENSAJE_PROCESO := 'Procedimiento ejecutado exitosamente';
exception
    when others then
        VCESTADO_PROCESO := 'N';
        VCMENSAJE_PROCESO := 'Ocurrio un error en QB_LGC_GESTOR_DOCUMENTAL.PL_UPD_NOMBREDIR ' || SQLERRM;
END PL_UPD_NOMBREDIR;
--}PL_UPD_NOMBREDIR

--{PL DOCUMENTOS POR ACUERDO
PROCEDURE PL_DOCUMENTOS_ACUERDO(
                            NMEPL_ND      IN NUMBER
                           ,CSCONSULTA            OUT csCursor
                           ,vcmensajeproceso      OUT VARCHAR2  --DETALLE ESTADO DEL PROCESO
                           ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N
)IS
     vcquery varchar2(4000);
     vcerror  varchar2(4000);
BEGIN

     OPEN CSCONSULTA FOR
SELECT tpd.tpd_codigo        tpd_codigo
                , tpd.tpd_descripcion   tpd_descripcion
                , tpd.dtd_codigo        dtd_codigo
                , prd.prd_codigo        prd_codigo
             FROM ADM.tipo_documento tpd
                , ADM.propiedades_documento prd
            WHERE tpd.tpd_codigo = prd.tpd_codigo
              AND tpd.dtd_codigo in  (SELECT det_dom.dtd_codigo
                                        FROM ACR.empresa_acuerdo emp_acu
                                           , acr.acuerdo_cliente acu_cli
                                           , ACR.acuerdo_cliente_detalle acc_det
                                           , acr.detalle_dominio DET_dom
                                       WHERE emp_acu.emp_acu_codigo = acu_cli.emp_acu_codigo
                                         AND acc_det.acc_codigo = acu_cli.acc_codigo
                                         AND TRIM(UPPER(DET_dom.dtd_descripcion)) = TRIM(upper(acc_det.dac_valor_atr_detalle))
                                         AND emp_acu.TDC_TD_FIL = (SELECT tdc_td FROM requisicion where req_consecutivo=(SELECT req_consecutivo FROM
                                                                                                                        (SELECT * FROM requisicion_hoja_vida WHERE epl_nd = NMEPL_ND
                                                                                                                        ORDER BY rqhv_fecha DESC)WHERE ROWNUM = 1))
                                         AND emp_acu.emp_nd_fil = (SELECT emp_nd FROM requisicion where req_consecutivo=(SELECT req_consecutivo FROM
                                                                                                                        (SELECT * FROM requisicion_hoja_vida WHERE epl_nd = NMEPL_ND
                                                                                                                        ORDER BY rqhv_fecha DESC)WHERE ROWNUM = 1))
                                         --AND acu_cli.atr_nombre IN('DOCUMENTOS SELECCION','DOCUMENTOS DE SELECCION')
                                         AND det_dom.dom_codigo IN (68,69)--cODIGO DE LA AGRUPACION PARA SELECCION
                                         AND acu_cli.aga_codigo = 22 );

EXCEPTION
WHEN OTHERS THEN
     vcquery :='---';
     vcerror:='error causado por:'||sqlerrm;

END PL_DOCUMENTOS_ACUERDO;
--}PL_DOCUMENTOS_ACUERDO
END QB_LGC_GESTOR_DOCUMENTAL;