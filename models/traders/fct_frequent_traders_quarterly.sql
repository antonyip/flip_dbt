{{
    config(
        materialized="table",
        tags=["traders"],
    )
}}

select
distinct(event_attributes:sender::string) as address,
count(distinct(tx_id)) AS n_txn
from
flipside.terra_sv.msg_events
where
tx_status = 'SUCCEEDED'
AND event_attributes:offer_asset is not null
AND block_timestamp > current_date - interval '90 days'
GROUP BY address