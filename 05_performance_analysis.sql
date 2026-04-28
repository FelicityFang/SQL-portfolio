/*
===============================================================================
05_performance_analysis
Purpose:
    Analyze product sales performance by comparing yearly sales against:
    1. The product's average yearly sales
    2. The product's previous year sales

Business Questions:
    - Which products performed above or below their average yearly sales?
    - Did each product's sales increase or decrease compared with the previous year?

Skills Used:
    - CTE
    - JOIN
    - YEAR()
    - SUM()
    - AVG() OVER()
    - LAG()
    - CASE WHEN
    - PARTITION BY
===============================================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Compare product yearly performance with average sales performance
-- =================================================

WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
    order_year,
    product_name,
    total_sales,
    AVG(total_sales) OVER (PARTITION BY product_name) AS avg_sales,
    total_sales - AVG(total_sales) OVER (PARTITION BY product_name) AS diff_avg,
    CASE 
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
        WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change
FROM yearly_product_sales
ORDER BY product_name, order_year;


-- =================================================
-- 2. Compare product yearly performance with the previous year
-- =================================================

WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
    order_year,
    product_name,
    total_sales,
    LAG(total_sales) OVER (
        PARTITION BY product_name 
        ORDER BY order_year
    ) AS previous_year_sales,
    CASE 
        WHEN LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) > total_sales THEN 'Decrease'
        WHEN LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) < total_sales THEN 'Increase'
        ELSE 'No Change'
    END AS previous_year_change
FROM yearly_product_sales
ORDER BY product_name, order_year;