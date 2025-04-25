CREATE OR REPLACE PACKAGE RHU.EMAIL_PKG AS
--****************************************************************
--** NOMBRE SCRIPT        : prhu0739.sql
--** OBJETIVO             : Crear el paquete EMAIL_PKG en el esquema actual, el cual contiene el procedimiento SEND_BULK_EMAILS
--**                        encargado de enviar correos electrónicos masivos.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
    PROCEDURE SEND_BULK_EMAILS;
END EMAIL_PKG;
/
create or replace PACKAGE BODY     RHU.EMAIL_PKG AS
--****************************************************************
--** NOMBRE SCRIPT        : prhu0739.sql
--** OBJETIVO             : Implementar el cuerpo del paquete EMAIL_PKG, con la lógica del procedimiento
--**                        SEND_BULK_EMAILS para enviar correos electrónicos personalizados con plantilla HTML
--**                        e incluir control de errores y actualización del estado del candidato.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
    PROCEDURE SEND_BULK_EMAILS IS
    vcDe                 VARCHAR2(200);
    vcError              VARCHAR2(4000);
    vcFirstName          VARCHAR2(200);

        CURSOR c_candidates IS
            SELECT CBU_IDENTIFICATION_TYPE, CBU_IDENTIFICATION_NUMBER,CBU_EMAIL
            FROM RHU.CANDIDATE_BULK_UPLOAD
            WHERE CBU_STATUS = 'PENDING';

        v_CBU_IDENTIFICATION_TYPE VARCHAR2(3);
        v_CBU_IDENTIFICATION_NUMBER NUMBER(20);
        v_CBU_EMAIL VARCHAR2(250);
        v_plantilla LONG; 
        vcPlantillaMove LONG;

    BEGIN           
        BEGIN

    v_plantilla := '<table role="presentation" width="100%" cellspacing="0" cellpadding="0" border="0" align="center">
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/BANNER.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="http://apps.activos.com.co/JADM0017/outside/Registro.xhtml" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/Hola.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/oficinas-activos/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/VISITANOS.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/PORQUE%20_.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="http://apps.activos.com.co/JADM0017/outside/Registro.xhtml" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/TU%20PROXIMO.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://www.activos.com.co/preguntas-frecuentes-activos/" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/Equipo.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
    <tr>
        <td align="center">
            <a href="https://storage.googleapis.com/bucket_prueba_grupo/POL%C3%8DTICAS%20DE%20MANEJO%20DE%20INFORMACI%C3%93N%20Y%20PRIVACIDAD.pdf" target="_blank">
                <img src="https://storage.googleapis.com/bucket_prueba_grupo/TRATAMIENTO.jpg" width="100%" style="max-width: 760px; display: block; cursor: pointer;">
            </a>
        </td>
    </tr>
</table>';
        vcDe:='notificacion@activos.com.co';
        END;

        FOR rec IN c_candidates LOOP
            v_CBU_IDENTIFICATION_TYPE := rec.CBU_IDENTIFICATION_TYPE;
            v_CBU_IDENTIFICATION_NUMBER := rec.CBU_IDENTIFICATION_NUMBER;
            v_CBU_EMAIL := rec.CBU_EMAIL;

            SELECT EPL_NOM1 INTO vcFirstName FROM RHU.EMPLEADO 
            WHERE EPL_ND=rec.CBU_IDENTIFICATION_NUMBER 
            AND TDC_TD=rec.CBU_IDENTIFICATION_TYPE ;

            vcPlantillaMove:=REPLACE(v_plantilla,'$EPL_NOM1',vcFirstName);

            pb_envia_x_e_delivery (
	                      vcDe    --vcde         
                          ,TRIM(rec.CBU_EMAIL)   --vcpara    
                          ,NULL     --vcccopia     
                          ,NULL   --vcc_oculta   
                          ,''||vcFirstName||', Tu futuro comienza aquí | Completa tu registro en Activos'       --vcasunto     
                          ,v_plantilla   --MENSAJE
						  ,null           --vcruta
                          ,null           --vcadjunto
                          ,null           --vcReporte 
                          ,null           --vcBuzonError
                          ,null           --nmrequerimiento
                          ,'JUFORERO'           --vcusuario    
                          ,vcerror        --vcerror IN OUT 
                          );

            UPDATE RHU.CANDIDATE_BULK_UPLOAD
            SET CBU_STATUS = 'SENT'
            WHERE CBU_IDENTIFICATION_TYPE = v_CBU_IDENTIFICATION_TYPE
            AND v_CBU_IDENTIFICATION_NUMBER = CBU_IDENTIFICATION_NUMBER;

        END LOOP;

        COMMIT;

    END SEND_BULK_EMAILS;

END EMAIL_PKG;