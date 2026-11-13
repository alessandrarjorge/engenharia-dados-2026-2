{{ config(severity = 'warn', store_failures = true) }}
-- Regra de negócio: um produto pertence a UMA categoria.
-- No dataset sintético isso não é garantido -> WARN e falhas gravadas para análise.
select produto_id, count(distinct categoria) as qtd_categorias
from {{ ref('int_pedidos__enriquecidos') }}
group by produto_id
having count(distinct categoria) > 1
