---Bài tập 1---
with cte1 as
(select 
extract(year from transaction_date) as yr,
product_id,
spend as curr_year_spend,
Lag(spend) over(partition by product_id order by product_id, extract(year from transaction_date)) as prev_year_spend
from user_transactions)

select yr,product_id, 
curr_year_spend, 
prev_year_spend,
round((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate
from cte1

---Bài tập 2---
with cte1 as
(select
card_name,
issued_amount,
row_number() over(partition by card_name order by issue_year,issue_month ) as rank
FROM monthly_cards_issued)

select 
card_name, issued_amount
from cte1
where rank = 1
order by issued_amount DESC

---Bài tập 3---
with cte1 as 
(select
user_id, spend,transaction_date,
row_number() over(partition by user_id order by transaction_date) as stt
from transactions)

select user_id, spend, transaction_date
from cte1
where stt = 3

---Bài tập 4---
With cte1 as
(SELECT 
user_id, product_id, transaction_date,
rank() over(partition by user_id order by transaction_date DESC) as stt
FROM user_transactions)

select transaction_date,  user_id, count(product_id) as purchase_count
from cte1 
where stt = 1
group by transaction_date, user_id
order by transaction_date

---Bài tập 5---
with cte1 as 
(select user_id,tweet_date,tweet_count,
LAG(tweet_count, 1) OVER(PARTITION BY user_id ORDER BY user_id) as lag1,
LAG(tweet_count, 2) OVER(PARTITION BY user_id ORDER BY user_id) as lag2
from tweets)

select user_id,tweet_date,
case 
when lag1 is null then round(tweet_count,2)
when lag2 is null then round((tweet_count+lag1)/2.0,2)
else round((tweet_count+lag1+lag2)/3.0,2)
end as rolling_avg_3d
from cte1

---Bài tập 6---
with cte1 as 
(select merchant_id,credit_card_id, amount,
(extract(epoch from transaction_timestamp) - 
  extract(epoch from lag(transaction_timestamp) 
  over(partition by merchant_id, credit_card_id, amount 
  order by transaction_timestamp)))/60 as minute
from transactions)

select count(merchant_id) 
from cte1
where minute <= 10

---Bài tập 7---
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

---Bài tập 8---
with cte1 as 
(select
a.artist_name, 
dense_rank() over (order by count(b.song_id) DESC) as artist_rank
from artists as a
join songs as b on a.artist_id = b.artist_id
join global_song_rank as c on c.song_id = b.song_id
where c.rank <= 10
group by a.artist_name)

select artist_name, artist_rank
from cte1
where artist_rank <= 5
