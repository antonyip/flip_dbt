{{
    config(
        materialized="table",
        tags=["wallets"],
    )
}}

select distinct
    msg_value:sender as sender
from flipside.terra_sv.msgs
where block_timestamp > current_date - 7
    and msg_type = 'wasm/MsgExecuteContract'
    and tx_status = 'SUCCEEDED'
