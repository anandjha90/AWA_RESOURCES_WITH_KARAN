-- =====================================================
-- Session 7 : SQL Operators (Snowflake)
-- =====================================================

-- -------------------------
-- Environment Setup
-- -------------------------

-- Use Role
USE ROLE ACCOUNTADMIN;

-- Use Warehouse
USE WAREHOUSE COMPUTE_WH;

-- Create Database
CREATE DATABASE IF NOT EXISTS V4_BASIC_SQL_OPERATORS_DB;

-- Use Database
USE DATABASE V4_BASIC_SQL_OPERATORS_DB;

-- Create Schema
CREATE SCHEMA IF NOT EXISTS V4_BASIC_SQL_OPERATORS_SCHEMA;

-- Use Schema
USE SCHEMA V4_BASIC_SQL_OPERATORS_SCHEMA;


-- -------------------------
-- Exploring the Data
-- -------------------------

-- Display all records
SELECT *
FROM SALESDATA;

-- Identify fundamental data issue
SELECT
    PROFIT,
    SALES
FROM SALESDATA;


-- =====================================================
-- Data Cleaning Approaches
-- =====================================================

-- -------------------------
-- Method 1 : Snowflake Specific (On-the-fly cleaning)
-- -------------------------

-- Build logic to clean SALES
SELECT
    SALES,
    REPLACE(REPLACE(SALES, '$', ''), ',', '') AS SALES_CLEAN_COLUMN
FROM SALESDATA;

-- Build logic to clean PROFIT
SELECT
    PROFIT,
    REPLACE(REPLACE(PROFIT, '$', ''), ',', '') AS PROFIT_CLEAN_COLUMN
FROM SALESDATA;

-- Update SALES column directly
UPDATE SALESDATA
SET SALES = REPLACE(REPLACE(SALES, '$', ''), ',', '');

-- Test implicit typecasting
SELECT
    SALES,
    SALES + 10 AS TESTING_ADDITION
FROM SALESDATA;


-- -------------------------
-- Method 2 : Platform Independent (Recommended)
-- -------------------------

-- Add new clean columns
ALTER TABLE SALESDATA
ADD COLUMN SALES_CLEAN DECIMAL(10, 2);

ALTER TABLE SALESDATA
ADD COLUMN PROFIT_CLEAN DECIMAL(10, 2);

-- Populate new columns
UPDATE SALESDATA
SET SALES_CLEAN = REPLACE(REPLACE(SALES, '$', ''), ',', '');

UPDATE SALESDATA
SET PROFIT_CLEAN = REPLACE(REPLACE(PROFIT, '$', ''), ',', '');

-- View final dataset
SELECT *
FROM SALESDATA;


-- =====================================================
-- SQL Query Template
-- =====================================================
/*
SELECT
FROM
WHERE
ORDER BY
*/


-- =====================================================
-- Operators in SQL
-- =====================================================

-- -------------------------
-- Arithmetic Operators
-- -------------------------

-- Question 1
/*
Return Total Order Value (Quantity * Sales)
*/
SELECT
    SALES,
    QUANTITY,
    QUANTITY * SALES AS TOTAL_ORDER_VALUE
FROM SALESDATA;

-- Question 2
/*
Return Shipping Cost increased by 10
*/
SELECT
    SHIPPING_COST,
    SHIPPING_COST + 10 AS PROJECTED_SHIPPING_COST
FROM SALESDATA;

-- Question 3
/*
Extra amount paid during shipping for 5 kms
*/
SELECT
    SHIPPING_COST,
    SHIPPING_COST % 5 AS EXTRA_AMOUNT_PAID
FROM SALESDATA;


-- -------------------------
-- Comparison Operators
-- -------------------------
/*
=   != or <>   >=   <=   >   <
*/

-- Question 4
/*
Profit is not negative
Display ORDER_ID and PROFIT
Sort by PROFIT ascending
*/
SELECT
    ORDER_ID,
    PROFIT_CLEAN
