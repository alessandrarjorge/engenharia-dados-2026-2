select
    md5(cast(cliente_id as varchar) || cast(dbt_valid_from as varchar)) as cliente_hist_sk,
    cliente_id,
    segmento_cliente,
    dbt_valid_from                                 as valido_de,
    coalesce(dbt_valid_to, timestamp '9999-12-31') as valido_ate,
    dbt_valid_to is null                           as is_atual
from {{ ref('snp_clientes_segmento') }}
