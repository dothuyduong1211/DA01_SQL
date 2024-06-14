1.
SELECT
   FORMAT_TIMESTAMP('%Y-%m', created_at) as month_year,
   COUNT(DISTINCT user_id) as total_user,
   COUNT(order_id) as total_order
 FROM `bigquery-public-data.thelook_ecommerce.orders`
 WHERE FORMAT_TIMESTAMP('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04'
 AND status = 'Complete'
 GROUP BY 1
 ORDER BY 1

2. 
SELECT 
FORMAT_TIMESTAMP('%Y-%m', a.created_at) AS month_year,
COUNT(DISTINCT a.user_id) AS distinct_users,
ROUND(SUM(sale_price)/ COUNT(DISTINCT a.order_id),2) AS average_order_value
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS a
INNER JOIN `bigquery-public-data.thelook_ecommerce.orders` AS b
ON a.order_id = b.order_id
WHERE FORMAT_TIMESTAMP('%Y-%m', a.created_at) BETWEEN '2019-01' AND '2022-04'
AND a.status = 'Complete'
GROUP BY month_year
ORDER BY month_year

3.
SELECT first_name, last_name, gender,
MIN(age) OVER(PARTITION BY gender) AS age,
'youngest' as tag
FROM `bigquery-public-data.thelook_ecommerce.users` 
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age IN (SELECT MIN(age) FROM `bigquery-public-data.thelook_ecommerce.users`)

UNION ALL
SELECT first_name, last_name, gender,
MAX(age) OVER(PARTITION BY gender) AS age,
'oldest'as tag
FROM `bigquery-public-data.thelook_ecommerce.users` 
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
AND age IN (SELECT MAX(age) FROM `bigquery-public-data.thelook_ecommerce.users`)
ORDER BY age 

4. 
with cte1 as  
(select
  FORMAT_TIMESTAMP('%Y-%m', a.created_at) as month_year,
  a.product_id, b.product_name, 
  ROUND(SUM(a.sale_price),2) as sales,
  ROUND(SUM(b.cost),2) as cost,
  ROUND((SUM(a.sale_price) - SUM(b.cost)),2) as profit,
from `bigquery-public-data.thelook_ecommerce.order_items` as a
join `bigquery-public-data.thelook_ecommerce.inventory_items` as b
on a.product_id = b.product_id
group by 1,2,3
),
rank as
(select *,
dense_rank() over(partition by month_year order by profit ) as XH
from cte1)
select *
from rank 
where XH <=5

5.
with cte1 as
(select
distinct a.category AS product_categories,
date(b.created_at) as date,
round(sum(b.sale_price),2) AS revenue
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.id = b.product_id
WHERE date(b.created_at)BETWEEN '2022-01-15'AND '2022-04-15'
AND b.status = 'Complete'
group by 1,2)
select *,
ROUND(SUM(revenue) over(partition by product_categories order by date),2) as Luy_ke
from cte1
