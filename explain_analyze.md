Цей запит виконувався через Hash join бере дані спочатку з однієї таблиці
і робить з них хеш таблицю іде в іншу таблицю і порівнює дані.
Також у плані видно що обидві таблиці читаються 
через Seq Scan. Запит виконався за 0.093 ms

THE EXECUTION PLAN

Hash Join (cost=27.09..41.32 rows=7 width=274) (actual time=0.054..0.058 rows=6.00 loops=1)

Hash Cond: (p.product_id = oi.product_id) Buffers: shared hit=2 dirtied=1 

-> Seq Scan on products p (cost=0.00..13.00 rows=300 width=222) (actual time=0.020..0.020 rows=7.00 loops=1) 

Buffers: shared hit=1

-> Hash (cost=27.00..27.00 rows=7 width=28) (actual time=0.025..0.025 rows=6.00 loops=1) 

Buckets: 1024 Batches: 1 Memory Usage: 9kB Buffers: shared hit=1 dirtied=1 

-> Seq Scan on order_items oi (cost=0.00..27.00 rows=7 width=28) (actual time=0.018..0.021 rows=6.00 loops=1) 

Filter: (order_id = 1) Rows Removed by Filter: 3 Buffers: shared hit=1 dirtied=1 

Planning: 

Buffers: shared hit=9

Planning Time: 0.316 ms 

Execution Time: 0.093 ms