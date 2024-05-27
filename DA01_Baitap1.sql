--Bài tập 1
SELECT Name FROM City
WHERE Population > 120000
AND CountryCode = 'USA'
--Bài tập 2
Select * from City
Where Countrycode = 'JPN'
--Bài tập 3
Select city, state from station
--Bài tập 4
Select distinct City from Station
Where CITY like 'A%' 
Or CITY like 'E%'
Or CITY like 'I%' 
Or CITY like 'O%' 
Or CITY like 'U%'
--Bài tập 5
Select distinct City from Station
Where CITY like '%a' 
Or CITY like '%e'
Or CITY like '%i' 
Or CITY like '%o' 
Or CITY like '%u'
--Bài tập 6
SELECT DISTINCT city FROM station
WHERE city NOT LIKE 'A%'
AND city NOT LIKE 'E%'
AND city NOT LIKE 'I%'
AND city NOT LIKE 'O%'
AND city NOT LIKE 'U%'
-- Bài tập 7
SELECT name FROM Employee
ORDER BY name ASC
-- Bài tập 8
SELECT name FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id
-- Bài tập 9
SELECT product_id FROM Products
WHERE low_fats LIKE 'Y'
AND recyclable LIKE 'Y'
-- Bài tập 10
SELECT name FROM Customer
WHERE referee_id <> 2 or referee_id is NULL
-- Bài tập 11
SELECT name,population,area FROM World
WHERE area >= 3000000 or population >= 25000000
-- Bài tập 12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY author_id ASC
-- Bài tập 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL 
-- Bài tập 14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary > 70000
-- Bài tập 15
select advertising_channel from uber_advertising
where money_spent > 100000 and year = '2019'
