create database salesDataWalmart;
use salesdatawalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

select * from sales;

-- Feature Engineering
-- time_of_date

select
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
from sales;

alter table sales add column time_of_day varchar(20);
update sales set time_of_day = (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END);


-- day and month name
select date, dayname(date), monthname(date) from sales;
alter table sales add column day_name varchar(10);
alter table sales add column month_name varchar(10);
update sales set day_name = (dayname(date));
update sales set month_name = (monthname(date));


--                                         Generic

select distinct city, branch, product_line from sales;

--                                         Product
 
-- most common payment method
select payment, count(payment) from sales
group by payment
order by count(payment) desc;


-- most selling product line
select product_line, count(product_line) from sales
group by product_line
order by count(product_line) desc;


-- total renvenue by month
select sum(total), month_name from sales
group by month_name
order by sum(total) desc;


-- largest cogs by month
select sum(cogs), month_name from sales
group by month_name
order by sum(cogs) desc;


-- product line with largest revenue
select sum(total), product_line from sales
group by product_line
order by sum(total) desc;


-- largest revenue by city
select sum(total), city, branch from sales
group by city, branch
order by sum(total) desc;


-- largest VAT(value added tax) by product line
select avg(tax_pct), product_line from sales
group by product_line
order by avg(tax_pct) desc;


-- branch sold more products than avg product sold
select branch, sum(quantity) as qty from sales
group by branch
having qty>(select avg(quantity) from sales);


-- most product line by gender
select gender,product_line, count(product_line) from sales
group by gender, product_line
order by count(product_line) desc;


-- avg rating of each product line
select product_line, avg(rating) from sales
group by product_line
order by avg(rating) desc;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales
select avg(quantity) from sales;
select product_line, CASE WHEN avg(quantity) > 6 THEN "Good" else "bad" end from sales
group by product_line;


--                                        Customers

-- unique customer type
select distinct(customer_type) from sales;


-- most common customer type
select customer_type, count(*) from sales
group by customer_type
order by  count(*) desc;


-- most customer type by gender
select count(customer_type), gender from sales
group by gender
order by count(customer_type) desc;

-- gender distribution per branch
select gender, count(gender), branch from sales
where branch = "A"
group by gender
order by count(gender) desc;

-- which time of the day do customer give most ratings
select time_of_day, avg(rating) from sales
group by time_of_day
order by avg(rating) desc;


-- Which time of the day do customers give most ratings per branch?
select avg(rating), time_of_day, branch from sales
where branch = "B"
group by time_of_day
order by avg(rating) desc;

-- which day's of week has best avg rating
select avg(rating), day_name from sales
group by day_name
order by avg(rating) desc;


-- which day's of week has best avg per branch
select avg(rating), day_name, branch from sales
where branch = "C"
group by day_name
order by avg(rating) desc;


--                                         Product

-- number of sales made in each time of the day per weekday
select time_of_day, count(*), day_name from sales
where day_name = "Monday"
group by time_of_day
order by count(*) desc;


-- which of the customer type brings the most revenue
select customer_type, sum(total) from sales
group by customer_type
order by sum(total) desc;


-- which city has the largest VAT percent
select city, round(avg(tax_pct),2) as avg_vat from sales
group by city
order by total_vat desc;


-- which customer type pays the most in vat
select customer_type, count(tax_pct) from sales
group by customer_type
order by count(tax_pct) desc;
