/*
===============================================================================
04_cumulative_analysis
Purpose:
    Analyze cumulative sales performance over time using window functions.

Business Questions:
    - What are the monthly sales totals?
    - How does cumulative sales grow over time?
    - How does yearly cumulative sales reset within each year?
    - What is the moving average price trend by year?

Skills Used:
    - DATE_FORMAT()
    - SUM()
    - AVG()
    - Window Functions
    - OVER()
    - PARTITION BY
    - ROWS BETWEEN
===============================================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Monthly total sales
-- =================================================

SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY order_month;


-- =================================================
-- 2. Running total of monthly sales
-- =================================================

SELECT 
	order_date,
    total_sale,
    SUM(total_sale) over (order by order_date) AS running_total_sales
FROM
(
SELECT 
	DATE_FORMAT(order_date,'%Y-%m-01') as order_date,
    SUM(sales_amount) as total_sale
FROM fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')
)t;


-- =================================================
-- 3. Running total of monthly sales within each year
-- =================================================

SELECT 
	order_date,
    total_sale,
    SUM(total_sale) over (PARTITION BY YEAR(order_date) order by order_date) AS running_total_sales
FROM
(
SELECT 
	DATE_FORMAT(order_date,'%Y-%m-01') as order_date,
    SUM(sales_amount) as total_sale
FROM fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date,'%Y-%m-01')
)t;


-- =================================================
-- 4. Running total of yearly sales
-- =================================================

SELECT 
	order_date,
    total_sale,
    SUM(total_sale) over (order by order_date) AS running_total_sales
FROM
(
SELECT 
	DATE_FORMAT(order_date,'%Y-01-01') as order_date,
    SUM(sales_amount) as total_sale
FROM fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date,'%Y-01-01')
)t;


-- =================================================
-- 5. Yearly sales with moving average price
-- =================================================

SELECT 
	order_date,
    total_sale,
    SUM(total_sale) over (order by order_date) AS running_total_sales,
    AVG(avg_price) over(order by order_date) AS moving_average_price
FROM
(
SELECT 
	DATE_FORMAT(order_date,'%Y-01-01') as order_date,
    SUM(sales_amount) as total_sale,
	AVG(price) as avg_price
FROM fact_sales
WHERE order_date is not null
GROUP BY DATE_FORMAT(order_date,'%Y-01-01')
)t;