select 
      order_date,
      order_id,
      category,
      total_profit
from `cesatriadata2022.ce_staging.superstore_datasets`
where order_date >= '2011-09-01'
      and order_date < '2011-09-02'
