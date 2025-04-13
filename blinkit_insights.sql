-- Data preparation-- 
-- Null Handling-- 
select * from blinkit_orders where order_id is null or order_total is null or store_id is null;
select * from blinkit_products where product_name is null or category is null or price is null;
select * from blinkit_customers 
where phone is null or address is null or area is null or customer_segment is null or avg_order_value is null;
select * from blinkit_marketing_performance 
where impressions is null or clicks is null or revenue_generated is null;

-- --To correct the values if incorrect--
select * from blinkit_orders where order_total < 0;
select * from blinkit_customers;
select distinct payment_method from blinkit_orders;
select distinct product_name from blinkit_products order by product_name;

------------------------ Sales Performance analysis--------------------------------------
-- Total Sales-- 
select Sum(order_total) from blinkit_orders; 

-- Yearwise and monthwise sales data using order_date and order_total from orders table--
select year(order_date) as year,monthname(order_date) AS month, round(Sum(order_total),2) as Total_sales
from blinkit_orders
group by year(order_date), monthname(order_date)
order by year(order_date);

-- Maximum sales in which month in the year 2023 and 2024-- 
select year(order_date) as year,monthname(order_date) AS month,Sum(order_total) as max_sales
from blinkit_orders where year(order_date) = 2023/2024
group by year(order_date), monthname(order_date)
order by sum(order_total) desc;

---	Minimum Sales in which month in year 2023 and 2024--
select year(order_date) as year,monthname(order_date) AS    month,Sum(order_total) as max_sales
from blinkit_orders where year(order_date) = 2023/2024
group by year(order_date), monthname(order_date)
order by sum(order_total);

-- Total orders placed in year and month wise--
select year(order_date) as year,monthname(order_date) AS month,count(order_id) as total_order
from blinkit_orders where year(order_date) = 2024
group by year(order_date), monthname(order_date)
order by count(order_id);

------------------------ Product Level Insights--------------------------------------
-- Maximum sold product-- 
select sum(quantity) as quantity, oi.product_id, p.product_name,p.category
from blinkit_order_items as oi join blinkit_products as p on 
oi.product_id=p.product_id
group by oi.product_id,p.category,p.product_name
order by sum(quantity) desc;

-- Product with maximum profit--
select distinct product_name, category,margin_percentage from blinkit_products 
where(select max(margin_percentage) from blinkit_products)
order by margin_percentage desc;

------------------------ Customer  Insights--------------------------------------
-- Top customers by spend--
select c.customer_id,customer_name,area,customer_segment,order_total from blinkit_customers as c join  blinkit_orders as o
on c.customer_id = o.customer_id
order by order_total desc;

-- Total customers--
select count(distinct customer_id) from blinkit_customers;

-- No of customers placed the maximum orders of 20 = 117 customers--   
select count(*)  as no_of_customers,max(total_orders)from  blinkit_customers
where total_orders = (select max(total_orders) from blinkit_customers);

------------------------ Location based Insights--------------------------------------
-- Delivery time analysis - delayed delivery-- 
select count(*) from blinkit_orders
where delayed_by <0;

-- Maximum time delayed = 30 mins-- 
select * from blinkit_orders
where delayed_by <0
order by delayed_by ;

-- No of deliveries which are significantly delayed: 98-- 
select count(*) from blinkit_orders
where delivery_status = 'Significantly Delayed';

------------------------ Time based Insights--------------------------------------
-- Peak Order Times-- 
SELECT 
    CASE 
        WHEN TIME(order_date) BETWEEN '06:00:00' AND '07:59:59' THEN '6 AM - 8 AM'
        WHEN TIME(order_date) BETWEEN '08:00:00' AND '11:59:59' THEN '8 AM - 12 PM'
        WHEN TIME(order_date) BETWEEN '12:00:00' AND '15:59:59' THEN '12 PM - 4 PM'
        WHEN TIME(order_date) BETWEEN '16:00:00' AND '17:59:59' THEN '4 PM - 6 PM'
        WHEN TIME(order_date) BETWEEN '18:00:00' AND '21:59:59' THEN '6 PM - 10 PM'
        WHEN TIME(order_date) BETWEEN '22:00:00' AND '23:59:59' THEN '10 PM - 12 AM'
        ELSE '12 AM - 6 AM'
    END AS time_slot,
    COUNT(order_id) AS total_orders
FROM blinkit_orders
GROUP BY time_slot
ORDER BY FIELD(time_slot, 
    '6 AM - 8 AM', 
    '8 AM - 12 PM', 
    '12 PM - 4 PM', 
    '4 PM - 6 PM', 
    '6 PM - 10 PM', 
    '10 PM - 12 AM', 
    '12 AM - 6 AM');

-- Day of Week Sales-- 
select dayname(order_date),count(order_id) as total_order
from blinkit_orders 
group by  dayname(order_date)
order by count(order_id) desc;

-- Most Used Payment Methods--
select count(order_id) as total_orders,payment_method from blinkit_orders
group by payment_method
order by count(order_id) desc;

-- Inventory Insights--
-- Total no of damaged stock--
select sum(damaged_stock) from blinkit_inventorynew
where damaged_stock>0;

------------------------ Customer feedback Insights--------------------------------------

-- Negative feedback related to App experience--  
  select count(feedback_text), feedback_category, sentiment from blinkit_customer_feedback
where sentiment = 'Negative' and feedback_category = 'App Experience' 
order by feedback_category;

-- Most common reasons:-- 
select distinct feedback_text, feedback_category, sentiment from blinkit_customer_feedback
where sentiment = 'Negative' and feedback_category = 'App Experience' 
order by feedback_category;





