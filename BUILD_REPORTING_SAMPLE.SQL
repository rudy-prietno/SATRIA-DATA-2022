-- Calculate the total profit in throughout the life of the business
select
  sum(total_profit) TotalProfit
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
