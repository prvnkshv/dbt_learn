with deduped as (
    select *
    from (
        select *,
            row_number() over (
                partition by id
                order by _batched_at desc
            ) as row_num
        from {{ source('stripe', 'payment') }}
    )
    where row_num = 1
)

select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    {{ cents_to_dollars('amount', 4) }} as amount,
    created as created_at,
    _batched_at
from deduped
