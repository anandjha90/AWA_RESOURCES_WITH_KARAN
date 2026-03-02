-- Ranking functions 
/*
    Functions 
    1. ROW_NUMBER()
    2. RANK()
    3. DENSE_RANK()
    
    1. OVER()
    2. PARTITION BY 
*/
-- Assigning the role for the account 
USE ROLE ACCOUNTADMIN;

-- Assigning the warehouse to the account 
USE WAREHOUSE COMPUTE_WH;

-- Creating a database named as SALES_DATABASE
CREATE DATABASE IF NOT EXISTS EndtoEndSQL;

-- USING THE DATABASE CREATED SALES_DATABASE 
USE DATABASE EndtoEndSQL;

-- CREATING a schema for the SALES_DATABASE 
CREATE SCHEMA IF NOT EXISTS WindowFunctionsSchema;

-- USING THE SCHEMA CREATED SALES_SCHEMA
USE SCHEMA WindowFunctionsSchema;


-- QUESTION 
/*
Tables
* `Signups(user_id, time_stamp)`
* `Confirmations(user_id, time_stamp, action)`
Each user may request multiple confirmation messages (either 'confirmed' or 'timeout')
Task:
    Write a query to find the **confirmation rate** for each user, defined as:
    Confirmed messages / total confirmation requests (confirmed + timeout)
    If a user has no requests, their rate is 0.
    Round the result to 2 decimal places
    Return: `user_id` and `confirmation_rate` (in any order).
*/
CREATE OR REPLACE TABLE Signups (
    user_id INT PRIMARY KEY,
    time_stamp DATETIME
);

INSERT INTO Signups (user_id, time_stamp) VALUES
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');



CREATE OR REPLACE TABLE Confirmations (
    user_id INT,
    time_stamp DATETIME,
    action string,
    PRIMARY KEY (user_id, time_stamp),
    FOREIGN KEY (user_id) REFERENCES Signups(user_id)
);

INSERT INTO Confirmations (user_id, time_stamp, action) VALUES
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');


/*
    Write a query to find the **confirmation rate** for each user, defined as:
    Confirmed messages / total confirmation requests (confirmed + timeout)
    If a user has no requests, their rate is 0.
*/

-- Write your MySQL query statement below

-- Tables
INSERT INTO Signups (user_id, time_stamp) VALUES
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

INSERT INTO Confirmations (user_id, time_stamp, action) VALUES
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

-- Approach 


-- Window Functions - Ranking Window Functions 
-- Create the table
CREATE OR REPLACE TABLE SALES_DATA (
    SALE_ID INT,
    SALESPERSON STRING,
    REGION STRING,
    SALE_AMOUNT NUMBER(10,2)
);

-- Insert sample data
INSERT INTO SALES_DATA (SALE_ID, SALESPERSON, REGION, SALE_AMOUNT) VALUES
(1,  'Amit',    'North', 5000),
(2,  'Priya',   'South', 7000),
(3,  'Rohan',   'East',  6000),
(4,  'Anjali',  'North', 5000),
(5,  'Sameer',  'East',  8000),
(6,  'Meera',   'South', 7000),
(7,  'Vikram',  'North', 9000),
(8,  'Kunal',   'East',  6000),
(9,  'Neha',    'South', 8500),
(10, 'Aarav',   'North', 9000),
(11, 'Tanya',   'East',  8000),
(12, 'Rajesh',  'South', 7000),
(13, 'Nikhil',  'North', 5000),
(14, 'Simran',  'East',  6000),
(15, 'Manish',  'South', 8500),
(16, 'Dev',     'North', 9000),
(17, 'Isha',    'East',  8000),
(18, 'Alok',    'South', 8500),
(19, 'Ritu',    'North', 5000),
(20, 'Sneha',   'East',  6000);

SELECT *
FROM SALES_DATA;


-- Question 1 
/*
    Write a SQL query to return the salesperson who did the maximum sales from the dataset    
*/
-- Solution
SELECT
    SALESPERSON, 
    SALE_AMOUNT
FROM SALES_DATA
ORDER BY SALE_AMOUNT DESC
LIMIT 1;

-- Concept of Ranking functions
-- ROW_NUMBER()
/*
    
*/
WITH CTE AS
(
SELECT
    SALESPERSON, 
    SALE_AMOUNT,
    ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) AS RANK_GIVEN
FROM SALES_DATA
) 
SELECT 
    *
FROM CTE
WHERE RANK_GIVEN < 4; -- How will I know I need to use 4 only here


SELECT
    SALESPERSON, 
    SALE_AMOUNT,
    ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) AS RANK_GIVEN
FROM SALES_DATA;


-- RANK()

with cte as 
(
SELECT
    SALESPERSON,
    SALE_AMOUNT, 
    ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) AS ROW_RANK_GIVEN,
    RANK() OVER(ORDER BY SALE_AMOUNT DESC) AS RANK_RANK_GIVEN
FROM SALES_DATA
ORDER BY ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) ASC
)
SELECT *
FROM CTE 
WHERE RANK_RANK_GIVEN = 1;


SELECT
    SALESPERSON,
    SALE_AMOUNT, 
    ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) AS ROW_RANK_GIVEN,
    RANK() OVER(ORDER BY SALE_AMOUNT DESC) AS RANK_RANK_GIVEN
FROM SALES_DATA
ORDER BY ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) ASC;

-- DENSE_RANK()
SELECT
    SALESPERSON,
    SALE_AMOUNT, 
    ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) AS ROW_RANK_GIVEN,
    RANK() OVER(ORDER BY SALE_AMOUNT DESC) AS RANK_RANK_GIVEN, 
    DENSE_RANK() OVER(ORDER BY SALE_AMOUNT DESC) AS DENSE_RANK_GIVEN
FROM SALES_DATA
ORDER BY ROW_NUMBER() OVER(ORDER BY SALE_AMOUNT DESC) ASC;

-- Question 
/*
    Write a SQL query to return the ranking of the sales persons in their region 
    based on the sale amount that they have achieved. 
    Note that you need to use all the functions and look at the result 
    1. ROW_NUMBER()
    2. RANK()
    3. DENSE_RANK()
    Columns to include 
    1. SALESPERSON, 
    2. REGION. 
    3. SALE_AMOUNT
*/
SELECT
    SALESPERSON, 
    REGION, 
    SALE_AMOUNT, 
    ROW_NUMBER() OVER(PARTITION BY REGION ORDER BY SALE_AMOUNT DESC) AS ROW_RANK_GIVEN,
    RANK() OVER(PARTITION BY REGION ORDER BY SALE_AMOUNT DESC) AS RANK_RANK_GIVEN,
    DENSE_RANK() OVER(PARTITION BY REGION ORDER BY SALE_AMOUNT DESC) AS DENSE_RANK_GIVEN
FROM SALES_DATA