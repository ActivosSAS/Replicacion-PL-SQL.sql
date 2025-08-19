import pandas as pd

# 📄 Leer Excel
df = pd.read_excel("MASIVO PARA PRUEBA DE PRODCUTIVIDAD.xlsx")
df.columns = df.columns.str.strip()
df = df.rename(columns={'Número de identificación': 'cedula'})
df['cedula'] = df['cedula'].astype(str).str.strip()
cedulas = [c for c in df['cedula'] if c.isdigit()]

# 🧱 Construir WITH virtual
with_clause = "WITH cedulas_excel (EPL_ND) AS (\n"
with_clause += "    SELECT {} FROM DUAL".format(cedulas[0])
for ced in cedulas[1:]:
    with_clause += f"\n    UNION ALL\n    SELECT {ced} FROM DUAL"
with_clause += "\n)\n"

# 🧾 Consulta principal
query = with_clause + """
SELECT
    c.EPL_ND,
    e.TDC_TD,
    e.EPL_APELL1,
    e.EPL_APELL2,
    e.EPL_NOM1,
    e.EPL_NOM2,
    CASE
        WHEN e.EPL_ND IS NOT NULL THEN 'SI'
        ELSE 'NO'
    END AS EXISTE
FROM cedulas_excel c
LEFT JOIN EMPLEADO e ON c.EPL_ND = e.EPL_ND;
"""

# 💾 Guardar archivo
with open("consulta_validacion_empleado.sql", "w") as f:
    f.write(query)

print("✅ Archivo generado: consulta_validacion_empleado.sql")
