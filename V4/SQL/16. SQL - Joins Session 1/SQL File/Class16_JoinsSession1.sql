-- USE ROLE 
USE ROLE ACCOUNTADMIN;

-- USE WAREHOUSE 
USE WAREHOUSE COMPUTE_WH;

-- CREATING A DATABASE 
CREATE DATABASE IF NOT EXISTS JOINS_SESSION_DB;

-- USE DATABASE 
USE DATABASE JOINS_SESSION_DB;

-- CREATE SCHEMA FOR THE TODAYS CLASS
CREATE SCHEMA IF NOT EXISTS JOINS_SESSION_1_SCHEMA;

-- USE SCHEMA 
USE SCHEMA JOINS_SESSION_1_SCHEMA;

-- CREATING A TABLE NAMED CUSTOMERS
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Country VARCHAR(50)
);

-- CREATING A TABLE NAMED ORDERS
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- INSERTING VALUES INSIDE TABLE CUSTOMER
INSERT INTO Customers (CustomerID, CustomerName, Country)
VALUES
(1, 'John Doe', 'USA'),
(2, 'Jane Smith', 'UK'),
(3, 'David Brown', 'Canada'),
(4, 'Emily White', 'Australia'),
(5, 'Michael Green', 'USA'),
(6, 'Anna Taylor', 'USA'),
(7, 'Robert King', 'UK'),
(8, 'Laura Wilson', 'Australia'),
(9, 'James Davis', 'Canada'),
(10, 'Sophia Harris', 'USA'),
(11, 'Chris Evans', 'Australia'),
(12, 'Jessica Adams', 'Canada'),
(13, 'Lucas Black', 'USA'),
(14, 'Olivia Walker', 'UK'),
(15, 'Nathan Scott', 'USA'),
(16, 'Emma Stone', 'Australia'),
(17, 'Daniel Lewis', 'UK'),
(18, 'Sophia Clark', 'Canada'),
(19, 'Liam Johnson', 'Australia'),
(20, 'Amelia Brown', 'USA');

-- INSERTING VALUES INTO TABLE ORDERS
INSERT INTO Orders (OrderID, OrderDate, CustomerID, Amount)
VALUES
(101, '2025-01-10', 1, 250.75),
(102, '2025-01-15', 2, 320.00),
(103, '2025-01-20', 3, 450.50),
(104, '2025-02-01', 1, 120.90),
(105, '2025-02-05', 2, 310.50),
(106, '2025-02-10', NULL, 299.99),
(107, '2025-02-15', 4, 400.25),
(108, '2025-02-20', 5, 150.00),
(109, '2025-02-25', 7, 500.75),
(110, '2025-03-01', 6, 225.50),
(111, '2025-03-05', 9, 600.00),
(112, '2025-03-10', NULL, 450.00),
(113, '2025-03-12', 8, 350.00),
(114, '2025-03-15', 11, 520.75),
(115, '2025-03-18', 12, 310.50),
(116, '2025-03-20', 15, 230.99),
(117, '2025-03-22', 13, 150.20),
(118, '2025-03-25', 14, 475.65),
(119, '2025-03-26', 15, 540.90),
(120, '2025-03-28', NULL, 299.00),  -- Another order without a customer
(121, '2025-03-29', 17, 405.50),
(122, '2025-03-29', NULL, 675.00),  -- Another order without a customer
(123, '2025-03-29', 19, 850.00),
(124, '2025-03-29', 20, 399.99);


-- INNER JOIN 
/*
    SELECT
        T1.*, 
        T2.*
    FROM TABLE_1 AS T1 -- LEFT TABLE 
    INNNER JOIN TABLE_2 AS T2 -- RIGHT TABLE
    ON T1.COLUMN <CONDITION> T2.COLUMN
*/
-- Question 1 
/*
    Find the customers who have placed atleast one order.
    Return only the customer id, customer name, order id
*/
-- Solution 
SELECT
    T1.CUSTOMERID AS CUSTOMERID_FROM_CUSTOMERS, 
    T2.CUSTOMERID AS CUSTOMERID_FROM_ORDERS, 
    T2.ORDERID AS ORDER_ID
