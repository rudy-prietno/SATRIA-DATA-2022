-- create table staging with empty data
create table `cesatriadata2022.ce_access_layer.superstore_pr_orderdate_stag` as
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
limit 0
