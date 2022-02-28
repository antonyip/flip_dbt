{{
    config(
        materialized="table",
        tags=["traders"],
    )
}}

with
    sells as (
        select offer_currency as currency, sum(offer_amount_usd) as sum_currency
        from flipside.terraswap.swaps
        where
            1 = 1 and sender in (
                select address from "COMMUNITY"."ANTONYIP"."ANT_INTERESTED_ADDRESS"
            ) and block_timestamp > current_date - 2
        group by 1
    ),
    buys as (
        select return_currency as currency, sum(return_amount_usd) as sum_currency
        from flipside.terraswap.swaps
        where
            1 = 1 and sender in (
                select address from "COMMUNITY"."ANTONYIP"."ANT_INTERESTED_ADDRESS"
            ) and block_timestamp > current_date - 2
        group by 1
    )

select
    nvl(s.currency, b.currency) as f_currency,
    nvl(s.sum_currency, 0) as sell_amount,
    nvl(b.sum_currency, 0) as buy_amount,
    buy_amount - sell_amount as net_amount,
    coalesce(l.token_symbol, l.token_name, f_currency) as final_id
from sells s
full outer join buys b on s.currency = b.currency
left join antonyip.ant_et_tokens l on f_currency = l.token_address
order by net_amount desc
