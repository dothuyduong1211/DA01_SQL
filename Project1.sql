---Câu 1---
alter table SALES_DATASET_RFM_PRJ
alter column ordernumber type numeric using (trim(ordernumber):: numeric),
alter column quantityordered type numeric using (trim(quantityordered):: numeric),
alter column priceeach type numeric using (trim(priceeach):: numeric),
alter column orderlinenumber type numeric using (trim(orderlinenumber):: numeric),
alter column sales type numeric using (trim(sales):: numeric),
alter column msrp type numeric using (trim(msrp):: numeric),
alter column orderdate type timestamp USING orderdate::timestamp without time zone

---Câu 2---
Select *
From SALES_DATASET_RFM_PRJ
Where ORDERNUMBER::text is null or ORDERNUMBER::text = ''

Select *
From SALES_DATASET_RFM_PRJ
Where QUANTITYORDERED::text is null or QUANTITYORDERED::text = ''

Select *
From SALES_DATASET_RFM_PRJ
Where PRICEEACH::text is null or PRICEEACH::text = ''

Select *
From SALES_DATASET_RFM_PRJ
Where ORDERLINENUMBER::text is null or ORDERLINENUMBER::text = ''

Select *
From SALES_DATASET_RFM_PRJ
Where SALES::text is null or SALES::text = ''

Select *
From SALES_DATASET_RFM_PRJ
Where  ORDERDATE ::text is null or ORDERDATE ::text  =''

---Câu 3---
Alter table SALES_DATASET_RFM_PRJ
Add CONTACTLASTNAME VARCHAR(255),
Add CONTACTFIRSTNAME VARCHAR(255)

Update SALES_DATASET_RFM_PRJ
Set CONTACTLASTNAME =  SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1),
   CONTACTFIRSTNAME = SUBSTRING(contactfullname FROM 1 FOR POSITION('-' IN contactfullname) - 1)

Update SALES_DATASET_RFM_PRJ
Set CONTACTLASTNAME=UPPER(LEFT(CONTACTLASTNAME,1)) || SUBSTRING(CONTACTLASTNAME from 2),
CONTACTFIRSTNAME=UPPER(LEFT(CONTACTFIRSTNAME,1)) || SUBSTRING(CONTACTFIRSTNAME from 2)

---Câu 4---
Alter table SALES_DATASET_RFM_PRJ
    Add QTR_ID VARCHAR(255),
    Add MONTH_ID VARCHAR(255),
    Add YEAR_ID VARCHAR(255)
	
Update SALES_DATASET_RFM_PRJ
Set QTR_ID = extract(quarter from ORDERDATE),
    MONTH_ID = extract(month from ORDERDATE),
    YEAR_ID = extract(year from ORDERDATE)

---Câu 5---
with cte1 as 
(
select *,
(select avg(QUANTITYORDERED) from SALES_DATASET_RFM_PRJ) as avg,
(select stddev(QUANTITYORDERED) from SALES_DATASET_RFM_PRJ) as stddev
from SALES_DATASET_RFM_PRJ
),
find_outlier as 
(
select *,
(QUANTITYORDERED - avg)/stddev as z_score
from cte1
where abs((QUANTITYORDERED - avg)/stddev) > 3
)
update SALES_DATASET_RFM_PRJ
set QUANTITYORDERED = (select avg(QUANTITYORDERED) from SALES_DATASET_RFM_PRJ)
where QUANTITYORDERED in (select QUANTITYORDERED from find_outlier)

---Câu 6---
Alter table SALES_DATASET_RFM_PRJ
Rename to SALES_DATASET_RFM_PRJ_CLEAN

