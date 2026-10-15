import boto3
import json
from datetime import datetime, timezone

MINIO_ENDPOINT = "http://localhost:9000"
MINIO_ACCESS_KEY = "minioadmin"
MINIO_SECRET_KEY = "minioadmin123"

client = boto3.client(
    "s3",
    endpoint_url=MINIO_ENDPOINT,
    aws_access_key_id=MINIO_ACCESS_KEY,
    aws_secret_access_key=MINIO_SECRET_KEY,
    region_name="us-east-1",
)

# Conteúdo do arquivo de teste
test_data = {
    "mensagem": "Teste de conectividade com o MinIO",
    "timestamp": datetime.now(timezone.utc).isoformat(),
    "camada": "bronze",
    "status": "ok",
}

# Definir o caminho do objeto no bucket (particionamento por data)
hoje = datetime.now()
object_key = f"_testes/ano={hoje.year}/mes={hoje.month:02d}/dia={hoje.day:02d}/teste_conexao.json"

# Upload
print("📤 Fazendo upload do arquivo de teste...")
client.put_object(
    Bucket="bronze",
    Key=object_key,
    Body=json.dumps(test_data, indent=2, ensure_ascii=False),
    ContentType="application/json",
)
print(f"   ✅ Arquivo enviado para: bronze/{object_key}")

# Verificar existência
response = client.head_object(Bucket="bronze", Key=object_key)
tamanho = response["ContentLength"]
print(f"\n📋 Metadados do arquivo:")
print(f"   Tamanho: {tamanho} bytes")
print(f"   Tipo: {response['ContentType']}")
print(f"   Última modificação: {response['LastModified']}")

# Download e verificação
print("\n📥 Fazendo download e verificando conteúdo...")
obj = client.get_object(Bucket="bronze", Key=object_key)
conteudo = json.loads(obj["Body"].read().decode("utf-8"))
assert conteudo["status"] == "ok", "Erro: conteúdo do arquivo não confere!"
print(f"   ✅ Conteúdo verificado: {conteudo['mensagem']}")
print("\n🎉 MinIO está funcionando corretamente!")

