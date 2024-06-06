--- Bài tập 1 ---
SELECT COUNT(distinct company_id) AS duplicate_companies
FROM (
  SELECT company_id, title, description, 
    COUNT(job_id) as job_count
  FROM job_listings
  GROUP BY company_id, title, description ) as job_listings_1
WHERE job_count > 1;

--- Bài tập 2 --- phải tra thêm rank + PARTITION BY
with cte1 as 
(select category, product,
sum(spend) as total_spend,
rank() over (partition by category order by sum(spend) DESC) as product_ranking --- Xếp hạng rank (order by cl1,cl2,...) + PARTITION BY: một nhóm các hàng
from product_spend
where extract(year from transaction_date) = 2022
group by category, product)

select category, product, total_spend
from cte1
where product_ranking <= 2

--- Bài tập 3 ---
with callers_callcount AS
(select policy_holder_id, count(case_id) as call_count
from callers
group by policy_holder_id
having count(case_id) >=3)

select count(policy_holder_id) as policy_holder_count
from callers_callcount

--- Bài tập 4 ---
select page_id from pages
where page_id not in 
(select page_id from page_likes)

--- Bài tập 5 ---
With June as
(SELECT user_id
FROM user_actions
WHERE EXTRACT(month from event_date) = 6),

July as
(SELECT user_id, EXTRACT(month from event_date) as month
FROM user_actions
WHERE EXTRACT(month from event_date) = 7)

SELECT month,
    COUNT(DISTINCT July.user_id) AS monthly_active_users
FROM July
JOIN June
ON june.user_id = july.user_id
GROUP BY month

--- Bài tập 6 ---
select left(trans_date,7) as month , country,
count(id) as trans_count, 
SUM(case when state = 'approved' then 1 else 0 end) as approved_count,
SUM(amount) as trans_total_amount,
SUM(case WHEN state = 'approved' then amount else 0 end ) as approved_total_amount 
from Transactions
group by left(trans_date,7), country

--- Bài tập 7 ---
with cte1 as (select product_id, min(year) as first_year from Sales
group by product_id)

select cte1.product_id, cte1.first_year, a.quantity, a.price
from Sales as a
join cte1 on a.product_id = cte1.product_id
group by product_id

--- Bài tập 8 ---
select customer_id
from Customer
group by customer_id
having count(distinct product_key) = (select count(distinct product_key) from Product)

--- Bài tập 9 ---
select  employee_id
from Employees 
where salary < 30000 
and manager_id not in (select employee_id from Employees)

--- Bài tập 10 --- Trùng link bài 1
SELECT COUNT(distinct company_id) AS duplicate_companies
FROM (SELECT company_id, title, description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description ) as job_listings_1
WHERE job_count > 1

--- Bài tập 11 ---
with rating_count as 
(select a.name
from users as a
join MovieRating as b on a.user_id=b.user_id
group by b.user_id
order by count(*) DESC, a.name ASC
limit 1),

rating_average as
(select c.title  
from movies as c
join MovieRating as d on c.movie_id = d.movie_id 
where created_at between '2020-02-01' and '2020-02-29'
group by d.movie_id
order by avg(d.rating) DESC, c.title
limit 1)

select name as results
from rating_count
union all
select title
from rating_average

--- Bài tập 12 ---
select id, count(*) as num
from
(select requester_id as id
from RequestAccepted
union all
select accepter_id 
FROM RequestAccepted) as friends_count
group by id
order by num DESC
limit 1
