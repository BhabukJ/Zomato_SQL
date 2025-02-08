select  * from customers
select  * from restaurants
select  * from Orders
select  * from riders
select  * from deliveries


--Inserting data into customers table
INSERT INTO customers (customer_name, reg_date)
SELECT customer_name, reg_date
FROM zomato_customer;

--Inserting data into restaurants table
INSERT INTO restaurants(restaurant_name,city,opening_hours)
SELECT restaurant_name,city,opening_hours
FROM zomato_restaurants;

--Inserting data into orders table
INSERT INTO Orders(order_id,customer_id,restaurant_id,order_item,order_date,order_time,order_status,total_amount)
SELECT order_id,customer_id,restaurant_id,order_item,order_date,order_time,order_status,total_amount
FROM zomato_orders;

--Inserting data into riders table
INSERT INTO riders(rider_name,sign_up)
SELECT rider_name,sign_up
FROM zomato_riders;

--Inserting data into deliveries table
INSERT INTO deliveries(order_id,delivery_status,delivery_time,rider_id)
SELECT order_id,delivery_status,delivery_time,rider_id
FROM zomato_deleveries;

--Handling NULL

select  count(*) from customers
where customer_id is null
OR
reg_date is null;

select  count(*) from restaurants
where restaurant_name is null
OR
city is null;

select  count(*) from restaurants
where restaurant_name is null
OR
city is null
OR
opening_hours IS NULL;

select   * from orders
WHERE
	order_item is NULL
	OR
	order_date is NULL
	OR
	order_time is NULL
	or 
	order_status is NULL
	or
	total_amount is NULL

	-- Q.1 -- Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta" in the last 1 year.
	select  * from customers;
	select  * from orders;

	select top 5 o.customer_id, c.customer_name,order_item,count(order_item) as order_count,
	DENSE_RANK() OVER(ORDER BY COUNT(*) desc) as rank
	FROM
		customers as c
	 JOIN
		orders as o
	ON
		c.customer_id=o.customer_id
	WHERE c.customer_name='Arjun Mehta'

	GROUP BY
		o.customer_id,c.customer_name,order_item
	ORDER BY
		count(order_item) desc;

- 2. Popular Time Slots
-- Question: Identify the time slots during which the most orders are placed. based on 2-hour intervals.
		
select  * from Orders
		
SELECT
    time_slot,
    COUNT(order_id) AS order_count
FROM (
    SELECT
        order_id,
        CASE
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 0 AND 1 THEN '00:00-02:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 2 AND 3 THEN '02:00-04:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 4 AND 5 THEN '04:00-06:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 6 AND 7 THEN '06:00-08:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 8 AND 9 THEN '08:00-10:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 10 AND 11 THEN '10:00-12:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 12 AND 13 THEN '12:00-14:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 14 AND 15 THEN '14:00-16:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 16 AND 17 THEN '16:00-18:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 18 AND 19 THEN '18:00-20:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 20 AND 21 THEN '20:00-22:00'
            WHEN DATEPART(HOUR, TRY_CAST(order_time AS TIME)) BETWEEN 22 AND 23 THEN '22:00-00:00'
        END AS time_slot
    FROM Orders
) AS subquery
GROUP BY time_slot
ORDER BY order_count DESC;

select
	Floor(DATEPART(HOUR, TRY_CAST(order_time as TIME))/2)*2 as start_time,
	Floor(DATEPART(HOUR, TRY_CAST(order_time as TIME))/2)*2+2 as end_time,
	COUNT(*) as total_orders
FROM orders
GROUP BY Floor(DATEPART(HOUR, TRY_CAST(order_time as TIME))/2)*2 ,Floor(DATEPART(HOUR, TRY_CAST(order_time as TIME))/2)*2+2 
ORDER BY COUNT(*) DESC

-- 3. Order Value Analysis
-- Question: Find the average order value per customer who has placed more than 750 orders.
-- Return customer_name, and aov(average order value)

	select customer_name, count(order_item) as food_orderd ,avg(total_amount) as AOV
		from orders
		join customers
		on
		orders.customer_id=customers.customer_id
		group by customer_name
		having count(order_item)>750;

-- 4. High-Value Customers
-- Question: List the customers who have spent more than 100K in total on food orders.
-- return customer_name, and customer_id!

