select top 10 * from swiggy_data;

-- Data Validation and Cleaning

-- Check for null values in each column
select 
	COUNT(*) as total_rows,
	sum(case when State IS NULL then 1 else 0 end) as null_state,
	sum(case when City IS NULL then 1 else 0 end) as null_city,
	sum(case when Order_Date IS NULL then 1 else 0 end) as null_order_date,
	sum(case when Restaurant_Name IS NULL then 1 else 0 end) as null_restaurant,
	sum(case when Location IS NULL then 1 else 0 end) as null_location,
	sum(case when Category IS NULL then 1 else 0 end) as null_category,
	sum(case when Dish_Name IS NULL then 1 else 0 end) as null_dish,
	sum(case when Price_INR IS NULL then 1 else 0 end) as null_price,
	sum(case when Rating IS NULL then 1 else 0 end) as null_rating,
	sum(case when Rating_Count IS NULL then 1 else 0 end) as null_rating_count
from swiggy_data;

-- Blank or Empty Strings
select *
from swiggy_data
where State = '' or City = '' or Order_Date = '' or Restaurant_Name = '' or Location = '' or Category = '' or Dish_Name = '';

select 
	sum(case when LTRIM(rtrim(State)) = '' then 1 else 0 end) as blank_state,
	sum(case when LTRIM(rtrim(City)) = '' then 1 else 0 end) as blank_city,
	sum(case when LTRIM(rtrim(Order_Date)) = '' then 1 else 0 end) as blank_order_date,
	sum(case when LTRIM(rtrim(Restaurant_Name)) = '' then 1 else 0 end) as blank_restaurant,
	sum(case when LTRIM(rtrim(Location)) = '' then 1 else 0 end) as blank_loc,
	sum(case when LTRIM(rtrim(Category)) = '' then 1 else 0 end) as blank_category,
	sum(case when LTRIM(rtrim(Dish_Name)) = '' then 1 else 0 end) as blank_dish_name,
	sum(case when LTRIM(rtrim(Price_INR)) = '' then 1 else 0 end) as blank_price,
	sum(case when LTRIM(rtrim(Rating)) = '' then 1 else 0 end) as blank_rating,
	sum(case when LTRIM(rtrim(Rating_Count)) = '' then 1 else 0 end) as blank_rating_count
from swiggy_data;

-- Duplicate Detection
select State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count, COUNT(*) as cnt
from swiggy_data
group by State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count
having COUNT(*) > 1
order by cnt desc;

-- Delete Duplication
with cte as
(
select *,
ROW_NUMBER() over(partition by State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count order by (select null)) as rn
from swiggy_data
)
delete
from cte where rn > 1;

-- Creating Schema:
-- Dimension Tables
-- DATE Table
create table dim_date (
date_id int identity(1,1) primary key,
full_date date,
year int,
month int,
month_name varchar(20),
quarter int,
day int,
weeks int
);

-- Location table
create table dim_location (
location_id int identity(1,1) primary key,
state varchar(100),
city varchar(100),
location varchar(500)
);

-- Restaurant table
create table dim_restaurant (
restaurant_id int identity(1,1) primary key,
restaurant_name varchar(200)
);

-- Category table
create table dim_category (
category_id int identity(1,1) primary key,
category varchar(200),
);

-- Dish_Name table
create table dim_dish (
dish_id int identity(1,1) primary key,
dish_name varchar(200),
);

-- Fact Table
create table fact_swiggy_orders (
order_id int identity(1,1) primary key,
date_id int,
price_inr decimal(10, 2),
rating decimal(4, 2),
rating_count int,

location_id int,
restaurant_id int,
category_id int,
dish_id int

foreign key (date_id) references dim_date(date_id),
foreign key (location_id) references dim_location(location_id),
foreign key (restaurant_id) references dim_restaurant(restaurant_id),
foreign key (category_id) references dim_category(category_id),
foreign key (dish_id) references dim_dish(dish_id)
);

-- Insert data in tables
-- dim_date
insert into dim_date (full_date, year, month, month_name, quarter, day, weeks)
select distinct
Order_Date, YEAR(Order_Date) as year, MONTH(Order_Date) as month,
DATENAME(month, Order_Date), DATEPART(Quarter, Order_Date),
DAY(Order_Date), DATEPART(week, Order_Date) 
from swiggy_data
where Order_Date is not null;

-- dim_location
insert into dim_location (state, city, location)
select distinct
State, City, Location
from swiggy_data;

-- dim_restaurant
insert into dim_restaurant (restaurant_name)
select distinct
Restaurant_Name
from swiggy_data;

-- dim_category
insert into dim_category (category)
select distinct
Category
from swiggy_data;

