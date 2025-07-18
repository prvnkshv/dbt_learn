{{ limit_data_in_dev(column_name='order_date', dev_days_of_data=1000) }}

with deduped_orders as (
    select *
    from (
        select *,
            row_number() over (
                partition by id
                order by _etl_loaded_at desc
            ) as row_num
        from {{ source('jaffle_shop', 'orders') }}
    )
    where row_num = 1
)

select
    id as order_id,
    user_id as customer_id,
    order_date,
    status,
    _etl_loaded_at
from deduped_orders