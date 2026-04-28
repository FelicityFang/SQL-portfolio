/*
===============================================================================
02_ranking_analysis
Purpose:
    Analyze rankings across customers and products using SQL ranking functions.

Skills Used:
    - GROUP BY
    - ORDER BY
    - LIMIT
    - ROW_NUMBER()
    - RANK()
    - DENSE_RANK()
===============================================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Top 10 customers by total spending
-- =================================================

SELECT
    customer_key,
    SUM(sales_amount) AS total_spending
FROM fact_sales
GROUP BY customer_key
ORDER BY total_spending DESC
LIMIT 10;


-- =================================================
-- 2. Rank customers by spending
-- =================================================

SELECT
    customer_key,
    total_spending,
    RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM
(
    SELECT
        customer_key,
        SUM(sales_amount) AS total_spending
    FROM fact_sales
    GROUP BY customer_key
) t;


-- =================================================
-- 3. Dense rank customers by spending
-- =================================================

SELECT
    customer_key,
    total_spending,
    DENSE_RANK() OVER (ORDER BY total_spending DESC) AS dense_rank_num
FROM
(
    SELECT
        customer_key,
        SUM(sales_amount) AS total_spending
    FROM fact_sales
    GROUP BY customer_key
) t;


-- =================================================
-- 4. Top 10 products by total sales
-- =================================================

SELECT
    p.product_name,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p
    ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_sales DESC
LIMIT 10;


-- =================================================
-- 5. Rank products by total sales
-- =================================================

SELECT
    product_name,
    total_sales,
    ROW_NUMBER() OVER (ORDER BY total_sales DESC) AS row_num,
    RANK() OVER (ORDER BY total_sales DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS dense_rank_num
FROM
(
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.product_name
) t;


-- =================================================
-- 6. Top product within each category
-- =================================================

SELECT
    category,
    product_name,
    total_sales,
    category_rank
FROM
(
    SELECT
        p.category,
        p.product_name,
        SUM(f.sales_amount) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(f.sales_amount) DESC
        ) AS category_rank
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category, p.product_name
) t
WHERE category_rank = 1;