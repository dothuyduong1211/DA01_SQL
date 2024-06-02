---Bài tập 1---
SELECT 
SUM(CASE when device_type = 'laptop' then 1 else 0 end) as laptop_reviews,
SUM(CASE when device_type in ('tablet','phone') then 1 else 0 end) as mobile_views
FROM viewership

---Bài tập 2---
select x,y,z,
case 
    when (x+y) > z and (x+z) > y and (y+z) > x then 'Yes'
    else 'No'
end as triangle
from Triangle

---Bài tập 3---
select 
round(cast(sum(case when call_category is NULL or call_category = 'n/a' then 1 else 0 end) as decimal) /count(*)*100,1) as uncategorised_call_pct
from callers

---Bài tập 4---
select name from Customer
where referee_id <> 2 or referee_id is NULL

---Bài tập 5---
select survived,
SUM(case when pclass = 1 then 1 else 0 end) as first_class,
SUM(case when pclass = 2 then 1 else 0 end) as second_class,
SUM(case when pclass = 3 then 1 else 0 end) as third_class
from titanic
group by survived
