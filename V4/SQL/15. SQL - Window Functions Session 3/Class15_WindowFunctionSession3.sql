-- ASSIGNING THE ACCOUNT TYPE 
USE ROLE ACCOUNTADMIN;

-- USING THE WAREHOUSE AVAILABLE
USE WAREHOUSE COMPUTE_WH;

-- CREATING A DATABASE NAMED AS SUBQUERIES_DATABASE
CREATE DATABASE IF NOT EXISTS WINDOW_FUNCTIONS_SESSION_3_DB;

-- USING THE DATABASE CREATED
USE DATABASE WINDOW_FUNCTIONS_SESSION_3_DB;

-- CREATING A SCHEMA NAMED AS SUBQUERIES_SCHEMA
CREATE SCHEMA IF NOT EXISTS WINDOW_FUNCTIONS_SESSION_3_SCHEMA;

-- USING THE SCHEMA CREATED 
USE SCHEMA WINDOW_FUNCTIONS_SESSION_3_SCHEMA;


-- Window functions 
-- Creating a table named Sales_order
CREATE OR REPLACE TABLE sales_orders (
    order_id INT,
    customer_name STRING,
    order_date DATE,
    sales_amount DECIMAL(10,2),
    region STRING
);

-- Inserting records into the table Sales_Order 
INSERT INTO sales_orders (order_id, customer_name, order_date, sales_amount, region) VALUES
(101, 'Amit', '2025-01-05', 5000.00, 'North'),
(102, 'Amit', '2025-01-15', 3000.00, 'North'),
(103, 'Amit', '2025-02-01', 4500.00, 'North'),
(104, 'Bhavna', '2025-01-10', 7000.00, 'South'),
(105, 'Bhavna', '2025-02-05', 2000.00, 'South'),
(106, 'Bhavna', '2025-02-20', 8000.00, 'South'),
(107, 'Chetan', '2025-01-07', 6500.00, 'West'),
(108, 'Chetan', '2025-01-25', 4000.00, 'West'),
(109, 'Chetan', '2025-03-01', 7500.00, 'West'),
(110, 'Deepa', '2025-01-12', 6000.00, 'East'),
(111, 'Deepa', '2025-03-15', 9000.00, 'East'),
(112, 'Amit', '2025-03-01', 5500.00, 'North'),
(113, 'Amit', '2025-03-20', 6200.00, 'North'),
(114, 'Bhavna', '2025-03-05', 4000.00, 'South'),
(115, 'Bhavna', '2025-03-18', 9000.00, 'South'),
(116, 'Chetan', '2025-03-15', 5000.00, 'West'),
(117, 'Chetan', '2025-04-02', 6500.00, 'West'),
(118, 'Deepa', '2025-04-01', 7500.00, 'East'),
(119, 'Deepa', '2025-04-20', 8200.00, 'East');


-- Understanding LEAD() & LAG()
-- LEAD()
/*
    LEAD is nothing but a function which gives you the next row based on the current row.
    Syntax:
    LEAD(COLUMN_NAME, OFFSET, DEFAULT) OVER(PARTITION BY COLUMN_NAME ORDER BY COLUMN_NAME)
        1. COLUMN_NAME - But the column who's next value we want 
        2. OFFSET - It is the number of rows we want to have the next value of
        3. DEFAULT - If the next row is not present then the default value to consider 
        4. OVER(PARTITION BY COLUMN_NAME ORDER BY COLUMN_NAME)
    
*/
SELECT *
FROM SALES_ORDERS;

-- Question 1
/*
    Based on the sales data that is provided. You need to print the next order date for each customer 
*/
-- Solution 
SELECT
    CUSTOMER_NAME, 
    ORDER_DATE,
    LEAD(ORDER_DATE, 1) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE ASC) AS NEXT_ORDER_DATE
FROM SALES_ORDERS;


-- Question 2
/*
    We need to analyse the duration of repeat orders from each customers based on their order date
*/
SELECT
    CUSTOMER_NAME, 
    ORDER_DATE, 
    LEAD(ORDER_DATE, 1) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE ASC) AS NEXT_ORDER_DATE, 
    DATEDIFF(DAY, ORDER_DATE, LEAD(ORDER_DATE, 1) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE ASC)) AS REPEAT_DURATION
FROM SALES_ORDERS;

-- LAG()
/*
    Lag() function gives us the value of the previous row based on the current row. 
    Syntax - 
    LAG(COLUMN_NAME, OFFSET, DEFAULT) -
        1. COLUMN_NAME - The column who's previous value we want to fetch 
        2. OFFSET - The number of rows we want to go back 
        3. DEFAULT - If the previous row is not present then what value to be taken
*/

-- Question 1
/*
    We need to displat the customer name, order date and previous order date for each customer
*/
SELECT
    CUSTOMER_NAME, 
    ORDER_DATE, 
    LAG(ORDER_DATE, 1) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE DESC) AS PREVIOUS_ORDER_DATE 
FROM SALES_ORDERS;

-- Question 2
/*
    Display the 3 consecutive orders for each and every customer along their sales amount
*/
SELECT
    CUSTOMER_NAME, 
    ORDER_DATE, 
    SALES_AMOUNT, 
    LAG(SALES_AMOUNT, 1) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE DESC) AS SECOND_PREV_SALES,
    LAG(SALES_AMOUNT, 2) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE DESC) AS THIRD_PREV_SALES
FROM SALES_ORDERS;




-- FIRSTVALUE()
/*
    Based on the partition and the sorting of the column that we provide, the first value from the window will be returned. 
    Syntax - 
    FIRSTVALUE(COLUMN_NAME) OVER(PARTITION BY COLUMN_NAME ORDER BY COLUMN_NAME ASC/DESC [ROWS BETWEEN])
        1. COLUMN_NAME - The column on which the first value must be returned 
        2. [ROWS BETWEEN] - Defined the range of the window the rowds to be included, it is useful for the LAST_VALUE, but also can be used here
        3. OVER(PARTITION BY COLUMN_NAME ORDER BY COLUMN_NAME ASC/DESC)
*/
-- Question 1
/*
    Write a sql query to find the FIRST ORDER DATE for each customer along with their order id
*/
    SELECT
        ORDER_ID,
        CUSTOMER_NAME,  
        ORDER_DATE, 
        FIRST_VALUE(ORDER_DATE) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE DESC) AS FIRST_ORDER_DATE
    FROM SALES_ORDERS
    ORDER BY CUSTOMER_NAME ASC, ORDER_DATE DESC;

-- LASTVALUE()
-- Question 2
/*
    Write a sql query to find the FIRST ORDER DATE for each customer along with their order id
*/
    SELECT
        ORDER_ID,
        CUSTOMER_NAME,  
        ORDER_DATE, 
        LAST_VALUE(ORDER_DATE) OVER(PARTITION BY CUSTOMER_NAME ORDER BY ORDER_DATE DESC) AS LAST_ORDER_DATE
    FROM SALES_ORDERS
    ORDER BY CUSTOMER_NAME ASC, ORDER_DATE ASC; -- RESULT 


-- Question 2
/*
    Using the sales_order table, display the following columns for each order:
        1. order_id
        2. customer_id
        3. order_date
    The last order date for that customer using LAST_VALUE()
*/
SELECT
    CUSTOMER_NAME, 
    ORDER_DATE, 
    LAST_VALUE(ORDER_DATE)
    OVER(
        PARTITION BY CUSTOMER_NAME
        ORDER BY ORDER_DATE
        ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING
    ) AS LAST_ORDERED_VALUE
FROM SALES_ORDERS
ORDER BY CUSTOMER_NAME, ORDER_DATE ;

