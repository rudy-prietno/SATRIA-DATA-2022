-- Use the CREATE TABLE statement with a SELECT AS clause for the query. Include a PARTITION BY clause to configure the partitioning.
create table
  `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
   (
          order_id STRING,
          gmv INT64,
          profit INT64,
          quantity INT64,
          category STRING,
          sub_category STRING,
          cost INT64,
          total_gmv INT64,
          total_cost INT64,
          total_profit INT64,
          order_date DATE,
          customer_name STRING,
          city STRING,
          country STRING,
          region STRING,
          segment STRING,
          ship_date DATE,
          ship_mode STRING,
          lon Float64,
          lat Float64
  )
partition by
  order_date
as (
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
  from
    `cesatriadata2022.ce_staging.superstore_datasets`
);
