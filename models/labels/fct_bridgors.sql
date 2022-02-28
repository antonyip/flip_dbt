{{
    config(
        materialized="table",
        tags=["bridge"],
    )
}}

with
    to_cex as (
        select
            event_from as address,
            sum(event_amount_usd) as sent_to_cex,
            count(distinct(tx_id)) as n_txn_to_cex
        from flipside.terra.transfers
        where
            event_to_label_type = 'cex'
            and event_from_label_type is null
            and block_timestamp > current_date - interval '90 days'
            and tx_status = 'SUCCEEDED'
        group by address
    ),
    from_cex as (
        select
            event_to as address,
            sum(event_amount_usd) as rec_from_cex,
            count(distinct(tx_id)) as n_txn_from_cex
        from flipside.terra.transfers
        where
            event_from_label_type = 'cex'
            and event_to_label_type is null
            and block_timestamp > current_date - interval '90 days'
            and tx_status = 'SUCCEEDED'
        group by address
    ),

    to_bridge as (
        select
            event_from as address,
            count(tx_id) as n_txn_to_bridge,
            sum(event_amount_usd) as sent_to_bridge
        from flipside.terra.transfers
        where
            event_to = 'terra13yxhrk08qvdf5zdc9ss5mwsg5sf7zva9xrgwgc'
            and tx_status = 'SUCCEEDED'
            and block_timestamp > current_date - interval '90 days'
            and event_from_label_type is null
        group by address
    ),
    from_bridge as (
        select
            event_to as address,
            count(tx_id) as n_txn_from_bridge,
            sum(event_amount_usd) as rec_from_bridge
        from flipside.terra.transfers
        where
            event_from = 'terra13yxhrk08qvdf5zdc9ss5mwsg5sf7zva9xrgwgc'
            and tx_status = 'SUCCEEDED'
            and block_timestamp > current_date - interval '90 days'
            and event_to_label_type is null
        group by address
    ),

    net_cex as (
        select
            coalesce(tc.address, fc.address) as address,
            coalesce(sent_to_cex, 0) as sent_to_cex_usd,
            coalesce(n_txn_to_cex, 0) as n_txn_to_cex_usd,
            coalesce(rec_from_cex, 0) as rec_to_cex_usd,
            coalesce(n_txn_from_cex, 0) as n_txn_from_cex_usd,
            coalesce(rec_from_cex, 0) - coalesce(sent_to_cex, 0) as net_from_cex_usd
        from to_cex tc
        full outer join from_cex fc on tc.address = fc.address
    ),

    net_bridge as (
        select
            coalesce(tb.address, fb.address) as address,
            coalesce(sent_to_bridge, 0) as sent_to_bridge_usd,
            coalesce(n_txn_to_bridge, 0) as n_txn_to_bridge_usd,
            coalesce(rec_from_bridge, 0) as rec_to_bridge_usd,
            coalesce(n_txn_from_bridge, 0) as n_txn_from_bridge_usd,
            coalesce(rec_from_bridge, 0) - coalesce(
                sent_to_bridge, 0
            ) as net_from_bridge_usd
        from to_bridge tb
        full outer join from_bridge fb on tb.address = fb.address
    )

select
    coalesce(nc.address, nb.address) as address,

    coalesce(sent_to_cex_usd, 0) as sent_to_cex_usd,
    coalesce(n_txn_to_cex_usd, 0) as n_txn_to_cex,
    coalesce(rec_to_cex_usd, 0) as rec_to_cex_usd,
    coalesce(n_txn_from_cex_usd, 0) as n_txn_from_cex,
    coalesce(net_from_cex_usd, 0) as net_from_cex_usd,

    coalesce(sent_to_bridge_usd, 0) as sent_to_bridge_usd,
    coalesce(n_txn_to_bridge_usd, 0) as n_txn_to_bridge,
    coalesce(rec_to_bridge_usd, 0) as rec_to_bridge_usd,
    coalesce(n_txn_from_bridge_usd, 0) as n_txn_from_bridge,
    coalesce(net_from_bridge_usd, 0) as net_from_bridge_usd,

    coalesce(net_from_cex_usd, 0) + coalesce(
        net_from_bridge_usd, 0
    ) as net_from_bridge_cex

from net_cex nc
full outer join net_bridge nb on nc.address = nb.address
