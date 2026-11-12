{% macro mapear_status(coluna) -%}
    case {{ padronizar_string(coluna) }}
        when 'concluido'   then 'faturado'
        when 'reembolsado' then 'estornado'
        when 'cancelado'   then 'cancelado'
        when 'pendente'    then 'em_aberto'
        else 'desconhecido'
    end
{%- endmacro %}