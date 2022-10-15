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



-- What is the 3rd busiest start station in 2015 (in terms of the number of rentals) and its weekly cumulative number of rentals in 2016?
-- subquery version
SELECT
  id,week_number,rental_count,
  SUM(rental_count) OVER(ORDER BY week_number)cumulative_sum
FROM (
  SELECT
    id, EXTRACT(week FROM ch.start_date)week_number,
    COUNT(rental_id)rental_count
  FROM (
    SELECT
      cs.id, COUNT(ch.rental_id)rental_count,
      RANK() OVER(ORDER BY COUNT(ch.rental_id) DESC)rank
    FROM
      `bigquery-public-data.london_bicycles.cycle_stations` cs
    JOIN
      `bigquery-public-data.london_bicycles.cycle_hire` ch
    ON
      cs.id = ch.start_station_id
    WHERE
      start_date >= '2015-01-01 00:00:00' AND start_date < '2016-01-01 00:00:00'
    GROUP BY 1
  )t1
  JOIN
    `bigquery-public-data.london_bicycles.cycle_hire` ch
  ON
    ch.start_station_id=t1.id
    AND ch.start_date >= '2016-01-01 00:00:00' AND ch.start_date < '2017-01-01 00:00:00'
  WHERE
    rank=3
  GROUP BY 1, 2
)t2


-- What is the 3rd busiest start station in 2015 (in terms of the number of rentals) and its weekly cumulative number of rentals in 2016?
-- with clause version
with 
  t1 as 
    (
        select
          cs.id, 
          count(ch.rental_id)rental_count,
          RANK() OVER(order by count(ch.rental_id) desc)rank
        from
          `bigquery-public-data.london_bicycles.cycle_stations` cs
        join
          `bigquery-public-data.london_bicycles.cycle_hire` ch
        on
          cs.id = ch.start_station_id
        where
          start_date >= '2015-01-01 00:00:00' and start_date < '2016-01-01 00:00:00'
        group by 1
    ),
  t2 as 
    (
        select 
          id, 
          EXTRACT(week from ch.start_date)week_number,
          count(rental_id)rental_count
        from t1
        join
          `bigquery-public-data.london_bicycles.cycle_hire` ch
        on
          ch.start_station_id=t1.id
          and ch.start_date >= '2016-01-01 00:00:00' and ch.start_date < '2017-01-01 00:00:00'
        where
          rank=3
        group by 1, 2
    )
    select 
      id,
      week_number,
      rental_count,
      sum(rental_count) OVER(ORDER BY week_number)cumulative_sum
    from t2



-- Of the bikes that are ridden TO stations with no install date, what percentage of them are ridden FROM stations with install date?
select
  count( distinct bike_id) count_bike,
  sum(IF(`end`.id IS NOT NULL,1,0)) sum_bike_end,
  sum(IF(`end`.id IS NOT NULL,1,0))/count(distinct bike_id) percentage_end
from
  `bigquery-public-data.london_bicycles.cycle_stations` start
join
  `bigquery-public-data.london_bicycles.cycle_hire` ch
  on
    start.id = ch.start_station_id
    and start.install_date is NULL
left join
  `bigquery-public-data.london_bicycles.cycle_stations` `end`
  on
    `end`.id = ch.end_station_id
    and `end`.install_date is not NULL
group by `end`.install_date, start.install_date


-- What are some popular routes?
select
  start_station_id,
  end_station_id,
  count(*) as Trips_on_route
from
  `bigquery-public-data.new_york_citibike.citibike_trips`
where
  (start_station_id != end_station_id) #or (start_station_id = end_station_id and tripduration > 300)
group by
  start_station_id,
  end_station_id
order by
  Trips_on_route desc
limit 10


-- Who rides more men or women? And how has their riding behavior changed over the years?
select
  extract(year from starttime) as year,
  sum(case
        when gender='female' 
        then tripduration
      end
    )/60*60 as Male_ride_time,
  sum(case
        when gender='male' 
        then tripduration
      end
    )/60*60 as Female_ride_time
from
  `bigquery-public-data.new_york_citibike.citibike_trips`
group by
  year
having 
  year is not NULL
order by year desc


-- How many trips does each generation (gen z to boomer) take in a year? And what kind of trend is observed over the years?
select
  extract(year from starttime) as year,
  count(case
          when birth_year>= 1940 AND birth_year < 1959 
          then 1
        end
    ) as Boomer,
  count(case
          when birth_year>= 1960 AND birth_year < 1979 
          then 1
        end
    ) as Gen_X,
  count(case
          when birth_year>= 1980 AND birth_year < 1994 
          then 1
        end
    ) as Gen_Y,
  count(case
          when birth_year>= 1995 and birth_year < 2012 
          then 1
        end
    ) as Gen_Z
from
  `bigquery-public-data.new_york_citibike.citibike_trips`
group by year
having year is not NULL
order by year desc
