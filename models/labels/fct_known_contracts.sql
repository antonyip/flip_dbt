{{ 
    config(
        materialized='incremental',
        unique_key='contract',
        incremental_strategy = 'delete+insert',
        tags=['playground'],
        cluster_by=['contract']
        ) 
}}

with 

raws as (
select
  block_timestamp,
  event_attributes:"contract_address"::string as c,
  event_attributes:"0_contract_address"::string as c0,
  event_attributes:"1_contract_address"::string as c1,
  event_attributes:"2_contract_address"::string as c2,
  event_attributes:"3_contract_address"::string as c3,
  event_attributes:"4_contract_address"::string as c4,
  event_attributes:"5_contract_address"::string as c5,
  event_attributes:"6_contract_address"::string as c6,
  event_attributes:"7_contract_address"::string as c7,
  event_attributes:"8_contract_address"::string as c8,
  event_attributes:"9_contract_address"::string as c9
from flipside.terra_sv.msg_events
where 1=1
and {{ incremental_load_filter("block_timestamp") }}
and msg_type = 'wasm/MsgExecuteContract'
and event_type = 'wasm'
),
combine as (
    select
        contract,
        block_timestamp as a_timestamp
            from (
            select block_timestamp, c as contract from raws
            union all
            select block_timestamp, c0 as contract from raws
            union all
            select block_timestamp, c1 as contract from raws
            union all
            select block_timestamp, c2 as contract from raws
            union all
            select block_timestamp, c3 as contract from raws
            union all
            select block_timestamp, c4 as contract from raws
            union all
            select block_timestamp, c5 as contract from raws
            union all
            select block_timestamp, c6 as contract from raws
            union all
            select block_timestamp, c7 as contract from raws
            union all
            select block_timestamp, c8 as contract from raws
            union all
            select block_timestamp, c9 as contract from raws
            )
    where contract is not null
)
, final as (
    select 
    contract,
        max(a_timestamp) as block_timestamp
    from combine
    group by 1
)

select * from final