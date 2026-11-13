select
    md5(cast(cliente_id as varchar))     as cliente_sk,      -- chave substituta
    cliente_id,                                              -- chave natural (do sistema de origem)
    primeiro_pedido_em,
    ultimo_pedido_em,
    total_pedidos,
    receita_total,
    segmento_cliente
from {{ ref('int_clientes__metricas') }}
