{{ config(
    materialized = 'external',
    location = var('gold_root') ~ '/ml/features_clientes.parquet'
) }}
-- Corte temporal (point-in-time): features ANTES da data de corte; rótulo DEPOIS dela.
{% set dias = var('dias_churn') %}

with pedidos as (
    select * from {{ ref('int_pedidos__enriquecidos') }}
),
corte as (
    select max(data_pedido) - interval {{ dias }} day as data_corte
    from pedidos
),
features as (
    select
        p.cliente_id,
        count(*)                                                     as qtd_pedidos,
        count(*) filter (where p.is_faturado)                        as qtd_faturados,
        count(*) filter (where p.status_pedido = 'cancelado')        as qtd_cancelados,
        coalesce(sum(p.valor_total) filter (where p.is_faturado), 0) as receita,
        avg(p.valor_total)                                           as ticket_medio,
        avg(p.avaliacao_cliente)                                     as nota_media,
        count(distinct p.categoria)                                  as categorias_distintas,
        date_diff('day', max(p.data_pedido), any_value(c.data_corte)::date) as dias_desde_ultimo
    from pedidos p
    cross join corte c
    where p.data_pedido < c.data_corte
    group by p.cliente_id
),
rotulo as (            -- clientes que COMPRARAM depois do corte (portanto, não churnaram)
    select distinct p.cliente_id
    from pedidos p cross join corte c
    where p.data_pedido >= c.data_corte
)
select
    f.*,
    case when r.cliente_id is null then 1 else 0 end as churn
from features f
left join rotulo r using (cliente_id)
