{{
    config(
        materialized="table",
        tags=["traders"],
    )
}}

with

    i_trades as (
        select sender, sum(return_amount_usd) as sum_return_amount_usd
        from flipside.terraswap.swaps
        where 1 = 1 and block_timestamp > current_date - 7
        group by sender
    )

select *
from i_trades
where sum_return_amount_usd > 10000*7
order by sum_return_amount_usd desc
