{% macro grant_select(schema, role) %}

    {% set query %}
        grant usage on schema {{ schema }} to role {{ role }};
        grant select on all tables in schema {{ schema }} to role {{ role }};
        grant select on all views in schema {{ schema }} to role {{ role }};    
    {% endset %}

    {{ log ('Granting select on all tables and views in schema ' ~ schema ~ ' to role ' ~ role, info=True) }}
    {% do run_query(query) %}
    {{ log('Privileges granted!', info=True) }}

{% endmacro %}