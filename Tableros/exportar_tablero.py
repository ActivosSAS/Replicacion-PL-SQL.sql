import pandas as pd
import oracledb as cx_Oracle
from gspread.oauth import authorize

# 🔐 Autenticación con Google Sheets (OAuth desde credenciales.json)
gc = authorize()

# 🔄 Conexión a Oracle
dsn = cx_Oracle.makedsn("192.168.21.147", 1521, service_name="TEST")
conn = cx_Oracle.connect(user="juforero", password="Test2028", dsn=dsn)

# 🧾 Consulta Oracle
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

# 📄 Buscar o crear la hoja en Google Sheets
spreadsheet_title = "Dashboard_Replicacion"

try:
    sh = gc.open(spreadsheet_title)
except:
    sh = gc.create(spreadsheet_title)

worksheet = sh.sheet1
worksheet.clear()
worksheet.update([df.columns.values.tolist()] + df.values.tolist())

print("✅ Datos exportados exitosamente a Google Sheets.")
