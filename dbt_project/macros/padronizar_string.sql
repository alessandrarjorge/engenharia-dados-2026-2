{% macro padronizar_string(coluna) -%}
    nullif(lower(trim({{ coluna }})), '')
{%- endmacro %}