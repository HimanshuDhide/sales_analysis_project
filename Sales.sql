use Portfolio_project

SELECT * FROM INFORMATION_SCHEMA.TABLES

select top 5 *  from sales

-- Retail Sales Analytics Project Questions

-- 📦 Product & Category Insights
-- What are the top 5 best-selling product categories by total sales?

select top 3 Category,round(sum(Sales),2) as total_sales from sales
group by Category
order by sum(sales) desc

-- Which sub-category has the highest average sales per order?

select top 1 Sub_Category,round(avg(sales),2) as Avg_sales_per_order from sales
group by Sub_Category
order by Avg_sales_per_order desc


-- Which product generated the most revenue overall?

select top 3 Product_Name,round(sum(sales),2) as total_sale from sales
group by Product_Name
order by total_sale desc

-- Are there any products that were sold only once?

SELECT Product_Name, COUNT(*) AS sold
FROM sales
GROUP BY Product_Name
HAVING COUNT(*) = 1

-- 👤 Customer & Segment Analysis
-- Which customer has placed the most orders?

select top 3 customer_Name, count(*) as orders from sales
group by Customer_Name
order by orders desc

-- What is the total revenue generated from each customer segment?

select Segment,round(sum(sales),2) as revenue from sales
group by Segment
order by revenue desc

-- What is the average order value per segment?

select Segment,ROUND(avg(sales),2) as avg_order_value from sales
group by Segment
order by avg_order_value desc

-- 🗓️ Sales Trends Over Time
-- How have monthly sales changed over time?

select MONTH(order_date) as months,YEAR(Order_Date) as sale_year,round(sum(sales),2) as total_sales from sales
group by month(Order_Date),YEAR(Order_Date)
order by total_sales desc
-- Which year had the highest total sales?

select top 1 YEAR(order_date) as yearr,round(sum(sales),2) as total_sales from sales
group by YEAR(Order_Date)
order by total_sales desc

-- In which month do we consistently see the highest number of orders?

SELECT 
    MONTH(Order_Date) AS MonthNumber,
    DATENAME(MONTH, Order_Date) AS MonthName,
    COUNT(DISTINCT Order_ID) AS NumberOfOrders
FROM sales
GROUP BY MONTH(Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY NumberOfOrders DESC;


-- 🌍 Geographic Performance
-- Which region generated the highest total sales?

select Region,ROUND(sum(sales),2) as total_sales from sales
group by Region 
order by total_sales

-- Which city had the most orders?

select top 1 City, count(Distinct Order_ID) as no_of_order from sales group by City order by no_of_order desc 

-- What is the sales distribution across different states?

SELECT State,ROUND(SUM(Sales), 2) AS Total_Sales FROM sales GROUP BY State ORDER BY Total_Sales DESC


-- 🚚 Shipping Efficiency
-- What is the average delivery time (Ship_Date - Order_Date)?
SELECT 
    Ship_Mode,
    ROUND(AVG(DATEDIFF(DAY, Order_Date, Ship_Date)), 2) AS Avg_Delivery_Time_Days
FROM sales
GROUP BY Ship_Mode
ORDER BY Avg_Delivery_Time_Days ASC;



-- Which shipping mode has the shortest average delivery time?

Select Ship_Mode,round(avg(DATEDIFF(hour,Order_Date,Ship_Date)),2) as avg_delivery_time from sales
group by Ship_Mode
order by avg_delivery_time desc

-- Is there a correlation between shipping mode and sales volume?

Select Ship_Mode,ROUND(sum(sales),2) as total_sales, ROUND(avg(sales),2) as avg_sales from sales
group by Ship_Mode

-- Repeat Customers
select 
  count(distinct case when order_count > 1 then Customer_ID end) as repeat_customers,
  count(distinct Customer_ID) as total_customers
from (
  select Customer_ID, count(distinct Order_ID) as order_count
  from sales
  group by Customer_ID
) t



-- 🧠 Advanced / Exploratory

-- What percentage of orders come from repeat customers?

with repeat_customer as(
select Customer_ID from sales group by Customer_ID having count(Distinct Order_id)>1
)
select round(100.0*count(s.order_id)/(select count(order_id) from sales),2) as repeatcust
from sales s join repeat_customer r on s.Customer_ID=r.customer_id


-- What is the reorder rate per product or category?
WITH ProductReorders AS (
SELECT Customer_ID,Product_Name,COUNT(DISTINCT Order_ID) AS OrdersCount FROM sales
GROUP BY Customer_ID, Product_Name
HAVING COUNT(DISTINCT Order_ID) > 1
)
SELECT Product_Name,COUNT(*) AS Reorder_Count FROM ProductReorders
GROUP BY Product_Name
ORDER BY Reorder_Count DESC;


-- Which postal codes have the highest concentration of high-value orders?

Select Postal_Code, COUNT(*) AS High_Value_Order_Count,ROUND(SUM(Sales), 2) AS Total_high_value_sales
FROM sales
WHERE Sales > 500
GROUP BY Postal_Code
ORDER BY High_Value_Order_Count DESC;


-- Can you identify any patterns in sales before and after specific dates (e.g., year-end, festivals)?

SELECT DATENAME(MONTH, Order_Date) AS Month_Name,MONTH(Order_Date) AS Month_Num,SUM(Sales) AS Total_Sales,
COUNT(DISTINCT Order_ID) AS Number_of_Orders FROM sales
WHERE MONTH(Order_Date) IN (11, 12, 1, 2)  -- Focus around year-end
GROUP BY DATENAME(MONTH, Order_Date), MONTH(Order_Date)
ORDER BY Month_Num;
