1.
  WITH CTE1 as 
(
  SELECT 
    DISTINCT b.category,
    FORMAT_TIMESTAMP('%Y-%m', a.created_at) AS month,
    FORMAT_TIMESTAMP('%Y', a.created_at) AS year,
    COUNT(a.order_id) AS total_order,
    ROUND(SUM(a.sale_price),2) AS revenue,
    ROUND(SUM(b.cost),2) as total_cost
  FROM `bigquery-public-data.thelook_ecommerce.order_items` AS a
  JOIN `bigquery-public-data.thelook_ecommerce.products` as b
  ON a.product_id = b.id
  WHERE DATE(a.created_at) BETWEEN '2019-01-01' AND '2022-04-30'
  AND a.status= 'Complete'
  GROUP BY month, year, category
  ORDER BY month DESC, year DESC, category
),
 CTE2 as 
 ( SELECT 
    month,
    year,
    category,
    total_order,
    total_cost,
    LEAD(total_order) OVER (PARTITION BY category ORDER BY month DESC, year DESC) AS total_order_last_month,
    revenue,
    LEAD(revenue) OVER(PARTITION BY category ORDER BY month DESC, year DESC) AS total_revenue_last_month,
    ROUND((revenue - total_cost),2) as total_profit,
    ROUND((revenue - total_cost)/total_cost,2) as profit_to_cost_ratio
  FROM cte1
  ORDER BY month DESC, year DESC, category)
 
 SELECT 
  month,
  year,
  category as Product_category,
  revenue as TPV,
  total_order as TPO,
  ROUND((total_order-total_order_last_month)/total_order_last_month*100,2) AS order_growth,
  ROUND((revenue-total_revenue_last_month)/total_revenue_last_month*100,2) as revenue_growth,
  total_cost,
  total_profit,
  profit_to_cost_ratio
  FROM cte2
  ORDER BY month DESC, year DESC, category

2.
WITH cte1 AS
(
select user_id, sale_price,
FORMAT_TIMESTAMP('%Y-%m', first_purchase_date) as cohort_date,
created_at,
(extract(year from created_at) - extract(year from first_purchase_date))*12
+ (extract(month from created_at) - extract(month from first_purchase_date)) + 1 as index
from
(
  SELECT user_id, 
  MIN(created_at) over(partition by user_id) AS first_purchase_date,
  sale_price,
  created_at
  FROM bigquery-public-data.thelook_ecommerce.order_items
)),
cte2 as 
(
select cohort_date, index,
count(distinct user_id) as cnt,
ROUND(sum(sale_price),2) as revenue
from cte1
group by cohort_date, index
),
cohort_1 as 
(
select 
cohort_date,
SUM(case when index = 1 then cnt else 0 end) as m1,
SUM(case when index = 2 then cnt else 0 end) as m2,
SUM(case when index = 3 then cnt else 0 end) as m3
from cte2
group by cohort_date
order by cohort_date
),
cohort_2 as
(
select
cohort_date, 
ROUND(COALESCE(100.00*m1 / NULLIF(m1,0), 0),2) || '%' as m1,
ROUND(COALESCE(100.00*m2 / NULLIF(m1,0), 0),2) || '%' as m2,
ROUND(COALESCE(100.00*m3 / NULLIF(m1,0), 0),2) || '%' as m3
from cohort_1
)
select
cohort_date, 
 ROUND(COALESCE(100-(100.00*m1 / NULLIF(m1,0)), 0),2) || '%' as m1,
 ROUND(COALESCE(100-(100.00*m2 / NULLIF(m1,0)), 0),2) || '%' as m2,
 ROUND(COALESCE(100-(100.00*m3 / NULLIF(m1,0)), 0),2) || '%' as m3
from cohort_1

Customer_cohort: https://docs.google.com/spreadsheets/d/1YrRedohYfrbM0_vQIBu0e9aFYRL7veSLIZuzWj4NUu4/edit?usp=sharing
Retention_cohort: https://docs.google.com/spreadsheets/d/1tNFNoEEdUinET-uJ1hj69JmgnPv5nWieDC7VLA_0Bi0/edit?usp=sharing
Churn_cohort: https://docs.google.com/spreadsheets/d/1m1dQ01fFg3wON31ThDKli14QVr6GEc5M4vtQI9FklKU/edit?usp=sharing

