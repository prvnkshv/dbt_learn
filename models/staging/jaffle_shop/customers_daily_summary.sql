-- This overrides the config in dbt_project.yml, and this model will not require tests
{{ config(required_tests=None) }}

select
    
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'order_date']) }} as id,
    customer_id,
    order_date,
    count(*) as num_orders

from {{ ref('stg_jaffle_shop__orders') }}
group by 1,2,3