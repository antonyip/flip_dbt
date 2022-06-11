{{
    config(
        materialized="table",
        tags=["flipside"],
    )
}}

with fix_name as (
  select 'sam #0575' as old_name, 'sam#0575' as new_name
  union select 'Crypgoat' as old_name, 'crypgoat#8781' as new_name
  union select 'crypgoat #8781' as old_name, 'crypgoat#8781' as new_name
  union select 'Kida' as old_name, 'Kida#8864' as new_name
  union select 'lostarious' as old_name, 'lostarious#6403' as new_name
  union select 'jp12' as old_name, 'jp12#4292' as new_name
  union select 'Scottincrypto' as old_name, 'scottincrypto#8019' as new_name
  union select 'brian_' as old_name, 'Brian_#3619' as new_name
  union select 'AD' as old_name, 'AD#5391' as new_name
),
renames as (
  select
    nvl(fix_name.new_name, analyst) as analyst
  from antonyip.flipside_ancient_gp_winners w
  left join fix_name on w.analyst = fix_name.old_name
),
gp_ancient_winners_ as (
    select
        analyst,
        count(analyst) as ccount
    from renames
    group by 1 
    order by 2 desc
),
gp_2021_winners_ as (
    select 
        analyst,
        count(analyst) as ccount
    from antonyip.flipside_gp_winners_2021
    group by 1 order by 2 desc
),
total_winners as (
   select
        gp_ancient_winners_.analyst,
        nvl(gp_ancient_winners_.ccount,0) as l_count,
        nvl(gp_2021_winners_.ccount,0) as r_count,
        l_count + r_count as total_count
   from gp_ancient_winners_
   left outer join gp_2021_winners_ on gp_ancient_winners_.analyst = gp_2021_winners_.analyst
)


select analyst, total_count from total_winners
order by total_count desc











