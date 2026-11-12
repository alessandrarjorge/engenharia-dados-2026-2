{% macro colunas_auditoria() -%}
    current_timestamp            as _dbt_processado_em,
    '{{ invocation_id }}'        as _dbt_invocation_id,
    '{{ this.name }}'            as _dbt_modelo
{%- endmacro %}