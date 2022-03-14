{{
    config(
        materialized="table",
        tags=["flipside"],
    )
}}

with
parse as (
    select ingest_timestamp, try_parse_json(ingest_data) as parsed_data
    from antonyip.src_flipside_bounties
),
flattened_questions as (
    select
        ingest_timestamp,
        t.value
    from parse,
        Table(Flatten(parsed_data:data:bounties)) t
),
final as (
  select
    ingest_timestamp,
    value:campaign:startDate::timestamp as startDate, 
    value:campaign:endDate::timestamp as endDate, 
    value:campaign:project:name::text as program, 
    value:title::text as questionTitle,
    value:shortDescription::text as shortDescription,
    value:description::text as description,
    value:difficulty::text as difficulty,
    value:payoutAmount::text as payoutAmount,
    value:grandPrizePayoutAmount::text as grandPrizePayoutAmount,
    value:payoutCurrency::text as payoutCurrency
  from flattened_questions
)
select * from final