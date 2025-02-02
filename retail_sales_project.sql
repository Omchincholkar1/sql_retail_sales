create database sql_project1;
-- Retail Sales Analysis

create table retail_sales(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(10),
	age	int,
	category varchar(15), 	
	quantiy int,	
	price_per_unit float,	
	cogs float,	
	total_sale float
);

select count(*) from retail_sales;

--DATA CLEANING
select * from retail_sales;

select * from retail_sales 
where 	transactions_id is null 
		or
		sale_date is null
		or
		sale_time is null
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

delete from retail_sales
where transactions_id is null 
		or
		sale_date is null
		or
		sale_time is null
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

--DATA EXPLORATION

--Number of sales we have
select count(*) as total_sales from retail_sales; 

--Number of unique customers we have
select count(distinct customer_id) as unique_customers from retail_sales;

--Number of unique Catefories
select count(distinct category) as unique_categories from retail_sales;


--KEY BUSINESS PROBLEMS AND ANSWERS

--Q1] Retrive all columns for sales made on '2022-11-05'
select * from retail_sales where sale_date = '2022-11-05'

--Q2] All transaction where category is clothing, quantity sold is more than 10 in the month of 
--Nov-2022
select * from retail_sales
where category='Clothing' and quantiy>=4 and to_char(sale_date,'YYYY-MM')='2022-11';

--Q3] Total Sale for each Category
select category, sum(total_sale) as total_sales
from retail_sales
group by category;

--Q4] Average age of customers who purchased items from beauty category.
select avg(age) as average_age
from retail_sales
where category='Beauty';

--Q5] All transactions where total sales greater than 1000
select * from retail_sales
where total_sale>1000;

--Q6] Total number of tractions made by each gender in each category
select category, gender, count(transactions_id) as total_transactions
from retail_sales
group by 1,2
order by category;

--Q7] Average sale for each month and best selling month in each year.
select * from
(
	select avg(total_sale) as average_sale, extract(month from sale_date) as month_,
	extract(year from sale_date) as year_,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as ranks
	from retail_sales
	group by year_, month_
)
where ranks=1;

--Q8] Top 5 customers based on highest total sales.
select customer_id, sum(total_sale) as sales
from retail_sales
group by customer_id
order by sales desc
limit 5;

--Q9] Number of unique customers who purchased items from each category
select category,count(distinct customer_id)
from retail_sales
group by category;

--Q10] To create each shift and number of orders
with hourly_sale 
as
(select *,
	case
	when extract(hour from sale_time)<12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end 
	as shift
from retail_sales)
select shift, count(*) as total_orders
from hourly_sale
group by shift;

--THE END--