FROM SALESDATA
WHERE PROFIT_CLEAN >= 0
ORDER BY PROFIT_CLEAN ASC;

-- Question 5
/*
Orders sold in either profit or loss
*/
SELECT
    ORDER_ID,
    PROFIT_CLEAN
FROM SALESDATA
WHERE PROFIT_CLEAN != 0
ORDER BY PROFIT_CLEAN ASC;

SELECT
    ORDER_ID,
    PROFIT_CLEAN
FROM SALESDATA
WHERE PROFIT_CLEAN <> 0
ORDER BY PROFIT_CLEAN ASC;


-- -------------------------
-- Logical Operators
-- -------------------------
/*
AND   OR   NOT
*/

-- Question 6
/*
Row ID > 5000 AND Segment = 'Consumer'
*/
SELECT
    ROW_ID,
    SEGMENT
FROM SALESDATA
WHERE
    ROW_ID > 5000
    AND SEGMENT = 'Consumer'
ORDER BY ROW_ID ASC;

-- Question 7
/*
Orders where profit is either positive or negative
*/
SELECT
    ORDER_ID,
    PROFIT_CLEAN
FROM SALESDATA
WHERE PROFIT_CLEAN <> 0
ORDER BY PROFIT_CLEAN;

SELECT
    ORDER_ID,
    PROFIT_CLEAN
FROM SALESDATA
WHERE
    PROFIT_CLEAN < 0
    OR PROFIT_CLEAN > 0
ORDER BY PROFIT_CLEAN ASC;


-- -------------------------
-- NOT Operator
-- -------------------------

-- Question 8
/*
Segment is either Consumer or Home Office
*/
SELECT
    ORDER_ID,
    SEGMENT
FROM SALESDATA
WHERE SEGMENT IN ('Consumer', 'Home Office');

SELECT
    ORDER_ID,
    SEGMENT
FROM SALESDATA
WHERE NOT SEGMENT = 'Corporate';


-- -------------------------
-- Bitwise Operators
-- -------------------------
/*
Bitwise AND & OR
*/

-- AND Example
SELECT
    BITAND(6, 3) AS RESULT;

-- OR Example
SELECT
    BITOR(6, 3) AS RESULT;


-- -------------------------
-- Special Operators
-- -------------------------
/*
BETWEEN   IN   IS NULL   IS NOT NULL   LIKE
*/

-- Question 9
/*
Profit between 500 and 1000
*/
SELECT
    ORDER_ID,
    PROFIT
FROM SALESDATA
WHERE PROFIT_CLEAN BETWEEN 500 AND 1000
ORDER BY PROFIT_CLEAN ASC;


-- Question 10
/*
Shipping Mode: First Class, Standard Class, Second Class
*/

-- Using IN
SELECT
    ORDER_ID,
    SHIP_MODE
FROM SALESDATA
WHERE SHIP_MODE IN ('First Class', 'Standard Class', 'Second Class');

-- Using NOT EQUAL
SELECT
    ORDER_ID,
    SHIP_MODE
FROM SALESDATA
WHERE SHIP_MODE <> 'Same Day'
ORDER BY ORDER_ID ASC;

-- Using OR
SELECT
    ORDER_ID,
    SHIP_MODE
FROM SALESDATA
WHERE
    SHIP_MODE = 'First Class'
    OR SHIP_MODE = 'Standard Class'
    OR SHIP_MODE = 'Second Class';


-- Question 11
/*
Orders with missing Postal Code
*/
SELECT
    ORDER_ID,
    POSTAL_CODE
FROM SALESDATA
WHERE POSTAL_CODE IS NULL;

-- Orders without missing Postal Code
SELECT
    ORDER_ID,
    POSTAL_CODE
FROM SALESDATA
WHERE POSTAL_CODE IS NOT NULL;

-- IFNULL demonstration
SELECT
    ORDER_ID,
    POSTAL_CODE,
    IFNULL(POSTAL_CODE, -1) AS NULL_CHECKER
FROM SALESDATA;
