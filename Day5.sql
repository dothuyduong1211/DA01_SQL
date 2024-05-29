--Bài tập 1_B5
select distinct city from station
where ID%2=0

--Bài tập 2_B5
select count(city) - count(distinct city) from Station

--Bài tập 3_B5
select ceil(avg(salary)-avg(replace(salary,0,''))) from EMPLOYEES;

--Bài tập 4_B5*
select round(cast(sum(item_count*order_occurrences)/sum(order_occurrences) as DECIMAL),1) as mean 
from items_per_order

--Bài tập 5_B5
SELECT candidate_id FROM candidates
WHERE SKILL IN ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(SKILL) = 3

--Bài tập 6_B5
SELECT user_id, DATE(MAX(post_date)) - DATE(MIN(post_date)) as days_between
FROM posts
where post_date >= '2021-01-01' and  post_date <= '2022-01-01'
GROUP BY user_id
Having COUNT(post_id) >= 2

--Bài tập 7_B5
SELECT card_name, Max(issued_amount)-Min(issued_amount) AS Difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY Difference DESC

--Bài tập 8_B5
SELECT manufacturer, count(drug) as count_dug, SUM(cogs) as Total_loss
FROM pharmacy_sales
Group by manufacturer
  
--Bài tập 9_B5
select * from Cinema
where description <> 'boring' and not id%2=0
order by rating DESC

--Bài tập 10_B5
select teacher_id, Count(distinct subject_id) as cnt
from Teacher
Group by teacher_id

--Bài tập 11_B5
select  user_id, Count(follower_id) as followers_count
from Followers
group by user_id
order by user_id 

--Bài tập 12_B5
select class from courses
group by class
having count(class)>=5
