-- insert data statemen example
insert into 
  `cesatriadata2022.ce_access_layer.superstore_pr_orderdate` (
      order_id,
      gmv,
      order_date
  )
values (
  'RD-2022-STDATAINSERT2022101501',
  2000,
  '2022-10-15'
)

-- how to check the new data you have after insert
select 
  order_id,
  gmv,
  order_date
from `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
where order_date = '2022-10-15'
