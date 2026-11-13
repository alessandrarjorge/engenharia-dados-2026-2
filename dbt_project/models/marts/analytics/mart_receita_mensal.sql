{{ config(
    materialized = 'external',
    location = var('gold_root') ~ '/analytics/receita_mensal.parquet'
) }}
select
    d.ano_mes,
    c.categoria,
    f.regiao,
    count(*)                                                    as total_pedidos,
    count(*) filter (where f.status_pedido = 'faturado')        as pedidos_faturados,
    sum(f.valor_faturado)                                       as receita,
    sum(f.valor_faturado)
      / nullif(count(*) filter (where f.status_pedido = 'faturado'), 0) as ticket_medio,
    count(distinct f.cliente_sk)                                as clientes_unicos,
    avg(f.avaliacao_cliente)                                    as nota_media
from {{ ref('fct_pedidos') }} f
join {{ ref('dim_datas') }}      d using (data_sk)
join {{ ref('dim_categorias') }} c using (categoria_sk)
group by all
