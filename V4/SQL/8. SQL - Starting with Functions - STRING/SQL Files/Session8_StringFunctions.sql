-- =====================================================
-- Lecture 8 : SQL String Functions (Snowflake)
-- =====================================================
/*
    String Functions Covered:
    1. LTRIM()
    2. RTRIM()
    3. TRIM()
    4. SPLIT()
    5. SPLIT_PART()
    6. CONCAT()
    7. CONCAT_WS()
*/

-- -----------------------------------------------------
-- Environment Setup
-- -----------------------------------------------------

-- Assign Role
USE ROLE ACCOUNTADMIN;

-- Assign Warehouse
USE WAREHOUSE COMPUTE_WH;

-- Create Database
CREATE DATABASE IF NOT EXISTS EndtoEndSQL;

-- Use Database
USE DATABASE EndtoEndSQL;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS StringFunctionsSchema;

-- Use Schema
USE SCHEMA StringFunctionsSchema;


-- -----------------------------------------------------
-- Sequence Creation (Auto Increment)
-- -----------------------------------------------------

CREATE SEQUENCE AUTO_INCREMENT_SEQUENCE
START WITH 1
INCREMENT BY 1;


-- -----------------------------------------------------
-- Table Creation
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS SALES (
    SALE_ID           INT DEFAULT AUTO_INCREMENT_SEQUENCE.NEXTVAL PRIMARY KEY NOT NULL,
    ORDER_ID          VARCHAR(100) NOT NULL,
    CUSTOMER_NAME     VARCHAR(100) NOT NULL,
    PRODUCT_NAME      VARCHAR(150) NOT NULL,
    PRODUCT_CATEGORY  VARCHAR(50),
    ORDER_CITY        VARCHAR(50),
    ORDER_STATE       VARCHAR(50),
    ORDER_COUNTRY     VARCHAR(50),
    SALES_CHANNEL     VARCHAR(50),
    PAYMENT_METHOD    VARCHAR(50),
    FEEDBACK          VARCHAR(255),
    SALE_AMOUNT       DECIMAL(10, 2),
    DISCOUNT          DECIMAL(5, 2),
    ORDER_DATE        DATE,
    SHIPPING_DATE     DATE
);


-- -----------------------------------------------------
-- Data Insertion
-- -----------------------------------------------------

INSERT INTO SALES (
    ORDER_ID,
    CUSTOMER_NAME,
    PRODUCT_NAME,
    PRODUCT_CATEGORY,
    ORDER_CITY,
    ORDER_STATE,
    ORDER_COUNTRY,
    SALES_CHANNEL,
    PAYMENT_METHOD,
    FEEDBACK,
    SALE_AMOUNT,
    DISCOUNT,
    ORDER_DATE,
    SHIPPING_DATE
)
VALUES
('ORD-1001', '  Alice Brown', 'iPhone 13', 'Electronics  ', 'New York', 'NY', 'USA', 'Online', 'Credit Card', '****Very Satisfied****', 999.99, 5.00, '2025-01-01', '2025-01-03'),
('ORD-1002', 'Bob Smith', 'MacBook Pro', 'Electronics ', 'San Francisco', 'CA', 'USA', 'Online', 'PayPal', 'Satisfied', 1999.99, 10.00, '2025-01-02', '2025-01-04'),
('ORD-1003', 'Charlie Green', 'Samsung Galaxy S21', 'Electronics', 'Los Angeles', 'CA', 'USA', 'Retail', 'Credit Card', 'Neutral', 799.99, 7.50, '2025-01-05', '2025-01-06'),
('ORD-1004', '   David White', 'Sony TV', 'Electronics', 'Miami', 'FL', 'USA', 'Retail', 'Debit Card', '****Very Satisfied****', 599.99, 15.00, '2025-01-10', '2025-01-12'),
('ORD-1005', 'Eva Black', 'HP Laptop', 'Electronics', 'Chicago', 'IL', 'USA', 'Online', 'Credit Card', 'Satisfied', 899.99, 12.50, '2025-01-11', '2025-01-13'),
-- (data continues unchanged)
('ORD-1033', 'Gina Rodriguez', 'Logitech MX Master 3', 'Electronics', 'Denver', 'CO', 'USA', 'Online', 'Credit Card', 'Satisfied', 99.99, 2.00, '2025-02-13', '2025-02-16');


-- -----------------------------------------------------
-- Verify Data
-- -----------------------------------------------------

SELECT *
FROM SALES;


-- =====================================================
-- STRING FUNCTION QUESTIONS
-- =====================================================

