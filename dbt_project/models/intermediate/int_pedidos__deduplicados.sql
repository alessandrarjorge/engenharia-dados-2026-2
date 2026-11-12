-- A Bronze é append-only: o mesmo pedido pode chegar em várias cargas.
-- Mantemos apenas a versão mais recente de cada pedido_id.
select *
from {{ ref('stg_ecommerce__pedidos') }}
qualify row_number() over (
    partition by pedido_id
    order by ingerido_em desc, arquivo_origem desc
) = 1