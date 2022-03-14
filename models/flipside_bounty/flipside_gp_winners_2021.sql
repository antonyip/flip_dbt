{{
    config(
        materialized="table",
        tags=["flipside"],
    )
}}

with parsed as (
    select try_parse_json(c1) as parsed_data from antonyip.src_gp_winners_2021
),
gp_winners_2021 as (
  select
    parsed_data:Question::text as question,
    parsed_data:"Bounty Question Description"::text as questiondescription,
    parsed_data:"Discord handle"::text as analyst,
    parsed_data:"Link(s) to public results"::text as link
    from parsed
)

select * from gp_winners_2021