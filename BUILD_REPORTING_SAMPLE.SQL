-- Calculate the total profit in throughout the life of the business
select
  sum(total_profit) TotalProfit
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`


-- Calculate the total profit with grouping by order_date
select
  order_date,
  count(order_id) TotalOrder,
  sum(total_profit) TotalProfit,
  sum(total_gmv) TotalGMV
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
where order_date >= '2011-01-01' and order_date < '2022-11-01'
group by 1
order by 1 desc

-- check duplicate data on column order_id
select
  order_date,
  order_id,
  count(order_id) TotalRows
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
where order_date >= '2011-01-01' and order_date < '2022-11-01'
group by 1,2 
having count(order_id) > 1


-- next, check 1 order_id pattern data to verification
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
where order_date >= '2011-01-01' and order_date < '2022-11-01'
      and order_id ='BN-2013-2008783'
   
   
-- finding sequencial of order customers
select 
  customer_name,
  order_date,
  row_number() over (partition by customer_name order by order_date asc) sequencial
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
where order_date >= '2011-01-01' and order_date < '2022-11-01'
      and customer_name = 'Nate Dacey'
group by 1,2
qualify sequencial >= 1


-- if you want to know when your customers comeback for re-orders
with 
    -- this query define by:rudy prietno --
    SequenceOrderCustomers as (
      select 
        customer_name,
        order_date,
        row_number() over (partition by customer_name order by order_date asc) sequencial
      from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
      where order_date >= '2011-01-01' and order_date < '2022-11-01'
            and customer_name = 'Nate Dacey'
      group by 1,2
      qualify sequencial >= 1
    )
    select
      customer_name,
      order_date,
      -- logic to calculate how much days for customers comeback to re-orders --
      date_diff(order_date, LeadSecuenceOrder_cusctomers, day) ReorderSequence_customers_days
    from (
      select
        customer_name,
        order_date,
        sequencial,
        -- logic for generate date sequence before current order_date --
        lag(order_date) over (partition by customer_name order by order_date asc) LeadSecuenceOrder_cusctomers
      from SequenceOrderCustomers
    ) state1








