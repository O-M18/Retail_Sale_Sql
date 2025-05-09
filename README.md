# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named ``.
- **Table Creation**: A table named `retail` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql

CREATE TABLE retail
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
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


```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail 
where sale_date= '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select * from retail
where category='Clothing' 
	and quantiy >=4 
	and to_char(sale_date,'YYYY-MM')='2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,sum(total_sale) as total_sales,count(*) Total_orders
from retail 
group by category
order by 2 desc;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select category,round(avg(age),2) as avg_age from retail 
group by category
having category ='Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail 
where total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category,gender,count (*) total_number from retail
group by category, gender
order by 1;

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id, sum(total_sale)as Total_sale from retail 
group by customer_id
order by 2 desc
limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select category,count(distinct customer_id)from retail
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

11. **Which product category has the highest average profit per unit sold? (Use: total_sale - cogs)**:
```sql
select category, round(avg(Profit))
from(
	select *,(total_sale-cogs)as Profit 
	from retail
) as t1
group by 1
order by 2 desc;
```

12. **Which age group (e.g., 18–25, 26–35, etc.) has the highest number of *transactions*, not just sales?**:
```sql
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
```


13. **What is the trend of sales by day of the week? (e.g., Are weekends more profitable?)**:
```sql
select 
to_char(sale_date,'Day')as day,
sum(total_sale)as week_sale
from retail
group by 1
order by 2 desc;
```

-- Q14: Which customers have made purchases across the most categories?
```sql
select 
to_char(sale_date,'Day')as day,
sum(total_sale)as week_sale
from retail
group by 1
order by 2 desc;
```
select customer_id,count(distinct category) unique_count
from retail
group by 1
order by 2 desc;


15. **What percentage of total sales comes from customers aged below 30?**:
```sql
select 
	round(
		(sum(case when age< 30 then total_sale else 0 end )*100)/
		sum(total_sale)
		) as Total_percentage
from retail;
```

16. **Are there any customers who bought items from the same category more than 5 times?**:
    
```sql
select customer_id,category,count(*)as category_count
from retail
group by 1, 2
having count(*) > 5
order by 3 desc;
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

