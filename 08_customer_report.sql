/*
===============================================================================
08_customer_report
Purpose:
    Create a customer-level report that summarizes customer behavior,
    customer segments, and key customer KPIs.

Business Questions:
    - Who are the most valuable customers?
    - Which customers are VIP, Regular, or New?
    - What is each customer's recency, average order value, and monthly spend?

Skills Used:
    - CTE
    - JOIN
    - CONCAT()
    - TIMESTAMPDIFF()
    - CASE WHEN
    - COUNT()
    - SUM()
    - MIN()
    - MAX()
===============================================================================
*/

USE DataWarehouseAnalytics;

DROP VIEW IF EXISTS report_customers;
-- =================================================
-- Customer Report
-- =================================================
CREATE VIEW report_customers AS

WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birthdate, CURDATE()) AS age
    FROM fact_sales f
    LEFT JOIN dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        customer_name,
        age
)

SELECT
    customer_key,
    customer_number,
    customer_name,
    age,

    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    first_order_date,
    last_order_date,

    TIMESTAMPDIFF(MONTH, last_order_date, CURDATE()) AS recency_months,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,

    CASE
        WHEN total_orders = 0 THEN 0
        ELSE ROUND(total_sales / total_orders, 2)
    END AS avg_order_value,

    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE ROUND(total_sales / lifespan, 2)
    END AS avg_monthly_spend

FROM customer_aggregation
ORDER BY total_sales DESC;