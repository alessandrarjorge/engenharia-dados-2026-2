# scripts/12_carga_incremental_demo.py
import io, boto3, pandas as pd
from datetime import datetime, timezone

s3 = boto3.client("s3", endpoint_url="http://localhost:9000", aws_access_key_id="minioadmin",
                  aws_secret_access_key="minioadmin123", region_name="us-east-1")
chave = next(o["Key"] for o in s3.list_objects_v2(Bucket="bronze", Prefix="ecommerce_sintetico/")["Contents"]
             if o["Key"].endswith(".parquet"))
df = pd.read_parquet(io.BytesIO(s3.get_object(Bucket="bronze", Key=chave)["Body"].read())).tail(500).copy()
df["id_pedido"] += 1_000_000
df["_ingerido_em"] = datetime.now(timezone.utc).isoformat()

hoje = datetime.now()
destino = f"ecommerce_sintetico/ano={hoje:%Y}/mes={hoje:%m}/dia={hoje:%d}/pedidos_{int(hoje.timestamp())}.parquet"
buffer = io.BytesIO(); df.to_parquet(buffer, index=False)
s3.put_object(Bucket="bronze", Key=destino, Body=buffer.getvalue())
print("Nova carga:", destino)