FROM CUSTOMERS AS T1 -- LEFT TABLE 
INNER JOIN ORDERS AS T2 -- RIGHT TABLE 
ON T1.CUSTOMERID = T2.CUSTOMERID; -- CONDITION OF JOIN

-- Question 2
/*
    We need to find the customers who have placed orders.   
    Also we need to find the Sum of total amount of each customers orders
*/
SELECT
    T1.CUSTOMERID, 
    T1.CUSTOMERNAME,
    SUM(T2.AMOUNT) AS TOTAL_ORDER_AMOUNT
FROM CUSTOMERS AS T1
JOIN ORDERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID
GROUP BY T1.CUSTOMERID, T1.CUSTOMERNAME
ORDER BY T1.CUSTOMERID;


-- Question 3
/*
    Find the details of orders placed by customers from USA.
    Note that you need to get the customer id, customer name, order id, amount, order date.
*/
SELECT
    T1.CUSTOMERID, 
    T1.CUSTOMERNAME, 
    T1.COUNTRY,
    T2.ORDERID, 
    T2.ORDERDATE, 
    T2.AMOUNT
FROM CUSTOMERS AS T1
INNER JOIN ORDERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID
WHERE T1.COUNTRY = 'USA';


-- Left Join 
-- Question 1 
/*
    We need to get the list of all the customers who are present in the business, and as well as the customers who have placed an order.
*/
-- Solution 
SELECT
    T1.CUSTOMERID AS CUSTOMERID_FC,
    T2.CUSTOMERID AS CUSTOMERID_FO, 
    T2.ORDERID AS ORDER_ID, 
    T2.AMOUNT AS ORDER_AMOUNT
FROM CUSTOMERS AS T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID
WHERE T2.CUSTOMERID IS NULL;


-- Question 2 
/*
    Find the total number of orders for each customers from USA, including the customers 
    who have not placed any orders. Sort the result based on the count of their orders 
*/
-- Solution 
SELECT
    T1.CUSTOMERID, 
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS
FROM CUSTOMERS AS T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID
WHERE T1.COUNTRY = 'USA'
GROUP BY T1.CUSTOMERID, T1.CUSTOMERNAME
ORDER BY SUM(T2.ORDERID) ASC;



-- Question 3
/*
    Retrieve a list of all customers and the number of their orders, but show only those who have placed more than 1 order or no orders at all.
*/
SELECT
    T1.CUSTOMERID, 
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) TOTAL_ORDERS
FROM CUSTOMERS AS T1 -- LEFT TABLE 
LEFT JOIN ORDERS AS T2 -- RIGHT TABLE 
ON T1.CUSTOMERID = T2.CUSTOMERID -- JOINING LOGIC 
GROUP BY T1.CUSTOMERID, T1.CUSTOMERNAME
HAVING COUNT(T2.ORDERID) > 1 OR COUNT(T2.ORDERID) = 0
ORDER BY TOTAL_ORDERS DESC;

-- Practice Question 
-- Total Spending by Each Customer with More Than One Order
/*
    Get the total amount spent by each customer who has placed atleast one order. 
    Show customer name, country, number of orders, and total amount spent. 
    Sort by total amount in descending order.
*/
-- Solution
SELECT
    T1.CUSTOMERNAME, 
    T1.COUNTRY, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS, 
    SUM(T2.AMOUNT) AS TOTAL_AMOUNT_SPENT
FROM CUSTOMERS AS T1
JOIN ORDERS AS T2 -- IDENTIFY THE TYPE OF JOIN
ON T1.CUSTOMERID = T2.CUSTOMERID
GROUP BY T1.CUSTOMERNAME, T1.COUNTRY
ORDER BY SUM(T2.AMOUNT) DESC;

SELECT
    T1.*, 
    T2.*
FROM CUSTOMERS as T1
LEFT JOIN ORDERS as T2
ORDER BY T1.CUSTOMERID ASC;