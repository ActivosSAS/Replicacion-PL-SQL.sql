--******************************************************************
--** SCRIPT NAME        : trhu0832.sql
--** PURPOSE            : Crear tabla de documentos requeridos y su carga inicial
--** SCHEMA             : RHU
--** AUTHOR             : JUFORERO
--** CREATION DATE      : 14/01/2025
--** ENVIRONMENT        : Producción
--** SOURCE SYSTEM      : RHU (Recursos Humanos)
--******************************************************************

-- ========================================
-- 1. Creación de la tabla RHU.REQUIRED_DOCUMENTS
-- ========================================
CREATE TABLE RHU.REQUIRED_DOCUMENTS (
    DOCUMENT_CODE NUMBER PRIMARY KEY,          -- Código único del documento
    DOCUMENT_NAME VARCHAR2(100)                -- Nombre del documento requerido
);

COMMENT ON TABLE RHU.REQUIRED_DOCUMENTS IS 'Tabla que almacena el listado de documentos requeridos por el área de Seleccion. trhu0832.sql';
COMMENT ON COLUMN RHU.REQUIRED_DOCUMENTS.DOCUMENT_CODE IS 'Código identificador único para cada tipo de documento requerido.';
COMMENT ON COLUMN RHU.REQUIRED_DOCUMENTS.DOCUMENT_NAME IS 'Nombre o descripción del documento requerido.';

-- ========================================
-- 2. Asignación de permisos de acceso
-- ========================================
GRANT ALL ON RHU.REQUIRED_DOCUMENTS TO PUBLIC;

-- ========================================
-- 3. Carga inicial de documentos requeridos
-- ========================================
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (23, 'DOCUMENTO DE IDENTIDAD');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (25, 'CERTIFICADO ANTECEDENTES JUDICIALES POLICIA');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (26, 'CERTIFICADO ANTECEDENTES JUDICIALES PROCURADURIA');
INSERT INTO RHU.REQUIRED_DOCUMENTS (DOCUMENT_CODE, DOCUMENT_NAME) VALUES (27, 'CERTIFICADO ANTECEDENTES JUDICIALES CONTRALORIA');

-- ========================================
-- 4. Confirmación de cambios
-- ========================================
COMMIT;

