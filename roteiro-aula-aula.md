# Tema 1 — Atividades Práticas - Ingestão de Dados
## Engenharia de Dados com Ferramentas Open Source

**Curso:** Engenharia de Dados com Ferramentas Open Source
**Aula:** 1 — Fundamentos da Engenharia de Dados e Arquitetura de Repositórios
**Duração das Atividades:** 2 horas
**Pré-requisitos:** Conhecimento básico de Python e linha de comando (terminal)

---

## Visão Geral das Atividades

As três atividades práticas desta aula formam uma sequência progressiva e interdependente. A **Atividade 1** prepara o ambiente completo que será utilizado ao longo de todo o curso. A **Atividade 2** coloca esse ambiente em operação, subindo o serviço de armazenamento de objetos MinIO que simulará o Data Lake local. A **Atividade 3** introduz os formatos de arquivo fundamentais para engenharia de dados, demonstrando na prática por que o formato Parquet é o padrão da indústria para repositórios analíticos.

| Atividade | Tema | Duração Estimada | Ferramentas |
|---|---|---|---|
| 1 | Configuração do Ambiente de Desenvolvimento | 40 min | Docker, Docker Compose, Python 3.11+, Git |
| 2 | Subida e Exploração do MinIO (Data Lake Local) | 30 min | Docker Compose, MinIO, Python (`boto3`) |
| 3 | Comparação de Formatos de Arquivo: CSV, JSON e Parquet | 50 min | Python, Pandas, PyArrow, Jupyter Notebook |

---

## Atividade 1 — Configuração do Ambiente de Desenvolvimento

### Objetivo

Preparar o ambiente de desenvolvimento local que será utilizado ao longo de todo o curso, garantindo que todas as ferramentas necessárias estejam instaladas, configuradas e funcionando corretamente. Um ambiente bem configurado é o alicerce de qualquer projeto de engenharia de dados.

### Contexto

Diferentemente de ambientes de produção em nuvem, o ambiente local do curso utiliza **Docker** e **Docker Compose** para isolar e orquestrar os serviços necessários (MinIO, bancos de dados, ferramentas de processamento). Essa abordagem garante reprodutibilidade: o ambiente funcionará da mesma forma em qualquer máquina, independentemente do sistema operacional do aluno. Ao final, os arquivos produzidos e as imagens poderão ser utilizados como base para ambientes de produção com o uso de Kubernetes.

### Pré-requisitos de Hardware

O ambiente mínimo recomendado para executar todas as ferramentas do curso é de 8 GB de RAM e 20 GB de espaço em disco disponível. Ambientes com 16 GB de RAM proporcionarão uma experiência mais fluida, especialmente nas aulas de Apache Spark.

---

### Passo 1 — Instalação do Docker e Docker Compose

O Docker é a plataforma de conteinerização que permite executar serviços complexos como MinIO e Airflow com um único comando, sem necessidade de instalação manual de dependências.


Instale o [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop/), que requer o WSL 2 (Windows Subsystem for Linux) habilitado. Siga as instruções do instalador.

**Verificação:**

```cmd
# Verificar a versão do Docker
docker --version
# Saída esperada: Docker version 24.x.x, build ...

# Verificar o Docker Compose
docker compose version
# Saída esperada: Docker Compose version v2.x.x
```

---

### Passo 2 — Instalação do Python 3.11+ e Gerenciador de Pacotes

O Python é a linguagem principal do curso. Recomenda-se fortemente o uso de ambientes virtuais para isolar as dependências de cada projeto.

```cmd
python --version
```

### Se não estiver instalado, será oferecida a opção de instalar da Microsoft Store que é a forma mais simples de efetuar essa instalação.

---

### Passo 3 — Instalação do Git e Configuração Inicial

O Git será utilizado para versionar todos os scripts e configurações desenvolvidos ao longo do curso.

Faça o download do instalador a partir do seguinte link:  https://git-scm.com/install/windows

---

---

### Passo 4 — Criação da Estrutura de Diretórios do Projeto

Toda a estrutura do curso seguirá uma organização padronizada que reflete a arquitetura Medallion. Execute os comandos abaixo para criar o projeto base:

```cmd
PS C:\ mkdir ~/engenharia-dados-2026-2
PS C:\ cd ~/engenharia-dados-2026-2
PS C:\Users\mamaz\engenharia-dados-2026-2> mkdir notebooks, scripts, dbt_project, airflow/dags, docker, data/bronze, data/silver, data/gold
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > notebooks/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > scripts/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > dbt_project/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > airflow/dags/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > docker/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > data/bronze/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > data/silver/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> echo "" > data/gold/README.md
PS C:\Users\mamaz\engenharia-dados-2026-2> python -m venv .venv
PS C:\Users\mamaz\engenharia-dados-2026-2> Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
PS C:\Users\mamaz\engenharia-dados-2026-2> .\.venv\Scripts\Activate.ps1
PS C:\Users\mamaz\engenharia-dados-2026-2> pip install pandas pyarrow boto3 jupyter notebook
```
---

### Passo 5 — Inicialização do Repositório Git

Crie um arquivo .gitignore com o seguinte conteúdo na pasta engenharia-dados:

Abra o arquivo utilizando o vscode:
```cmd
PS C:\Users\mamaz\engenharia-dados-2026-2> code .gitignore
```

Copie o seguinte conteúdo:

```cmd
.venv
__pycache__/
*.pyc

.ipynb_checkpoints

data/

.env
*.log
```

Nosso primeiro commit:

```cmd
PS C:\Users\mamaz\engenharia-dados-2026-2> git init
PS C:\Users\mamaz\engenharia-dados-2026-2> git config user.name "Seu Nome"
PS C:\Users\mamaz\engenharia-dados-2026-2> git config user.email "Seu email"
PS C:\Users\mamaz\engenharia-dados-2026-2> git config --list
PS C:\Users\mamaz\engenharia-dados-2026-2> git add .
PS C:\Users\mamaz\engenharia-dados-2026-2> git commit -m "feat: estrutura inicial do projeto do curso"
```

### Verificação Final da Atividade 1

Execute o script abaixo para confirmar que o ambiente está corretamente configurado (arquivo scripts/teste_instalacao_python.py):

```python
import sys
import subprocess

checks = {
    "Python 3.11+": sys.version_info >= (3, 11),
    "pandas": False,
    "pyarrow": False,
    "boto3": False,
    "jupyter": False,
}

for lib in ["pandas", "pyarrow", "boto3", "jupyter"]:
    try:
        __import__(lib)
        checks[lib] = True
    except ImportError:
        pass

print("=== Verificação do Ambiente ===")
for item, status in checks.items():
    icon = "✅" if status else "❌"
    print(f"  {icon}  {item}")

all_ok = all(checks.values())
print()
if all_ok:
    print("🎉 Ambiente configurado com sucesso! Pronto para a Atividade 2.")
else:
    print("⚠️  Alguns itens precisam de atenção. Revise os passos acima.")
```

Para executar:

```cmd
PS C:\Users\mamaz\engenharia-dados-2026-2> python .\scripts\teste_instalacao_python.py
```

---

## Atividade 2 — Subida e Exploração do MinIO (Data Lake Local)

### Objetivo

Configurar e inicializar o **MinIO**, um servidor de armazenamento de objetos de alto desempenho compatível com a API do Amazon S3. O MinIO será a fundação do Data Lake local utilizado em todas as aulas do curso, simulando o comportamento de serviços de nuvem como Amazon S3, Google Cloud Storage e Azure Blob Storage.

### Contexto

Em ambientes de produção, Data Lakes são construídos sobre serviços de armazenamento de objetos em nuvem (principalmente o Amazon S3). O MinIO replica essa interface localmente, permitindo que todos os scripts e ferramentas desenvolvidos no curso funcionem em produção sem alterações de código — apenas mudando as credenciais e o endpoint de conexão.

A compatibilidade com a API S3 é fundamental: ferramentas como Apache Spark, DuckDB, dbt e Apache Airflow se conectam ao MinIO exatamente da mesma forma que se conectariam ao S3 real.

---

### Passo 1 — Criação do Arquivo Docker Compose para o MinIO

```bash
cd ~/engenharia-dados-2026-2/docker

cat > compose.yml << 'EOF'
services:
  minio:
    image: docker.io/pgsty/silo:RELEASE.2026-09-16T00-00-00Z   # fixe a versão; evite "latest"
    container_name: minio-datalake
    ports:
      - "9000:9000" # API S3
      - "9001:9001" # Console web
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
      MINIO_UPDATE: "off"
    volumes:
      - minio_data:/data
    command: server /data --console-address ":9001"
    healthcheck:
      # a imagem é mínima (UBI micro) e pode não ter curl; usa o mc embutido
      test: ["CMD", "mc", "ready", "local"]
      interval: 15s
      timeout: 10s
      retries: 5
      start_period: 10s
    restart: unless-stopped

volumes:
  minio_data:
    driver: local
EOF
```

> **Nota de Segurança:** As credenciais `minioadmin` / `minioadmin123` são adequadas apenas para desenvolvimento local. Em ambientes de produção, utilize credenciais fortes e gerencie-as com ferramentas de gerenciamento de segredos como HashiCorp Vault ou AWS Secrets Manager.

---

### Passo 2 — Inicialização do Serviço MinIO

```bash
# Navegar para o diretório docker
cd ~/engenharia-dados-2026-2/docker

# Iniciar o MinIO em segundo plano
docker compose up -d

# Verificar se o contêiner está rodando
docker compose ps

# Acompanhar os logs de inicialização
docker compose logs minio
```

A saída esperada dos logs deve conter uma linha similar a:

```
MinIO Object Storage Server
Copyright: 2015-2024 MinIO, Inc.
License: GNU AGPLv3
Version: RELEASE.2024-01-01T00-00-00Z

API: http://0.0.0.0:9000
WebUI: http://0.0.0.0:9001
```

---

### Passo 3 — Acesso ao Console Web do MinIO

Abra o navegador e acesse `http://localhost:9001`. Utilize as credenciais configuradas:

- **Usuário:** `minioadmin`
- **Senha:** `minioadmin123`

Após o login, você verá o painel de administração do MinIO. Explore a interface para se familiarizar com os conceitos de **Buckets** (equivalentes a pastas raiz no S3) e **Objects** (os arquivos armazenados).

---

### Passo 4 — Criação dos Buckets da Arquitetura Medallion via Python

Em vez de criar os buckets manualmente pela interface gráfica, utilizaremos Python com a biblioteca `boto3` para automatizar essa tarefa — uma prática essencial em engenharia de dados.

Crie o arquivo `scripts/setup_minio.py`:

```python
# scripts/setup_minio.py
"""
Script de configuração inicial do MinIO.
Cria os buckets correspondentes às camadas da Arquitetura Medallion:
  - bronze: dados brutos, sem transformação
  - silver: dados limpos e conformados
  - gold:   dados curados, prontos para consumo
"""

import boto3
from botocore.exceptions import ClientError

# Configuração da conexão com o MinIO local
MINIO_ENDPOINT = "http://localhost:9000"
MINIO_ACCESS_KEY = "minioadmin"
MINIO_SECRET_KEY = "minioadmin123"

# Buckets a serem criados (camadas Medallion)
BUCKETS = [
    {
        "name": "bronze",
        "description": "Dados brutos ingeridos das fontes originais, sem transformação."
    },
    {
        "name": "silver",
        "description": "Dados limpos, padronizados e integrados."
    },
    {
        "name": "gold",
        "description": "Dados curados e modelados para Analytics e Machine Learning."
    },
]


def create_s3_client():
    """Cria e retorna um cliente S3 configurado para o MinIO local."""
    return boto3.client(
        "s3",
        endpoint_url=MINIO_ENDPOINT,
        aws_access_key_id=MINIO_ACCESS_KEY,
        aws_secret_access_key=MINIO_SECRET_KEY,
        region_name="us-east-1",  # Valor obrigatório, mas ignorado pelo MinIO
    )


def create_bucket(client, bucket_name: str) -> bool:
    """
    Cria um bucket no MinIO.
    Retorna True se criado com sucesso, False se já existia.
    """
    try:
        client.create_bucket(Bucket=bucket_name)
        return True
    except ClientError as e:
        error_code = e.response["Error"]["Code"]
        if error_code == "BucketAlreadyOwnedByYou":
            return False  # Bucket já existe — não é um erro
        raise  # Re-lança erros inesperados


def list_buckets(client) -> list:
    """Retorna a lista de buckets existentes no MinIO."""
    response = client.list_buckets()
    return [b["Name"] for b in response.get("Buckets", [])]


def main():
    print("=" * 55)
    print("  Configuração do Data Lake Local (MinIO)")
    print("  Arquitetura Medallion — Bronze / Silver / Gold")
    print("=" * 55)

    client = create_s3_client()

    for bucket in BUCKETS:
        name = bucket["name"]
        created = create_bucket(client, name)
        status = "✅ Criado" if created else "⚠️  Já existia"
        print(f"\n  [{name.upper()}]  {status}")
        print(f"  Descrição: {bucket['description']}")

    print("\n" + "=" * 55)
    print("  Buckets disponíveis no MinIO:")
    for b in list_buckets(client):
        print(f"    🪣  {b}")
    print("=" * 55)
    print("\n  ✅ Data Lake local configurado com sucesso!")
    print("  Acesse o console em: http://localhost:9001")


if __name__ == "__main__":
    main()
```

Execute o script:

```bash
cd ~/engenharia-dados-2026-2
source .venv/bin/activate
python scripts/setup_minio.py
```

A saída esperada é:

```
=======================================================
  Configuração do Data Lake Local (MinIO)
  Arquitetura Medallion — Bronze / Silver / Gold
=======================================================

  [BRONZE]  ✅ Criado
  Descrição: Dados brutos ingeridos das fontes originais, sem transformação.

  [SILVER]  ✅ Criado
  Descrição: Dados limpos, padronizados e integrados.

  [GOLD]  ✅ Criado
  Descrição: Dados curados e modelados para Analytics e Machine Learning.

=======================================================
  Buckets disponíveis no MinIO:
    🪣  bronze
    🪣  silver
    🪣  gold
=======================================================

  ✅ Data Lake local configurado com sucesso!
```

---

### Passo 5 — Teste de Upload e Download de Arquivo

Valide que o MinIO está funcionando corretamente fazendo upload e download de um arquivo de teste:

```python
# scripts/test_minio_connection.py
"""
Teste de conectividade com o MinIO.
Realiza upload de um arquivo de teste, verifica sua existência
e faz o download para confirmar a integridade.
"""

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
```

```bash
python scripts/test_minio_connection.py
```

---

### Verificação Final da Atividade 2

Ao final desta atividade, o aluno deve ser capaz de:

1. Confirmar que o contêiner MinIO está em execução com `docker compose ps`
2. Acessar o console web em `http://localhost:9001` e visualizar os 3 buckets criados (`bronze`, `silver`, `gold`)
3. Ver o arquivo de teste em `bronze/_testes/...` no console web
4. Compreender a estrutura de particionamento por data (`ano=YYYY/mes=MM/dia=DD`) que será utilizada ao longo do curso

---

## Atividade 3 — Comparação de Formatos de Arquivo: CSV, JSON e Parquet

### Objetivo

Demonstrar empiricamente as diferenças de desempenho, eficiência de armazenamento e capacidade de consulta entre os formatos CSV, JSON e Parquet. Esta atividade fundamenta a escolha do Parquet como formato padrão para Data Lakes e explica por que ele é o pilar dos formatos de tabela modernos como Apache Iceberg e Delta Lake.

### Contexto

A escolha do formato de arquivo tem impacto direto no custo de armazenamento e na velocidade de processamento de um Data Lake. O formato **Parquet** é colunar, comprimido e fortemente tipado — características que o tornam até 10 vezes mais eficiente que o CSV para cargas analíticas típicas, onde se lê apenas um subconjunto das colunas de um dataset grande.

Esta atividade utiliza o dataset **Iris** do UCI Machine Learning Repository para os exemplos básicos, e dados sintéticos para demonstrar as diferenças de escala.

---

### Passo 1 — Criação do Jupyter Notebook

```bash
cd ~/engenharia-dados-curso-2026-2
source .venv/Scripts/activate

# Iniciar o Jupyter Notebook
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser

# O terminal exibirá uma URL com token de acesso, por exemplo:
# http://127.0.0.1:8888/tree?token=abc123...
```

Acesse a URL exibida no terminal e crie um novo notebook em `notebooks/` com o nome `aula1_formatos_arquivo.ipynb`.

---

### Passo 2 — Importações e Configuração Inicial

No notebook, execute as células a seguir em sequência:

```python
# Célula 1 — Importações
import pandas as pd
import numpy as np
import pyarrow as pa
import pyarrow.parquet as pq
import json
import os
import time
import boto3
from pathlib import Path
from datetime import datetime, timezone

print(f"Pandas: {pd.__version__}")
print(f"PyArrow: {pa.__version__}")
print("✅ Bibliotecas importadas com sucesso!")
```

```python
# Célula 2 — Configuração do cliente MinIO
s3_client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

# Diretório temporário local para os arquivos gerados
Path("../data/bronze/iris").mkdir(parents=True, exist_ok=True)
Path("../data/bronze/sintetico").mkdir(parents=True, exist_ok=True)
print("✅ Diretórios e conexão MinIO configurados!")
```
---

### Passo 3 — Carregamento e Exploração do Dataset Iris

```python
# Célula 3 — Carregamento do dataset Iris
# O dataset Iris está disponível diretamente no repositório UCI
# Fonte: https://archive.ics.uci.edu/dataset/53/iris

URL_IRIS = (
    "https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"
)

COLUNAS_IRIS = [
    "comprimento_sepala_cm",
    "largura_sepala_cm",
    "comprimento_petala_cm",
    "largura_petala_cm",
    "especie",
]

df_iris = pd.read_csv(URL_IRIS, header=None, names=COLUNAS_IRIS)

# Adicionar metadados de ingestão (prática da camada Bronze)
df_iris["_fonte"] = "uci_iris"
df_iris["_ingerido_em"] = datetime.now(timezone.utc).isoformat()
df_iris["_versao_schema"] = "1.0"

print(f"Shape do dataset: {df_iris.shape}")
print(f"\nTipos de dados:\n{df_iris.dtypes}")
print(f"\nPrimeiras 5 linhas:")
df_iris.head()
```

```python
# Célula 4 — Estatísticas descritivas do dataset
print("=== Estatísticas Descritivas ===")
print(df_iris.describe())
print(f"\nDistribuição por espécie:")
print(df_iris["especie"].value_counts())
```

---

### Passo 4 — Geração de Dataset Sintético para Testes de Escala

O dataset Iris possui apenas 150 linhas, insuficiente para demonstrar diferenças de performance. Vamos gerar um dataset sintético de 1 milhão de registros que simula dados de transações de e-commerce:

