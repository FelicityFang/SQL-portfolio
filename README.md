# SQL Sales Analytics Portfolio Project

## Project Overview

This project is a SQL-based sales analytics portfolio project built using MySQL. The goal of this project is to analyze customer behavior, product performance, sales trends, and business KPIs using structured sales data.

The dataset follows a simple data warehouse structure with one sales fact table and two dimension tables:

- `fact_sales`: transaction-level sales data
- `dim_customers`: customer information
- `dim_products`: product information

This project demonstrates how SQL can be used to explore raw data, answer business questions, segment customers and products, and build reporting-ready datasets.

---

## Dataset Structure

### fact_sales
Contains transaction-level sales records, including:

- order number
- product key
- customer key
- order date
- shipping date
- due date
- sales amount
- quantity
- price

### dim_customers
Contains customer-level information, including:

- customer key
- customer number
- customer name
- country
- marital status
- gender
- birthdate

### dim_products
Contains product-level information, including:

- product key
- product name
- category
- subcategory
- product line
- cost
- start date

---

## Analysis Performed

### 1. Database Exploration
Reviewed table structures, sample records, row counts, date ranges, and basic data quality checks.

### 2. Ranking Analysis
Identified top customers and top products by revenue using ranking logic and SQL window functions.

### 3. Change Over Time Analysis
Analyzed sales trends by day, month, and year to understand revenue growth and customer activity over time.

### 4. Cumulative Analysis
Calculated running total sales and moving average price trends using window functions.

### 5. Performance Analysis
Compared product yearly sales against average sales and previous year performance using `AVG() OVER()` and `LAG()`.

### 6. Part-to-Whole Analysis
Calculated each product category’s contribution to total sales.

### 7. Data Segmentation
Segmented products by cost range and customers into VIP, Regular, and New groups based on spending and purchase history.

### 8. Customer Report
Created a customer-level report with KPIs such as total sales, total orders, customer lifespan, recency, average order value, and average monthly spend.

### 9. Product Report
Created a product-level report with KPIs such as total revenue, total quantity sold, total customers, recency, average selling price, and product performance segment.

---

## SQL Skills Demonstrated

- SELECT statements
- JOINs
- GROUP BY
- Aggregate functions
- CASE WHEN
- Common Table Expressions (CTEs)
- Window functions
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- SUM() OVER()
- AVG() OVER()
- DATE_FORMAT()
- TIMESTAMPDIFF()
- Customer segmentation
- Product performance reporting

---

## Tools Used

- MySQL
- MySQL Workbench
- GitHub

---

## Project Files

### Scripts

- `01_database_exploration.sql`
- `02_ranking_analysis.sql`
- `03_change_over_time_analysis.sql`
- `04_cumulative_analysis.sql`
- `05_performance_analysis.sql`
- `06_part_to_whole_analysis.sql`
- `07_data_segmentation.sql`
- `08_customer_report.sql`

### Datasets

- `dim_customers.csv`
- `dim_products.csv`
- `fact_sales.csv`

---

## Key Business Questions Answered

- Which customers generate the most revenue?
- Which products are the top performers?
- How do sales change over time?
- Which categories contribute most to total revenue?
- Which customers are VIP, Regular, or New?
- Which products perform above or below their average sales?
- What are the key customer and product KPIs?

---

## Author

Felicity Fang
