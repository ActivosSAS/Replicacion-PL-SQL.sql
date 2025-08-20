-- ===============================================================
-- Sequence for primary key
-- ===============================================================
CREATE SEQUENCE RHU.SEQ_DATA_ORIGIN_LOG
 START WITH 1
 INCREMENT BY 1
 NOCACHE
 NOCYCLE;

-- ===============================================================
-- Table definition
-- ===============================================================
CREATE TABLE RHU.DATA_ORIGIN_LOG (
    ID_LOG          NUMBER       PRIMARY KEY,
    DOCUMENT_TYPE   VARCHAR2(5)  NOT NULL,
    DOCUMENT_NUMBER VARCHAR2(20) NOT NULL,
    DATA_SOURCE     VARCHAR2(50) NOT NULL,
    CREATED_AT      DATE         DEFAULT SYSDATE NOT NULL,
    CREATED_BY      VARCHAR2(50) DEFAULT USER    NOT NULL
);
GRANT ALL ON RHU.DATA_ORIGIN_LOG TO PUBLIC;

-- ===============================================================
-- Column comments
-- ===============================================================
COMMENT ON TABLE  RHU.DATA_ORIGIN_LOG IS 'Audit table to track the origin of data records (e.g. GCP recruiter).';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.ID_LOG IS 'Primary key identifier for each log record.';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.DOCUMENT_TYPE IS 'Type of document (e.g. CC, TI, NIT).';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.DOCUMENT_NUMBER IS 'Document number associated with the record.';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.DATA_SOURCE IS 'Source system or process where the data originated (e.g. RECRUITER_GCP).';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.CREATED_AT IS 'Date and time when the log record was created.';
COMMENT ON COLUMN RHU.DATA_ORIGIN_LOG.CREATED_BY IS 'Database user who created the log record.';

-- ===============================================================
-- Trigger to auto-generate ID_LOG
-- ===============================================================
CREATE OR REPLACE TRIGGER RHU.TRG_DATA_ORIGIN_LOG
BEFORE INSERT ON RHU.DATA_ORIGIN_LOG
FOR EACH ROW
BEGIN
  IF :NEW.ID_LOG IS NULL THEN
    SELECT RHU.SEQ_DATA_ORIGIN_LOG.NEXTVAL
      INTO :NEW.ID_LOG
      FROM dual;
  END IF;
END;
/
CREATE UNIQUE INDEX UQ_DATA_ORIGIN_LOG
ON RHU.DATA_ORIGIN_LOG (DOCUMENT_TYPE, DOCUMENT_NUMBER);