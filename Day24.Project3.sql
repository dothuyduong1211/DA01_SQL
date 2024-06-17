--1--
select 
productline,
year_id,
dealsize,
SUM(sales) as Revenue
from public.sales_dataset_rfm_prj
group by productline,year_id,dealsize
order by year_id,dealsize

--2--
select 
month_id,
SUM(sales) as revenue,
COUNT(ordernumber) as order_number
from public.sales_dataset_rfm_prj
group by month_id
order by revenue DESC

--3--
select
productline,
SUM(sales) as revenue,
COUNT(ordernumber) as order_number
from public.sales_dataset_rfm_prj
where month_id = '11' 
group by productline,month_id
order by revenue DESC

--4--
with cte1 as
(
select year_id, productline, SUM(sales) as revenue
from public.sales_dataset_rfm_prj
where country = 'UK'
group by productline, year_id
),
cte2 as 
(
select year_id, productline, revenue,
rank() over(partition by year_id order by revenue DESC ) as rank
from cte1
)
select * from cte2
where rank = 1

--5--
with cte1 as
(
select customername,
current_date - MAX(orderdate) as R,
count(distinct ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj
group by customername
),
cte2 as 
(
select customername,
ntile(5) over(order by R DESC) as R_score,
ntile(5) over(order by F) as F_score,
ntile(5) over(order by M) as M_score
from cte1
),
cte3 as
(
select customername,
cast(R_score as varchar) || cast(F_score as varchar) || cast(M_score as varchar) as RFM
from cte2
)
select a.customername, b.segment
from cte3 as a
join public.segment_score as b on b.scores = a.RFM
