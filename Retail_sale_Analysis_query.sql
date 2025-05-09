create table retail(
transactions_id	INT,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age	INT,
category VARCHAR(20),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);


--DATA EXPLORATION
--how many sale we have
select count(total_sale) from retail;

--how many unique customer we have
select count(distinct customer_id) from retail;

--what type of category we have
select distinct category from retail;

--FIND NULL VALUES
SELECT * FROM RETAIL 
WHERE transactions_id IS NULL
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or cogs is null 
	or total_sale is null;

---delete data with more  null vlaue
delete from retail 
WHERE transactions_id IS NULL
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or category is null
	or quantiy is null
	or cogs is null 
	or total_sale is null;

---substitute the age avg at null value
select avg(age) avg_age from retail;

update retail set age=41 where age is null;

select * from retail;


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- Q11: Which product category has the highest average profit per unit sold? (Use: total_sale - cogs)
-- Q12: Which age group (e.g., 18–25, 26–35, etc.) has the highest number of *transactions*, not just sales?
-- Q13: What is the trend of sales by day of the week? (e.g., Are weekends more profitable?)
-- Q14: Which customers have made purchases across the most number of categories?
-- Q15: What percentage of total sales comes from customers aged below 30?
-- Q16: Are there any customers who bought items from the same category more than 5 times?

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail 
where sale_date= '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail
where category='Clothing' 
	and quantiy >=4 
	and to_char(sale_date,'YYYY-MM')='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category and order by highest.
select category,sum(total_sale) as total_sales,count(*) Total_orders
from retail 
group by category
order by 2 desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category,round(avg(age),2) as avg_age from retail 
group by category
having category ='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail 
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count (*) total_number from retail
group by category, gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(   select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as Monthly_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail
	group by 1,2
) as t1
where rank=1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale)as Total_sale from retail 
group by customer_id
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
select category,count(distinct customer_id)from retail
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale as(select *,
		case 
		when extract(hour from sale_time)>12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail)
select shift,count(quantiy)as number_of_orders
from hourly_sale
group by 1
order by 1;


-- Q11: Which product category has the highest average profit per unit sold? (Use: total_sale - cogs)
select category, round(avg(Profit))
from(
	select *,(total_sale-cogs)as Profit 
	from retail
) as t1
group by 1
order by 2 desc;

-- Q12: Which age group (e.g., 18–25, 26–35, etc.) has the highest number of *transactions*, not just sales?
with agewise_sale as(select *,
	case
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	else '45+'
	end as age_group
from retail)
select age_group,count(*)as Transcations_count
from agewise_sale
group by 1
order by 2 desc;

-- Q13: What is the trend of sales by day of the week? (e.g., Are weekends more profitable?)
select 
to_char(sale_date,'Day')as day,
sum(total_sale)as week_sale
from retail
group by 1
order by 2 desc;

-- Q14: Which customers have made purchases across the most categories?
select customer_id,count(distinct category) unique_count
from retail
group by 1
order by 2 desc;


-- Q15: What percentage of total sales comes from customers aged below 30?
select 
	round(
		(sum(case when age< 30 then total_sale else 0 end )*100)/
		sum(total_sale)
		) as Total_percentage
from retail;

-- Q16: Are there any customers who bought items from the same category more than 5 times?
select customer_id,category,count(*)as category_count
from retail
group by 1, 2
having count(*) > 5
order by 3 desc;







-------------------------------------------  END of Project ---------------------------------------

