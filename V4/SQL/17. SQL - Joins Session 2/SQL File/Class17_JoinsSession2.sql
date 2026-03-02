-- USE ROLE 
USE ROLE ACCOUNTADMIN;

-- USE WAREHOUSE 
USE WAREHOUSE COMPUTE_WH;

-- CREATING A DATABASE 
CREATE DATABASE IF NOT EXISTS JOINS_SESSION_DB;

-- USE DATABASE 
USE DATABASE JOINS_SESSION_DB;

-- CREATE SCHEMA FOR THE TODAYS CLASS
CREATE SCHEMA IF NOT EXISTS JOINS_SESSION_SCHEMA;

-- USE SCHEMA 
USE SCHEMA JOINS_SESSION_SCHEMA;

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


-- Practice Question 1 
/*
    Retrieve a list all customers and the number of their orders, but show only those customers who have 
    placed more than one order or no orders at all
*/
-- Note that you need to give me 3 solutions of this questions using the LEFT JOIN
-- SOL 1 
SELECT
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS
FROM CUSTOMERS as T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = t2.customerid
GROUP BY T1.CUSTOMERNAME
HAVING COUNT(T2.ORDERID) > 1 OR COUNT(T2.ORDERID) = 0;

-- Sol 2
SELECT
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS
FROM CUSTOMERS as T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = t2.customerid
GROUP BY T1.CUSTOMERNAME
HAVING COUNT(T2.ORDERID) <> 1;

-- Sol 3
SELECT
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS
FROM CUSTOMERS as T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = t2.customerid
GROUP BY T1.CUSTOMERNAME
HAVING NOT COUNT(T2.ORDERID) = 1;



-- Question 2 
/*
    Write a sql query to retrive the customer id, customer name, as well as country. 
    Classify the customers as different categorical values such as "Premium customer" if the 
    total number of orders is more than or equal to 1, "Normal Customer" if the total number of order is in range 1. 
    Else opportunity if the total number of order is 0
*/ 
-- Solution
/*
    CASE
        WHEN <CONDITION> THEN <OUTPUT> 
        WHEN <CONDITION> THEN <OUTPUT> 
        ELSE <OUTPUT>
    END AS COLUMN_NAME
*/

SELECT
    T1.CUSTOMERNAME, 
    COUNT(T2.ORDERID) AS TOTAL_ORDERS,
    -- CASE STATEMENTS
    CASE
        WHEN COUNT(T2.ORDERID) > 1 THEN 'Premium Customer' 
        WHEN COUNT(T2.ORDERID) = 1 THEN 'Normal Customer' 
        ELSE 'Opportunity'
    END AS CustomerCategory
FROM CUSTOMERS AS T1
LEFT JOIN ORDERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID
GROUP BY T1.CUSTOMERNAME
ORDER BY COUNT(T2.ORDERID) DESC;



-- Right Join 
/*
    Cutomers who have placed atleast 1 orde
*/
-- Soluition 
SELECT
    T1.CUSTOMERID, 
    T2.CUSTOMERID,
    T2.CUSTOMERNAME,
    T1.ORDERID
FROM ORDERS AS T1
RIGHT JOIN CUSTOMERS AS T2
ON T1.CUSTOMERID = T2.CUSTOMERID;


-- changing the dataset
CREATE TABLE IF NOT EXISTS course
(
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    course_desc VARCHAR(100),
    course_tag VARCHAR(20)
);

-- Inserting values into the course table
INSERT INTO course (course_id, course_name, course_desc, course_tag)
VALUES
(101, 'Mathematics', 'Advanced Mathematics Course', 'Math'),
(102, 'Physics', 'Basics of Physics', 'Physics'),
(103, 'Chemistry', 'Chemistry for Beginners', 'Chemistry'),
(104, 'Biology', 'Introduction to Biology', 'Biology'),
(105, 'Computer Science', 'Learn Programming', 'CS'),
(106, 'English Literature', 'Shakespearean Studies', 'English');


CREATE TABLE IF NOT EXISTS student
(
    student_id INT PRIMARY KEY, 
    student_name VARCHAR(50),
    student_mobile BIGINT, 
    student_course_enroll VARCHAR(50),
    student_course_id INT
);

-- Inserting values into the student table
INSERT INTO student (student_id, student_name, student_mobile, student_course_enroll, student_course_id)
VALUES
(201, 'Alice', 9876543210, 'Mathematics', 101),
(202, 'Bob', 9123456789, 'Physics', 102),
(203, 'Charlie', 9988776655, 'Computer Science', 105),
(204, 'David', 9112233445, 'Mathematics', 101),
(205, 'Eve', 9876654321, 'Biology', 104),
(206, 'Frank', 9543212345, 'Philosophy', NULL), -- Student enrolled in non-existent course
(207, 'Grace', 9898989898, 'Chemistry', 103);


CREATE TABLE IF NOT EXISTS instructor
(
    instructor_id INT PRIMARY KEY,
    instructor_name VARCHAR(50),
    course_id INT -- References course.course_id
);

-- Inserting values into the instructor table
INSERT INTO instructor (instructor_id, instructor_name, course_id)
VALUES
(301, 'Dr. Smith', 101),
(302, 'Dr. Johnson', 102),
(303, 'Dr. Lee', 103),
(304, 'Dr. White', 104),
(305, 'Prof. Davis', 105);


SELECT *
FROM STUDENT;

SELECT *
FROM COURSE;

SELECT *
FROM INSTRUCTOR;


-- FULL JOIN / CROSS JOIN
/*
    List all students and the courses they are enrolled in, 
    including students who are not enrolled in any course and courses that have no students.
*/
SELECT
    T1.STUDENT_ID,
    T1.STUDENT_COURSE_ID, 
    T2.COURSE_ID
FROM STUDENT AS T1
FULL JOIN COURSE AS T2
-- ON T1.STUDENT_COURSE_ID = T2.COURSE_ID;








