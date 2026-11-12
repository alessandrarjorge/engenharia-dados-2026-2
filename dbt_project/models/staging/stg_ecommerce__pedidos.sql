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