-- dim_dish
insert into dim_dish (dish_name)
select distinct
Dish_Name
from swiggy_data;

-- fact_table
insert into fact_swiggy_orders (
date_id, price_inr, rating, rating_count, location_id, restaurant_id, category_id, dish_id
)
select 
d.date_id, s.Price_INR, s.Rating, s.Rating_Count,
l.location_id, r.restaurant_id, c.category_id, di.dish_id
from swiggy_data s 
join dim_date d
on s.Order_Date = d.full_date

join dim_location l
on s.State = l.state
and s.City = l.city
and s.Location = l.location

join dim_restaurant r
on s.Restaurant_Name = r.restaurant_name

join dim_category c
on s.Category = c.category

join dim_dish di
on s.Dish_Name = di.dish_name;

-- Final Schema
select * 
from fact_swiggy_orders fso
join dim_date dd
on dd.date_id = fso.date_id
join dim_location dl
on dl.location_id = fso.location_id
join dim_restaurant dr
on dr.restaurant_id = fso.restaurant_id
join dim_category dc
on dc.category_id = fso.category_id
join dim_dish d
on d.dish_id = fso.dish_id;

-- KPI's
-- Total Orders
select COUNT(*) as total_orders
from fact_swiggy_orders;

-- Total Revenue (INR Million)
select format(SUM(convert(float, price_inr)) / 1000000, 'N2') + ' INR Million' as total_revenue
from fact_swiggy_orders; 

-- Average dish price
select format(AVG(convert(float, price_inr)), 'N2') + ' INR' as avg_dish_price
from fact_swiggy_orders;

-- Average rating
select AVG(rating) as avg_rating
from fact_swiggy_orders;

-- Deep-Dive Business Analysis

-- Monthly Order trends
select d.year, d.month, d.month_name, COUNT(*) as total_orders from 
fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year, d.month, d.month_name
order by total_orders desc;

-- Quarterly Order Trends
select d.year, d.quarter, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year, d.quarter
order by total_orders desc;

-- Yearly Orders
select d.year, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by d.year;

-- Orders by Day of Week (Mon-Sun)
select DATENAME(WEEKDAY, d.full_date) as day_name, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
group by DATENAME(WEEKDAY, d.full_date), DATEPART(WEEKDAY, d.full_date)
order by DATEPART(WEEKDAY, d.full_date);

-- Location Based Analysis

-- Top 10 cities by order volume
select top 10 l.city, count(*) as total_orders
from fact_swiggy_orders f
join dim_location l on f.location_id = l.location_id
group by l.city
order by total_orders desc;

-- Revenue Contribution by States
select l.state, SUM(f.price_inr) as total_revenue
from fact_swiggy_orders f
join dim_location l on f.location_id = l.location_id
group by l.state
order by total_revenue desc;

-- Total Order Contribution by States
select l.state, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_location l on f.location_id = l.location_id
group by l.state
order by total_orders desc;

-- Food Performance

-- Top 10 Restaurants by Orders
select top 10 r.restaurant_name, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_restaurant r on f.restaurant_id = r.restaurant_id
group by r.restaurant_name
order by total_orders desc;

-- Top Categories by Order Volume
select c.category, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by c.category
order by total_orders desc;

-- Top 10 Ordered Dishes
select top 10 d.dish_name, COUNT(*) as total_orders
from fact_swiggy_orders f
join dim_dish d on f.dish_id = d.dish_id
group by d.dish_name
order by total_orders desc;

-- Cuisine Performance (Orders + Avg Rating)
select c.category, COUNT(*) as total_orders, format(AVG(convert(float, f.rating)), 'N2') as avg_rating
from fact_swiggy_orders f
join dim_category c on f.category_id = c.category_id
group by c.category
order by total_orders desc; 

-- Customer Spending Insights

-- Total Orders by Price Range (Under 100, 100–199, 200–299, 300–499, 500+)
select 
case 
when price_inr < 100 then 'under_100'
when price_inr between 100 and 199 then '100-199'
when price_inr between 200 and 299 then '200-299'
when price_inr between 300 and 499 then '300-499'
else
'500+'
end as price_range,
COUNT(*) as total_orders
from fact_swiggy_orders
group by
case 
when price_inr < 100 then 'under_100'
when price_inr between 100 and 199 then '100-199'
when price_inr between 200 and 299 then '200-299'
when price_inr between 300 and 499 then '300-499'
else
'500+'
end
order by total_orders desc;

-- Ratings Analysis

-- Rating Count Distribution (1 - 5)
select rating, COUNT(*) as rating_count
from fact_swiggy_orders
group by rating
order by rating_count desc
--------------------------------------------------------------------------------------