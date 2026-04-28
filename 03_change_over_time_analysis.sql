/*
===============================================================================
03_change_over_time_analysis
Purpose:
    Analyze how sales, customers, and quantity change over time.

Business Questions:
    - How does total sales change by day, month, and year?
    - How many customers purchase each year or month?
    - How does quantity sold change over time?

Skills Used:
    - YEAR()
    - MONTH()
    - DATE_FORMAT()
    - SUM()
    - COUNT(DISTINCT)
    - GROUP BY
    - ORDER BY
===============================================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Daily sales trend
-- =================================================

SELECT 
    order_date, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_date
ORDER BY order_date;


-- =================================================
-- 2. Yearly sales trend
-- =================================================

SELECT 
    YEAR(order_date) AS order_year, 
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- =================================================
-- 3. Yearly sales and customer trend
-- =================================================

SELECT 
    YEAR(order_date) AS order_year, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;


-- =================================================
-- 4. Monthly trend across all years
-- =================================================
-- This groups all Januaries together, all Februaries together, etc.

SELECT 
    MONTH(order_date) AS order_month, 
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY order_month;


-- =================================================
-- 5. Monthly trend by year
-- =================================================

SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY order_month;


-- =================================================
-- 6. Yearly average order value
-- =================================================

SELECT
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT order_number) AS total_orders,
    ROUND(SUM(sales_amount) / COUNT(DISTINCT order_number), 2) AS avg_order_value
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;