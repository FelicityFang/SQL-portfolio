/*
=================================================
01_database_exploration
Purpose:
Explore the sales database tables, check row counts,
review sample records, understand dimensions, and inspect
basic data quality.

Tables:
- dim_customers
- dim_products
- fact_sales

Skills Used:
- SELECT
- COUNT
- DISTINCT
- MIN / MAX
- GROUP BY
- ORDER BY
- LIMIT
=================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Preview tables
-- =================================================

SELECT *
FROM dim_customers
LIMIT 10;

SELECT *
FROM dim_products
LIMIT 10;

SELECT *
FROM fact_sales
LIMIT 10;


-- =================================================
-- 2. Count rows in each table
-- =================================================

SELECT COUNT(*) AS total_customers
FROM dim_customers;

SELECT COUNT(*) AS total_products
FROM dim_products;

SELECT COUNT(*) AS total_sales_records
FROM fact_sales;


-- =================================================
-- 3. Explore customer dimensions
-- =================================================

SELECT DISTINCT country
FROM dim_customers
ORDER BY country;

SELECT DISTINCT gender
FROM dim_customers
ORDER BY gender;

SELECT DISTINCT marital_status
FROM dim_customers
ORDER BY marital_status;


-- =================================================
-- 4. Explore product dimensions
-- =================================================

SELECT DISTINCT category
FROM dim_products
ORDER BY category;

SELECT DISTINCT subcategory
FROM dim_products
ORDER BY subcategory;

SELECT DISTINCT product_line
FROM dim_products
ORDER BY product_line;


-- =================================================
-- 5. Explore sales date range
-- =================================================

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM fact_sales;


-- =================================================
-- 6. Explore customer age range
-- =================================================

SELECT
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate
FROM dim_customers;


-- =================================================
-- 7. Explore key sales measures
-- =================================================

SELECT
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    AVG(price) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM fact_sales;


-- =================================================
-- 8. Check missing values in important columns
-- =================================================

SELECT
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN sales_amount IS NULL THEN 1 ELSE 0 END) AS missing_sales_amount,
    SUM(CASE WHEN customer_key IS NULL THEN 1 ELSE 0 END) AS missing_customer_key,
    SUM(CASE WHEN product_key IS NULL THEN 1 ELSE 0 END) AS missing_product_key
FROM fact_sales;


-- =================================================
-- 9. Check join coverage
-- =================================================

SELECT
    COUNT(*) AS unmatched_customer_records
FROM fact_sales f
LEFT JOIN dim_customers c
    ON f.customer_key = c.customer_key
WHERE c.customer_key IS NULL;

SELECT
    COUNT(*) AS unmatched_product_records
FROM fact_sales f
LEFT JOIN dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL;


-- =================================================
-- 10. Quick business overview
-- =================================================

SELECT
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customers,
    COUNT(DISTINCT product_key) AS total_products,
    SUM(sales_amount) AS total_sales
FROM fact_sales;