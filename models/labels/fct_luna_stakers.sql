{{
    config(
        materialized="table",
        tags=["staking"],
    )
}}

with
    maxdate as (
        select max(date) as date from flipside.terra.daily_balances where date > current_date - 4
    ),

    luna_staked as (
        select address, balance as staked_luna
        from flipside.terra.daily_balances
        where
            date = (select date from maxdate) - interval '1 day'
            and address_label is null
            and balance_type = 'staked'
            and currency = 'LUNA'
    )

select
    bals.address,
    balance as liquid_luna,
    staked_luna,
    staked_luna / (balance + staked_luna) as staked_prop
from flipside.terra.daily_balances bals
full outer join luna_staked on bals.address = luna_staked.address
where
    date = (select date from maxdate) - interval '1 day'
    and address_label is null
    and balance_type = 'liquid'
    and currency = 'LUNA'
    and staked_luna > 0
