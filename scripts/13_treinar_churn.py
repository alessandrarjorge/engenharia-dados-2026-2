"""Treina um modelo de churn a partir da Gold (s3://gold/ml/features_clientes.parquet)."""
import json
import os
from datetime import datetime, timezone
from pathlib import Path

import duckdb
import joblib
from sklearn.ensemble import HistGradientBoostingClassifier
from sklearn.metrics import average_precision_score, roc_auc_score
from sklearn.model_selection import train_test_split

GOLD_ROOT = os.getenv("GOLD_ROOT", "s3://gold")
SAIDA = Path(os.getenv("CURSO_HOME", ".")) / "data" / "modelos"

con = duckdb.connect()
if GOLD_ROOT.startswith("s3://"):
    con.execute("INSTALL httpfs; LOAD httpfs;")
    con.execute(f"""CREATE SECRET minio (TYPE s3, KEY_ID '{os.getenv("MINIO_ACCESS_KEY", "minioadmin")}',
        SECRET '{os.getenv("MINIO_SECRET_KEY", "minioadmin123")}', ENDPOINT '{os.getenv("MINIO_ENDPOINT", "localhost:9000")}',
        URL_STYLE 'path', USE_SSL false, REGION 'us-east-1')""")

df = con.sql(f"SELECT * FROM read_parquet('{GOLD_ROOT}/ml/features_clientes.parquet')").df()
X, y = df.drop(columns=["cliente_id", "churn"]), df["churn"]
X_tr, X_te, y_tr, y_te = train_test_split(X, y, test_size=0.25, random_state=42, stratify=y)

modelo = HistGradientBoostingClassifier(random_state=42).fit(X_tr, y_tr)
proba = modelo.predict_proba(X_te)[:, 1]
metricas = {
    "treinado_em": datetime.now(timezone.utc).isoformat(),
    "linhas": len(df),
    "taxa_churn": round(float(y.mean()), 4),
    "roc_auc": round(roc_auc_score(y_te, proba), 4),
    "pr_auc": round(average_precision_score(y_te, proba), 4),
    "features": list(X.columns),
}
SAIDA.mkdir(parents=True, exist_ok=True)
joblib.dump(modelo, SAIDA / "churn.joblib")
(SAIDA / "churn_metricas.json").write_text(json.dumps(metricas, indent=2, ensure_ascii=False))
print(json.dumps(metricas, indent=2, ensure_ascii=False))
