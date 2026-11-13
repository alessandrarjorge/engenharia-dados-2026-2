select distinct
    md5(categoria)  as categoria_sk,
    categoria
from {{ ref('int_pedidos__enriquecidos') }}
