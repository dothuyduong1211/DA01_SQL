--- Bài tập 1 ---
select count(distinct company_id) as duplicate_companies
from 
(select company_id, title, description, count(job_id) as job_count
from job_listings
group by company_id, title, description ) as job_listings_1
where job_count > 1

--- Bài tập 2 ---
with cte1 as 
(select category, product,
sum(spend) as total_spend,
rank() over (partition by category order by sum(spend) DESC) as product_ranking --- Xếp hạng RANK() OVER (ORDER BY column1, column2, ...) + PARTITION BY: dùng để nhóm các hàng có liên quan đến nhau thành 1 partition để thực hiện việc tính toán
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
(select user_id
from user_actions
where extract(month from event_date) = 6),

July as
(select user_id, extract(month from event_date) as month
from user_actions
where extract(month from event_date) = 7)

select month, count(distinct July.user_id) as monthly_active_users
from July
join June on june.user_id = july.user_id
group by month

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
select count(distinct company_id) as duplicate_companies
from 
(select company_id, title, description, count(job_id) as job_count
from job_listings
group by company_id, title, description ) as job_listings_1
where job_count > 1
  
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
