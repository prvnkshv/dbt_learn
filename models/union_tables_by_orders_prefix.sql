{{ config(
    materialized='view'
    
    ) 
}}

select * 
from (
    {{ union_tables_by_prefix('raw', 'dbt_jinja', 'orders__') }}
)