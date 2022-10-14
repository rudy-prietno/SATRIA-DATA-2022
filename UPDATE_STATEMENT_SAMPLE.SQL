-- update statement example
update `cesatriadata2022.ce_access_layer.superstore_pr_orderdate`
set
  profit=  500,
  quantity=  3,
  category=  'Furniture',
  sub_category=  'Bookcases',
  cost=  980,
  total_gmv=  6000,
  total_cost=  980,
  total_profit=  1500,
  customer_name=  'Satria Data 2022',
  city=  'Yogyakarta',
  country=  'Indonesia',
  region=  'Southeast Asia',
  segment=  'Home Office',
  ship_date=  '2022-01-01',
  ship_mode=  'Economy Plus',
  lon=  -7.6888304,
  lat= 110.4096058
where 
  order_date = '2022-10-15'
  and order_id = 'RD-2022-STDATAINSERT2022101501'
