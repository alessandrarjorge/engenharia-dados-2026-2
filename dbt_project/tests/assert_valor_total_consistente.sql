-- valor_total deve ser valor_unitario × quantidade (tolerância de 1 centavo)
select pedido_id, valor_unitario, quantidade, valor_total
from {{ ref('int_pedidos__enriquecidos') }}
where abs(valor_total - valor_unitario * quantidade) > 0.01
