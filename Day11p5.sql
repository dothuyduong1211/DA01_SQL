---Bài tập 1---
Select b.continent, floor(avg(a.population))
From city as a
Inner join country as b
On a.CountryCode = b.Code
group by  b.continent

---Bài tập 2---
SELECT 
  ROUND(cast(COUNT(b.email_id) as DECIMAL) /COUNT(DISTINCT a.email_id),2) AS activation_rate
FROM emails as a
LEFT JOIN texts as b
ON a.email_id = b.email_id and b.signup_action = 'Confirmed'

---Bài tập 3---
SELECT a.age_bucket,
ROUND(SUM(Case when b.activity_type = 'send' then b.time_spent else 0 end)*100/
    SUM(Case when b.activity_type in ('send','open') then b.time_spent else 0 end),2) as send_perc,
ROUND(SUM(Case when b.activity_type = 'open' then b.time_spent else 0 end)*100/
    SUM(Case when b.activity_type in ('send','open') then b.time_spent else 0 end),2) as open_perc
FROM age_breakdown as a
JOIN activities as b
ON a.user_id = b.user_id
group by a.age_bucket

---Bài tập 4---
SELECT customer_id
FROM customer_contracts as a
JOIN products as b
ON a.product_id = b.product_id
Group by customer_id
Having count(distinct b.product_category) = 3

---Bài tập 5---
select a.employee_id, a.name, 
count(b.reports_to) as reports_count , ceiling(avg(b.age)) as average_age
from Employees as a
join Employees as b
on a.employee_id = b.reports_to
group by a.employee_id

---Bài tập 6---
select a.product_name, SUM(b.unit) as unit
from products as a
Join orders as b
on a.product_id = b.product_id  
Where b.order_date between '2020-02-01' AND '2020-02-29'
group by a.product_name
having SUM(b.unit) >=100

---Bài tập 7---
SELECT a.page_id
FROM pages as a
LEFT JOIN page_likes as b
ON a.page_id = b.page_id
where b.page_id is NULL
order by page_id
