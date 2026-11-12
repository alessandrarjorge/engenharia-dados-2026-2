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