-- -----------------------------------------------------
-- Question 1 : LTRIM()
-- -----------------------------------------------------
/*
    Remove unwanted leading spaces from CUSTOMER_NAME.
    Filter only state = 'CA'.
    Sort data by SALE_ID from highest to lowest.
*/

SELECT
    SALE_ID,
    CUSTOMER_NAME,
    LENGTH(CUSTOMER_NAME) AS ORIGINAL_LENGTH,
    LTRIM(CUSTOMER_NAME) AS CLEANED_CUSTOMER_NAME,
    LENGTH(LTRIM(CUSTOMER_NAME)) AS CLEANED_LENGTH,
    ORDER_STATE
FROM SALES
WHERE ORDER_STATE = 'CA'
ORDER BY SALE_ID DESC;


-- -----------------------------------------------------
-- Question 2 : RTRIM()
-- -----------------------------------------------------
/*
    Remove unwanted trailing spaces from PRODUCT_CATEGORY.
    Filter states: CA, TX, WA
    Payment Method must be Credit Card.
*/

SELECT
    SALE_ID,
    PRODUCT_CATEGORY,
    LENGTH(PRODUCT_CATEGORY) AS ORIGINAL_LENGTH,
    RTRIM(PRODUCT_CATEGORY) AS CLEANED_PRODUCT_CATEGORY,
    LENGTH(RTRIM(PRODUCT_CATEGORY)) AS CLEANED_LENGTH
FROM SALES
WHERE
    ORDER_STATE IN ('CA', 'TX', 'WA')
    AND PAYMENT_METHOD = 'Credit Card'
ORDER BY SALE_ID ASC;


-- -----------------------------------------------------
-- Question 3 : TRIM()
-- -----------------------------------------------------
/*
    Remove unwanted characters (#, -, *) from FEEDBACK.
*/

SELECT
    SALE_ID,
    CUSTOMER_NAME,
    FEEDBACK,
    TRIM(FEEDBACK, '#-*') AS CLEANED_FEEDBACK,
    TRIM(CUSTOMER_NAME) AS CLEANED_CUSTOMER_NAME
FROM SALES;


-- -----------------------------------------------------
-- Question 4 : SPLIT()
-- -----------------------------------------------------
/*
    Split CUSTOMER_NAME into First Name and Last Name.
*/

SELECT
    SALE_ID,
    ORDER_ID,
    CUSTOMER_NAME,
    SPLIT(LTRIM(CUSTOMER_NAME), ' ') AS FIRSTNAME_LASTNAME,
    ORDER_STATE,
    SALES_CHANNEL,
    PAYMENT_METHOD
FROM SALES;


-- -----------------------------------------------------
-- Question 5 : SPLIT_PART()
-- -----------------------------------------------------
/*
    Extract First Name and Last Name separately.
*/

SELECT
    SALE_ID,
    ORDER_ID,
    CUSTOMER_NAME,
    SPLIT_PART(LTRIM(CUSTOMER_NAME), ' ', 1) AS FIRST_NAME,
    SPLIT_PART(LTRIM(CUSTOMER_NAME), ' ', 2) AS LAST_NAME,
    ORDER_STATE,
    SALES_CHANNEL,
    PAYMENT_METHOD
FROM SALES;


-- -----------------------------------------------------
-- Question 6 : CONCAT()
-- -----------------------------------------------------
/*
    Combine ORDER_STATE and ORDER_COUNTRY.
*/

SELECT
    SALE_ID,
    ORDER_ID,
    ORDER_STATE,
    ORDER_COUNTRY,
    CONCAT(ORDER_STATE, ' - ', ORDER_COUNTRY) AS ORDER_STATE_COUNTRY
FROM SALES;


-- -----------------------------------------------------
-- Question 7 : CONCAT_WS()
-- -----------------------------------------------------
/*
    Combine ORDER_STATE, ORDER_CITY, ORDER_COUNTRY.
*/

SELECT
    SALE_ID,
    ORDER_ID,
    ORDER_STATE,
    ORDER_CITY,
    ORDER_COUNTRY,
    CONCAT_WS(' - ', ORDER_STATE, ORDER_CITY, ORDER_COUNTRY) AS ORDER_STATE_CITY_COUNTRY
FROM SALES;


-- -----------------------------------------------------
-- Data Cleaning Example (Product Category)
-- -----------------------------------------------------

SELECT
    ORDER_ID,
    PRODUCT_CATEGORY,
    CONCAT(
        SPLIT_PART(PRODUCT_CATEGORY, ' ', 1),
        SPLIT_PART(PRODUCT_CATEGORY, ' ', 2)
    ) AS CLEANED_PRODUCT_CATEGORY
FROM SALES
WHERE ORDER_ID = 'ORD-1034';
