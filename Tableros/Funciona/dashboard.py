import streamlit as st
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime
from calendar import monthrange
import matplotlib.pyplot as plt
from streamlit_autorefresh import st_autorefresh
st.set_page_config(page_title="Dashboard Replicación", layout="wide")


# Selección del tiempo de refresco en minutos
refresh_minutes = st.sidebar.slider("⏱ Actualizar cada (minutos)", min_value=1, max_value=60, value=1)

# Convertir minutos a milisegundos
refresh_interval = refresh_minutes * 60 * 1000

# Activar autorefresh
st_autorefresh(interval=refresh_interval, key="auto_refresh")




st.title("📊 Dashboard - Replication Detail RHU")

# 🔄 Botón para actualizar
if st.button("🔄 Actualizar Datos"):
    st.rerun()

# 📅 Fecha actual y selección
hoy = datetime.today()
mes_actual = hoy.month
año_actual = hoy.year

col1, col2 = st.columns(2)
with col1:
    año_sel = st.selectbox("📅 Año", list(range(año_actual, año_actual - 5, -1)), index=0)
with col2:
    meses = {1: "Enero", 2: "Febrero", 3: "Marzo", 4: "Abril", 5: "Mayo", 6: "Junio",
             7: "Julio", 8: "Agosto", 9: "Septiembre", 10: "Octubre", 11: "Noviembre", 12: "Diciembre"}
    mes_sel = st.selectbox("📆 Mes", list(meses.keys()), format_func=lambda x: meses[x], index=mes_actual - 1)

# 🗓️ Rango de fechas
fecha_inicio = f"{año_sel}-{mes_sel:02d}-01"
ultimo_dia = monthrange(año_sel, mes_sel)[1]
fecha_fin = f"{año_sel}-{mes_sel:02d}-{ultimo_dia}"

# 🔗 Conexión Oracle
engine = create_engine("oracle+oracledb://juforero:Test2029@192.168.21.147:1521/?service_name=TEST")

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
WHERE TO_DATE(DATE_RD, 'YYYY-MM-DD HH24:MI:SS') 
      BETWEEN TO_DATE(:fecha_ini, 'YYYY-MM-DD') 
      AND TO_DATE(:fecha_fin, 'YYYY-MM-DD')
ORDER BY ID_RD DESC
"""

with engine.connect() as conn:
    df = pd.read_sql(query, conn, params={"fecha_ini": fecha_inicio, "fecha_fin": fecha_fin})

df.columns = df.columns.str.lower()
df["date_rd"] = pd.to_datetime(df["date_rd"], errors="coerce")
df["fecha"] = df["date_rd"].dt.date

# ----------------------------
# 🎛️ Filtros dinámicos
# ----------------------------
col1, col2, col3, col4 = st.columns(4)
with col1:
    estado = st.selectbox("Filtrar por Estado", ["Todos"] + sorted(df["state_rd"].dropna().unique()))
with col2:
    usuario = st.selectbox("Filtrar por Usuario", ["Todos"] + sorted(df["user_rd"].dropna().unique()))
with col3:
    tipo_doc = st.selectbox("Filtrar por Tipo de Documento", ["Todos"] + sorted(df["document_type"].dropna().unique()))
with col4:
    id_config = st.selectbox("Filtrar por ID Config", ["Todos"] + sorted(df["id_config"].dropna().unique()))

if estado != "Todos":
    df = df[df["state_rd"] == estado]
if usuario != "Todos":
    df = df[df["user_rd"] == usuario]
if tipo_doc != "Todos":
    df = df[df["document_type"] == tipo_doc]
if id_config != "Todos":
    df = df[df["id_config"] == id_config]
# ----------------------------
# 📋 Tabla final
# ----------------------------
st.subheader("📋 Detalle de Registros")
st.dataframe(df, use_container_width=True)

# ----------------------------
# 📌 Métricas resumen
# ----------------------------
st.subheader("📌 Resumen")
col1, col2, col3, col4 = st.columns(4)
col1.metric("Total Registros", len(df))
col2.metric("Estados Únicos", df["state_rd"].nunique())
col3.metric("Días Activos", df["fecha"].nunique())
col4.metric("Top Usuario", df["user_rd"].value_counts().idxmax() if not df.empty else "N/A")

# ----------------------------
# 📊 Gráficos
# ----------------------------
st.subheader("📊 Visualizaciones")

# Gráfico 1 y 2: por Estado y Evolución temporal
col1, col2 = st.columns(2)

with col1:
    st.markdown("**Registros por Estado**")
    st.bar_chart(df["state_rd"].value_counts())

with col2:
    st.markdown("**Evolución por Día**")
    evolucion = df.groupby(["fecha", "state_rd"]).size().unstack(fill_value=0)
    st.line_chart(evolucion)

# Gráfico 3 y 4: por Usuario+Estado y Tipo Documento
col1, col2 = st.columns(2)

with col1:
    st.markdown("**Registros por Usuario y Estado**")
    pivot_table = df.pivot_table(index="user_rd", columns="state_rd", aggfunc="size", fill_value=0)
    st.bar_chart(pivot_table)

with col2:
    st.markdown("**Registros por Tipo de Documento**")
    st.bar_chart(df["document_type"].value_counts())

# Gráfico 5: ID_CONFIG con descripción
# Forzar tipo int por seguridad
df["id_config"] = df["id_config"].astype(int)

# Diccionario descriptivo
config_labels = {
    1: "BlockData (PAR.HOJA_VIDA_RESTRICCIONES)",
    2: "RequisitionData (PAR.REQUISICION_HOJA_VIDA)",
    3: "AgreementData (RHU.CONTRATO)",
    4: "UserDocReview (PAR.REQUISICION_HOJA_VIDA)",
    6: "BasicData (RHU.EMPLEADO)"




}

# Crear nueva columna antes de cualquier filtro
df["id_config_label"] = df["id_config"].map(config_labels)

col1, col2 = st.columns(2)

# Columna 1: gráfico de barras vertical (opcional)
with col1:
    st.markdown("**Gráfico Horizontal - ID_CONFIG**")
    config_counts = df["id_config_label"].value_counts()

    fig, ax = plt.subplots(figsize=(6, 4))
    config_counts.plot(kind="barh", ax=ax, color="#4DA8DA")
    ax.set_title("ID_CONFIG (Descriptivo)")
    ax.set_xlabel("Cantidad")
    ax.set_ylabel("")
    
    st.pyplot(fig)



