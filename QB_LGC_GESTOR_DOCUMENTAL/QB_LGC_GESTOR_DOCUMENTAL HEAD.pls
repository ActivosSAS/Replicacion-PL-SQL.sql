create or replace PACKAGE      ADM.QB_LGC_GESTOR_DOCUMENTAL AS
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
--** ACTUALIZACION		  : JUPATARROYO 25/03/2022
--** DESCRIPCION          : Se agregan cursores para evitar errores al capturar consulta por mas de una fila, en los procedimientos:
--							pl_cslt_ContratacionOC, pl_cslt_SEL_PC, pl_cslt_SeleccionRC, pl_consulta_iib_Az
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
    --{MAP
    TYPE hashmap IS RECORD (llave VARCHAR2(4000), valor CLOB);
    TYPE LISTAHASHMAP IS TABLE OF hashmap INDEX BY BINARY_INTEGER;
    --}

   TYPE csCursor                IS REF CURSOR;
/*<Crear procedimiento que realize la busqueda del ultimo id de la estructura de carpetas,
 segun la estructura padre que recibe; la cual seria la empresa principal y usuaria
 (taxionomia de seleccion y taxionomia de contratos)>
*/
--{pl_cslt_ContratacionOC
PROCEDURE pl_cslt_ContratacionOC(VCtdc_td_ppal         IN VARCHAR2    --PRINCIPAL
                                ,NMemp_nd              IN NUMBER      --PRINCIPAL
                                ,VCtdc_td_fil          IN VARCHAR2    --FILIAL
                                ,NMemp_nd_fil          IN NUMBER      --FIALIAL
                                ,vcCarpetagen          IN VARCHAR2    --oRDENES cONTRATACIoN (OC)
                                ,dtfecha               IN DATE
                                ,vcSede		          IN VARCHAR2
                                ,vcEstado	          IN VARCHAR2
                                ,vcFechaOC	          IN VARCHAR2
                                ,NMDEA_CODIGO_RTN     OUT NUMBER      --ID TABLA AZDIGITAL
                                ,NMAZ_CODIGO_CLI_RTN  OUT VARCHAR2    --ID PROVEEDOR
                                ,vcmensajeproceso     OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                                ,vcestadoproceso      OUT VARCHAR2
                               );
--{pl_cslt_SEL_PC
PROCEDURE pl_cslt_SEL_PC(VCtdc_td_ppal         IN  VARCHAR2    --PRINCIPAL
                        ,NMemp_nd              IN  NUMBER      --PRINCIPAL
                        ,VCtdc_td_fil          IN  VARCHAR2    --FILIAL
                        ,NMemp_nd_fil          IN  NUMBER      --FIALIAL
                        ,vccarpetagen          IN  VARCHAR2     --Carpeta generica Procesos seleccion (SEL)
                        ,vcCarpetaCandito      IN VARCHAR2    --CArpeta candidato
                        ,vcproceso             IN VARCHAR2    --NOMBRE PROCESO
                        ,NMDEA_CODIGO_RTN     OUT NUMBER      --ID TABLA AZDIGITAL
                        ,NMAZ_CODIGO_CLI_RTN  OUT VARCHAR2    --ID PROVEEDOR
                        ,vcmensajeproceso     OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                        ,vcestadoproceso      OUT VARCHAR2);   --ESTADO S/N
--}pl_cslt_SEL_PC

--{pl_cslt_SeleccionRC
PROCEDURE pl_cslt_SeleccionRC(VCtdc_td_ppal          IN VARCHAR2
                             ,NMemp_nd               IN NUMBER
                             ,VCtdc_td_fil           IN VARCHAR2
                             ,NMemp_nd_fil           IN NUMBER
                             ,vccarpetagen           IN VARCHAR2
                             ,dtfecha                IN DATE
                             ,vcsede                 IN VARCHAR2
                             ,vcestado               IN VARCHAR2
                             ,nmrequisicion          IN NUMBER
                             ,NMDEA_CODIGO_RTN      OUT NUMBER
                             ,NMAZ_CODIGO_CLI_RTN   OUT VARCHAR2
                             ,vcmensajeproceso      OUT VARCHAR2
                             ,vcestadoproceso       OUT VARCHAR2);
--}pl_cslt_SeleccionRC


--{pl_cslt_BancoHV
PROCEDURE pl_cslt_BancoHV(vctdc_td_epl           IN VARCHAR2
                         ,nmepl_nd               IN NUMBER
                         ,vcestado               IN VARCHAR2
                         ,nmprd_codigo           IN NUMBER
                         ,NMDEA_CODIGO_RTN      OUT NUMBER
                         ,NMAZ_CODIGO_CLI_RTN   OUT VARCHAR2
                         ,vcmensajeproceso      OUT VARCHAR2
                         ,vcestadoproceso       OUT VARCHAR2);
--}pl_cslt_BancoHV


--{fl_rtn_tpx_codigo
FUNCTION fl_rtn_taxonomia_param(nmtxp_codigo NUMBER    --pk_tabla
                               ,vccolumna    VARCHAR2  --Columna
                               ) RETURN VARCHAR2;
--}fl_rtn_tpx_codigo

--{fl_rtn_data_erp_az
FUNCTION fl_rtn_data_erp_az(nmdea_codigo NUMBER    --pk_tabla
                           ,vccolumna    VARCHAR2  --Columna
                           ) RETURN VARCHAR2;
--}fl_rtn_data_erp_az

--{fl_rtn_data_erp_az
FUNCTION fl_rtn_az_digital(nmaz_codigo NUMBER
                          ,vccolumna    VARCHAR2
                          ) RETURN VARCHAR2;
--}fl_rtn_data_erp_az

--{PL_RTN_QUERY_NIVEL
PROCEDURE PL_RTN_QUERY_NIVEL(n_count     IN NUMBER
                            ,VCQUERY    OUT VARCHAR2
                            ,VCERROR    OUT VARCHAR2);
--}PL_RTN_QUERY_NIVEL

--{pl_rtn_documentos
PROCEDURE pl_rtn_documentos(NMDEA_CODIGO_RTN      IN NUMBER
                           ,CSCONSULTA            OUT csCursor
                           ,vcmensajeproceso      OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                           ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N

);
--}pl_rtn_documentos

--{pl_rtrn_lista_acuerdo
PROCEDURE pl_rtrn_lista_acuerdo(nmagu_codigo           IN NUMBER
                               ,vctdc_td_fil           IN VARCHAR2
                               ,nmemp_nd_fil           IN NUMBER
                               ,CSCONSULTA            OUT csCursor
                               ,vcmensajeproceso      OUT VARCHAR2  --DETALLE ESTADO DEL PROCESO
                               ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N
                               ) ;
--}pl_rtrn_lista_acuerdo

--{pl_ins_gestor
PROCEDURE pl_ins_gestor(nmTIP_FLUJO              IN NUMBER
                       ,vcNOMTABLA               IN VARCHAR2
                       ,vcTXP_DESCRIPCION        IN VARCHAR2
                       ,nmdea_codigoPAdre        IN NUMBER
                       ,nmPRD_CODIGO             IN NUMBER  --SI NO ES NULO ES POR QUE ES LA PROPIEDAD DE UN ARCHIVO
                       ,vcNOM_ARCHIVO            IN OUT VARCHAR2
                       ,vcAUD_USUARIO            IN VARCHAR2
                       ,nmDEA_CODIGO            OUT VARCHAR2
                       ,vcmensajeproceso        OUT VARCHAR2
                       ,vcestadoproceso         OUT VARCHAR2
);
--}pl_ins_gestor

--{PL_UPD_CODIGO_CLI
PROCEDURE PL_UPD_CODIGO_CLI(nmDEA_CODIGO             IN NUMBER
                           ,NMAZ_CODIGO_CLI          IN NUMBER
                           ,vcnombreArchivo          IN VARCHAR2
                           ,vcmensajeproceso        OUT VARCHAR2
                           ,vcestadoproceso         OUT VARCHAR2);
--}PL_UPD_CODIGO_CLI

PROCEDURE pl_ins_respuesta_ws(cltramaEnviaXML             IN CLOB
                             ,cltramaRespuestaXML         IN CLOB
                             ,CSCONSULTA                 OUT csCursor
                             ,vcestadoproceso            OUT VARCHAR2
                             ,vcmensajeproceso           OUT VARCHAR2);




--{PL_VAL_DOCUMENTO
PROCEDURE PL_VAL_DOCUMENTO(vctpd_descripcion  IN VARCHAR2 --nOMBRE ARCHIVO
                          ,Vctxp_Descripcion  IN VARCHAR2 --NOMBRE CARPETA
                          ,vcestadoproceso   OUT VARCHAR2
                          ,vcmensajeproceso  OUT VARCHAR2);
--}PL_VAL_DOCUMENTO

--{pl_eliminar_documento
PROCEDURE pl_eliminar_documento(nmdea_codigo       IN NUMBER
                               ,vcestadoproceso   OUT VARCHAR2
                               ,vcmensajeproceso  OUT VARCHAR2
);
--}pl_eliminar_documento

--{PL_DIRPADRE_REQ
PROCEDURE PL_DIRPADRE_REQ(VCTXP_DESCRIPCION IN VARCHAR2
                         ,vcestadoproceso   OUT VARCHAR2
                         ,vcmensajeproceso  OUT VARCHAR2);
--}PL_DIRPADRE_REQ

-- desierra 27/04/2022
  PROCEDURE PL_OBTENER_TIPO(
        vcdocumento      IN VARCHAR, --CORRESPONDE AL ID DE TIPO DE DOCUMENTO
        rctipo_doc       OUT cscursor,
        vcestadoproceso  OUT VARCHAR,
        vcmensajeproceso OUT VARCHAR
    );

-- desierra 27/04/2022

--{PL_OBTENER_TIPODOC
PROCEDURE PL_OBTENER_TIPODOC(VCDOCUMENTO       IN VARCHAR,
                             NMTIPO_ESTUDIO    IN NUMBER, --CORRESPONDE AL TTE_CODIGO DE LA TABLA tsel_tipo_estudio
                             RCTIPO_DOC       OUT csCursor,
                             vcestadoproceso  OUT VARCHAR,
                             vcmensajeproceso OUT VARCHAR);
--}PL_OBTENER_TIPODOC

--{PL_DOCUMENTOS_BASICOS
PROCEDURE PL_DOCUMENTOS_BASICOS(RCDOCUMENTOS       OUT csCursor,
                                 vcestadoproceso  OUT VARCHAR,
                                 vcmensajeproceso OUT VARCHAR);
--}PL_DOCUMENTOS_BASICOS

-- desierra 27/04/2022
PROCEDURE PL_DOCUMENTOS_BASICOS(
                                 nmdea_codigo_rtn IN NUMBER,
                                 RCDOCUMENTOS  OUT csCursor,
                                 vcestadoproceso  OUT VARCHAR,
                                 vcmensajeproceso OUT VARCHAR);
-- desierra 27/04/2022

--{PL_OBTENER_TIPODOC_BASICO
PROCEDURE PL_OBTENER_TIPODOC_BASICO(NMTIPO_DOC       IN NUMBER,
                                     RCTIPO_DOC       OUT csCursor,
                                     vcestadoproceso  OUT VARCHAR,
                                     vcmensajeproceso OUT VARCHAR);
--}PL_OBTENER_TIPODOC_BASICO

--{pb_generar_HV_PDF
PROCEDURE pb_generar_HV_PDF(vctdc_td         IN VARCHAR2
                           ,nmepl_nd         IN NUMBER
                           ,nmrequisicion    IN NUMBER
                           ,VCurl            OUT VARCHAR2
                           ,VCERROR          OUT VARCHAR2);
--}pb_generar_HV_PDF

--{PL_OBTENER_TIPODOC
PROCEDURE PL_OBTENER_TIPODOC(VCDOCUMENTO       IN VARCHAR,
                             RCTIPO_DOC       OUT csCursor,
                             vcestadoproceso  OUT VARCHAR,
                             vcmensajeproceso OUT VARCHAR);
--}PL_OBTENER_TIPODOC


--{
PROCEDURE pl_cslt_numero_sig(nmdea_codigoPAdre        IN NUMBER
                            ,nmPRD_CODIGO             IN NUMBER
                            ,vcNUMERO                OUT VARCHAR2
                            ,vcmensajeproceso        OUT VARCHAR2
                            ,vcestadoproceso         OUT VARCHAR2
                            );
--}

--{PL_DELETE_DATA_ERP
PROCEDURE PL_DELETE_DATA_ERP(NMDEA_CODIGO IN NUMBER
                             ,VCESTADO_PROCESO  OUT VARCHAR2
                             ,VCMENSAJE_PROCESO OUT VARCHAR2);
--}

--{pl_mover_az
PROCEDURE pl_mover_az(NMDEA_CODIGO_ACT         IN NUMBER
                  ,NMDEA_CODIGO_MOV         IN NUMBER
                  ,vcmensajeproceso        OUT VARCHAR2
                  ,vcestadoproceso         OUT VARCHAR2
                  );
--}pl_mover_az

--{pl_consulta_iib_Az
PROCEDURE pl_consulta_iib_Az(vctdc_td_epl        IN VARCHAR2
                            ,nmepl_nd            IN NUMBER
                            ,nmtipo_prueba       IN NUMBER
                            ,nmaz_codigo_cli    OUT NUMBER
                            ,vcNombreArchivo    OUT VARCHAR2
                            ,vcestadoproceso    OUT VARCHAR2
                            ,vcmensajeproceso   OUT VARCHAR2
                            );
--}pl_consulta_iib_Az

--{fl_rtn_tipo_document
FUNCTION fl_rtn_tipo_document(nmtpd_codigo NUMBER    --pk_tabla
                             ,vccolumna    VARCHAR2  --Columna
                           ) RETURN VARCHAR2;

PROCEDURE PL_UPD_NOMBREDIR(NMDEA_CODIGO        NUMBER,
                           VCNOMBRE_DIR        VARCHAR2,
                           VCESTADO_PROCESO    OUT VARCHAR2,
                           VCMENSAJE_PROCESO   OUT VARCHAR2);

--{PL_DOCUMENTOS_ACUERDO
PROCEDURE PL_DOCUMENTOS_ACUERDO(NMEPL_ND      IN NUMBER
                           ,CSCONSULTA            OUT csCursor
                           ,vcmensajeproceso      OUT VARCHAR2    --DETALLE ESTADO DEL PROCESO
                           ,vcestadoproceso       OUT VARCHAR2  --ESTADO S/N

);
--}PL_DOCUMENTOS_ACUERDO

END QB_LGC_GESTOR_DOCUMENTAL;
