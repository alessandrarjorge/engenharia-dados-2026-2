FROM jupyter/pyspark-notebook:spark-3.5.0

# Mesmas versões usadas no venv do host (evita incompatibilidade do arquivo .duckdb)
RUN pip install --no-cache-dir \
      "duckdb>=1.4,<2" \
      "pyiceberg[sql-sqlite,pyarrow,pandas,duckdb]>=0.10" \
      "pyarrow==17.0.0" "numpy==1.24.4" \
      boto3

# Pré-instala as extensões do DuckDB na imagem (não depende de internet na hora da aula)
RUN python -c "import duckdb; c = duckdb.connect(); c.execute('INSTALL httpfs'); c.execute('INSTALL iceberg')"