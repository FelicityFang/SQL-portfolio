/*
===============================================================================
06_part_to_whole_analysis
Purpose:
    Analyze how each product category contributes to total sales.

Business Question:
    - Which category contributes the most to overall sales?

Skills Used:
    - CTE
    - JOIN
    - SUM()
    - Window Function
    - OVER()
    - CONCAT()
    - ROUND()
===============================================================================
*/

USE DataWarehouseAnalytics;


-- =================================================
-- 1. Category contribution to overall sales
-- =================================================

WITH sales_by_category AS (
    SELECT 
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM fact_sales f
    LEFT JOIN dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(
        ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2),
        '%'
    ) AS portion_of_total
FROM sales_by_category
ORDER BY total_sales DESC;