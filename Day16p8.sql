---BT1:
with cte1 as
(select min(order_date) as first_order_date, 
min(customer_pref_delivery_date) as first_delivery_date 
from Delivery 
group by customer_id)

select
round((100*SUM(case when first_order_date = first_delivery_date then 1 else 0 end))/count(*),2) as  immediate_percentage
from cte1

---BT2:
with cte1 as (select player_id, event_date,
lead(event_date) over(partition by player_id order by event_date) as lead_day,
row_number() over(partition by player_id order by event_date) as day_stt
from Activity)

select
round(count(*)/(select count(distinct player_id) from Activity),2) as fraction
from cte1
where date_sub(lead_day, interval 1 day) = event_date and day_stt = 1

--BT3:
select 
case 
when id = (SELECT MAX(id) FROM seat) and id%2 = 1 then id
when id%2 = 1 then id + 1
else id -1 end as id,
student
from Seat
order by id

--BT4:
with cte1 as (
select visited_on, SUM(amount) as day_amount 
from Customer 
group by visited_on
)
select visited_on,(day_amount+amount1+amount2+amount3+amount4+amount5+amount6) as amount,
round((day_amount+amount1+amount2+amount3+amount4+amount5+amount6)/7,2) as average_amount 
from (select visited_on, day_amount,
lag(day_amount,1) over(order by visited_on) as amount1,
lag(day_amount,2) over(order by visited_on) as amount2,
lag(day_amount,3) over(order by visited_on) as amount3,
lag(day_amount,4) over(order by visited_on) as amount4,
lag(day_amount,5) over(order by visited_on) as amount5,
lag(day_amount,6) over(order by visited_on) as amount6,
dense_rank() over(order by visited_on) as day
from cte1) as cte2
where day >=7

--BT5
select round(sum(tiv_2016),2) as tiv_2016
from Insurance
where tiv_2015 in (select tiv_2015
from Insurance 
group by tiv_2015
having count(pid) > 1)

and (lat,lon) in(select lat, lon
from Insurance 
group by lat, lon
having count(pid) = 1)

--BT6:
with cte1 as (
select b.name as Department, a.name as Employee, a.salary as Salary,
dense_rank () over(partition by b.name order by a.salary DESC) as stt
from Employee as a
join Department as b on a.departmentId = b.id
)
select Department, Employee, Salary
from cte1
where stt <=3

--BT7:
with cte1 as (
select turn, person_id, person_name, weight,
SUM(weight) over(order by turn ASC) as Total_Weight
from Queue
)
select person_name
from cte1
where Total_Weight = 1000

--BT8:
select distinct product_id,
first_value(new_price) over (partition by product_id order by change_date DESC ) as price
from Products
where change_date <= '2019-08-16'
union
select distinct product_id, 10 as price
from Products
where product_id not in (select product_id from Products
where change_date <= '2019-08-16')