select  * from orders;
select customer_name, count(order_item) as food_orderd ,sum(total_amount) as total_revenue
		from orders
		join customers
		on
		orders.customer_id=customers.customer_id
		group by customer_name
		having sum(total_amount)>100000;

-- 5. Orders Without Delivery
-- Question: Write a query to find orders that were placed but not delivered. 
-- Return each restuarant name, city and number of not delivered orders 

select restaurant_name,city,count(order_status)
FROM
	deliveries as d
right  JOIN
	orders as o
ON
	d.order_id=o.order_id
JOIN restaurants as r
ON
	r.restaurant_id=o.restaurant_id
where order_status ='Not Fulfilled'
GROUP BY
	 restaurant_name,city
ORDER BY
	Count(order_status) DESC;


-- Q. 6
-- Restaurant Revenue Ranking: 
-- Rank restaurants by their total revenue from the last year, including their name, 
-- total revenue, and rank within their city.

select  * from customers
select  * from restaurants
select  * from Orders
select  * from riders
select  * from deliveries

WITH ranking_Table AS (
    SELECT
        r.city,
        r.restaurant_name,
        SUM(o.total_amount) AS revenue,
        RANK() OVER (PARTITION BY r.city ORDER BY SUM(o.total_amount) DESC) AS rank
    FROM
        orders AS o
    JOIN
        restaurants AS r
    ON
        r.restaurant_id = o.restaurant_id
    GROUP BY
        r.city,
        r.restaurant_name
)

select * from ranking_table
where rank =1

-- Most Popular Dish by City: 
-- Identify the most popular dish in each city based on the number of orders.

select  * from orders;
select * from restaurants;

With ranking_table as(
select city,count(order_item) as total_orders,order_item,
DENSE_RANK() OVER(PARTITION BY city ORDER BY COUNT(order_item)  DESC) as rank 
from
	orders
JOIN
	restaurants
ON
	orders.restaurant_id=restaurants.restaurant_id
GROUP BY city,order_item)

Select city,order_item,rank
	from ranking_table
		where rank=1

-- Q.8 Customer Churn: 
-- Find customers who haven’t placed an order in 2024 but did in 2023.

  select  * from orders;


SELECT customer_id
FROM 
    orders
WHERE  DATEPART(YEAR, order_date)=2024 ;

select distinct customer_id
from
	orders
where customer_id  not in (SELECT  distinct customer_id
FROM 
    orders
WHERE  DATEPART(YEAR, order_date)=2024);


-- Q.9 Cancellation Rate Comparison: 
-- Calculate and compare the order cancellation rate for each restaurant between the 
-- current year and the previous year.

	WITH cancel_rate_23 AS 
