{% macro contar_por_valor(coluna, valores, prefixo='qtd') -%}
    {%- for valor in valores %}
    count(*) filter (where {{ coluna }} = '{{ valor }}') as {{ prefixo }}_{{ valor }}
    {%- if not loop.last %},{% endif %}
    {%- endfor %}
{%- endmacro %}