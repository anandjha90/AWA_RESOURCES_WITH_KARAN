-- =====================================================
-- Lecture 9 : SQL String Functions & LIKE OPERATOR (Snowflake)
-- =====================================================
/*
    String Functions Already Covered:
    1. LTRIM()
    2. RTRIM()
    3. TRIM()
    4. SPLIT()
    5. SPLIT_PART()
    6. CONCAT()
    7. CONCAT_WS()

    -- In this lecture
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
CREATE SCHEMA IF NOT EXISTS StringFunctionsLikeSchema;

-- Use Schema
USE SCHEMA StringFunctionsLikeSchema;


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
('ORD-1033', 'Gina Rodriguez', 'Logitech MX Master 3', 'Electronics', 'Denver', 'CO', 'USA', 'Online', 'Credit Card', 'Satisfied', 99.99, 2.00, '2025-02-13', '2025-02-16'),
('ORD-1034', 'Daniel Brown', 'Sony Headphones', 'Electronics', 'Austin', 'TX', 'USA', 'Online', 'Credit Card', 'Satisfied', 199.99, 5.00, '2025-02-14', '2025-02-16'),
('ORD-1035', 'Daisy Ridley', 'Samsung Galaxy Watch', 'Electronics', 'Dallas', 'TX', 'USA', 'Retail', 'Cash', 'Very Satisfied', 299.99, 10.00, '2025-02-15', '2025-02-17'),
('ORD-1036', 'David Beckham', 'Samsung Galaxy Buds', 'Electronics', 'Miami', 'FL', 'USA', 'Online', 'PayPal', 'Satisfied', 149.99, 7.50, '2025-02-16', '2025-02-18'),
('ORD-1037', 'Chris Brown', 'Apple iPhone 14', 'Electronics', 'New York', 'NY', 'USA', 'Online', 'Credit Card', 'Satisfied', 1099.99, 15.00, '2025-02-17', '2025-02-19'),
('ORD-1038', 'James Brown', 'Apple AirPods Pro', 'Electronics', 'Chicago', 'IL', 'USA', 'Retail', 'Debit Card', 'Satisfied', 249.99, 8.00, '2025-02-18', '2025-02-20'),
('ORD-1039', 'Aaron Paul', 'Apple Watch Ultra', 'Electronics', 'Seattle', 'WA', 'USA', 'Online', 'Credit Card', 'Very Satisfied', 799.99, 12.00, '2025-02-19', '2025-02-21'),
('ORD-1040', 'Ben Affleck', 'Sony Bravia OLED TV', 'Electronics', 'San Jose', 'CA', 'USA', 'Retail', 'Credit Card', 'Satisfied', 1999.99, 20.00, '2025-02-20', '2025-02-22'),
('ORD-1041', '   adam levine', 'Apple MacBook Pro', 'Electronics', 'Los Angeles', 'CA', 'USA', 'Online', 'PayPal', 'Satisfied', 2399.99, 25.00, '2025-02-21', '2025-02-23'),
('ORD-1042', 'Amy Adams', 'samsung Galaxy S23', 'Electronics', 'San Diego', 'CA', 'USA', 'Retail', 'Cash', 'Very Satisfied', 899.99, 10.00, '2025-02-22', '2025-02-24'),
('ORD-1043', 'Carl Johnson', 'HP Pavilion 15', 'Electronics', 'Phoenix', 'AZ', 'USA', 'Online', 'Credit Card', 'Neutral', 699.99, 5.00, '2025-02-23', '2025-02-25'),
('ORD-1044', 'Cathy Holmes', 'HP Pavilion 14', 'Electronics', 'Tempe', 'AZ', 'USA', 'Retail', 'Debit Card', 'Satisfied', 649.99, 6.00, '2025-02-24', '2025-02-26'),
('ORD-1045', 'Brian Cox', 'Google Pixel 7', 'Electronics', 'San Antonio', 'TX', 'USA', 'Online', 'Credit Card', 'Satisfied', 599.99, 7.00, '2025-02-25', '2025-02-27'),
('ORD-1046', 'Bruno Mars', 'Google Pixel Watch', 'Electronics', 'San Mateo', 'CA', 'USA', 'Retail', 'Cash', 'Very Satisfied', 349.99, 5.00, '2025-02-26', '2025-02-28');