```python
# Célula 5 — Geração do dataset sintético (1 milhão de registros)
print("Gerando dataset sintético de 1.000.000 registros...")
inicio = time.time()

np.random.seed(42)
N = 1_000_000

CATEGORIAS = ["Eletrônicos", "Roupas", "Alimentos", "Livros", "Esportes"]
STATUS = ["concluido", "cancelado", "pendente", "reembolsado"]
REGIOES = ["Sudeste", "Sul", "Nordeste", "Norte", "Centro-Oeste"]

df_sintetico = pd.DataFrame({
    "id_pedido": range(1, N + 1),
    "id_cliente": np.random.randint(1, 100_001, N),
    "id_produto": np.random.randint(1, 10_001, N),
    "categoria": np.random.choice(CATEGORIAS, N),
    "valor_unitario": np.round(np.random.uniform(5.0, 2000.0, N), 2),
    "quantidade": np.random.randint(1, 11, N),
    "status_pedido": np.random.choice(STATUS, N, p=[0.75, 0.10, 0.10, 0.05]),
    "regiao": np.random.choice(REGIOES, N),
    "data_pedido": pd.date_range(start="2022-01-01", periods=N, freq="30s"),
    "avaliacao_cliente": np.random.choice([1, 2, 3, 4, 5, None], N, p=[0.05, 0.08, 0.15, 0.30, 0.37, 0.05]),
    "_fonte": "sistema_ecommerce_v2",
    "_ingerido_em": datetime.now(timezone.utc).isoformat(),
})

# Calcular o valor total do pedido
df_sintetico["valor_total"] = (
    df_sintetico["valor_unitario"] * df_sintetico["quantidade"]
).round(2)

duracao = time.time() - inicio
print(f"✅ Dataset gerado em {duracao:.2f}s")
print(f"Shape: {df_sintetico.shape}")
print(f"Uso de memória: {df_sintetico.memory_usage(deep=True).sum() / 1024**2:.1f} MB")
```

---

### Passo 5 — Gravação nos Três Formatos

```python
# Célula 6 — Gravação do dataset sintético nos três formatos

BASE_PATH = Path("../data/bronze/sintetico")

# ── CSV ──────────────────────────────────────────────────────────────────────
print("Gravando CSV...")
inicio = time.time()
caminho_csv = BASE_PATH / "pedidos.csv"
df_sintetico.to_csv(caminho_csv, index=False)
tempo_escrita_csv = time.time() - inicio
tamanho_csv = caminho_csv.stat().st_size

# ── JSON (linhas) ─────────────────────────────────────────────────────────────
print("Gravando JSON Lines (JSONL)...")
inicio = time.time()
caminho_json = BASE_PATH / "pedidos.jsonl"
df_sintetico.to_json(caminho_json, orient="records", lines=True, date_format="iso")
tempo_escrita_json = time.time() - inicio
tamanho_json = caminho_json.stat().st_size

# ── Parquet (sem compressão) ──────────────────────────────────────────────────
print("Gravando Parquet (sem compressão)...")
inicio = time.time()
caminho_parquet_raw = BASE_PATH / "pedidos_sem_compressao.parquet"
df_sintetico.to_parquet(caminho_parquet_raw, index=False, compression=None)
tempo_escrita_parquet_raw = time.time() - inicio
tamanho_parquet_raw = caminho_parquet_raw.stat().st_size

# ── Parquet (Snappy — padrão da indústria) ────────────────────────────────────
print("Gravando Parquet (Snappy)...")
inicio = time.time()
caminho_parquet_snappy = BASE_PATH / "pedidos_snappy.parquet"
df_sintetico.to_parquet(caminho_parquet_snappy, index=False, compression="snappy")
tempo_escrita_parquet_snappy = time.time() - inicio
tamanho_parquet_snappy = caminho_parquet_snappy.stat().st_size

# ── Parquet (ZSTD — melhor compressão) ───────────────────────────────────────
print("Gravando Parquet (ZSTD)...")
inicio = time.time()
caminho_parquet_zstd = BASE_PATH / "pedidos_zstd.parquet"
df_sintetico.to_parquet(caminho_parquet_zstd, index=False, compression="zstd")
tempo_escrita_parquet_zstd = time.time() - inicio
tamanho_parquet_zstd = caminho_parquet_zstd.stat().st_size

print("\n✅ Todos os arquivos gravados!")
```

---

### Passo 6 — Comparação de Tamanho em Disco

```python
# Célula 7 — Tabela comparativa de tamanho em disco

def formatar_tamanho(bytes_val: int) -> str:
    """Formata bytes em MB com 1 casa decimal."""
    return f"{bytes_val / 1024**2:.1f} MB"

def reducao_percentual(base: int, comparado: int) -> str:
    """Calcula a redução percentual em relação ao CSV."""
    reducao = (1 - comparado / base) * 100
    return f"{reducao:.1f}% menor"

resultados_tamanho = {
    "Formato": ["CSV", "JSON Lines", "Parquet (sem compressão)", "Parquet (Snappy)", "Parquet (ZSTD)"],
    "Tamanho em Disco": [
        formatar_tamanho(tamanho_csv),
        formatar_tamanho(tamanho_json),
        formatar_tamanho(tamanho_parquet_raw),
        formatar_tamanho(tamanho_parquet_snappy),
        formatar_tamanho(tamanho_parquet_zstd),
    ],
    "Redução vs CSV": [
        "— (referência)",
        reducao_percentual(tamanho_csv, tamanho_json),
        reducao_percentual(tamanho_csv, tamanho_parquet_raw),
        reducao_percentual(tamanho_csv, tamanho_parquet_snappy),
        reducao_percentual(tamanho_csv, tamanho_parquet_zstd),
    ],
    "Tempo de Escrita (s)": [
        f"{tempo_escrita_csv:.2f}",
        f"{tempo_escrita_json:.2f}",
        f"{tempo_escrita_parquet_raw:.2f}",
        f"{tempo_escrita_parquet_snappy:.2f}",
        f"{tempo_escrita_parquet_zstd:.2f}",
    ],
}

df_tamanhos = pd.DataFrame(resultados_tamanho)
print("=== Comparativo de Tamanho em Disco (1.000.000 registros) ===")
print(df_tamanhos.to_string(index=False))
```

---

### Passo 7 — Comparação de Velocidade de Leitura

Esta é a demonstração mais importante: a leitura seletiva de colunas (column pruning), que é onde o Parquet demonstra sua maior vantagem sobre formatos baseados em linhas.

```python
# Célula 8 — Comparação de velocidade de leitura (arquivo completo)

REPETICOES = 3  # Número de repetições para calcular a média

def medir_tempo_leitura(funcao_leitura, repeticoes=REPETICOES):
    """Executa a função de leitura N vezes e retorna o tempo médio."""
    tempos = []
    for _ in range(repeticoes):
        inicio = time.time()
        funcao_leitura()
        tempos.append(time.time() - inicio)
    return sum(tempos) / len(tempos)

# Leitura completa
tempo_csv_completo = medir_tempo_leitura(
    lambda: pd.read_csv(caminho_csv)
)
tempo_json_completo = medir_tempo_leitura(
    lambda: pd.read_json(caminho_json, lines=True)
)
tempo_parquet_completo = medir_tempo_leitura(
    lambda: pd.read_parquet(caminho_parquet_snappy)
)

print(f"Leitura COMPLETA (1.000.000 linhas, todas as colunas):")
print(f"  CSV:     {tempo_csv_completo:.3f}s")
print(f"  JSON:    {tempo_json_completo:.3f}s")
print(f"  Parquet: {tempo_parquet_completo:.3f}s")
print(f"  → Parquet é {tempo_csv_completo / tempo_parquet_completo:.1f}x mais rápido que CSV")
```

```python
# Célula 9 — Leitura seletiva de colunas (column pruning)
# Esta é a vantagem FUNDAMENTAL do formato colunar

COLUNAS_ANALITICAS = ["categoria", "valor_total", "status_pedido", "regiao"]

# CSV: precisa ler TODAS as colunas e depois filtrar
tempo_csv_seletivo = medir_tempo_leitura(
    lambda: pd.read_csv(caminho_csv, usecols=COLUNAS_ANALITICAS)
)

# Parquet: lê APENAS as colunas solicitadas do disco
tempo_parquet_seletivo = medir_tempo_leitura(
    lambda: pd.read_parquet(caminho_parquet_snappy, columns=COLUNAS_ANALITICAS)
)

print(f"Leitura SELETIVA (apenas 4 de 14 colunas):")
print(f"  CSV:     {tempo_csv_seletivo:.3f}s  (ainda lê tudo do disco)")
print(f"  Parquet: {tempo_parquet_seletivo:.3f}s (lê apenas as colunas necessárias)")
print(f"  → Parquet é {tempo_csv_seletivo / tempo_parquet_seletivo:.1f}x mais rápido na leitura seletiva")
print()
print("💡 Em Data Lakes com petabytes de dados, essa diferença representa")
print("   economia de horas de processamento e centenas de dólares em custo de nuvem.")
```

---


### Passo 8 — Inspeção do Schema do Parquet

Uma das vantagens do Parquet é o armazenamento do schema (metadados de tipos) junto com os dados:

```python
# Célula 10 — Inspeção do schema do arquivo Parquet

schema_parquet = pq.read_schema(caminho_parquet_snappy)

print("=== Schema do Arquivo Parquet ===")
print(schema_parquet)
print()
print("=== Metadados do Arquivo ===")
metadata = pq.read_metadata(caminho_parquet_snappy)
print(f"Número de row groups: {metadata.num_row_groups}")
print(f"Número de colunas: {metadata.num_columns}")
print(f"Número de linhas: {metadata.num_rows:,}")
print(f"Tamanho serializado: {metadata.serialized_size:,} bytes")
print()
print("💡 O Parquet armazena o schema junto com os dados.")
print("   Isso elimina a necessidade de inferência de tipos na leitura,")
print("   garantindo consistência e evitando erros silenciosos.")
```

### Passo 9 — Upload dos Arquivos para o MinIO (Camada Bronze)

Após comparar os formatos, vamos fazer o upload do arquivo Parquet (o escolhido para o Data Lake) para o MinIO, seguindo a convenção de particionamento por data:

```python
# Célula 11 — Upload do Parquet para o MinIO (camada Bronze)

hoje = datetime.now()
prefixo_particao = f"ano={hoje.year}/mes={hoje.month:02d}/dia={hoje.day:02d}"

# Upload do Parquet Snappy para o bucket Bronze
chave_objeto = f"ecommerce_sintetico/{prefixo_particao}/pedidos.parquet"

print(f"📤 Fazendo upload para: bronze/{chave_objeto}")
inicio = time.time()

s3_client.upload_file(
    Filename=str(caminho_parquet_snappy),
    Bucket="bronze",
    Key=chave_objeto,
    ExtraArgs={"ContentType": "application/octet-stream"},
)

duracao = time.time() - inicio
print(f"✅ Upload concluido em {duracao:.2f}s")

# Verificar o objeto no MinIO
response = s3_client.head_object(Bucket="bronze", Key=chave_objeto)
print(f"\nMetadados no MinIO:")
print(f"  Tamanho: {response['ContentLength'] / 1024**2:.1f} MB")
print(f"  Última modificação: {response['LastModified']}")
print(f"\n🎉 Dado bruto armazenado na camada Bronze do Data Lake!")
print(f"   Acesse em: http://localhost:9001/browser/bronze")
```

---

### Passo 10 — Resumo Comparativo Final

```python
# Célula 12 — Resumo final comparativo

print("=" * 65)
print("  RESUMO COMPARATIVO — FORMATOS DE ARQUIVO PARA DATA LAKES")
print("=" * 65)

resumo = pd.DataFrame({
    "Característica": [
        "Tipo de armazenamento",
        "Compressão nativa",
        "Schema embutido",
        "Leitura seletiva de colunas",
        "Suporte a tipos complexos",
        "Legível por humanos",
        "Ideal para Data Lakes",
        "Suporte em ferramentas",
    ],
    "CSV": [
        "Orientado a linhas",
        "Não",
        "Não (inferido)",
        "Não (lê tudo)",
        "Não",
        "Sim",
        "❌ Não recomendado",
        "Universal",
    ],
    "JSON/JSONL": [
        "Orientado a linhas",
        "Não",
        "Não (inferido)",
        "Não (lê tudo)",
        "Sim (aninhado)",
        "Sim",
        "⚠️  Apenas para APIs",
        "Universal",
    ],
    "Parquet": [
        "Orientado a colunas",
        "Sim (Snappy/ZSTD)",
        "Sim (forte tipagem)",
        "Sim (column pruning)",
        "Sim (listas, mapas)",
        "Não (binário)",
        "✅ Padrão da indústria",
        "Spark, DuckDB, Iceberg...",
    ],
})

print(resumo.to_string(index=False))
print()
print("Conclusão: O formato Parquet com compressão Snappy ou ZSTD é o")
print("padrão da indústria para Data Lakes por combinar alta compressão,")
print("leitura seletiva de colunas e schema fortemente tipado.")
```

## Ingestão de Dados e a Camada Bronze

**Pré-requisitos:** ambiente Docker operacional, MinIO rodando com buckets Bronze/Silver/Gold criados, ambiente virtual Python ativo

---

## Visão Geral das Atividades

As três atividades a seguir constroem os primeiros pipelines de ingestão reais do curso, conectando fontes externas ao Data Lake local. A **Atividade 1** coloca o Airbyte em operação — uma plataforma visual de ingestão que elimina a necessidade de código para conectar dezenas de fontes de dados. A **Atividade 2** desenvolve um pipeline programático em Python com a biblioteca `dlt` (Data Load Tool), extraindo dados de duas APIs públicas com paginação e carregando-os diretamente no MinIO em formato Parquet. A **Atividade 3** consolida as boas práticas de organização da camada Bronze, implementando particionamento lógico por data e adicionando metadados de rastreabilidade a cada arquivo ingerido.

| Atividade | Tema | Duração Estimada | Ferramentas |
|---|---|---|---|
| 4 | Configuração do Airbyte e Criação de Conexões | 50 min | Docker Compose, Airbyte OSS |
| 5 | Pipeline de Ingestão com `dlt` + APIs Públicas | 60 min | Python, `dlt`, REST Countries API, PokeAPI |
| 6 | Organização da Camada Bronze com Particionamento | 40 min | Python, `boto3`, Parquet, MinIO |

> **Regra de ouro da camada Bronze:** dados ingeridos nesta camada nunca devem ser alterados após a gravação. O objetivo é preservar o dado exatamente como veio da fonte, acrescentando apenas metadados de rastreabilidade (timestamp de ingestão, nome da fonte, versão do schema). Qualquer transformação, limpeza ou enriquecimento ocorre exclusivamente nas camadas Silver e Gold.

---

## Atividade 4 — Configuração do Airbyte e Criação de Conexões

### Objetivo

Instalar e configurar o **Airbyte Open Source** via Docker Compose, explorar sua interface web e criar uma conexão completa entre uma fonte de dados externa (REST Countries API) e o MinIO (destino S3-compatível), demonstrando como uma plataforma de ingestão visual elimina a necessidade de código para o processo de extração e carga (o "EL" do paradigma ELT).

### Contexto

