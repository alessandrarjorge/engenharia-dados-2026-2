-- Calendário gerado por SQL, cobrindo o intervalo dos pedidos
with limites as (
    select min(data_pedido) as inicio, max(data_pedido) as fim
    from {{ ref('int_pedidos__enriquecidos') }}
),
calendario as (
    select cast(unnest(generate_series(inicio, fim, interval 1 day)) as date) as data
    from limites
)
select
    cast(strftime(data, '%Y%m%d') as integer)       as data_sk,
    data,
    year(data)                                      as ano,
    quarter(data)                                   as trimestre,
    month(data)                                     as mes,
    strftime(data, '%Y-%m')                         as ano_mes,
    day(data)                                       as dia,
    isodow(data)                                    as dia_semana,
    isodow(data) in (6, 7)                          as is_fim_de_semana
from calendario
