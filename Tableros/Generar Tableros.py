import gspread
import pandas as pd
import oracledb as cx_Oracle
from gspread.oauth import authorize

# Autenticación por OAuth usando tu cuenta de Gmail
gc = authorize()  # Te pedirá autenticación la primera vez

# Conexión a Oracle
dsn = cx_Oracle.makedsn("192.168.21.147", 1521, service_name="TEST")
conn = cx_Oracle.connect(user="juforero", password="Test2028", dsn=dsn)

query = """
SELECT
    ID_RD,
    DOCUMENT_TYPE,
    DOCUMENT_NUMBER,
    ID_CONFIG,
    STATE_RD,
    TO_CHAR(DATA_JSON) AS DATA_JSON,
    DATE_RD,
    USER_RD,
    DESCRIPTION_RD
FROM RHU.Replication_Detail
WHERE ROWNUM <= 100
ORDER BY ID_RD DESC
"""

df = pd.read_sql(query, conn)
conn.close()

# Crear o abrir la hoja de Google
try:
    sh = gc.open("Dashboard_Replicacion")
except gspread.SpreadsheetNotFound:
    sh = gc.create("Dashboard_Replicacion")
worksheet = sh.sheet1
worksheet.clear()
worksheet.update([df.columns.values.tolist()] + df.values.tolist())

print("✅ Datos subidos correctamente con tu cuenta personal.")