O Airbyte é uma plataforma open source de integração de dados que oferece mais de 350 conectores pré-construídos para bancos de dados, APIs, arquivos e serviços SaaS[[1]](https://airbyte.com/). Sua arquitetura baseada em contêineres Docker permite que cada conector seja executado de forma isolada, garantindo que uma falha em uma conexão não afete as demais. Em ambientes de produção, o Airbyte é implantado em Kubernetes para escalabilidade horizontal.

---

### Passo 1 — Adição do Airbyte ao Docker Compose

O Airbyte requer vários serviços internos (servidor, worker, banco de dados de metadados, servidor de temporalidade). A forma mais simples de instalá-lo localmente é utilizando o script oficial de instalação, que gerencia automaticamente todos esses serviços.

```bash
# Navegar para o diretório de trabalho do curso
cd ~/engenharia-dados-2026-2

# Criar um subdiretório dedicado ao Airbyte
mkdir -p airbyte && cd airbyte

```
--- 

### Instalação no Windows

### Passo 2 - Instalação do airbyte

Na página: https://github.com/airbytehq/abctl/releases/latest faça o download da versão para o windows.

Instalar o abctl.exe a partir do seguinte endereço:

[Airbyte](https://docs.airbyte.com/platform/using-airbyte/getting-started/oss-quickstart)

### Instalação como usuário não privilegiado:

Após fazer o download, extrair o arquivo.

Dentro da pasta que será criada, localize o arquivo abctl.exe.

Crie uma pasta airbyte em:

C:\Users\{seu_usuario}\AppData\Local\airbyte

Copie o arquivo abctl.exe para essa pasta.

Edite a sua variável de ambiente PATH e inclua o caminho: 

C:\Users\{seu_usuario}\AppData\Local\airbyte

Após terminar a instalação, configurar seu usuário e senha:

```cmd
abctl local install
```

ALTERNATIVO: Em máquinas com poucos recursos, use:

```cmd
abctl local install --low-resource-mode
```

```cmd
abctl local credentials --email SeuEmail --password SuaSenhaSegura
```

Se você quiser alterar sua senha, posteriormente:

```cmd
abctl local credentials --password SuaSenhaSegura
```

## A estrutura que será criada em nosso repositório ##
````
bronze/
└── airbyte/
└──-------rest-countries-api/
└──------------ 2026_10_14_193910319_0.parquet

````

Configuração do endpoint do airbyte:

![alt text](airbyte/image.png)

Configuração da fonte https:

Iremos utilizar a url do restcountries API que você pode encontrar em: 

[Rest Countries](https://restcountries.com/)

### Passo 3 — Acesso à Interface Web do Airbyte

Após termos feito a instalação do Airbyte, acessaremos a interface web do Airbyte:

```
URL:   http://localhost:8000
Usuário: airbyte
Senha:   password
```

Ao fazer login pela primeira vez, o Airbyte solicitará um e-mail para cadastro. Utilize qualquer e-mail válido (não é necessário confirmar). Explore brevemente a interface, identificando as seções principais:

| Seção | Descrição |
|---|---|
| **Sources** | Catálogo de conectores de origem (APIs, bancos de dados, arquivos) |
| **Destinations** | Conectores de destino (Data Warehouses, Data Lakes, bancos de dados) |
| **Connections** | Pipelines configurados (Source → Destination) com agendamento |
| **Settings** | Configurações gerais, notificações e integrações |

---

### Passo 4 — Configuração do Destination: MinIO (S3-Compatível)

Antes de criar a fonte de dados, configure o destino (MinIO) para que o Airbyte saiba onde gravar os dados extraídos.

Na interface do Airbyte, navegue até **Destinations → New Destination** e pesquise por **"S3"**. Selecione o conector **Amazon S3** e preencha os campos conforme abaixo:

| Campo | Valor |
|---|---|
| **Destination name** | `minio-bronze-local` |
| **S3 Bucket Name** | `bronze` |
| **S3 Bucket Path** | `airbyte/` |
| **S3 Bucket Region** | `us-east-1` |
| **Access Key ID** | `minioadmin` |
| **Secret Access Key** | `minioadmin123` |
| **S3 Endpoint** | `http://host.docker.internal:9000` |
| **Output Format** | `Parquet — Apache Parquet columnar storage` |
| **Compression Codec** | `SNAPPY` |
| **S3 Path Format** | `${NAMESPACE}/${STREAM_NAME}/${YEAR}_${MONTH}_${DAY}_${EPOCH}_` | 

> **Nota técnica:** O endereço `host.docker.internal` é utilizado porque o Airbyte roda dentro de contêineres Docker e precisa acessar o MinIO, que está em outro contêiner na mesma máquina. Em sistemas Linux, pode ser necessário adicionar `--add-host=host.docker.internal:host-gateway` ao `docker-compose.yaml` do Airbyte se a resolução falhar.

Clique em **Setup connection**. O Airbyte criará um arquivo de teste no bucket `bronze` para validar a conexão. Se o teste passar, o destino está configurado corretamente.

---

### Passo 5 — Configuração da Source: REST Countries API

Navegue até **Sources → New Source** e pesquise por **"REST Countries"** ou, alternativamente, utilize o conector genérico **"HTTP Request"** para maior flexibilidade.

A API rest-countries agora exisge uma chave de autenticação que precisa ser obtida em:


https://restcountries.com/apis


Para usar o conector HTTP genérico, selecione **"Need to build your own source"** e configure:

| Campo | Valor |
|---|---|
| **Source name** | `rest-countries-api` |
| **API Endpoint URL** | `https://api.restcountries.com/countries/v5?response_fields=names.common,codes.alpha_2,flag.emoji&pretty=1` |
| **HTTP Method** | `GET` |
| **Authenticator** | `Bearer Token Authentication` |
| **Token** | `Token da Api do Rest Countries` |

![alt text](airbyte/image2.png)


Clique em **Test**. O Airbyte fará uma requisição de teste à API e exibirá uma amostra dos dados retornados — um array JSON com informações de todos os países do mundo.

---

### Passo 6 — Criação da Connection (Pipeline Completo)

Antes de iniciar a configuração do pipeline é necessário criar uma chave de API para o airbyte em User->Applications, conforme imagem abaixo:

![alt text](airbyte/image.png)

Essa chave deverá ser fornecida na API Key do connector que será criado com Source e Destination configurados. Crie a conexão que define o pipeline de ingestão:

1. Navegue até **Connections → New Connection**
2. Selecione a source `rest-countries-api`
3. Selecione o destination `minio-bronze-local`
4. Configure os parâmetros da conexão:

| Parâmetro | Valor | Justificativa |
|---|---|---|
| **Connection name** | `countries-to-bronze` | Nome descritivo do pipeline |
| **Replication frequency** | `Manual` | Para controle manual durante o curso |
| **Sync mode** | `Full Refresh — Overwrite` | Dados cadastrais raramente mudam |
| **Namespace format** | `rest-countries-api` | Organiza os dados por namespace |

5. Clique em **Set up connection**
6. Execute a sincronização manualmente clicando em **Sync Now**

---

### Passo 7 — Verificação dos Dados no MinIO

Após a sincronização concluir (status **Succeeded**), verifique os dados no MinIO:

```bash
# Listar os objetos criados pelo Airbyte no bucket bronze
python3 - << 'EOF'
import boto3

client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

response = client.list_objects_v2(Bucket="bronze", Prefix="airbyte/")
objetos = response.get("Contents", [])

print(f"Objetos criados pelo Airbyte no bucket bronze: {len(objetos)}")
for obj in objetos:
    tamanho_kb = obj["Size"] / 1024
    print(f"  📄 {obj['Key']}  ({tamanho_kb:.1f} KB)")
EOF
```

Você deve ver arquivos Parquet criados pelo Airbyte no caminho `bronze/airbyte/rest-countries-api/...`. Acesse também o console web do MinIO em `http://localhost:9001` para visualizar os arquivos graficamente.

---

## Atividade 5 — Pipeline de Ingestão com `dlt` + APIs Públicas

### Objetivo

Desenvolver pipelines de ingestão programáticos em Python utilizando a biblioteca **`dlt` (Data Load Tool)**, extraindo dados de duas APIs públicas — REST Countries API e PokeAPI — com tratamento de paginação, e carregando os dados diretamente no MinIO em formato Parquet. Esta atividade demonstra como construir pipelines de ingestão customizados quando os conectores pré-construídos do Airbyte não atendem a requisitos específicos de negócio.

### Contexto

O `dlt` é uma biblioteca Python open source que simplifica drasticamente a construção de pipelines de ingestão, oferecendo funcionalidades como inferência automática de schema, normalização de dados aninhados (JSON → tabelas relacionais), gerenciamento de estado para ingestão incremental e suporte nativo a múltiplos destinos (incluindo S3/MinIO, DuckDB, BigQuery e Snowflake). Diferentemente do Airbyte, o `dlt` é orientado a código, o que o torna ideal para pipelines que exigem lógica customizada de extração.

---

### Passo 1 - Instalação da s dependências
```cmd
cd ~/engenharia-dados-2026-2
source .venv/Scripts/Activate.ps1

pip install "dlt[filesystem]"

pip install requests tenacity

python -c "import dlt; print(f'dlt versão {dlt.__version__}');


```

Crie o arquivo `scripts/5_pipeline_ingestao_dlt.py`

```python
"""
Pipeline de ingestão de dados utilizando o DLT (Data Load Tool) e integração com o MinIO.
Este script demonstra como configurar uma pipeline de ingestão de dados, utilizando o DLT para processar e armazenar dados em diferentes camadas (bronze, silver, gold) no MinIO.
As camadas representam diferentes estágios de processamento dos dados:
- bronze: Dados brutos ingeridos das fontes originais, sem transformação   
"""

import logging
import os
from datetime import datetime, timezone
from typing import Iterator

import dlt
from dlt.sources.helpers.rest_client import RESTClient
from dlt.sources.helpers.rest_client.auth import BearerTokenAuth
from dlt.sources.helpers.rest_client.paginators import OffsetPaginator

logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s", datefmt="%Y-%m-%d %H:%M:%S")

logger = logging.getLogger(__name__)

# Configuração do MinIO - Destino da gravação
# O dlt usa variáveis de ambiente para configurar as nossas credenciais
# No ambiente local, podemos passá-las diretamente no script, mas em produção é recomendado usar variáveis de ambiente ou um arquivo de configuração seguro.
os.environ["DESTINATION__FILESYSTEM__BUCKET_URL"] = "s3://bronze"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__REGION_NAME"] = "us-east-1"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__AWS_ACCESS_KEY_ID"] = "minioadmin"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__AWS_SECRET_ACCESS_KEY"] = "minioadmin123"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__ENDPOINT_URL"] = "http://localhost:9000"

# Configuração da rest countries api
BASE_URL = "https://api.restcountries.com"
ENDPOINT = "/countries/v5"
VERSAO_API = "v5"
TAMANHO_PAGINA = 100 # máximo no plano gratuito no uso da api

CAMPOS_SELECIONADOS = [
    "names.common", "names.official", "codes.alpha_2", "codes.alpha_3",
    "codes.ccn3","region","subregion", "continents",
    "capitals","languages","currencies", "population", "area.kilometers",
    "coordinates.lat", "coordinates.lng","tlds",
    "classification.sovereign",
    "classification.un_member",
    "classification.iso_status",
    "timezones","borders",
    "flag.emoji",
]

def obter_api_key() -> str:
    """
    Lê a API key da variável de ambiente RESTCOUNTRIES_API_KEY.
    A chave NUNCA deve ser escrita no código nem versionada no Git.
    """
    api_key = os.getenv("RESTCOUNTRIES_API_KEY")
    if not api_key:
        raise RuntimeError(
            "Variável de ambiente RESTCOUNTRIES_API_KEY não definida.\n"
            "Obtenha sua chave em https://restcountries.com e defina-a antes de executar:\n"
            '  PowerShell: $env:RESTCOUNTRIES_API_KEY = "sua_chave"\n'
            '  Linux/macOS: export RESTCOUNTRIES_API_KEY="sua_chave"'
        )
    return api_key


@dlt.resource(
    name="countries",
    write_disposition="replace",   # Substitui os dados a cada execução (dado cadastral)
    primary_key="codes__alpha_2",  # ISO 3166-1 alpha-2 (codes.alpha_2 achatado pelo dlt)
)
def extrair_paises() -> Iterator[list[dict]]:
    """
    Extrai todos os países da REST Countries API v5, página a página.
    O decorador @dlt.resource transforma esta função geradora
    em um recurso gerenciado pelo pipeline dlt.
    """
    cliente = RESTClient(
        base_url=BASE_URL,
        auth=BearerTokenAuth(token=obter_api_key()),  # Authorization: Bearer <chave>
        paginator=OffsetPaginator(
            limit=TAMANHO_PAGINA,
            offset_param="offset",
            limit_param="limit",
            total_path="data.meta.total",  # total de países informado pela API
        ),
        data_selector="data.objects",      # onde ficam os registros na resposta
    )
 
    logger.info(f"Iniciando extração de: {BASE_URL}{ENDPOINT}")
    timestamp_ingestao = datetime.now(timezone.utc).isoformat()
    total = 0
 
    for numero_pagina, pagina in enumerate(
        cliente.paginate(
            ENDPOINT,
            params={"response_fields": ",".join(CAMPOS_SELECIONADOS)},
        ),
        start=1,
    ):
        for pais in pagina:
            # Metadados de rastreabilidade (prática obrigatória na camada Bronze)
            pais["_fonte"] = "restcountries_v5"
            pais["_ingerido_em"] = timestamp_ingestao
            pais["_versao_api"] = VERSAO_API
 
        total += len(pagina)
        logger.info(f"Página {numero_pagina}: {len(pagina)} países (acumulado: {total})")
        yield pagina  # enviar a página inteira é mais eficiente que país a país
 
    logger.info(f"Total de países recebidos da API: {total}")

 
def executar_pipeline():
    """Configura e executa o pipeline dlt para a REST Countries API."""
 
    # Criar o pipeline dlt
    pipeline = dlt.pipeline(
        pipeline_name="rest_countries_bronze",
        destination="filesystem",
        dataset_name="rest_countries",  # Subdiretório dentro do bucket bronze
    )
 
    logger.info("Iniciando pipeline: REST Countries v5 → MinIO Bronze")
    inicio = datetime.now()
 
    # Executar a carga
    info = pipeline.run(
        extrair_paises(),
        loader_file_format="parquet",  # Formato Parquet com Snappy (padrão do dlt)
    )
 
    duracao = (datetime.now() - inicio).total_seconds()
 
    # Exibir o relatório de execução
    print("\n" + "=" * 60)
    print("  RELATÓRIO DE EXECUÇÃO — REST Countries API v5")
    print("=" * 60)
    print(f"  Status:        {'✅ Sucesso' if not info.has_failed_jobs else '❌ Falha'}")
    print(f"  Duração:       {duracao:.2f}s")
    print(f"  Destino:       s3://bronze/rest_countries/")
    print(f"  Formato:       Parquet + Snappy")
    print()
    print("  Detalhes da carga:")
    print(info)
    print("=" * 60)
 
    return info
 
 
if __name__ == "__main__":
    executar_pipeline()

```

Execute o pipeline:

```bash
cd ~/engenharia-dados-2026-2
source .venv/bin/activate
python scripts/5_pipeline_ingestao_dlt.py
```

---
### Passo 2 — Exploração dos Dados Ingeridos (REST Countries)

Após a execução, explore os dados carregados no MinIO:

```python
# scripts/6_explorar_countries_bronze.py
"""
Exploração dos dados da REST Countries API na camada Bronze.
Demonstra como ler dados Parquet diretamente do MinIO com Pandas.
"""

import pandas as pd
import boto3
import io

# Configurar cliente S3
client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

# Listar os arquivos Parquet criados pelo dlt
print("Arquivos criados pelo pipeline dlt:")
response = client.list_objects_v2(Bucket="bronze", Prefix="rest_countries/")
arquivos_parquet = [
    obj["Key"] for obj in response.get("Contents", [])
    if obj["Key"].endswith(".parquet")
]

for arq in arquivos_parquet:
    tamanho_kb = client.head_object(Bucket="bronze", Key=arq)["ContentLength"] / 1024
    print(f"  📄 {arq}  ({tamanho_kb:.1f} KB)")

# Ler o arquivo principal de países
if arquivos_parquet:
    chave_principal = next(
        (k for k in arquivos_parquet if "countries" in k.lower()), arquivos_parquet[0]
    )
    obj = client.get_object(Bucket="bronze", Key=chave_principal)
    df = pd.read_parquet(io.BytesIO(obj["Body"].read()))

    print(f"\nShape do dataset: {df.shape}")
    print(f"\nColunas disponíveis:\n{list(df.columns)}")
    print(f"\nDistribuição por região:")
    print(df["region"].value_counts())
    print(f"\nTop 10 países por população:")
    print(
        df[["name__common", "population", "region"]]
        .sort_values("population", ascending=False)
        .head(10)
        .to_string(index=False)
    )
```

---

### Passo 3 — Pipeline 2: PokeAPI com Paginação

A PokeAPI é um exemplo de API com paginação — um padrão extremamente comum em sistemas transacionais reais. O endpoint `/pokemon` retorna apenas 20 registros por página, exigindo múltiplas requisições para extrair o dataset completo. Esta atividade demonstra como o `dlt` gerencia paginação de forma elegante e como implementar **ingestão incremental** (extraindo apenas registros novos em execuções subsequentes).

```cmd
source .venv/scripts/Activate.py
pip install --upgrade certifi requests
pip install truststore
```

Crie o arquivo `scripts/7_ingest_pokemon.py`:

```python
# scripts/7_ingest_pokemon_paginado.py
"""
Pipeline de ingestão da PokeAPI para a camada Bronze.

Fonte: https://pokeapi.co/api/v2/pokemon
Destino: MinIO (bucket bronze) — formato Parquet com compressão Snappy
Tipo de dado: Entidade com relacionamentos (pokémon → habilidades, tipos, estatísticas)

A PokeAPI demonstra dois padrões fundamentais de ingestão:
  1. Paginação: o endpoint lista retorna 20 itens por página
  2. Enriquecimento: cada item da lista requer uma segunda requisição
     para obter os detalhes completos (padrão "list + detail")
"""
import truststore
truststore.inject_into_ssl()

import dlt
import requests
import time
import logging
from datetime import datetime, timezone
from typing import Iterator

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
logger = logging.getLogger(__name__)

import os
os.environ["DESTINATION__FILESYSTEM__BUCKET_URL"] = "s3://bronze"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__AWS_ACCESS_KEY_ID"] = "minioadmin"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__AWS_SECRET_ACCESS_KEY"] = "minioadmin123"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__ENDPOINT_URL"] = "http://localhost:9000"
os.environ["DESTINATION__FILESYSTEM__CREDENTIALS__REGION_NAME"] = "us-east-1"

# Configurações da API
BASE_URL = "https://pokeapi.co/api/v2"
LIMITE_POR_PAGINA = 100   # Máximo permitido pela PokeAPI
TOTAL_POKEMON = 300       # Limitar a 300 para a atividade (existem ~1300 no total)
DELAY_ENTRE_REQUESTS = 0.1  # Segundos entre requisições (respeitar rate limit)


def buscar_detalhes_pokemon(url: str, session: requests.Session) -> dict:
    """
    Busca os detalhes completos de um pokémon pelo URL do recurso.
    Implementa retry simples em caso de falha temporária.
    """
    for tentativa in range(3):
        try:
            resposta = session.get(url, timeout=10)
            resposta.raise_for_status()
            return resposta.json()
        except requests.RequestException as e:
            if tentativa == 2:
                raise
            logger.warning(f"Tentativa {tentativa + 1} falhou para {url}: {e}. Retentando...")
            time.sleep(1)


def normalizar_pokemon(dados: dict, timestamp: str) -> dict:
    """
    Normaliza os dados brutos de um pokémon, achatando estruturas aninhadas
    que seriam difíceis de trabalhar diretamente.
    Na camada Bronze, mantemos o dado original E adicionamos campos normalizados
    para facilitar o uso downstream.
    """
    return {
        # Identificadores
        "id": dados["id"],
        "nome": dados["name"],
        "nome_especie": dados.get("species", {}).get("name"),

        # Atributos físicos
        "altura_dm": dados["height"],       # Em decímetros
        "peso_hg": dados["weight"],         # Em hectogramas
        "experiencia_base": dados["base_experience"],

        # Tipos (até 2 tipos por pokémon)
        "tipo_primario": dados["types"][0]["type"]["name"] if dados["types"] else None,
        "tipo_secundario": dados["types"][1]["type"]["name"] if len(dados["types"]) > 1 else None,

        # Estatísticas base (estrutura original preservada como lista)
        "estatisticas": [
            {"nome": s["stat"]["name"], "valor_base": s["base_stat"]}
            for s in dados["stats"]
        ],

        # Habilidades
        "habilidades": [
            {"nome": a["ability"]["name"], "oculta": a["is_hidden"]}
            for a in dados["abilities"]
        ],

        # Sprites (imagens)
        "sprite_url": dados.get("sprites", {}).get("front_default"),

        # Metadados de rastreabilidade (obrigatórios na camada Bronze)
        "_fonte": "pokeapi_v2",
        "_url_recurso": f"{BASE_URL}/pokemon/{dados['id']}",
        "_ingerido_em": timestamp,
        "_versao_api": "v2",
    }


@dlt.resource(
    name="pokemon",
    write_disposition="replace",
    primary_key="id",
)
def extrair_pokemon(total: int = TOTAL_POKEMON) -> Iterator[dict]:
    """
    Extrai pokémons da PokeAPI com paginação automática.

    Fluxo de extração:
      1. GET /pokemon?limit=100&offset=0  → lista de 100 pokémons (apenas nome + URL)
      2. Para cada pokémon da lista: GET /pokemon/{id} → detalhes completos
      3. Repetir com offset=100, 200, ... até atingir o total desejado
    """
    timestamp_ingestao = datetime.now(timezone.utc).isoformat()
    session = requests.Session()
    session.headers.update({"User-Agent": "DataEngineeringCourse/1.0"})

    total_extraidos = 0
    offset = 0

    logger.info(f"Iniciando extração de {total} pokémons da PokeAPI")

    while total_extraidos < total:
        # Calcular quantos registros buscar nesta página
        limite_pagina = min(LIMITE_POR_PAGINA, total - total_extraidos)

        # Requisição à página de listagem
        url_lista = f"{BASE_URL}/pokemon?limit={limite_pagina}&offset={offset}"
        logger.info(f"Buscando lista: offset={offset}, limite={limite_pagina}")

        resposta_lista = session.get(url_lista, timeout=15)
        resposta_lista.raise_for_status()
        dados_lista = resposta_lista.json()

        resultados = dados_lista.get("results", [])
        if not resultados:
            logger.info("Sem mais resultados. Encerrando paginação.")
            break

        # Para cada item da lista, buscar os detalhes completos
        for item in resultados:
            dados_detalhes = buscar_detalhes_pokemon(item["url"], session)
            pokemon_normalizado = normalizar_pokemon(dados_detalhes, timestamp_ingestao)
            yield pokemon_normalizado
            total_extraidos += 1

            # Respeitar o rate limit da API (gratuita e sem autenticação)
            time.sleep(DELAY_ENTRE_REQUESTS)

        offset += limite_pagina
        logger.info(f"Progresso: {total_extraidos}/{total} pokémons extraídos")

    logger.info(f"Extração concluída. Total: {total_extraidos} pokémons")


def executar_pipeline():
    """Configura e executa o pipeline dlt para a PokeAPI."""

    pipeline = dlt.pipeline(
        pipeline_name="pokeapi_bronze",
        destination="filesystem",
        dataset_name="pokeapi",
    )

    logger.info("Iniciando pipeline: PokeAPI → MinIO Bronze")
    inicio = datetime.now()

    info = pipeline.run(
        extrair_pokemon(),
        loader_file_format="parquet",
    )

    duracao = (datetime.now() - inicio).total_seconds()

    print("\n" + "=" * 60)
    print("  RELATÓRIO DE EXECUÇÃO — PokeAPI")
    print("=" * 60)
    print(f"  Status:        {'✅ Sucesso' if not info.has_failed_jobs else '❌ Falha'}")
    print(f"  Duração:       {duracao:.2f}s")
    print(f"  Destino:       s3://bronze/pokeapi/")
    print(f"  Formato:       Parquet + Snappy")
    print()
    print("  Detalhes da carga:")
    print(info)
    print("=" * 60)

    return info


if __name__ == "__main__":
    executar_pipeline()
```

Execute o pipeline da PokeAPI:

```bash
python scripts/07_ingest_pokemon_paginado.py
```

> **Tempo estimado:** A extração de 300 pokémons com delay de 0,1s entre requisições leva aproximadamente 3 a 5 minutos. Este tempo é intencional para demonstrar o respeito ao rate limit de APIs públicas — uma prática obrigatória em ambientes de produção.

---

### Passo 4 — Comparação dos Dois Pipelines

Após executar ambos os pipelines, compare as estruturas geradas no MinIO:

```python
# scripts/comparar_pipelines.py
"""
Compara os dados ingeridos pelos dois pipelines (Countries e PokeAPI)
e demonstra as diferenças de estrutura entre dados cadastrais
e dados com relacionamentos complexos.
"""

import pandas as pd
import boto3
import io

client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

def ler_parquet_do_minio(bucket: str, prefixo: str) -> pd.DataFrame:
    """Lê o primeiro arquivo Parquet encontrado no prefixo especificado."""
    response = client.list_objects_v2(Bucket=bucket, Prefix=prefixo)
    arquivos = [
        obj["Key"] for obj in response.get("Contents", [])
        if obj["Key"].endswith(".parquet")
    ]
    if not arquivos:
        raise FileNotFoundError(f"Nenhum arquivo Parquet em {bucket}/{prefixo}")

    obj = client.get_object(Bucket=bucket, Key=arquivos[0])
    return pd.read_parquet(io.BytesIO(obj["Body"].read()))


print("=" * 65)
print("  COMPARATIVO DOS DADOS INGERIDOS NA CAMADA BRONZE")
print("=" * 65)

# REST Countries
df_countries = ler_parquet_do_minio("bronze", "rest_countries/")
print(f"\n🌍 REST Countries API")
print(f"   Registros: {len(df_countries):,}")
print(f"   Colunas:   {len(df_countries.columns)}")
print(f"   Regiões:   {df_countries['region'].nunique()} únicas")
print(f"   Metadados: {[c for c in df_countries.columns if c.startswith('_')]}")

# PokeAPI
df_pokemon = ler_parquet_do_minio("bronze", "pokeapi/")
print(f"\n🎮 PokeAPI")
print(f"   Registros: {len(df_pokemon):,}")
print(f"   Colunas:   {len(df_pokemon.columns)}")
print(f"   Tipos únicos: {df_pokemon['tipo_primario'].nunique()}")
print(f"   Metadados: {[c for c in df_pokemon.columns if c.startswith('_')]}")

print(f"\n{'─' * 65}")
print("  Distribuição de pokémons por tipo primário:")
print(df_pokemon["tipo_primario"].value_counts().head(10).to_string())
print("=" * 65)
```

```bash
python scripts/8_comparar_pipelines.py
```

## Atividade 6 — Organização da Camada Bronze com Particionamento

### Objetivo

Implementar e consolidar as boas práticas de organização da camada Bronze: particionamento lógico por data de ingestão, convenção de nomenclatura de caminhos, adição de metadados de rastreabilidade e criação de um manifesto de ingestão que registra cada execução de pipeline. Estas práticas são fundamentais para a manutenibilidade e auditabilidade de Data Lakes em produção.

### Contexto

Em Data Lakes de produção com petabytes de dados, a organização dos arquivos no armazenamento de objetos tem impacto direto na performance de leitura e no custo de processamento. O **particionamento por data** (`ano=YYYY/mes=MM/dia=DD`) é o padrão mais comum porque a maioria das consultas analíticas filtra por período de tempo. Ferramentas como Apache Spark e DuckDB conseguem ignorar automaticamente partições que não correspondem ao filtro da consulta — uma técnica chamada **partition pruning** — reduzindo drasticamente a quantidade de dados lidos do disco.

---

### Passo 1 — Convenção de Nomenclatura para a Camada Bronze

Antes de implementar o particionamento, é importante estabelecer e documentar a convenção de nomenclatura que será seguida em todo o curso. Crie o arquivo de documentação:

```bash
# Convenção de Nomenclatura — Camada Bronze

## Estrutura de Caminhos

bronze/
└── {sistema_origem}/

    └── {entidade}/

        └── ano={YYYY}/

            └── mes={MM}/

                └── dia={DD}/

                    └── {entidade}_{timestamp_unix}.parquet
```

## Exemplos

```
bronze/
├── restcountries_api/
│   └── countries/
│       └── ano=2024/mes=01/dia=15/
│           └── countries_1705363200.parquet
├── pokeapi/
│   └── pokemon/
│       └── ano=2024/mes=01/dia=15/
│           └── pokemon_1705363200.parquet
└── ecommerce_db/
    └── orders/
        └── ano=2024/mes=01/dia=15/
            └── orders_1705363200.parquet
```

## Regras

1. Nomes em snake_case, letras minúsculas, sem espaços ou caracteres especiais.
2. O timestamp no nome do arquivo é Unix timestamp (segundos desde epoch).
3. Particionamento obrigatório por ano/mês/dia da DATA DE INGESTÃO (não da data do dado).
4. Cada arquivo deve conter os metadados: _fonte, _ingerido_em, _versao_schema.
5. Nunca sobrescrever arquivos existentes na camada Bronze — apenas acrescentar.


---

### Passo 2 — Classe Utilitária para Ingestão na Camada Bronze

Crie uma classe reutilizável que encapsula todas as boas práticas de ingestão na camada Bronze. Esta classe será utilizada em todos os pipelines das aulas seguintes:

```python
# scripts/bronze_writer.py
"""
Utilitário para gravação padronizada na camada Bronze do Data Lake.

Encapsula as boas práticas de:
  - Particionamento por data de ingestão
  - Adição de metadados de rastreabilidade
  - Nomenclatura padronizada de arquivos
  - Registro de manifesto de ingestão
  - Verificação de integridade (contagem de registros)
"""

import pandas as pd
import boto3
import json
import io
import hashlib
import logging
from datetime import datetime, timezone
from pathlib import PurePosixPath
from typing import Optional

logger = logging.getLogger(__name__)


class BronzeWriter:
    """
    Gerencia a gravação padronizada de dados na camada Bronze do Data Lake.

    Uso:
        writer = BronzeWriter()
        resultado = writer.gravar(
            df=meu_dataframe,
            sistema_origem="pokeapi",
            entidade="pokemon",
        )
        print(resultado["caminho_objeto"])
    """

    # Configurações padrão do MinIO local
    ENDPOINT = "http://localhost:9000"
    ACCESS_KEY = "minioadmin"
    SECRET_KEY = "minioadmin123"
    BUCKET = "bronze"

    def __init__(
        self,
        endpoint: str = ENDPOINT,
        access_key: str = ACCESS_KEY,
        secret_key: str = SECRET_KEY,
        bucket: str = BUCKET,
    ):
        self.bucket = bucket
        self.client = boto3.client(
            "s3",
            endpoint_url=endpoint,
            aws_access_key_id=access_key,
            aws_secret_access_key=secret_key,
            region_name="us-east-1",
        )

    def _construir_caminho(
        self,
        sistema_origem: str,
        entidade: str,
        timestamp: datetime,
    ) -> str:
        """
        Constrói o caminho S3 seguindo a convenção de particionamento.

        Exemplo de saída:
            pokeapi/pokemon/ano=2024/mes=01/dia=15/pokemon_1705363200.parquet
        """
        particao = (
            f"ano={timestamp.year}/"
            f"mes={timestamp.month:02d}/"
            f"dia={timestamp.day:02d}"
        )
        nome_arquivo = f"{entidade}_{int(timestamp.timestamp())}.parquet"
        return str(PurePosixPath(sistema_origem) / entidade / particao / nome_arquivo)

    def _adicionar_metadados(
        self,
        df: pd.DataFrame,
        sistema_origem: str,
        versao_schema: str,
        timestamp: datetime,
    ) -> pd.DataFrame:
        """
        Adiciona colunas de metadados de rastreabilidade ao DataFrame.
        Estas colunas são prefixadas com '_' para diferenciá-las dos dados originais.
        """
        df = df.copy()
        df["_fonte"] = sistema_origem
        df["_ingerido_em"] = timestamp.isoformat()
        df["_versao_schema"] = versao_schema
        df["_particao_data"] = timestamp.strftime("%Y-%m-%d")
        return df

    def _calcular_checksum(self, buffer: bytes) -> str:
        """Calcula o hash MD5 do arquivo para verificação de integridade."""
        return hashlib.md5(buffer).hexdigest()

    def gravar(
        self,
        df: pd.DataFrame,
        sistema_origem: str,
        entidade: str,
        versao_schema: str = "1.0",
        compressao: str = "snappy",
        timestamp: Optional[datetime] = None,
    ) -> dict:
        """
        Grava um DataFrame Pandas na camada Bronze do MinIO.

        Args:
            df:              DataFrame com os dados a serem gravados.
            sistema_origem:  Identificador do sistema de origem (ex: 'pokeapi').
            entidade:        Nome da entidade/tabela (ex: 'pokemon').
            versao_schema:   Versão do schema dos dados (para controle de evolução).
            compressao:      Algoritmo de compressão Parquet ('snappy' ou 'zstd').
            timestamp:       Data/hora de ingestão. Se None, usa o momento atual.

        Returns:
            Dicionário com metadados da operação de gravação.
        """
        if timestamp is None:
            timestamp = datetime.now(timezone.utc)

        # Adicionar metadados de rastreabilidade
        df_com_metadados = self._adicionar_metadados(
            df, sistema_origem, versao_schema, timestamp
        )

        # Construir o caminho do objeto no MinIO
        caminho_objeto = self._construir_caminho(sistema_origem, entidade, timestamp)

        # Serializar para Parquet em memória
        buffer = io.BytesIO()
        df_com_metadados.to_parquet(buffer, index=False, compression=compressao)
        buffer.seek(0)
        dados_bytes = buffer.read()

        # Calcular checksum para verificação de integridade
        checksum = self._calcular_checksum(dados_bytes)

        # Upload para o MinIO
        self.client.put_object(
            Bucket=self.bucket,
            Key=caminho_objeto,
            Body=dados_bytes,
            ContentType="application/octet-stream",
            Metadata={
                "fonte": sistema_origem,
                "entidade": entidade,
                "registros": str(len(df)),
                "checksum_md5": checksum,
                "versao_schema": versao_schema,
            },
        )

        resultado = {
            "caminho_objeto": f"s3://{self.bucket}/{caminho_objeto}",
            "registros": len(df),
            "colunas": len(df_com_metadados.columns),
            "tamanho_bytes": len(dados_bytes),
            "checksum_md5": checksum,
            "compressao": compressao,
            "timestamp_ingestao": timestamp.isoformat(),
        }

        logger.info(
            f"✅ Bronze gravado: {caminho_objeto} "
            f"({resultado['registros']:,} registros, "
            f"{resultado['tamanho_bytes'] / 1024:.1f} KB)"
        )

        return resultado

    def registrar_manifesto(self, execucao: dict) -> None:
        """
        Registra um manifesto JSON com os metadados de cada execução de pipeline.
        O manifesto é armazenado em bronze/_manifesto/ e serve como log de auditoria.
        """
        timestamp = datetime.now(timezone.utc)
        chave_manifesto = (
            f"_manifesto/"
            f"ano={timestamp.year}/mes={timestamp.month:02d}/dia={timestamp.day:02d}/"
            f"manifesto_{int(timestamp.timestamp())}.json"
        )

        self.client.put_object(
            Bucket=self.bucket,
            Key=chave_manifesto,
            Body=json.dumps(execucao, indent=2, ensure_ascii=False, default=str),
            ContentType="application/json",
        )

        logger.info(f"📋 Manifesto registrado: {chave_manifesto}")

    def listar_particoes(self, sistema_origem: str, entidade: str) -> list:
        """
        Lista todas as partições disponíveis para uma entidade específica.
        Útil para verificar a cobertura temporal dos dados na camada Bronze.
        """
        prefixo = f"{sistema_origem}/{entidade}/"
        response = self.client.list_objects_v2(
            Bucket=self.bucket, Prefix=prefixo, Delimiter="/"
        )

        particoes = []
        # Navegar recursivamente pelas partições
        for prefix in response.get("CommonPrefixes", []):
            sub_response = self.client.list_objects_v2(
                Bucket=self.bucket, Prefix=prefix["Prefix"], Delimiter="/"
            )
            for sub_prefix in sub_response.get("CommonPrefixes", []):
                sub_sub_response = self.client.list_objects_v2(
                    Bucket=self.bucket, Prefix=sub_prefix["Prefix"]
                )
                for obj in sub_sub_response.get("Contents", []):
                    if obj["Key"].endswith(".parquet"):
                        particoes.append({
                            "caminho": obj["Key"],
                            "tamanho_bytes": obj["Size"],
                            "ultima_modificacao": obj["LastModified"],
                        })

        return particoes
```


---

### Passo 3 — Reingesta com Particionamento Correto

Utilize a classe `BronzeWriter` para reingerir os dados da REST Countries API e da PokeAPI, desta vez seguindo a convenção de particionamento padronizada:

```python
# scripts/9_reingerir_com_particionamento.py
"""
Demonstração do uso da classe BronzeWriter para ingestão padronizada.
Reingestão dos dados de Countries e Pokémon com particionamento correto.

REST Countries API v5 (a v3.1 foi descontinuada):
  - Endereço: https://api.restcountries.com/countries/v5
  - Autenticação obrigatória: cabeçalho "Authorization: Bearer <API_KEY>".
    A chave é lida da variável de ambiente RESTCOUNTRIES_API_KEY:
        PowerShell:   $env:RESTCOUNTRIES_API_KEY = "sua_chave"
        Linux/macOS:  export RESTCOUNTRIES_API_KEY="sua_chave"
  - Resposta embrulhada: registros em data.objects, paginação em data.meta.
  - Paginação por limit/offset (máximo de 100 por página no plano gratuito).
  - Seleção de campos com "response_fields" (caminhos com ponto).
"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

# Usa o repositório de certificados do sistema operacional (redes com inspeção HTTPS).
# Opcional: se o pacote não estiver instalado, segue com os certificados padrão do Python.
try:
    import truststore
    truststore.inject_into_ssl()
except ImportError:
    pass

import requests
import pandas as pd
import time
from datetime import datetime, timezone
from bronze_writer import BronzeWriter


# ── Configuração da REST Countries API v5 ────────────────────────────────────
RESTCOUNTRIES_BASE_URL = "https://api.restcountries.com"   # atenção: com "api."
RESTCOUNTRIES_ENDPOINT = "/countries/v5"
RESTCOUNTRIES_PAGINA = 100  # máximo permitido no plano gratuito

# Equivalentes v5 dos campos usados na v3.1
CAMPOS_COUNTRIES = [
    "codes.alpha_2",                    # cca2
    "names.common", "names.official",   # name.common / name.official
    "region",
    "continents",
    "capitals",                         # capital
    "currencies",
    "population",
    "area.kilometers",                  # area
    "coordinates.lat", "coordinates.lng",  # latlng
]


def obter_api_key() -> str:
    """Lê a API key da variável de ambiente (nunca escreva a chave no código)."""
    api_key = os.getenv("RESTCOUNTRIES_API_KEY")
    if not api_key:
        raise RuntimeError(
            "Variável de ambiente RESTCOUNTRIES_API_KEY não definida.\n"
            "Obtenha sua chave em https://restcountries.com e defina-a antes de executar:\n"
            '  PowerShell: $env:RESTCOUNTRIES_API_KEY = "sua_chave"\n'
            '  Linux/macOS: export RESTCOUNTRIES_API_KEY="sua_chave"'
        )
    return api_key


def extrair_paises_v5() -> list[dict]:
    """Extrai todos os países da REST Countries API v5, percorrendo as páginas."""
    session = requests.Session()
    session.headers.update({"Authorization": f"Bearer {obter_api_key()}"})

    paises, offset = [], 0
    while True:
        resposta = session.get(
            f"{RESTCOUNTRIES_BASE_URL}{RESTCOUNTRIES_ENDPOINT}",
            params={
                "response_fields": ",".join(CAMPOS_COUNTRIES),
                "limit": RESTCOUNTRIES_PAGINA,
                "offset": offset,
            },
            timeout=30,
        )
        resposta.raise_for_status()
        dados = resposta.json()["data"]
        pagina, meta = dados["objects"], dados["meta"]

        paises.extend(pagina)
        print(f"  Página offset={offset}: {len(pagina)} países (acumulado: {len(paises)}/{meta['total']})")

        offset += RESTCOUNTRIES_PAGINA
        if not pagina or not meta.get("more", offset < meta["total"]):
            break
        time.sleep(0.5)  # limite da API: 20 requisições a cada 10 segundos

    return paises


def capital_principal(capitais: list | None) -> str | None:
    """Retorna a capital principal (attributes.primary) ou, na falta dela, a primeira da lista."""
    if not capitais:
        return None
    principal = next(
        (c for c in capitais if (c.get("attributes") or {}).get("primary")),
        capitais[0],
    )
    return principal.get("name")


writer = BronzeWriter()

# ── 1. Reingestão da REST Countries API ──────────────────────────────────────
print("\n" + "─" * 55)
print("  Reingestão: REST Countries API v5 → Bronze (particionado)")
print("─" * 55)

paises_raw = extrair_paises_v5()

# Normalizar os campos aninhados mantendo os MESMOS nomes de colunas da versão
# anterior, para não quebrar os scripts e consultas que leem esta entidade.
paises_normalizados = []
for p in paises_raw:
    codes = p.get("codes") or {}
    names = p.get("names") or {}
    area = p.get("area") or {}
    coords = p.get("coordinates") or {}
    paises_normalizados.append({
        "cca2": codes.get("alpha_2"),
        "nome_comum": names.get("common"),
        "nome_oficial": names.get("official"),
        "regiao": p.get("region"),
        "continentes": p.get("continents"),
        "moedas": p.get("currencies"),
        "populacao": p.get("population"),
        "area_km2": area.get("kilometers"),
        "latlng": [coords.get("lat"), coords.get("lng")] if coords else None,
        "capital": capital_principal(p.get("capitals")),
    })

df_countries = pd.DataFrame(paises_normalizados)

resultado_countries = writer.gravar(
    df=df_countries,
    sistema_origem="restcountries_api",
    entidade="countries",
    versao_schema="2.0",  # origem mudou para a API v5 (mesmas colunas, nova procedência)
)
# Registrar manifesto
writer.registrar_manifesto({
    "pipeline": "rest_countries_bronze",
    "api_versao": "v5",
    "execucao_em": datetime.now(timezone.utc).isoformat(),
    "resultado": resultado_countries,
})

print(f"  ✅ {resultado_countries['registros']} países gravados")
print(f"  📍 {resultado_countries['caminho_objeto']}")

# ── 2. Reingestão da PokeAPI (primeiros 50 pokémons) ─────────────────────────
print("\n" + "─" * 55)
print("  Reingestão: PokeAPI → Bronze (particionado)")
print("─" * 55)

BASE_URL = "https://pokeapi.co/api/v2"

pokemon_lista = []

# Buscar lista dos primeiros 50 pokémons
resp_lista = requests.get(f"{BASE_URL}/pokemon?limit=50&offset=0", timeout=15)
resp_lista.raise_for_status()

for i, item in enumerate(resp_lista.json()["results"]):
    resp_detalhe = requests.get(item["url"], timeout=10)
    resp_detalhe.raise_for_status()
    d = resp_detalhe.json()

    pokemon_lista.append({
        "id": d["id"],
        "nome": d["name"],
        "altura_dm": d["height"],
        "peso_hg": d["weight"],
        "experiencia_base": d.get("base_experience"),
        "tipo_primario": d["types"][0]["type"]["name"] if d["types"] else None,
        "tipo_secundario": d["types"][1]["type"]["name"] if len(d["types"]) > 1 else None,
        "hp_base": next((s["base_stat"] for s in d["stats"] if s["stat"]["name"] == "hp"), None),
        "ataque_base": next((s["base_stat"] for s in d["stats"] if s["stat"]["name"] == "attack"), None),
        "defesa_base": next((s["base_stat"] for s in d["stats"] if s["stat"]["name"] == "defense"), None),
        "sprite_url": d.get("sprites", {}).get("front_default"),
    })

    if (i + 1) % 10 == 0:
        print(f"  Extraídos: {i + 1}/50 pokémons...")
    time.sleep(0.1)

df_pokemon = pd.DataFrame(pokemon_lista)

resultado_pokemon = writer.gravar(
    df=df_pokemon,
    sistema_origem="pokeapi",
    entidade="pokemon",
    versao_schema="1.0",
)

writer.registrar_manifesto({
    "pipeline": "pokeapi_bronze",
    "execucao_em": datetime.now(timezone.utc).isoformat(),
    "resultado": resultado_pokemon,
})

print(f"  ✅ {resultado_pokemon['registros']} pokémons gravados")
print(f"  📍 {resultado_pokemon['caminho_objeto']}")

# ── 3. Relatório final ────────────────────────────────────────────────────────
print("\n" + "=" * 55)
print("  RELATÓRIO FINAL — CAMADA BRONZE")
print("=" * 55)

for sistema, entidade in [("restcountries_api", "countries"), ("pokeapi", "pokemon")]:
    particoes = writer.listar_particoes(sistema, entidade)
    total_bytes = sum(p["tamanho_bytes"] for p in particoes)
    print(f"\n  [{sistema}/{entidade}]")
    print(f"    Arquivos:  {len(particoes)}")
    print(f"    Tamanho:   {total_bytes / 1024:.1f} KB")
    for p in particoes:
        print(f"    📄 {p['caminho']}")

print("\n  ✅ Camada Bronze organizada com particionamento correto!")
print("  Acesse: http://localhost:9001/browser/bronze")
```

Execute o script:

```bash
python scripts/9_reingerir_com_particionamento.py
```

### Passo 4 — Verificação do Manifesto de Ingestão

O manifesto de ingestão é um registro de auditoria que documenta cada execução de pipeline. Verifique os manifestos criados:

```python
# scripts/10_verificar_manifesto.py
"""
Lê e exibe os manifestos de ingestão registrados na camada Bronze.
O manifesto é a base para auditoria e rastreabilidade do Data Lake.
"""

import boto3
import json

client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

response = client.list_objects_v2(Bucket="bronze", Prefix="_manifesto/")
manifestos = sorted(
    [obj["Key"] for obj in response.get("Contents", []) if obj["Key"].endswith(".json")],
    reverse=True,  # Mais recentes primeiro
)

print(f"Manifestos de ingestão encontrados: {len(manifestos)}\n")

for chave in manifestos[:5]:  # Exibir os 5 mais recentes
    obj = client.get_object(Bucket="bronze", Key=chave)
    manifesto = json.loads(obj["Body"].read().decode("utf-8"))
    print(f"📋 {chave}")
    print(f"   Pipeline:   {manifesto.get('pipeline')}")
    print(f"   Executado:  {manifesto.get('execucao_em')}")
    resultado = manifesto.get("resultado", {})
    print(f"   Registros:  {resultado.get('registros', 'N/A'):,}")
    print(f"   Tamanho:    {resultado.get('tamanho_bytes', 0) / 1024:.1f} KB")
    print(f"   Checksum:   {resultado.get('checksum_md5', 'N/A')}")
    print()
```

```bash
python scripts/10_verificar_manifesto.py
```

---

### Passo 5 — Leitura com Partition Pruning

Demonstração de como o particionamento por data permite leituras eficientes, ignorando partições desnecessárias:

```python
# scripts/11_demonstrar_partition_pruning.py
"""
Demonstração do partition pruning: leitura eficiente de dados
particionados sem carregar todas as partições disponíveis.
"""

import pandas as pd
import boto3
import io
from datetime import datetime

client = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="minioadmin",
    aws_secret_access_key="minioadmin123",
    region_name="us-east-1",
)

def ler_particao_especifica(
    sistema: str,
    entidade: str,
    ano: int,
    mes: int,
    dia: int,
) -> pd.DataFrame:
    """
    Lê apenas a partição correspondente à data especificada.
    Ignora todas as outras partições — isso é o partition pruning.
    """
    prefixo = f"{sistema}/{entidade}/ano={ano}/mes={mes:02d}/dia={dia:02d}/"

    response = client.list_objects_v2(Bucket="bronze", Prefix=prefixo)
    arquivos = [
        obj["Key"] for obj in response.get("Contents", [])
        if obj["Key"].endswith(".parquet")
    ]

    if not arquivos:
        print(f"  ⚠️  Nenhum dado encontrado para {prefixo}")
        return pd.DataFrame()

    # Ler apenas os arquivos da partição solicitada
    frames = []
    for chave in arquivos:
        obj = client.get_object(Bucket="bronze", Key=chave)
        frames.append(pd.read_parquet(io.BytesIO(obj["Body"].read())))

    return pd.concat(frames, ignore_index=True) if frames else pd.DataFrame()


# Ler apenas a partição de hoje
hoje = datetime.now()
print(f"Lendo partição de hoje ({hoje.strftime('%Y-%m-%d')}):\n")

df_countries_hoje = ler_particao_especifica(
    "restcountries_api", "countries",
    hoje.year, hoje.month, hoje.day
)

if not df_countries_hoje.empty:
    print(f"  ✅ Countries: {len(df_countries_hoje)} registros carregados")
    print(f"  Colunas de metadados: {[c for c in df_countries_hoje.columns if c.startswith('_')]}")
    print(f"\n  Amostra dos dados:")
    print(
        df_countries_hoje[["nome_comum", "regiao", "populacao", "_ingerido_em"]]
        .head(5)
        .to_string(index=False)
    )

print("\n💡 Em um Data Lake com anos de dados históricos, a leitura")
print("   com partition pruning evita varrer milhares de arquivos")
print("   desnecessários, reduzindo custo e tempo de processamento.")
```

```bash
python scripts/11_demonstrar_partition_pruning.py
```

---

# Tema 2 - Processamento Distribuído e Formatos de Tabela (Lakehouse)

**Pré-requisitos:** Conclusão das Atividades 1 e 2 — ambiente Docker operacional, MinIO rodando com dados da REST Countries API, PokeAPI e dataset sintético de e-commerce na camada Bronze.

---

## Visão Geral das Atividades

Esta aula marca a transição do paradigma de armazenamento para o de **processamento**. Os dados que foram ingeridos e preservados na camada Bronze nas aulas anteriores agora serão lidos, processados e transformados por dois motores analíticos complementares. A **Atividade 1** introduz o Apache Spark — o motor de processamento distribuído padrão da indústria — demonstrando como ele lê dados diretamente do MinIO e executa operações de DataFrame em escala. A **Atividade 2** apresenta o DuckDB, um motor OLAP in-process que executa SQL analítico de alta performance diretamente sobre arquivos Parquet, sem necessidade de servidor. A **Atividade 3** eleva o Data Lake ao nível de **Data Lakehouse**, convertendo os dados para o formato Apache Iceberg e demonstrando na prática as transações ACID, evolução de schema e *time travel* — funcionalidades que antes eram exclusivas de bancos de dados relacionais.

| Atividade | Tema | Duração Estimada | Ferramentas |
|---|---|---|---|
| 1 | Introdução ao PySpark com MinIO | 45 min | PySpark 3.5, Docker, MinIO, Jupyter |
| 2 | Consultas Analíticas com DuckDB | 35 min | DuckDB, Python, SQL, MinIO |
| 3 | Data Lakehouse com Apache Iceberg | 40 min | PyIceberg, DuckDB, MinIO, Python |

> **Contexto arquitetural:** As três atividades desta aula operam sobre a camada Bronze (leitura) e produzem resultados que serão a base da camada Silver. O processamento realizado aqui é exploratório e de validação — a transformação definitiva e documentada para a camada Silver ocorrerá na Aula 4 com o dbt.

> **Andamento real:** a Atividade 1 (PySpark) foi realizada no notebook `notebooks/1_notebook_spark.ipynb`. As Atividades 2 (DuckDB) e 3 (Iceberg) foram reorganizadas no **Tema 3** e no notebook `notebooks/2_duckdb.ipynb`, depois da customização da imagem do Jupyter.

---

## Atividade 1 — Introdução ao PySpark com MinIO

### Objetivo

Configurar um ambiente Apache Spark local via Docker, conectá-lo ao MinIO como fonte de dados S3-compatível e executar as operações fundamentais de DataFrame em PySpark: leitura de Parquet, filtros, seleções, agrupamentos, joins e gravação de resultados. O dataset de e-commerce sintético gerado na Aula 1 (1 milhão de registros) será utilizado para demonstrar o poder do processamento distribuído.

### Contexto

O Apache Spark é o motor de processamento distribuído mais amplamente utilizado na indústria para cargas de trabalho de Big Data. Sua arquitetura divide os dados em partições que são processadas em paralelo por múltiplos executores (workers), permitindo escalar horizontalmente para petabytes de dados. Mesmo em modo local (single-node), o Spark demonstra ganhos de performance sobre o Pandas para datasets acima de alguns gigabytes, pois utiliza todos os núcleos de CPU disponíveis e executa operações de forma lazy (avaliação preguiçosa) — construindo um plano de execução otimizado antes de processar qualquer dado.

---

### Passo 1 — Configuração do PySpark via Docker

O Spark requer a JVM (Java Virtual Machine) e configurações específicas para se conectar ao MinIO. A forma mais simples de ter um ambiente Spark funcional é utilizando a imagem oficial do Jupyter com PySpark pré-instalado:

No arquivo `docker/compose.yml`, acrescente o serviço abaixo **dentro de `services:`**, logo após o serviço `minio` e antes da seção `volumes:`:

```yaml
  # Jupyter com PySpark e suporte a S3 (MinIO)
  spark-jupyter:
    image: jupyter/pyspark-notebook:spark-3.5.0
    container_name: spark-jupyter
    ports:
      - "8888:8888"   # Interface Jupyter
      - "4040:4040"   # Spark UI (monitoramento de jobs)
    environment:
      JUPYTER_ENABLE_LAB: "yes"
      SPARK_OPTS: "--driver-java-options=-Xms1g --driver-java-options=-Xmx4g"
    volumes:
      - ../notebooks:/home/jovyan/notebooks
      - ../scripts:/home/jovyan/scripts
      - ../data:/home/jovyan/data
    networks:
      - default
```

> No Tema 3, a linha `image:` deste serviço é substituída por uma imagem customizada (`build: ./spark-jupyter`), que acrescenta DuckDB e PyIceberg.

```powershell
cd ~/engenharia-dados-2026-2/docker

# Iniciar o serviço Spark/Jupyter (pode levar 1-2 minutos na primeira vez)
docker compose up -d spark-jupyter

# Obter o token de acesso do Jupyter
docker logs spark-jupyter 2>&1 | Select-String "token=" | Select-Object -Last 1
```

Acesse o Jupyter Lab em `http://localhost:8888` utilizando o token exibido no terminal. Crie um novo notebook em `notebooks/` com o nome `1_notebook_spark.ipynb`.

---

### Passo 2 — Configuração da Sessão Spark com Conexão ao MinIO - EM UM NOTEBOOK JUPYTERLAB

A configuração do Spark para se conectar ao MinIO requer a especificação de pacotes adicionais (hadoop-aws e aws-java-sdk) e as credenciais de acesso S3. Execute as células abaixo no notebook:

```python
# Célula 1 — Configuração da SparkSession com suporte ao MinIO
import os
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql.types import (
    StructType, StructField, StringType, IntegerType,
    DoubleType, TimestampType
)

# Endereço do MinIO acessível de dentro do contêiner Docker
# "host.docker.internal" resolve para o IP do host a partir do contêiner
MINIO_ENDPOINT = "http://host.docker.internal:9000"
MINIO_ACCESS_KEY = "minioadmin"
MINIO_SECRET_KEY = "minioadmin123"

# Criar a SparkSession com os pacotes necessários para S3
spark = (
    SparkSession.builder
    .appName("DataEngineeringCourse-Aula3")
    .master("local[*]")  # Usar todos os núcleos de CPU disponíveis
    .config(
        "spark.jars.packages",
        "org.apache.hadoop:hadoop-aws:3.3.4,"
        "com.amazonaws:aws-java-sdk-bundle:1.12.262"
    )
    # Configurações do conector S3A para MinIO
    .config("spark.hadoop.fs.s3a.endpoint", MINIO_ENDPOINT)
    .config("spark.hadoop.fs.s3a.access.key", MINIO_ACCESS_KEY)
    .config("spark.hadoop.fs.s3a.secret.key", MINIO_SECRET_KEY)
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false")
    # Otimizações de performance
    .config("spark.sql.adaptive.enabled", "true")
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true")
    .config("spark.ui.port", "4040")
    .getOrCreate()
)

# Configurar nível de log para reduzir verbosidade
spark.sparkContext.setLogLevel("WARN")

print(f"✅ SparkSession criada com sucesso!")
print(f"   Versão do Spark: {spark.version}")
print(f"   Master: {spark.sparkContext.master}")
print(f"   Núcleos disponíveis: {spark.sparkContext.defaultParallelism}")
print(f"\n   Spark UI disponível em: http://localhost:4040")
```

> **Nota:** Na primeira execução, o Spark fará download dos pacotes `hadoop-aws` e `aws-java-sdk-bundle` (~150 MB). Esse processo pode levar alguns minutos. As execuções subsequentes utilizarão o cache local.

---

### Passo 3 — Leitura de Dados Parquet do MinIO

```python
# Célula 2 — Leitura do dataset de e-commerce da camada Bronze
import time

# Caminho S3A para os arquivos Parquet no MinIO
# O prefixo s3a:// indica o conector Hadoop para S3
CAMINHO_ECOMMERCE = "s3a://bronze/ecommerce_sintetico/"

print("Lendo dataset de e-commerce do MinIO...")
inicio = time.time()

df_pedidos = spark.read.parquet(CAMINHO_ECOMMERCE)

# Nota: a leitura é LAZY — o Spark ainda não processou nenhum dado
# O schema é inferido dos metadados do Parquet (sem ler os dados)
duracao = time.time() - inicio

print(f"✅ Schema inferido em {duracao:.2f}s (leitura lazy — dados ainda não carregados)")
print(f"\nSchema do DataFrame:")
df_pedidos.printSchema()
```

```python
# Célula 3 — Primeira ação: contar registros (força a execução do plano)
print("Contando registros (primeira ação — força execução do plano Spark)...")
inicio = time.time()

total_registros = df_pedidos.count()

duracao = time.time() - inicio
print(f"✅ Total de registros: {total_registros:,}")
print(f"   Tempo de execução: {duracao:.2f}s")
print(f"\n   Acesse o Spark UI em http://localhost:4040 para ver o plano de execução!")
```

```python
# Célula 4 — Exploração inicial do DataFrame
# show() é uma ação que força a execução e exibe os dados
print("Amostra dos dados (5 primeiras linhas):")
df_pedidos.show(5, truncate=False)

print(f"\nEstatísticas descritivas das colunas numéricas:")
df_pedidos.select(
    "valor_unitario", "quantidade", "valor_total"
).describe().show()
```
---

### Passo 4 — Operações Fundamentais de DataFrame

```python
# Célula 5 — Filtros e Seleções (equivalente ao WHERE e SELECT do SQL)

# Filtrar apenas pedidos concluidos com valor total acima de R$ 500
df_pedidos_premium = (
    df_pedidos
    .filter(
        (F.col("status_pedido") == "concluido") &
        (F.col("valor_total") > 500.0)
    )
    .select(
        "id_pedido",
        "id_cliente",
        "categoria",
        "valor_total",
        "regiao",
        "data_pedido",
    )
)

print("Pedidos concluidos com valor > R$ 500:")
print(f"  Total filtrado: {df_pedidos_premium.count():,} registros")
df_pedidos_premium.show(5)
```

```python
# Célula 6 — Agrupamentos e Agregações (equivalente ao GROUP BY do SQL)

# Receita total e ticket médio por categoria e região
df_receita_categoria = (
    df_pedidos
    .filter(F.col("status_pedido") == "concluido")
    .groupBy("categoria", "regiao")
    .agg(
        F.count("id_pedido").alias("total_pedidos"),
        F.sum("valor_total").alias("receita_total"),
        F.avg("valor_total").alias("ticket_medio"),
        F.countDistinct("id_cliente").alias("clientes_unicos"),
    )
    .withColumn("receita_total", F.round("receita_total", 2))
    .withColumn("ticket_medio", F.round("ticket_medio", 2))
    .orderBy(F.desc("receita_total"))
)

print("Receita por Categoria e Região (pedidos concluidos):")
df_receita_categoria.show(15)
```

```python
# Célula 7 — Funções de Janela (Window Functions)
# Calcular o ranking de receita por categoria dentro de cada região
from pyspark.sql.window import Window

janela_regiao = Window.partitionBy("regiao").orderBy(F.desc("receita_total"))

df_ranking = (
    df_receita_categoria
    .withColumn("ranking_na_regiao", F.rank().over(janela_regiao))
    .filter(F.col("ranking_na_regiao") <= 3)  # Top 3 categorias por região
    .orderBy("regiao", "ranking_na_regiao")
)

print("Top 3 categorias por receita em cada região:")
df_ranking.show(20)
```

```python
# Célula 8 — Criação de Colunas Derivadas e Transformações

df_enriquecido = (
    df_pedidos
    .withColumn(
        # Extrair o mês da data do pedido
        "mes_pedido", F.month("data_pedido")
    )
    .withColumn(
        # Extrair o ano
        "ano_pedido", F.year("data_pedido")
    )
    .withColumn(
        # Classificar o pedido por faixa de valor
        "faixa_valor",
        F.when(F.col("valor_total") < 100, "Baixo")
         .when(F.col("valor_total") < 500, "Médio")
         .when(F.col("valor_total") < 1500, "Alto")
         .otherwise("Premium")
    )
    .withColumn(
        # Flag para pedidos com avaliação positiva (4 ou 5 estrelas)
        "avaliacao_positiva",
        F.when(F.col("avaliacao_cliente") >= 4, True).otherwise(False)
    )
)

print("DataFrame enriquecido com colunas derivadas:")
df_enriquecido.select(
    "id_pedido", "valor_total", "faixa_valor",
    "mes_pedido", "ano_pedido", "avaliacao_positiva"
).show(10)
```

---

### Passo 5 — Plano de Execução e Otimização

```python
# Célula 9 — Visualização do Plano de Execução (Catalyst Optimizer)
# O Spark usa o Catalyst Optimizer para transformar o plano lógico
# em um plano físico otimizado antes de executar qualquer operação.

print("=== Plano de Execução Lógico (não otimizado) ===")
df_receita_categoria.explain(mode="simple")

print("\n=== Plano de Execução Físico (otimizado pelo Catalyst) ===")
df_receita_categoria.explain(mode="cost")
```

```python
# Célula 10 — Cache de DataFrames para Reutilização
# Quando um DataFrame é usado múltiplas vezes, o cache evita
# que o Spark releia os dados do MinIO a cada operação.

print("Armazenando DataFrame em cache...")
inicio = time.time()
df_pedidos.cache()
df_pedidos.count()  # Força a materialização do cache
duracao_cache = time.time() - inicio
print(f"  Cache materializado em {duracao_cache:.2f}s")

# Segunda contagem — agora vem do cache (muito mais rápida)
inicio = time.time()
df_pedidos.count()
duracao_cache_hit = time.time() - inicio
print(f"  Leitura do cache: {duracao_cache_hit:.4f}s")
print(f"  Speedup: {duracao_cache / duracao_cache_hit:.0f}x mais rápido com cache")
```

---

### Passo 6 — Gravação dos Resultados no MinIO

```python
# Célula 11 — Gravação do resultado processado de volta no MinIO
# Os resultados são gravados como Parquet particionado por categoria

CAMINHO_SAIDA = "s3a://bronze/ecommerce_processado/"

print(f"Gravando resultados em: {CAMINHO_SAIDA}")
inicio = time.time()

(
    df_enriquecido
    .filter(F.col("status_pedido") == "concluido")
    .write
    .mode("overwrite")
    .partitionBy("ano_pedido", "mes_pedido")  # Particionamento físico no S3
    .parquet(CAMINHO_SAIDA)
)

duracao = time.time() - inicio
print(f"✅ Dados gravados em {duracao:.2f}s")
print(f"   Particionado por: ano_pedido / mes_pedido")
print(f"   Formato: Parquet + Snappy (padrão do Spark)")

# Verificar os arquivos criados
df_verificacao = spark.read.parquet(CAMINHO_SAIDA)
print(f"\n   Registros gravados: {df_verificacao.count():,}")
print(f"   Partições físicas criadas:")
df_verificacao.select("ano_pedido", "mes_pedido").distinct().orderBy("ano_pedido", "mes_pedido").show(5)
```

---
# Tema 3 — Lakehouse na prática e Camada Silver com dbt

## Aula de 29/10/2026 — o que foi realizado

| Atividade | Tema | Situação | Onde está |
|---|---|---|---|
| 0 | Ajuste do ambiente: imagem `spark-jupyter` customizada com DuckDB e PyIceberg | ✅ Concluída | `docker/spark-jupyter/Dockerfile`, `docker/compose.yml` |
| 1 | Apache Iceberg na prática | ⏸️ Passos 1 a 3 concluídos (conexão, catálogo e criação da tabela) | `notebooks/2_duckdb.ipynb` (Células 1 a 3) |
| — | Restante da Atividade 1, consultas analíticas com DuckDB e dbt (Camada Silver) | ➡️ Próxima aula | `roteiro-para-proximas-aulas.md` |

> **Onde cada coisa roda a partir de agora**
>
> | Ambiente | Usado para | Endereço do MinIO | Caminho dos dados |
> |---|---|---|---|
> | Contêiner `spark-jupyter` (Jupyter Lab em `http://localhost:8888`) | Notebooks (`1_notebook_spark`, `2_duckdb`, …) | `host.docker.internal:9000` | `../data` → `/home/jovyan/data` |
> | Host Windows (PowerShell + `.venv`) | Scripts da pasta `scripts/` e, a partir da próxima aula, o dbt | `localhost:9000` | `data/` na raiz do projeto |
>
> Dentro do contêiner, `localhost` é o **próprio contêiner**, não o Windows. Por isso os notebooks usam `host.docker.internal`.

---

## Atividade 0 — Ajuste do Ambiente

### Passo 1 — Ambiente virtual do host

O `.venv` do host (Python 3.14) continua sendo usado para os scripts e, a partir da próxima aula, para o dbt. Nele **não** fixamos versões antigas de `numpy`/`pyarrow`: essas versões não existem para Python 3.14 e não são necessárias fora do contêiner.

```powershell
cd ~/engenharia-dados-2026-2
.\.venv\Scripts\Activate.ps1          # Linux/macOS: source .venv/bin/activate

# DuckDB < 2.0 (exigência do pyiceberg[duckdb]) e driver SQLite do catálogo Iceberg
pip install "duckdb>=1.4,<2" "pyiceberg[sql-sqlite,pyarrow,pandas,duckdb]>=0.10" boto3

python -c "import duckdb, pyiceberg; print(duckdb.__version__, pyiceberg.__version__)"
```

### Passo 2 — Por que customizar a imagem do Jupyter

O notebook do Iceberg roda no contêiner `spark-jupyter`, cuja imagem (`jupyter/pyspark-notebook:spark-3.5.0`) não traz DuckDB nem PyIceberg. A primeira tentativa foi instalá-los com `docker exec ... pip install`, e isso quebrou o ambiente:

- o `pyiceberg[...]` exige `pyarrow >= 17`, e o pip instalou a versão mais recente (26);
- o `pyarrow` 26 exige **NumPy 2**, mas a imagem traz NumPy **1.24.4**, compilado junto com pandas e PySpark;
- resultado: `ImportError: pyarrow requires NumPy 2.0 or newer, found 1.24.4`.

O problema ilustra uma situação comum com imagens prontas: imagens antigas têm componentes com versões mais novas disponíveis, e atualizar sem fixar versões gera conflitos de dependência. A forma correta é criar uma **imagem customizada** com as versões declaradas, seja no `Dockerfile`, seja em um `requirements.txt` ou no arquivo de versões do gerenciador de pacotes.

### Passo 3 — Dockerfile da imagem customizada

Crie a pasta `docker/spark-jupyter/` e, dentro dela, o arquivo `Dockerfile`:

```dockerfile
FROM jupyter/pyspark-notebook:spark-3.5.0

# Mesmas versões usadas no venv do host (evita incompatibilidade do arquivo .duckdb)
RUN pip install --no-cache-dir \
      "duckdb>=1.4,<2" \
      "pyiceberg[sql-sqlite,pyarrow,pandas,duckdb]>=0.10" \
      "pyarrow==17.0.0" "numpy==1.24.4" \
      boto3

# Pré-instala as extensões do DuckDB na imagem (não depende de internet na hora da aula)
RUN python -c "import duckdb; c = duckdb.connect(); c.execute('INSTALL httpfs'); c.execute('INSTALL iceberg')"
```

- `pyarrow==17.0.0` é a versão mínima aceita pelo PyIceberg e a última que ainda funciona com NumPy 1.x.
- `numpy==1.24.4` mantém a versão original da imagem e impede que o pip a atualize.

### Passo 4 — Usar a imagem customizada no compose

No `docker/compose.yml`, o serviço `spark-jupyter` deixa de usar a imagem pronta e passa a construir a imagem local:

```yaml
  # Jupyter com PySpark e suporte a S3 (MinIO)
  spark-jupyter:
    # image: jupyter/pyspark-notebook:spark-3.5.0
    build: ./spark-jupyter
    image: curso/spark-jupyter:3.5.0-duckdb
    container_name: spark-jupyter
    ports:
      - "8888:8888"   # Interface Jupyter
      - "4040:4040"   # Spark UI (monitoramento de jobs)
    environment:
      JUPYTER_ENABLE_LAB: "yes"
      SPARK_OPTS: "--driver-java-options=-Xms1g --driver-java-options=-Xmx4g"
    volumes:
      - ../notebooks:/home/jovyan/notebooks
      - ../scripts:/home/jovyan/scripts
      - ../data:/home/jovyan/data
    networks:
      - default
```

### Passo 5 — Reconstruir a imagem e recriar o contêiner

```powershell
cd ~/engenharia-dados-2026-2/docker
docker compose up -d --build spark-jupyter     # constrói a imagem e recria só o contêiner do Jupyter
docker compose ps                               # minio-datalake e spark-jupyter em execução
docker logs spark-jupyter 2>&1 | Select-String "token=" | Select-Object -Last 1
```

> **Cuidado com `docker compose down -v`:** a opção `-v` remove os **volumes nomeados**, entre eles o `minio_data`, onde está toda a camada Bronze. Para trocar a imagem do Jupyter, basta `up -d --build spark-jupyter`. O compose percebe que a imagem mudou e recria apenas aquele contêiner.

Confira as versões dentro do contêiner, em uma célula de notebook:

```python
import numpy, pyarrow, duckdb, pyiceberg
print(numpy.__version__, pyarrow.__version__, duckdb.__version__, pyiceberg.__version__)
# esperado: 1.24.4  17.0.0  1.x  0.1x
```

### Passo 6 — Notebook `2_duckdb.ipynb` e conexão DuckDB↔MinIO

No Jupyter Lab, crie o notebook `notebooks/2_duckdb.ipynb`. Ele reaproveita a configuração de conexão do antigo `aula3_duckdb.ipynb`, agora com o **gerenciador de segredos** do DuckDB. Os comandos `SET s3_*` usados anteriormente valem apenas para a sessão.

```python
# Célula 1 (revisada) — DuckDB + MinIO com Secrets Manager
import duckdb

con = duckdb.connect("../data/curso_analytics.duckdb")
con.execute("INSTALL httpfs; LOAD httpfs;")

# Segredo TEMPORÁRIO: vale para esta conexão quando feita entre containers Docker. Rode esta célula sempre que reabrir o notebook.
con.execute("""
    CREATE OR REPLACE SECRET minio (
        TYPE s3,
        KEY_ID 'minioadmin',
        SECRET 'minioadmin123',
        ENDPOINT 'host.docker.internal:9000',
        URL_STYLE 'path',
        USE_SSL false,
        REGION 'us-east-1'
    );
""")

# Segredo Temporário usando localhost: vale para as conexões feitas pelo host. Rode esta célula apenas uma vez.
#con.execute("""
#    CREATE OR REPLACE SECRET minio (
#        TYPE s3,
#        KEY_ID 'minioadmin',
#        SECRET 'minioadmin123',
#        ENDPOINT 'localhost:9000',
#        URL_STYLE 'path',
#        USE_SSL false,
#        REGION 'us-east-1'
#    );
#""")

print(con.sql("SELECT name, type, persistent FROM duckdb_secrets()"))
```

Saída esperada:

```text
┌─────────┬─────────┬────────────┐
│  name   │  type   │ persistent │
│ varchar │ varchar │  boolean   │
├─────────┼─────────┼────────────┤
│ minio   │ s3      │ false      │
└─────────┴─────────┴────────────┘
```

> **Por que a *view* persiste e a credencial não?** Uma *view* é um objeto do catálogo e fica gravada no arquivo `.duckdb`. O segredo pertence à sessão. Existe `CREATE PERSISTENT SECRET`, que grava a credencial **em texto puro** em `~/.duckdb/stored_secrets`: aceitável em laboratório, nunca em produção.

---

## Atividade 1 — Apache Iceberg na Prática

### Objetivo

Converter a Bronze em uma tabela Iceberg e demonstrar, com operações reais, as garantias do Lakehouse: snapshots imutáveis, *time travel*, exclusão e *upsert* transacionais (caso LGPD), evolução de schema sem reescrita e leitura por outro motor (DuckDB).

### Passo 1 — Dependências

O PyIceberg, com o driver SQLite do catálogo, já está instalado na imagem customizada (Atividade 0, Passo 3). Não é preciso instalar nada no notebook.

### Passo 2 — Catálogo Iceberg

O Iceberg precisa de um **catálogo** que guarde, para cada tabela, o ponteiro para o `metadata.json` atual. No laboratório usamos um catálogo SQL em SQLite (`data/iceberg_catalog/catalog.db`). Em produção, usa-se um catálogo REST (Apache Polaris, Lakekeeper, Nessie), AWS Glue ou Unity Catalog.

```python
# Célula 2 (revisada) — Catálogo Iceberg (SQLite local + MinIO)
import io, os, time
from datetime import datetime, timezone

import boto3
import pandas as pd
import pyarrow as pa
from pyiceberg.catalog.sql import SqlCatalog

os.makedirs("../data/iceberg_catalog", exist_ok=True)

MINIO = {
    "s3.endpoint": "http://host.docker.internal:9000",
    "s3.access-key-id": "minioadmin",
    "s3.secret-access-key": "minioadmin123",
    "s3.region": "us-east-1",            # evita a tentativa de descobrir a região do bucket
}

#MINIO = {
#    "s3.endpoint": "http://localhost:9000",
#    "s3.access-key-id": "minioadmin",
#    "s3.secret-access-key": "minioadmin123",
#    "s3.region": "us-east-1",            # evita a tentativa de descobrir a região do bucket
#}


catalog = SqlCatalog(
    "curso_lakehouse",
    **{"uri": "sqlite:///../data/iceberg_catalog/catalog.db", "warehouse": "s3://silver", **MINIO},
)
catalog.create_namespace_if_not_exists("bronze_processado")
print("Namespaces:", catalog.list_namespaces())
```

Saída esperada: `Namespaces: [('bronze_processado',)]`

> O endereço do MinIO **não** fica gravado no catálogo: ele é uma configuração de quem acessa. O mesmo `catalog.db` pode ser usado pelo notebook (`host.docker.internal`) e por scripts no host (`localhost`).

### Passo 3 — Criação da tabela Iceberg

```python
# Célula 3 — Schema fortemente tipado + particionamento oculto (hidden partitioning)
from pyiceberg.schema import Schema
from pyiceberg.types import (NestedField, LongType, IntegerType, StringType,
                             DoubleType, TimestampType, BooleanType)
from pyiceberg.partitioning import PartitionSpec, PartitionField
from pyiceberg.transforms import MonthTransform

schema_pedidos = Schema(
    NestedField(1,  "id_pedido",         LongType(),      required=True),
    NestedField(2,  "id_cliente",        LongType(),      required=True),
    NestedField(3,  "id_produto",        LongType(),      required=True),
    NestedField(4,  "categoria",         StringType()),
    NestedField(5,  "valor_unitario",    DoubleType()),
    NestedField(6,  "quantidade",        IntegerType()),
    NestedField(7,  "valor_total",       DoubleType()),
    NestedField(8,  "status_pedido",     StringType()),
    NestedField(9,  "regiao",            StringType()),
    NestedField(10, "data_pedido",       TimestampType()),
    NestedField(11, "avaliacao_cliente", IntegerType()),
    NestedField(12, "_fonte",            StringType()),
    NestedField(13, "_ingerido_em",      StringType()),
    identifier_field_ids=[1],            # chave lógica: usada pelo upsert
)

# O particionamento é declarado sobre uma TRANSFORMAÇÃO da coluna (mês de data_pedido).
# Quem consulta filtra por data_pedido e não precisa conhecer a estrutura de pastas.
spec_particao = PartitionSpec(
    PartitionField(source_id=10, field_id=1000, transform=MonthTransform(), name="data_pedido_mes")
)

NOME_TABELA = "bronze_processado.pedidos_ecommerce"
tabela = catalog.create_table_if_not_exists(
    identifier=NOME_TABELA,
    schema=schema_pedidos,
    partition_spec=spec_particao,
    properties={
        "write.parquet.compression-codec": "zstd",
        "write.metadata.compression-codec": "gzip",
    },
)
print(tabela.schema())
print(tabela.spec())
print("Localização:", tabela.location())
```

Saída esperada:

```text
table {
  1: id_pedido: required long
  2: id_cliente: required long
  ...
  13: _ingerido_em: optional string
}
[
  1000: data_pedido_mes: month(10)
]
Localização: s3://silver/bronze_processado/pedidos_ecommerce
```

### Final da aula de 29/10/2026

Estado do ambiente ao final da aula:

- imagem `curso/spark-jupyter:3.5.0-duckdb` construída e em uso;
- `notebooks/2_duckdb.ipynb` com as Células 1 a 3 executadas;
- catálogo `data/iceberg_catalog/catalog.db` com o namespace `bronze_processado`;
- tabela `bronze_processado.pedidos_ecommerce` criada, ainda **sem dados** (nenhum snapshot), com localização `s3://silver/bronze_processado/pedidos_ecommerce`.

## Ponto de partida (estado do repositório ao fim da aula de 29/10/2026)

| Item | Estado |
|---|---|
| MinIO (`minio-datalake`) | Buckets `bronze`, `silver`, `gold`; Bronze com `ecommerce_sintetico/` (1 milhão de pedidos), `restcountries_api/countries/` e `pokeapi/pokemon/` (BronzeWriter, particionados por `ano=/mes=/dia=`), além das saídas do dlt (`rest_countries/`, `pokeapi/pokemon/*.parquet` sem partição) e do Spark (`ecommerce_processado/`) |
| Jupyter (`spark-jupyter`) | Imagem customizada `curso/spark-jupyter:3.5.0-duckdb` (DuckDB, PyIceberg, `pyarrow==17.0.0`, `numpy==1.24.4`, extensões `httpfs` e `iceberg` pré-instaladas) |
| `notebooks/1_notebook_spark.ipynb` | Concluído (Tema 2, Atividade 1) |
| `notebooks/2_duckdb.ipynb` | Células 1 a 3: secret do DuckDB, catálogo Iceberg e criação da tabela `bronze_processado.pedidos_ecommerce` (**ainda sem dados**) |
| `data/iceberg_catalog/catalog.db` | Catálogo SQL do Iceberg com o namespace `bronze_processado` |
| `dbt_project/` | Só o `README.md`: o projeto dbt começa na próxima aula |

## Dois ambientes de execução

Desde a customização do Jupyter, o curso usa **dois ambientes**. Cada passo deste roteiro indica onde deve ser executado.

| | 🐳 Contêiner `spark-jupyter` | 💻 Host Windows (`.venv`, PowerShell) |
|---|---|---|
| Usado para | Notebooks (`2_duckdb`, `3_gold`, …) | Scripts de `scripts/`, **dbt**, Airflow (via Docker) |
| Python | 3.11 (imagem), NumPy 1.24 / PyArrow 17 | 3.14, NumPy 2 / PyArrow 25 |
| Endereço do MinIO | `host.docker.internal:9000` | `localhost:9000` |
| Pasta de dados | `../data` (= `/home/jovyan/data`) | `data/` (ou `../data` a partir de `dbt_project/`) |
| Pasta `dbt_project/` | **não** montada | Sim |

> **Regras de convivência**
> 1. **Mesmo DuckDB nos dois lados.** O arquivo `data/lakehouse.duckdb`, criado pelo dbt no host, pode ser lido pelos notebooks. Confira se as versões coincidem (Atividade 0 da Aula 6).
> 2. **Um escritor por vez.** Nunca deixe um notebook conectado a `data/lakehouse.duckdb` enquanto o dbt roda no host: o arquivo fica em uma pasta compartilhada entre Windows e Linux, onde o bloqueio de arquivos não é confiável. No notebook, prefira ler a Gold pelos Parquets em `s3://gold`; se abrir o `.duckdb`, use `read_only=True` e `con.close()` ao terminar.
> 3. **Catálogo Iceberg compartilhado.** O `catalog.db` pode ser usado pelos dois lados; muda apenas o endereço do MinIO informado por quem acessa.

## Cronograma das aulas restantes

O meu planejamento original previa a Camada Silver na própria Aula 5. Como a aula de 29/10 foi dedicada ao ajuste da imagem do Jupyter e ao início do Iceberg, o conteúdo restante foi redistribuído nas **três aulas finais**, preservando todos os tópicos da ementa.

| Aula | Tema da ementa | Prática (este roteiro) | Teoria (decks) |
|---|---|---|---|
| **6** | Formatos de Tabela (Lakehouse), conclusão · **Transformação e Camada Silver** | Iceberg (Células 4–11) · DuckDB analítico (Células 12–15) · dbt *staging* e *intermediate* | Aula 5 (Lakehouse, ELT/dbt, Silver) |
| **7** | **Modelagem para Analytics, IA e Camada Gold** · **Qualidade e Testes** | Esquema estrela, fato incremental, SCD2, marts em `s3://gold`, *features* e churn · testes dbt, unitários e contratos | Aula 6 + blocos 1–2 da Aula 7 |
| **8** | **Governança** · **Orquestração e Deploy em Produção** | Pandera na ingestão, documentação/linhagem/PII · Airflow + Cosmos, *Assets*, manutenção Iceberg e CI | Bloco 3 da Aula 7 + Aula 8 |

## Convenções de nomes (continuação do repositório)

| Tipo | Já existentes | Novos neste roteiro |
|---|---|---|
| Notebooks | `1_notebook_spark`, `2_duckdb` | `2_duckdb` (continuação), `3_gold.ipynb` |
| Scripts | `1_…` a `11_demonstrar_partition_prunning.py`, `bronze_writer.py` | `12_carga_incremental_demo.py`, `13_treinar_churn.py`, `14_carga_invalida_demo.py`, `15_validar_bronze.py`, `16_manutencao_iceberg.py`, `17_gerar_amostra_ci.py` |

> **Versões de referência (nov/2026):** DuckDB 1.5 (manter `<2.0` por compatibilidade com o PyIceberg) · PyIceberg 0.11–0.12 · dbt-core 1.12 · dbt-duckdb 1.11 · Apache Airflow 3.3 · astronomer-cosmos 1.15 · Pandera 0.35. Os blocos de código foram executados em ambiente de teste com essas versões (S3 simulado no lugar do MinIO).

---

# AULA 6 — Lakehouse (conclusão) e Camada Silver com dbt

**Pré-requisitos:** estado descrito em "Ponto de partida"; MinIO e `spark-jupyter` em execução.

| Atividade | Tema | Onde | Ferramentas |
|---|---|---|---|
| 0 | Retomada do ambiente e alinhamento de versões | 🐳 + 💻 | Docker, PowerShell |
| 1 | Apache Iceberg (continuação): cargas, *time travel*, DELETE/UPSERT, evolução de schema | 🐳 `2_duckdb.ipynb` | PyIceberg, DuckDB |
| 2 | DuckDB como motor analítico sobre a Bronze | 🐳 `2_duckdb.ipynb` | DuckDB SQL |
| 3 | Projeto dbt e modelos *staging* | 💻 PowerShell | dbt-core, dbt-duckdb |
| 4 | Modelos *intermediate*: deduplicação, enriquecimento e segmentação | 💻 PowerShell | dbt, macros Jinja |

---

## Atividade 0 — Retomada do Ambiente

### Passo 1 — Subir os serviços

```powershell
cd ~/engenharia-dados-2026-2/docker
docker compose up -d minio spark-jupyter
docker compose ps
docker logs spark-jupyter 2>&1 | Select-String "token=" | Select-Object -Last 1
```

### Passo 2 — Reexecutar as Células 1 a 3 do `2_duckdb.ipynb`

Abra `notebooks/2_duckdb.ipynb` no Jupyter Lab (`http://localhost:8888`) e execute as três primeiras células. O secret do DuckDB não é persistente, e o objeto `tabela` precisa ser carregado de novo. O `create_table_if_not_exists` apenas **carrega** a tabela criada na aula anterior.

### Passo 3 — Alinhar a versão do DuckDB entre host e contêiner

A partir da Atividade 3, o dbt (no host) grava `data/lakehouse.duckdb`, e os notebooks (no contêiner) poderão lê-lo. As duas versões do DuckDB precisam ser iguais:

```powershell
# no host
.\.venv\Scripts\python -c "import duckdb; print(duckdb.__version__)"
# no contêiner
docker exec spark-jupyter python -c "import duckdb; print(duckdb.__version__)"
```

Se forem diferentes, fixe no `docker/spark-jupyter/Dockerfile` a mesma versão do host (por exemplo `"duckdb==1.5.6"` no lugar de `"duckdb>=1.4,<2"`) e reconstrua a imagem com `docker compose up -d --build spark-jupyter`. **Não** use `docker compose down -v`: a opção `-v` apaga o volume do MinIO.

---

## Atividade 1 — Apache Iceberg (continuação) 🐳

### Objetivo

Carregar dados na tabela criada na aula anterior e demonstrar, com operações reais, as garantias do Lakehouse: snapshots imutáveis, *time travel*, exclusão e *upsert* transacionais (caso LGPD), evolução de schema sem reescrita e leitura por outro motor.

> Todas as células desta atividade continuam o `notebooks/2_duckdb.ipynb`, depois da Célula 3. Elas usam os objetos `con`, `MINIO`, `catalog`, `tabela` e `NOME_TABELA` das células anteriores.

### Passo 4 — Primeira carga (Snapshot 1)

```python
# Célula 4 — Leitura da Bronze e primeira carga
s3 = boto3.client(
    "s3",
    endpoint_url=MINIO["s3.endpoint"],          # http://host.docker.internal:9000 (definido na Célula 2)
    aws_access_key_id=MINIO["s3.access-key-id"],
    aws_secret_access_key=MINIO["s3.secret-access-key"],
    region_name="us-east-1",
)

arquivos = [
    o["Key"] for o in s3.list_objects_v2(Bucket="bronze", Prefix="ecommerce_sintetico/").get("Contents", [])
    if o["Key"].endswith(".parquet")
]
df_bronze = pd.read_parquet(io.BytesIO(s3.get_object(Bucket="bronze", Key=arquivos[0])["Body"].read()))
print(f"Bronze: {len(df_bronze):,} linhas em {arquivos[0]}")

COLUNAS = [campo.name for campo in tabela.schema().fields]

def preparar_lote(df: pd.DataFrame) -> pa.Table:
    """Converte um DataFrame da Bronze para o schema Arrow da tabela Iceberg."""
    df = df.copy()
    df["avaliacao_cliente"] = pd.to_numeric(df["avaliacao_cliente"], errors="coerce").astype("Int32")
    df["quantidade"] = df["quantidade"].astype("int32")
    return pa.Table.from_pandas(df[COLUNAS], schema=tabela.schema().as_arrow(), preserve_index=False)

inicio = time.time()
tabela.append(preparar_lote(df_bronze.iloc[:50_000]))
print(f"✅ Snapshot 1: 50.000 registros em {time.time() - inicio:.2f}s")
```

### Passo 5 — Segunda carga e *time travel*

```python
# Célula 5 — Segunda carga (Snapshot 2) e histórico de snapshots
tabela.append(preparar_lote(df_bronze.iloc[50_000:100_000]))
tabela = catalog.load_table(NOME_TABELA)

def listar_snapshots(t):
    for s in sorted(t.snapshots(), key=lambda s: s.timestamp_ms):
        ts = datetime.fromtimestamp(s.timestamp_ms / 1000, tz=timezone.utc)
        print(f"{s.snapshot_id}  {ts:%H:%M:%S}  {s.summary.operation.value:<9}"
              f" +{s.summary.get('added-records', '0'):>6}  total={s.summary.get('total-records')}")

listar_snapshots(tabela)

# Alternativa tabular (metadados como tabela Arrow)
tabela.inspect.snapshots().to_pandas()[["committed_at", "snapshot_id", "operation"]]
```

```python
# Célula 6 — Time travel por ID e por instante
snapshots = sorted(tabela.snapshots(), key=lambda s: s.timestamp_ms)
v1 = snapshots[0]                                     # o mais antigo é o PRIMEIRO em ordem cronológica

n_v1    = tabela.scan(snapshot_id=v1.snapshot_id).to_arrow().num_rows
n_atual = tabela.scan().to_arrow().num_rows
print(f"Snapshot inicial: {n_v1:,} | Atual: {n_atual:,}")

# "Como estava a tabela neste instante?"
s = tabela.snapshot_as_of_timestamp(v1.timestamp_ms)
print("Snapshot vigente naquele instante:", s.snapshot_id)

# Leitura com filtro e projeção: o Iceberg poda partições e arquivos pelas estatísticas dos manifests
df = tabela.scan(
    row_filter="status_pedido == 'cancelado' and data_pedido >= '2022-01-15T00:00:00'",
    selected_fields=("id_pedido", "valor_total", "data_pedido"),
).to_pandas()
print(f"Cancelados após 15/01: {len(df):,}")
```

### Passo 6 — DELETE e UPSERT transacionais (caso LGPD)

```python
# Célula 7 — Direito de eliminação (LGPD art. 18): apagar todos os pedidos de um cliente
cliente = int(tabela.scan(selected_fields=("id_cliente",), limit=1).to_pandas().iloc[0, 0])
print("Antes :", tabela.scan(row_filter=f"id_cliente == {cliente}").to_arrow().num_rows)

tabela.delete(delete_filter=f"id_cliente == {cliente}")
tabela = catalog.load_table(NOME_TABELA)

print("Depois:", tabela.scan(row_filter=f"id_cliente == {cliente}").to_arrow().num_rows)
print("Operação:", tabela.current_snapshot().summary.operation)
```

> **Discussão:** o registro sumiu da versão atual, mas **continua acessível por *time travel*** nos snapshots anteriores. Para cumprir a eliminação de fato, é preciso **expirar os snapshots** que ainda o contêm (rotina de manutenção da Aula 8). LGPD em Lakehouse = `DELETE` + política de retenção de snapshots. Observe também o volume reescrito no resumo do snapshot (`added-records`): com *copy-on-write*, o Iceberg regrava os arquivos que continham o cliente.

```python
# Célula 8 — UPSERT (MERGE) pela chave id_pedido
lote = tabela.scan(row_filter="id_pedido <= 3").to_pandas()
lote["status_pedido"] = "reembolsado"                 # 3 pedidos alterados

novo = lote.iloc[[0]].copy()
novo["id_pedido"], novo["status_pedido"] = 2_000_001, "pendente"   # 1 pedido novo

resultado = tabela.upsert(
    pa.Table.from_pandas(pd.concat([lote, novo]), schema=tabela.schema().as_arrow(), preserve_index=False),
    join_cols=["id_pedido"],
)
print(f"Atualizados: {resultado.rows_updated} | Inseridos: {resultado.rows_inserted}")
tabela = catalog.load_table(NOME_TABELA)
listar_snapshots(tabela)
```

### Passo 7 — Evolução de schema

```python
# Célula 9 — Adicionar e renomear colunas: operações apenas de METADADOS
with tabela.update_schema() as atualizacao:
    atualizacao.add_column("pedido_internacional", BooleanType(),
                           doc="Indica se o pedido foi feito por cliente de outro país")
    atualizacao.rename_column("avaliacao_cliente", "nota_cliente")

tabela = catalog.load_table(NOME_TABELA)
print(tabela.schema())

amostra = tabela.scan(selected_fields=("id_pedido", "nota_cliente", "pedido_internacional"), limit=3)
print(amostra.to_pandas())
```

> **Por que o *rename* não quebra nada?** O Iceberg identifica colunas por **ID** (`field_id`), não por nome. Os arquivos Parquet antigos continuam com o nome `avaliacao_cliente`, mas o campo 11 é lido como `nota_cliente`. Colunas novas retornam `NULL` nos arquivos antigos.
>
> **Atenção:** depois desta célula, a coluna passa a se chamar `nota_cliente`. Se precisar reexecutar as Células 4 a 8, que usam `avaliacao_cliente`, recrie a tabela: `catalog.drop_table(NOME_TABELA)` e depois Célula 3.

### Passo 8 — Leitura pelo DuckDB (interoperabilidade)

```python
# Célula 10 — Outro motor lendo a mesma tabela (reaproveita a conexão `con` da Célula 1)
con.execute("LOAD iceberg;")             # extensão já instalada na imagem

print("metadata.json atual:", tabela.metadata_location)
con.sql(f"""
    SELECT categoria, regiao, COUNT(*) AS pedidos,
           ROUND(SUM(valor_total), 2) AS receita, ROUND(AVG(nota_cliente), 2) AS nota_media
    FROM iceberg_scan('{tabela.metadata_location}')
    WHERE status_pedido = 'concluido'
    GROUP BY ALL ORDER BY receita DESC LIMIT 10
""").df()
```

> O catálogo SQLite não é compartilhável entre motores; por isso apontamos o DuckDB diretamente para o `metadata.json`. Em produção, usa-se um **catálogo REST** (Apache Polaris, Lakekeeper, Nessie, AWS Glue, Unity Catalog), e qualquer motor faz `ATTACH` no catálogo.

### Passo 9 — Anatomia da tabela no MinIO

```python
# Célula 11 — Estrutura física: metadata.json → manifest list → manifests → dados
objetos = s3.list_objects_v2(Bucket="silver", Prefix="bronze_processado/pedidos_ecommerce/")["Contents"]

def classificar(chave: str) -> str:
    nome = chave.rsplit("/", 1)[-1]
    if nome.endswith(".metadata.json"): return "metadata.json"
    if nome.startswith("snap-"):        return "manifest list"
    if nome.endswith(".avro"):          return "manifest"
    return "dados (parquet)"

resumo = pd.DataFrame([{"tipo": classificar(o["Key"]), "kb": o["Size"] / 1024} for o in objetos])
print(resumo.groupby("tipo").agg(arquivos=("kb", "size"), total_kb=("kb", "sum")).round(1))

# Visões de metadados prontas
print(tabela.inspect.partitions().to_pandas()[["partition", "record_count", "file_count"]])
print(tabela.inspect.files().to_pandas()[["file_path", "record_count"]].head())
```

> Em `inspect.partitions()`, o valor `{'data_pedido_mes': 624}` é o número de meses desde jan/1970: (2022 − 1970) × 12 = 624, ou seja, jan/2022.

### Verificação Final da Atividade 1

1. Explicar por que cada `append`, `delete` e `upsert` gera um **novo snapshot** e nunca altera arquivos existentes.
2. Consultar a tabela em um snapshot anterior (por ID e por instante).
3. Executar exclusão por predicado e explicar por que a LGPD exige também **expirar snapshots**.
4. Adicionar e renomear colunas sem reescrever dados, explicando o papel dos *field IDs*.
5. Ler a mesma tabela pelo DuckDB e identificar os quatro níveis de arquivos no MinIO.

---

## Atividade 2 — DuckDB como Motor Analítico 🐳

### Objetivo

Usar o DuckDB para consultas SQL analíticas diretamente sobre os Parquets da Bronze, sem carregá-los em memória nem em um servidor. É o mesmo motor que o dbt usará na Atividade 3, e o mesmo SQL aparecerá nos modelos.

### Passo 1 — Consulta direta sobre Parquet no MinIO

```python
# Célula 12 — Agregação direta sobre a Bronze (1 milhão de pedidos)
inicio = time.time()
resultado = con.sql("""
    SELECT categoria,
           COUNT(*)                    AS total_pedidos,
           ROUND(SUM(valor_total), 2)  AS receita_total,
           ROUND(AVG(valor_total), 2)  AS ticket_medio
    FROM read_parquet('s3://bronze/ecommerce_sintetico/ano=*/**/*.parquet')
    WHERE status_pedido = 'concluido'
    GROUP BY categoria
    ORDER BY receita_total DESC
""").df()
print(f"Tempo: {time.time() - inicio:.2f}s")
resultado
```

> O padrão `ano=*/**/*.parquet` lê apenas os arquivos dentro da estrutura de partições da convenção da Bronze (Aula 2). Arquivos fora dela, como os gravados pelo `dlt` sem partição, ficam de fora.

### Passo 2 — CTEs, agregações condicionais e funções de janela

```python
# Célula 13 — Cancelamento e satisfação por região (CTE + FILTER)
con.sql("""
    WITH pedidos AS (
        SELECT regiao, status_pedido, valor_total, avaliacao_cliente
        FROM read_parquet('s3://bronze/ecommerce_sintetico/ano=*/**/*.parquet')
    )
    SELECT regiao,
           COUNT(*)                                                            AS total_pedidos,
           ROUND(SUM(valor_total), 2)                                          AS receita_total,
           ROUND(100.0 * COUNT(*) FILTER (WHERE status_pedido = 'cancelado') / COUNT(*), 2)
                                                                               AS taxa_cancelamento_pct,
           ROUND(AVG(avaliacao_cliente), 2)                                    AS nota_media
    FROM pedidos
    GROUP BY regiao
    ORDER BY receita_total DESC
""").df()
```

```python
# Célula 14 — Crescimento mensal por categoria (window function LAG)
con.sql("""
    WITH vendas_mensais AS (
        SELECT DATE_TRUNC('month', data_pedido) AS mes, categoria,
               ROUND(SUM(valor_total), 2)       AS receita_mes
        FROM read_parquet('s3://bronze/ecommerce_sintetico/ano=*/**/*.parquet')
        WHERE status_pedido = 'concluido'
        GROUP BY ALL
    )
    SELECT mes, categoria, receita_mes,
           ROUND(100.0 * (receita_mes - LAG(receita_mes) OVER w)
                 / NULLIF(LAG(receita_mes) OVER w, 0), 2) AS crescimento_pct
    FROM vendas_mensais
    WINDOW w AS (PARTITION BY categoria ORDER BY mes)
    QUALIFY mes < '2022-04-01'
    ORDER BY categoria, mes
""").df()
```

### Passo 3 — Views persistentes e exportação exploratória

```python
# Célula 15 — Views no arquivo curso_analytics.duckdb + exportação para s3://gold/exploratorio
con.execute("""
    CREATE OR REPLACE VIEW vw_pedidos_bronze AS
    SELECT * FROM read_parquet('s3://bronze/ecommerce_sintetico/ano=*/**/*.parquet')
""")
con.execute("""
    CREATE OR REPLACE VIEW vw_pokemon_bronze AS
    SELECT * FROM read_parquet('s3://bronze/pokeapi/pokemon/ano=*/**/*.parquet', union_by_name = true)
""")

# Resultados exploratórios NÃO vão para a Bronze (que guarda só dados brutos)
con.execute("""
    COPY (
        SELECT categoria, regiao, DATE_TRUNC('month', data_pedido) AS mes,
               COUNT(*) AS pedidos, ROUND(SUM(valor_total), 2) AS receita
        FROM vw_pedidos_bronze
        WHERE status_pedido = 'concluido'
        GROUP BY ALL
    ) TO 's3://gold/exploratorio/resumo_mensal.parquet' (FORMAT PARQUET, COMPRESSION ZSTD)
""")
con.sql("SELECT COUNT(*) AS linhas FROM 's3://gold/exploratorio/resumo_mensal.parquet'").show()
con.close()          # libera o arquivo .duckdb antes de seguir para o dbt
```

> **Por que a *view* persiste e a credencial não?** A *view* fica gravada no `curso_analytics.duckdb`; o secret, não. Ao reabrir o notebook, rode a Célula 1 antes de consultar as *views*.
>
> **Exercício (DuckDB × Spark):** rode a agregação da Célula 12 também no `1_notebook_spark.ipynb` e compare o tempo total, incluindo a criação da `SparkSession`. Quando cada motor é preferível?

---

## Atividade 3 — Projeto dbt e Modelos *Staging* 💻

### Objetivo

Criar o projeto dbt que materializa a **Camada Silver** sobre a Bronze do MinIO: fontes declaradas, modelos *staging* 1:1 com as fontes, macros reutilizáveis e testes básicos. Tudo é executado pelo DuckDB, sem servidor.

### Passo 1 — Instalação (host, PowerShell com o `.venv` ativo)

O dbt roda **no host**: a pasta `dbt_project/` não está montada no contêiner do Jupyter, e o dbt é uma ferramenta de linha de comando, versionada junto com o projeto.

```powershell
cd ~/engenharia-dados-2026-2
.\.venv\Scripts\Activate.ps1
pip install "dbt-core~=1.12.0" "dbt-duckdb~=1.11.0" "duckdb>=1.4,<2"   # mantém o DuckDB já instalado
dbt --version
python -c "import duckdb; print(duckdb.__version__)"                     # deve ser igual ao do contêiner
```

O `dbt-core` é o motor (compilação Jinja → SQL, grafo de dependências, testes). O `dbt-duckdb` é o **adaptador**. Em outro *warehouse*, troca-se só o adaptador e o `profiles.yml`.

### Passo 2 — Estrutura do projeto

A pasta `dbt_project/` já existe desde a Aula 1, e o `dbt init` recusa pastas existentes. Por isso, crie a estrutura manualmente:

```powershell
cd dbt_project
mkdir models/staging, models/intermediate, models/marts/core, models/marts/analytics, models/marts/ml, macros, snapshots, tests, seeds
```

```text
dbt_project/
├── dbt_project.yml          # configuração do projeto
├── profiles.yml             # conexão (fica no projeto; segredos vêm de variáveis de ambiente)
├── macros/                  # funções Jinja reutilizáveis (DRY)
├── models/
│   ├── staging/             # SILVER — 1 modelo por fonte: renomear, tipar, padronizar
│   ├── intermediate/        # SILVER — joins, deduplicação, regras de negócio
│   └── marts/               # GOLD (Aula 7) — fatos, dimensões, features
├── snapshots/               # SCD tipo 2 (Aula 7)
└── tests/                   # testes singulares (Aula 7)
```

### Passo 3 — `dbt_project.yml`

```yaml
name: curso_ed
version: "1.0.0"
profile: curso_ed

model-paths: ["models"]
macro-paths: ["macros"]
test-paths: ["tests"]
seed-paths: ["seeds"]
snapshot-paths: ["snapshots"]
target-path: "target"
clean-targets: ["target", "dbt_packages"]

vars:
  bronze_root: "s3://bronze"
  gold_root: "s3://gold"
  dias_churn: 60

models:
  curso_ed:
    staging:
      +schema: staging
      +materialized: view
    intermediate:
      +schema: intermediate
      +materialized: view
    marts:
      +schema: marts
      +materialized: table
```

### Passo 4 — `profiles.yml` (conexão DuckDB + MinIO)

```yaml
curso_ed:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: "{{ env_var('DUCKDB_PATH', '../data/lakehouse.duckdb') }}"
      threads: 4
      extensions: [httpfs]
      secrets:
        - type: s3
          key_id: "{{ env_var('MINIO_ACCESS_KEY', 'minioadmin') }}"
          secret: "{{ env_var('MINIO_SECRET_KEY', 'minioadmin123') }}"
          endpoint: "{{ env_var('MINIO_ENDPOINT', 'localhost:9000') }}"
          region: us-east-1
          url_style: path
          use_ssl: false
```

> `env_var()` com valor padrão permite rodar localmente sem configuração e, em produção ou no contêiner, injetar credenciais por variáveis de ambiente, **sem versionar segredos**. O caminho do banco também é parametrizado, porque o Airflow (Aula 8) executa o dbt a partir de outro diretório.

```powershell
dbt debug          # deve terminar com "All checks passed!"
```

### Passo 5 — Macros (DRY)

`macros/generate_schema_name.sql` faz os schemas se chamarem `staging`, `intermediate` e `marts`. Sem ela, o padrão do dbt geraria `main_staging`:

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- if custom_schema_name is none -%}
        {{ target.schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
```

`macros/padronizar_string.sql`:

```sql
{% macro padronizar_string(coluna) -%}
    nullif(lower(trim({{ coluna }})), '')
{%- endmacro %}
```

`macros/mapear_status.sql` traduz o status técnico da origem para o vocabulário de negócio:

```sql
{% macro mapear_status(coluna) -%}
    case {{ padronizar_string(coluna) }}
        when 'concluido'   then 'faturado'
        when 'reembolsado' then 'estornado'
        when 'cancelado'   then 'cancelado'
        when 'pendente'    then 'em_aberto'
        else 'desconhecido'
    end
{%- endmacro %}
```

`macros/colunas_auditoria.sql`:

```sql
{% macro colunas_auditoria() -%}
    current_timestamp            as _dbt_processado_em,
    '{{ invocation_id }}'        as _dbt_invocation_id,
    '{{ this.name }}'            as _dbt_modelo
{%- endmacro %}
```

`macros/contar_por_valor.sql` usa um laço Jinja para gerar SQL dinâmico (um *pivot*):

```sql
{% macro contar_por_valor(coluna, valores, prefixo='qtd') -%}
    {%- for valor in valores %}
    count(*) filter (where {{ coluna }} = '{{ valor }}') as {{ prefixo }}_{{ valor }}
    {%- if not loop.last %},{% endif %}
    {%- endfor %}
{%- endmacro %}
```

### Passo 6 — Declaração das fontes (`models/staging/_sources.yml`)

```yaml
version: 2

sources:
  - name: ecommerce
    description: "Pedidos do sistema de e-commerce (dataset sintético da Aula 1) na camada Bronze"
    tables:
      - name: pedidos
        config:
          external_location: "read_parquet('{{ var('bronze_root') }}/ecommerce_sintetico/ano=*/**/*.parquet', hive_partitioning = false, union_by_name = true, filename = true)"
          loaded_at_field: "cast(_ingerido_em as timestamptz)"
          freshness:
            warn_after: {count: 7, period: day}
            error_after: {count: 30, period: day}

  - name: restcountries
    description: "Países da REST Countries API v5 (Aula 2)"
    tables:
      - name: countries
        config:
          external_location: "read_parquet('{{ var('bronze_root') }}/restcountries_api/countries/ano=*/**/*.parquet', union_by_name = true, filename = true)"

  - name: pokeapi
    description: "Pokémons da PokeAPI (Aula 2)"
    tables:
      - name: pokemon
        config:
          external_location: "read_parquet('{{ var('bronze_root') }}/pokeapi/pokemon/ano=*/**/*.parquet', union_by_name = true, filename = true)"
```

> **Por que `ano=*/**`?** Na Bronze, `pokeapi/pokemon/` contém dois conjuntos de arquivos: os do `dlt` (Aula 2, sem partição e com outro schema, em que os *stats* ficam em tabela filha) e os do `BronzeWriter` (`ano=/mes=/dia=`, colunas `hp_base`, `ataque_base` etc.). O padrão `ano=*/**` lê somente os arquivos que seguem a convenção da Bronze.
>
> `filename = true` acrescenta a coluna `filename` com o arquivo de origem de cada linha, o que dá linhagem até o arquivo da Bronze. `union_by_name` tolera arquivos com colunas em ordem diferente ou colunas novas (evolução de schema na origem).

### Passo 7 — Modelos *staging*

`models/staging/stg_ecommerce__pedidos.sql`. A convenção `stg_<fonte>__<entidade>` vem do guia de estilo do dbt.

```sql
-- Staging: 1:1 com a fonte. Apenas renomear, tipar e padronizar.
with fonte as (
    select * from {{ source('ecommerce', 'pedidos') }}
),

renomeado as (
    select
        cast(id_pedido  as bigint)                   as pedido_id,
        cast(id_cliente as bigint)                   as cliente_id,
        cast(id_produto as bigint)                   as produto_id,
        {{ padronizar_string('categoria') }}         as categoria,
        {{ padronizar_string('regiao') }}            as regiao,
        {{ padronizar_string('status_pedido') }}     as status_origem,
        {{ mapear_status('status_pedido') }}         as status_pedido,
        cast(valor_unitario as decimal(12, 2))       as valor_unitario,
        cast(quantidade     as integer)              as quantidade,
        cast(valor_total    as decimal(14, 2))       as valor_total,
        cast(avaliacao_cliente as integer)           as avaliacao_cliente,
        cast(data_pedido as timestamp)               as pedido_em,
        cast(data_pedido as date)                    as data_pedido,
        _fonte                                       as fonte_sistema,
        cast(_ingerido_em as timestamptz)            as ingerido_em,
        filename                                     as arquivo_origem
    from fonte
)

select * from renomeado
```

`models/staging/stg_restcountries__paises.sql`:

```sql
select
    upper(trim(cca2))                       as pais_codigo,
    trim(nome_comum)                        as pais_nome,
    trim(nome_oficial)                      as pais_nome_oficial,
    {{ padronizar_string('regiao') }}       as regiao_mundial,
    trim(capital)                           as capital,
    cast(populacao as bigint)               as populacao,
    cast(area_km2  as double)               as area_km2,
    cast(_ingerido_em as timestamptz)       as ingerido_em,
    filename                                as arquivo_origem
from {{ source('restcountries', 'countries') }}
```

`models/staging/stg_pokeapi__pokemon.sql`:

```sql
select
    cast(id as integer)                          as pokemon_id,
    {{ padronizar_string('nome') }}              as pokemon_nome,
    {{ padronizar_string('tipo_primario') }}     as tipo_primario,
    {{ padronizar_string('tipo_secundario') }}   as tipo_secundario,
    cast(altura_dm as integer) * 10              as altura_cm,
    cast(peso_hg   as integer) / 10.0            as peso_kg,
    cast(hp_base     as integer)                 as hp_base,
    cast(ataque_base as integer)                 as ataque_base,
    cast(defesa_base as integer)                 as defesa_base,
    cast(_ingerido_em as timestamptz)            as ingerido_em,
    filename                                     as arquivo_origem
from {{ source('pokeapi', 'pokemon') }}
```

### Passo 8 — Documentação e testes da *staging* (`models/staging/_staging.yml`)

```yaml
version: 2

models:
  - name: stg_ecommerce__pedidos
    description: "Pedidos da Bronze renomeados, tipados e padronizados (pode conter duplicatas de reingestão)."
    columns:
      - name: pedido_id
        description: "Identificador do pedido no sistema de origem"
        data_tests:
          - not_null
      - name: cliente_id
        data_tests:
          - not_null
      - name: status_pedido
        description: "Status harmonizado pela macro mapear_status"
        data_tests:
          - accepted_values:
              arguments:
                values: ['faturado', 'cancelado', 'em_aberto', 'estornado']
```

> A partir do dbt 1.10, os parâmetros dos testes genéricos ficam sob `arguments:`. A sintaxe antiga ainda funciona, mas gera aviso de depreciação.

### Passo 9 — Compilar, executar e inspecionar

```powershell
dbt compile --select stg_ecommerce__pedidos     # veja o SQL gerado em target/compiled/
dbt build --select staging                       # cria as views e roda os testes, nesta ordem
dbt show --select stg_ecommerce__pedidos --limit 5
```

Abra `target/compiled/curso_ed/models/staging/stg_ecommerce__pedidos.sql` e veja as macros expandidas em SQL puro: o banco nunca vê Jinja.

---

## Atividade 4 — Modelos *Intermediate* 💻

### Objetivo

Aplicar a lógica que torna a Silver confiável: **deduplicação** das cargas *append-only* da Bronze, **enriquecimento** com regras de negócio e **métricas de cliente** (segmentação RFM), respondendo à pergunta da Aula 4: *"como foi calculado o segmento VIP?"*

### Passo 1 — Deduplicação (`models/intermediate/int_pedidos__deduplicados.sql`)

```sql
-- A Bronze é append-only: o mesmo pedido pode chegar em várias cargas.
-- Mantemos apenas a versão mais recente de cada pedido_id.
select *
from {{ ref('stg_ecommerce__pedidos') }}
qualify row_number() over (
    partition by pedido_id
    order by ingerido_em desc, arquivo_origem desc
) = 1
```

> **Simulação:** para ver a deduplicação funcionando, faça uma segunda carga parcial do dataset sintético em outra partição de data (ex.: 1.000 pedidos com `status_pedido` alterado e novo `_ingerido_em`). O `stg_` terá 1.001.000 linhas e o `int_` continuará com 1.000.000.

### Passo 2 — Enriquecimento (`models/intermediate/int_pedidos__enriquecidos.sql`)

```sql
select
    pedido_id,
    cliente_id,
    produto_id,
    categoria,
    regiao,
    status_pedido,
    status_pedido = 'faturado'                          as is_faturado,
    valor_unitario,
    quantidade,
    valor_total,
    case
        when valor_total <  100  then 'baixo'
        when valor_total <  500  then 'medio'
        when valor_total < 1500  then 'alto'
        else 'premium'
    end                                                 as faixa_valor,
    avaliacao_cliente,
    avaliacao_cliente >= 4                              as is_avaliacao_positiva,
    pedido_em,
    data_pedido,
    date_trunc('month', data_pedido)::date              as mes_pedido,
    row_number() over (
        partition by cliente_id order by pedido_em
    )                                                   as sequencia_pedido_cliente,
    ingerido_em,
    {{ colunas_auditoria() }}
from {{ ref('int_pedidos__deduplicados') }}
```

### Passo 3 — Métricas e segmento de cliente (`models/intermediate/int_clientes__metricas.sql`)

```sql
-- Métricas por cliente e segmentação RFM (Recência, Frequência, Valor monetário)
{% set status_possiveis = ['faturado', 'cancelado', 'em_aberto', 'estornado'] %}

with pedidos as (
    select * from {{ ref('int_pedidos__enriquecidos') }}
),

data_referencia as (
    select max(data_pedido) as data_ref from pedidos
),

agregado as (
    select
        cliente_id,
        min(data_pedido)                                     as primeiro_pedido_em,
        max(data_pedido)                                     as ultimo_pedido_em,
        count(*)                                             as total_pedidos,
        {{ contar_por_valor('status_pedido', status_possiveis) }},
        sum(valor_total) filter (where is_faturado)          as receita_total,
        avg(valor_total) filter (where is_faturado)          as ticket_medio,
        avg(avaliacao_cliente)                               as nota_media
    from pedidos
    group by cliente_id
),

rfm as (
    select
        a.*,
        d.data_ref - a.ultimo_pedido_em                                 as dias_desde_ultimo_pedido,
        ntile(5) over (order by d.data_ref - a.ultimo_pedido_em desc)   as score_r,
        ntile(5) over (order by a.qtd_faturado)                         as score_f,
        ntile(5) over (order by coalesce(a.receita_total, 0))           as score_m
    from agregado a
    cross join data_referencia d
)

select
    *,
    case
        when score_m = 5 and score_f >= 4 and score_r >= 4 then 'vip'
        when score_m >= 4                                  then 'alto_valor'
        when score_r <= 2                                  then 'em_risco'
        else 'regular'
    end as segmento_cliente
from rfm
```

### Passo 4 — Testes da *intermediate* (`models/intermediate/_intermediate.yml`)

```yaml
version: 2

models:
  - name: int_pedidos__deduplicados
    description: "Última versão de cada pedido (deduplicação por pedido_id)."
    columns:
      - name: pedido_id
        data_tests: [unique, not_null]

  - name: int_clientes__metricas
    description: "Uma linha por cliente com métricas RFM e segmento."
    columns:
      - name: cliente_id
        data_tests: [unique, not_null]
      - name: segmento_cliente
        description: "vip = quintil superior em valor, com alta frequência e recência"
        data_tests:
          - accepted_values:
              arguments:
                values: ['vip', 'alto_valor', 'em_risco', 'regular']
```

### Passo 5 — Execução, linhagem e documentação

```powershell
dbt build                          # staging + intermediate + testes
dbt docs generate
dbt docs serve --port 8081         # abra http://localhost:8081 e clique no ícone de grafo (lineage)
```

```powershell
# Conferindo a Silver pelo próprio dbt (sem abrir o .duckdb em outro processo)
dbt show --inline "select segmento_cliente, count(*) as clientes, round(avg(receita_total)) as receita_media from {{ ref('int_clientes__metricas') }} group by 1 order by 3 desc"
```

> Para consultar a Silver em um notebook, **feche antes** qualquer execução do dbt e abra o arquivo em modo leitura: `duckdb.connect("../data/lakehouse.duckdb", read_only=True)`. Feche a conexão (`con.close()`) antes de rodar o dbt de novo.

### Verificação Final da Atividade 4 / Consolidação da Aula 6

1. Explicar a diferença de responsabilidade entre `staging` e `intermediate`.
2. Mostrar no SQL compilado como `ref()` e `source()` foram resolvidos e por que isso cria o grafo de dependências.
3. Demonstrar que a deduplicação mantém exatamente uma linha por `pedido_id`.
4. Explicar `dbt run` × `dbt test` × `dbt build`.
5. Localizar no *lineage* do `dbt docs` o caminho `source → stg → int`.

> **Desafio:** crie a macro `cents_to_reais(coluna)` e uma *seed* (`seeds/regioes.csv`) com a sigla e o nome completo das regiões, ligada aos pedidos em um novo modelo *intermediate*.

---
