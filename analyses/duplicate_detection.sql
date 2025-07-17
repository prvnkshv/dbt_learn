
--analyses/duplicate_order_ids.sql

select
    order_id,
    count(*) as order_count
from {{ ref('stg_jaffle_shop__orders') }}
group by order_id
having count(*) > 1