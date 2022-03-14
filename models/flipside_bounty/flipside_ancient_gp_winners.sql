{{
    config(
        materialized="table",
        tags=["flipside"],
    )
}}

with parsed as (
    select try_parse_json(c1) as parsed_data from antonyip.src_gp_ancient_winners
),
ancient_gp_winners as (
  select
    parsed_data:Analyst::text as analyst,
    parsed_data:Link::text as link,
    parsed_data:Program::text as program,
    parsed_data:Question::number as question_id
    from parsed
)

select * from ancient_gp_winners