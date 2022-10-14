-- insert data into table staging using insert into select
insert into `cesatriadata2022.ce_access_layer.superstore_pr_orderdate_stag` 
select
order_id,
        gmv,
        profit,
        quantity,
        category,
        sub_category,
        cost,
        total_gmv,
        total_cost,
        total_profit,
        order_date,
        customer_name,
        city,
        country,
        region,
        segment,
        ship_date,
        ship_mode,
        lon,
        lat
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
where 
  order_date = '2022-10-15'
  and order_id = 'RD-2022-STDATAINSERT2022101501'
