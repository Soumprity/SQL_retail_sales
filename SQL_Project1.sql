--SQL Retail Sales Analysis-P1
create database sql_peoject_p2;

--create table
drop table if exists retail_sales;
create table retail_sales
         (
           transactions_id int primary key,
		   sale_date date,	
		   sale_time time,	
		   customer_id int,	
		   gender varchar(20),	
		   age int,	
		   category varchar(20),
		   quantiy int,
		   price_per_unit float,	
		   cogs float,
		   total_sale float
         );

select * from retail_sales;

select count(*) from retail_sales;
--cogs=purchasing power

--data cleaning
--to find null values
select * from retail_sales
where 
     transactions_id is null
	 or
	 sale_date is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or
	 total_sale is null;
--deleting null values
delete from retail_sales
where 
     transactions_id is null
	 or
	 sale_date is null
	 or
	 customer_id is null
	 or
	 gender is null
	 or
	 age is null
	 or
	 category is null
	 or
	 quantiy is null
	 or
	 price_per_unit is null
	 or
	 cogs is null
	 or
	 total_sale is null;

--updating the column name
alter table retail_sales
rename column quantiy to quantity;

select * from retail_sales;

--data exploration
--how many sales we have?
select count(*) as total_sales from retail_sales;

--how many unique customers we have? 
select count(distinct customer_id) from retail_sales;

--unique categories
select count(distinct category) from retail_sales;
select distinct category from retail_sales;

--Data Analaysis and business key problems and answers
--1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales
where sale_date = '2022,11,05';

--for date values we need to use single inverted commas

--Write a SQL query to retrieve all transactions where the category is 'Clothing'
--and the quantity sold is equal to or more than 4 in the month of Nov-2022:

select * from retail_sales
where 
     category = 'Clothing'
	 and
	 to_char(sale_date, 'YYYY-MM')='2022-11'
	 and 
	 quantity>=4;

--Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as net_sales,
count(*) as total_orders from retail_sales
group by 1;

--we counted the order per category as well so count function is used

--Write a SQL query to find the average age of customers who purchased 
--items from the 'Beauty' category.:
select category, round(avg(age),2) as avg_age from retail_sales
where category ='Beauty'
group by 1;

--we can just do the below steps
select round(avg(age),2) as avg_age from retail_sales
where category ='Beauty';

--Write a SQL query to find all transactions 
--where the total_sale is greater than 1000.:
select * from retail_sales
where total_sale>1000;

--Write a SQL query to find the total number of 
--transactions (transaction_id) made by each gender in each category.:
select category, gender, count(transactions_id) as transactions from retail_sales
group by 1,2;

--Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year:
select extract(month from sale_date) as month,
extract(year from sale_date) as year,
avg(total_sale)as avg_sales from retail_sales
group by 1,2
order by 2, 3 desc
--from here we can just rank the one with the highest avg monthly sale using windows function
select * from 
( 
 select extract(month from sale_date) as month,
 extract(year from sale_date) as year,
 avg(total_sale)as avg_sales,
 rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
 from retail_sales
 group by 1,2
) as t1
where rank =1
--instead of * we can write year, month and avg_sales

--*Write a SQL query to find the top 5 customers based on the highest total sales **:
select distinct customer_id, sum(total_sale) as total 
from retail_sales 
group by 1
order by 2 desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category.:
select category, count(distinct customer_id)as customer 
from retail_sales 
group by 1

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--we can check the current hour using the below formula
select EXTRACT(HOUR FROM current_time) 

--end of project