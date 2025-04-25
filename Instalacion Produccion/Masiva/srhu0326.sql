--****************************************************************
--** NOMBRE SCRIPT        : srhu0326.sql
--** OBJETIVO             : Insertar registros iniciales en la tabla Replication_Config del esquema RHU, configurando las referencias locales y de GCP junto con el estado inicial de cada configuración.
--** ESQUEMA              : RHU
--** AUTOR                : JUFORERO
--** FECHA CREACION       : 13/04/2025
--****************************************************************
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.HOJA_VIDA_RESTRICCIONES', 'BlockData', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.REQUISICION_HOJA_VIDA', 'RequisitionData', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'RHU.CONTRATO', 'AgreementData', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'PAR.REQUISICION_HOJA_VIDA', 'UserDocumentaryReview', 'Active');
INSERT INTO RHU.Replication_Config (ID_CONFIG, LOCAL_TABLE_REF, GCP_TABLE_REF, STATUS_RC) 
VALUES (NULL, 'Observaciones', 'RemarkData', 'Active');
