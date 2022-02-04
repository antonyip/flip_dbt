{{ config(materialized='table') }}

SELECT 
    date_trunc('day', block_timestamp) as metric_date,
    count(distinct block_id) as daily_block_count
-- Note we are referring to tables defined in ./models/sources.yml with `ref`
-- the format is `source(<schema_name>, <table_name>)`
FROM {{ source("terra_sv", "blocks") }}
WHERE block_timestamp >= getdate() - interval '7 days'
GROUP BY 1
