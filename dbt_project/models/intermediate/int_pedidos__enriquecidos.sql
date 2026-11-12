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