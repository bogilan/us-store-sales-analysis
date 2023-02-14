-- ============= DATABASE ===============
-- Create database
CREATE DATABASE	db_us_store_sales;

-- Use database
USE db_us_store_sales;
-- ======================================

-- ========= CREATE MASTER TABLE ========
-- Drop table if table already created
DROP TABLE IF EXISTS master_table_us_sales;

-- Create new master table with specified columns
CREATE TABLE master_table_us_sales (
	store_code INTEGER,
    store_state VARCHAR(100),
    store_region VARCHAR(20),
    market_size VARCHAR(50),
    profit DECIMAL,
    margin DECIMAL,
    sales_value DECIMAL,
    cogs DECIMAL,
    total_expenses DECIMAL,
    marketing_expenses DECIMAL,
    inventory_value DECIMAL,
    exp_profit DECIMAL,
    exp_cogs DECIMAL,
    exp_margin DECIMAL,
    exp_sales_value DECIMAL,
    product_id INTEGER,
    sale_date VARCHAR(100),
    product_category VARCHAR(50),
    product_desc VARCHAR(50),
    product_type VARCHAR(50)
);

-- Load data from csv file to newly created master table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_database.csv'
INTO TABLE master_table_us_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 ROWS;

-- Check all table data
SELECT *
FROM master_table_us_sales;

-- Check the data row count
SELECT 
    COUNT(*)
FROM
    master_table_us_sales;
    
-- ======================================


-- ==== CREATE AND EXPORT DATA TABLES ===
-- Show files export folder
SHOW VARIABLES LIKE "secure_file_priv";

-- Create STORE DATA table
DROP TABLE IF EXISTS store_data;
CREATE TABLE store_data AS
	SELECT DISTINCT store_code, store_state, store_region, market_size
	FROM master_table_us_sales
	ORDER BY store_code ASC;

-- Export store_data results with appended column names
SELECT 'store_code', 'store_state', 'store_region', 'market_size'
UNION
SELECT * FROM store_data
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\store_data.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

-- Create PRODUCT DATA table
DROP TABLE IF EXISTS product_data;
CREATE TABLE product_data AS
	SELECT DISTINCT product_id, product_category, product_desc, product_type
	FROM master_table_us_sales;
    
-- Export product_data results with appended column names
SELECT 'product_id', 'product_category', 'product_desc', 'product_type'
UNION
SELECT * FROM product_data
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\product_data.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

-- Create SALES DATA Table
DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data AS
	SELECT store_code, sales_value, cogs, total_expenses, marketing_expenses,
		inventory_value, exp_profit, product_id, sale_date
	FROM master_table_us_sales;

-- Export product_data results with appended column names
SELECT 'store_code', 'sales_value', 'cogs', 'total_expenses', 'marketing_expenses',
		'inventory_value', 'exp_profit', 'product_id', 'sale_date'
UNION
SELECT * FROM sales_data
INTO OUTFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\sales_data.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '\\'
LINES TERMINATED BY '\n';

-- ======================================