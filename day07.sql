-- Bài tập 1 --
select name from students
where marks > 75 
order by right(name, 3), id ASC

-- Bài tập 2 --
select user_id, 
concat(upper(left(name,1)), substring(lower(name),2)) as name
from Users
Order by user_id 

--Bài tập 3 --
SELECT manufacturer,
'$' || ROUND(sum(total_sales)/1000000) || 'million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC , manufacturer

--Bài tập 4 --
SELECT
extract(month from submit_date) as month,
product_id as product,
round(avg(stars),2) as avg_stars
FROM reviews
group by product_id,month
order by month, product

-- Bài tập 5 --
SELECT sender_id, 
count(message_id) as message_count
FROM messages
where extract(month FROM sent_date) = 8 and extract(year FROM sent_date) = 2022
group by sender_id
order by count(message_id) DESC
limit 2

-- Bài tập 6 --
select tweet_id from Tweets
where length(content) > 15

-- Bài tập 7 --
select activity_date as day, 
count(distinct(user_id)) as active_users 
from Activity
where activity_date between "2019-06-28" and "2019-07-27"
group by activity_date

-- Bài tập 8 --
select 
count(id)
from employees
where joining_date between '2022-01-01' and '2022-08-01'

-- Bài tập 9 --
select 
position('a'in first_name)
from worker
where first_name = 'Amitah'

-- Bài tập 10 --
select winery,
substring(title,length(winery)+2,4) 
from winemag_p2
where country = 'Macedonia'