(
    SELECT 
        o.restaurant_id, 
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM ORDERS AS o
    LEFT JOIN deliveries AS d
        ON o.order_id = d.order_id
    WHERE DATEPART(YEAR, order_Date) = 2023
    GROUP BY restaurant_id
),
cancel_ratio_24 AS 
(
    SELECT 
        o.restaurant_id, 
        COUNT(o.order_id) AS total_orders,
        COUNT(CASE WHEN d.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM ORDERS AS o
    LEFT JOIN deliveries AS d
        ON o.order_id = d.order_id
    WHERE DATEPART(YEAR, order_Date) = 2024
    GROUP BY restaurant_id
),

last_year_data AS (
    SELECT 
        restaurant_id, 
        total_orders, 
        not_delivered, 
        FORMAT(ROUND((not_delivered * 100.0 / total_orders), 2), 'N2') AS cancel_rate_percentage
    FROM cancel_rate_23
),

current_year_data AS (
    SELECT 
        restaurant_id, 
        total_orders, 
        not_delivered, 
        FORMAT(ROUND((not_delivered * 100.0 / total_orders), 2), 'N2') AS cancel_rate_percentage
    FROM cancel_ratio_24
)

SELECT
    c.restaurant_id AS restaurant_id,
    c.cancel_rate_percentage AS current_year_cancel_ratio,
    l.cancel_rate_percentage AS last_year_cancel_ratio
FROM current_year_data AS c
JOIN last_year_data AS l
ON c.restaurant_id = l.restaurant_id;



-- Q.10 Rider Average Delivery Time: 
-- Determine each rider's average delivery time.

select  * from riders;
select  * from deliveries;

SELECT  
    o.order_id, 
    o.order_time, 
    d.delivery_time, 
    d.rider_id, 
    DATEDIFF(SECOND, o.order_time, d.delivery_time) AS time_difference_in_sec,
    DATEDIFF(MINUTE, o.order_time, d.delivery_time) AS time_difference_in_min
FROM orders AS o
JOIN deliveries AS d ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered' ;



--What is the percentage of failed deliveries (where no delivery ID is assigned) for each restaurant, 
--compared to the total number of orders placed at that restaurant?"
WITH grand_total AS (
    SELECT 
        restaurant_id, 
        COUNT(order_id) AS total_orders
    FROM 
        orders 
    GROUP BY 
        restaurant_id
),
no_ETA AS (
    SELECT   
        restaurant_id, 
        COUNT(CASE WHEN delivery_id IS NULL THEN 1 END) AS failed_delivery
    FROM 
        orders AS o
    LEFT JOIN
        deliveries AS d
    ON
        o.order_id = d.order_id
    GROUP BY 
        restaurant_id
)

SELECT 
    n.failed_delivery, 
    g.total_orders, 
    ((n.failed_delivery * 100.0) / g.total_orders) AS failed_delivery_percentage
FROM 
    no_ETA AS n
INNER JOIN
    grand_total AS g
ON
    g.restaurant_id = n.restaurant_id;


	-- Q.11 Monthly Restaurant Growth Ratio: 
-- Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining
	select  * from orders;

select  * ,
FORMAT(order_date,' MM-yy ') as month
from 
orders;

select  * from deliveries;
select  * from orders

with growth_ratio
as 
(
	select restaurant_id,
	format(order_date,'MM-yy') as month,
	count(o.order_id) as cr_month_orders,
	LAG(count(o.order_id),1) OVER (PARTITION BY restaurant_id order by format(order_date,'MM-yy')) as prev_month_orders
	from orders as o
	join deliveries as d
	on o.order_id=d.order_id
	where delivery_status='Delivered'
	group by restaurant_id,format(o.order_date,'MM-yy')
	--order by restaurant_id,format(o.order_date,'MM-yy')

)

select  restaurant_id,
	month,
		cr_month_orders,
		prev_month_orders,
		ROUND(
        (cr_month_orders - prev_month_orders) * 100.0 / NULLIF(prev_month_orders, 0), 
        2)

	FROM growth_ratio;


---Q.12 Customer Segmentation: 
-- Customer Segmentation: Segment customers into 'Gold' or 'Silver' groups based on their total spending 
-- compared to the average order value (AOV). If a customer's total spending exceeds the AOV, 
-- label them as 'Gold'; otherwise, label them as 'Silver'. Write an SQL query to determine each segment's 
-- total number of orders and total revenue
select  * from orders;

with reference as
(
	select  customer_id,sum(total_amount) as total_spent,count(order_id) as ct,
case
when sum(total_amount)>avg(total_amount)
THEN
'Gold'
Else
'Silver'
END as segmentation
from
	orders
	group by customer_id)
	--order by segmentation)

	select sum(total_spent),segmentation,sum(ct)
		from reference
		group by segmentation;


		-- Q.13 Rider Monthly Earnings: 
-- Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount.
select * from orders;
select  * from deliveries;

