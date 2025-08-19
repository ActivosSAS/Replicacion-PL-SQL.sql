import gspread
import pandas as pd
import oracledb as cx_Oracle
from google.oauth2.service_account import Credentials

# 📁 Ruta a tu archivo de credenciales
SERVICE_ACCOUNT_FILE = "credenciales.json"

# 🔐 Alcances requeridos
SCOPES = ["https://www.googleapis.com/auth/spreadsheets", "https://www.googleapis.com/auth/drive"]

# ⚙️ Autenticación con Google Sheets
creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
gc = gspread.authorize(creds)

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
WHERE ROWNUM <= 200
ORDER BY ID_RD DESC
"""

df = pd.read_sql(query, conn)
conn.close()

# 📄 Crear o abrir la hoja
spreadsheet_title = "Dashboard_Replicacion"
try:
    sh = gc.open(spreadsheet_title)
except gspread.SpreadsheetNotFound:
    sh = gc.create(spreadsheet_title)
worksheet = sh.sheet1
worksheet.clear()
worksheet.update([df.columns.values.tolist()] + df.values.tolist())

print("✅ Datos exportados a Google Sheets con éxito.")
