{{ config(materialized='table') }}

-- Terra Daily Transactions Example
SELECT 
    metric_date,
    'tx_count' as metric_type,
    daily_tx_count as metric_value
-- Note we are referring to the file ./metrics/terra_daily_txs.sql
FROM {{ ref("terra_daily_txs") }}

UNION ALL

-- Terra Daily Blocks Example
SELECT 
    metric_date,
    'block_count' as metric_type,
    daily_block_count as metric_value
-- Note we are referring to the file ./metrics/terra_daily_blocks.sql
FROM {{ ref("terra_daily_blocks") }}