with Monthly_Earnings 
as
(
	select rider_id,total_amount,format(order_Date,'MM-yy') as month
--SUM()(OVER sum(total_amount)
from orders o
 join deliveries d
on
	o.order_id=d.order_id
	where delivery_status='Delivered'
	--order by rider_id,format(order_Date,'MM-yy')
	),

Temporary as
(select rider_id, sum(total_amount) as total,month
	from
		Monthly_Earnings
		group by 
				rider_id,month)

				select M.rider_id,T.total*0.08,M.month
				from Monthly_Earnings as M
				join Temporary as t
				on
				M.rider_id=t.rider_id
				order by M.rider_id,M.month;

select  * from orders;
select  * from deliveries;

With Monthly_Earnings
as

(

select 
	rider_id,count(o.order_id) total_count,sum(total_amount) as total_spent,format(order_date,'MM-yy') as month
from
	orders as o
join
	deliveries as d
on
	o.order_id=d.order_id
	group by rider_id,format(order_date,'MM-yy')
	--order by rider_id,format(order_date,'MM-yy')
	)

	select rider_id,total_spent*0.08,month
	from Monthly_Earnings
	order by rider_id,month;

-- Q.14 Rider Ratings Analysis: 
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has.
-- riders receive this rating based on delivery time.
-- If orders are delivered less than 15 minutes of order received time the rider get 5 star rating,
-- if they deliver 15 and 20 minute they get 4 star rating 
-- if they deliver after 20 minute they get 3 star rating.

select  * from orders;
select  * from deliveries;

with Rating_Analysis
as
(
select o.order_id,
rider_id,
customer_id,
delivery_time,
order_time,
datediff(Minute,Order_time,delivery_time) as differences

from orders as o
join 
	deliveries as d
on
	o.order_id=d.order_id
	where delivery_status='Delivered'
	),

	Rating as
	(
	select rider_id,differences,
	CASE
	When
	differences<15
	Then '5 Star'
	When differences>15 and differences<20
	Then '4 Star'
	Else
	'3 Star'
	End as Riders_rating
	from
	Rating_Analysis
	--order by rider_id, Riders_rating
	)

SELECT 
    r.rider_id,
    r.Riders_rating,
    COUNT(Riders_rating) AS Final_Rating
FROM 
    Rating AS r
GROUP BY 
    r.rider_id, r.Riders_rating
ORDER BY 
    r.rider_id, r.Riders_rating;

-- Q.15 Order Frequency by Day: 
-- Analyze order frequency per day of the week and identify the peak day for each restaurant.

--select * from orders

with ranking as
(
SELECT restaurant_id,count(order_id) as total,  
       FORMAT(order_date, 'dddd') AS order_day,
	   RANK() OVER(PARTITION BY restaurant_id order by count(order_id) desc) as new
FROM orders
group by restaurant_id,FORMAT(order_date, 'dddd')
--order by restaurant_id
)
select distinct restaurant_id,order_day
	from ranking
	where new='1';

-- Q.16 Customer Lifetime Value (CLV): 
-- Calculate the total revenue generated by each customer over all their orders.

select  * from orders;

select customer_id,
	count(order_id) as total_orders,
	sum(total_amount) as revenue
from
	orders
group by 
	customer_id
order by customer_id;


-- Q.17 Monthly Sales Trends: 
-- Identify sales trends by comparing each month's total sales to the previous month.

select  * from orders

select 
format(order_date,'MM') as month,
format(order_date,'yy') as year,
sum(total_amount) as total_sale,
lag(sum(total_amount),1) OVER(order by format(order_date,'MM') ,format(order_date,'yy')) as prev_month
from Orders
group by format(order_date,'MM') ,format(order_date,'yy')
	
-- Q.18 Rider Efficiency: 
-- Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages.

WITH t1 AS (
    SELECT 
        d.rider_id,
        DATEDIFF(MINUTE, o.order_time, d.delivery_time) + 
        CASE WHEN d.delivery_time < o.order_time THEN 1440 ELSE 0 END AS difference
    FROM 
        orders AS o
    JOIN 
        deliveries AS d
    ON 
        o.order_id = d.order_id
    WHERE 
        d.delivery_status = 'Delivered'
),

t2 AS (
    SELECT 
        rider_id,
        AVG(difference) AS avg_difference
    FROM 
        t1
    GROUP BY 
        rider_id
)

SELECT 
    MAX(avg_difference) AS max_avg_difference,
    MIN(avg_difference) AS min_avg_difference
FROM 
    t2;



-- Q.19 Order Item Popularity: 
-- Track the popularity of specific order items over time and identify seasonal demand spikes.

select  * from orders;

with t1 
as
(
select count(order_item) as order_count,order_item,
CASE
WHEN
FORMAT(order_date,'MM') between 4 and 6 THEN 'Spring'
WHEN
FORMAT(order_date,'MM') >6 AND FORMAT(order_date,'MM')<9  THEN 'Summer'
ELSE 'Winter'
END as seasons
from orders
group by order_item,format(order_date,'MM')
--order by order_item,count(order_item)  desc
)

select sum(order_count),order_item,seasons
from t1
group by order_item ,seasons
order by sum(order_count) desc;

-- Q.20 Rank each city based on the total revenue for last year 2023 

select  * from restaurants
select  * from Orders
select  * from deliveries

select city,sum(total_amount) total_revenue,
RANK() OVER (ORDER BY sum(total_amount) DESC) as rank
from orders as o
 join restaurants as r
on
o.restaurant_id=r.restaurant_id
where format(order_date,'yy')=23
group by city,format(order_date,'yy')
order by sum(total_amount) desc


























-- Q.20 Rank each city based on the total revenue for last year 2023 


