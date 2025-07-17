-- analyses/data_freshness.sql

select
    max(_etl_loaded_at) as latest_loaded,
    current_timestamp() as now,
    datediff('minute', max(_etl_loaded_at), current_timestamp()) as minutes_since_last_load
from {{ source('jaffle_shop', 'orders') }}