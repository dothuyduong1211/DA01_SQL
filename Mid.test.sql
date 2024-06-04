---Q1:
select distinct replacement_cost
from film
order by replacement_cost 

---Q2:
select 
SUM(case when replacement_cost between 9.99 and 19.99 then 1 else 0 End) as Low,
SUM(case when replacement_cost between 20.00 and 24.99 then 1 else 0 End) as Medium,
SUM(case when replacement_cost between 25.00 and 29.99 then 1 else 0 End) as High
from film

---Q3:
select a.title, a.length, c.name as category_name
from film as a
Left join film_category as b on a.film_id = b.film_id
Left join category as c on b.category_id = c.category_id
where c.name in ('Drama','Sports')
order by length DESC

---Q4:
Select c.name as Danh_muc, count(title) as So_luong_phim
From film as a
Left join film_category as b on a.film_id = b.film_id
Left join category as c on b.category_id = c.category_id
Group by Danh_muc
Order by count(title) DESC

---Q5: Khác đáp án GINA DEGENERES	42
select a.actor_id, a.first_name, a.last_name, count(b.film_id)
from actor as a
full join film_actor as b on a.actor_id = b.actor_id
group by a.actor_id
order by count(b.film_id) DESC

---Q6:
select count(b.address_id)
from customer as a
right join address as b
on a.address_id = b.address_id
where a.customer_id is null

---Q7:
select a.city, sum(d.amount)
from city as a
join address as b on a.city_id = b.city_id
join customer as c on b.address_id = c.address_id
join payment as d on c.customer_id = d.customer_id
group by a.city
order by sum(d.amount) DESC

---Q8: Đề bài ghi theo format “city, country" và hỏi thành phố nào doanh thu nào cao nhất nhưng mà Answer lại là thấp nhất và theo format: “country, city"
select a.city || ', ' || e.country as dn_tp , sum(d.amount) as Doanh_thu
from city as a
join address as b on a.city_id = b.city_id
join customer as c on b.address_id = c.address_id
join payment as d on c.customer_id = d.customer_id
join country as e on e.country_id = a.country_id
group by dn_tp
order by sum(d.amount) 
