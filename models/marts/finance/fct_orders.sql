{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'order_id'
) }}

with base_orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

-- Deduplicate orders (in case upstream has duplicates)
orders as (
    select *
    from (
        select *,
            row_number() over (partition by order_id order by order_date desc) as row_num
        from base_orders
    )
    where row_num = 1
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount
    from payments
    group by order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount
    from orders
    left join order_payments using (order_id)
)

select * from final
{% if is_incremental() %}
  -- Only include recently changed orders
  where order_date >= (select max(order_date) from {{ this }})
{% endif %}
order by order_date desc