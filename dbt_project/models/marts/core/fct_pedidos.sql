{{
    config(
        materialized = 'incremental',
        unique_key = 'pedido_id',
        incremental_strategy = 'delete+insert'
    )
}}
-- Fato no grão "1 linha por pedido"
select
    p.pedido_id,
    md5(cast(p.cliente_id as varchar))                    as cliente_sk,
    md5(p.categoria)                                      as categoria_sk,
    cast(strftime(p.data_pedido, '%Y%m%d') as integer)    as data_sk,
    p.produto_id,                                         -- dimensão degenerada
    p.regiao,
    p.status_pedido,
    p.faixa_valor,
    p.quantidade,
    p.valor_unitario,
    p.valor_total,
    case when p.is_faturado then p.valor_total else 0 end as valor_faturado,
    p.avaliacao_cliente,
    p.ingerido_em
from {{ ref('int_pedidos__enriquecidos') }} p
{% if is_incremental() %}
-- Só processa o que chegou depois da última carga do fato
where p.ingerido_em > (select max(ingerido_em) from {{ this }})
{% endif %}
