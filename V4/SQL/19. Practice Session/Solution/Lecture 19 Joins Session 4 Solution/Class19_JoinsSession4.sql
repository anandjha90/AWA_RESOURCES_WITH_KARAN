-- USE ROLE 
USE ROLE ACCOUNTADMIN;

-- USE WAREHOUSE 
USE WAREHOUSE COMPUTE_WH;

-- CREATING A DATABASE 
CREATE DATABASE IF NOT EXISTS JOINS_SESSION_3_DB;

-- USE DATABASE 
USE DATABASE JOINS_SESSION_3_DB;

-- CREATE SCHEMA FOR THE TODAYS CLASS
CREATE SCHEMA IF NOT EXISTS JOINS_SESSION_3_SCHEMA;

-- USE SCHEMA 
USE SCHEMA JOINS_SESSION_3_SCHEMA;


-- Dataset 1 
-- Departments Table
CREATE OR REPLACE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    location VARCHAR(100)
);

INSERT INTO Departments VALUES
(1, 'HR', 'Mumbai'),
(2, 'Engineering', 'Bangalore'),
(3, 'Finance', 'Delhi');

-- Employees Table
CREATE OR REPLACE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    manager_id INT,
    salary INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Employees VALUES
(101, 'Alice', 1, NULL, 60000, '2018-01-15'),
(102, 'Bob', 2, 101, 80000, '2019-03-20'),
(103, 'Charlie', 2, 102, 70000, '2020-07-10'),
(104, 'David', 3, 101, 75000, '2021-02-18'),
(105, 'Eva', 3, 104, 68000, '2022-05-22'),
(106, 'Karan', 2, 101, 7000, '2022-07-05'),
(107, 'Raj', 1, 102, 5000, '2022-05-23'),
(108, 'Rahul', 1, 101, 70000, '2022-11-01');

-- Projects Table
CREATE OR REPLACE TABLE Projects (
    proj_id INT PRIMARY KEY,
    proj_name VARCHAR(100),
    emp_id INT,
    budget INT,
    start_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Projects VALUES
(201, 'Payroll System', 101, 500000, '2023-01-01'),
(202, 'AI Model', 102, 700000, '2023-02-01'),
(203, 'Dashboard', 103, 400000, '2023-03-15'),
(204, 'Audit System', 104, 300000, '2023-04-10'),
(205, 'Investment Portal', 105, 450000, '2023-05-01');


-- Understading how to join more than 2 tables 
SELECT *
FROM EMPLOYEES;

SELECT *
FROM PROJECTS;

SELECT *
FROM DEPARTMENTS;

-- Question 1
/*
    Based on the dataset that is provided. We need to write a sql query to return the following things
    1. Project Name
    2. Employee Name
    3. Department Name
    4. Budget 
    Note that all the employees information must be given irrespective of whether they are allocated to a project or not 
    If an employee is not allocated to any project then the project name should be 'On Bench' and the budget value must be 0
*/
SELECT
    T1.EMP_NAME, 
    T3.DEPT_NAME, 
    CASE 
        WHEN T2.PROJ_NAME IS NULL THEN 'On Bench'
        ELSE T2.PROJ_NAME
    END AS PROJECT_NAME, 
    CASE 
        WHEN T2.BUDGET IS NULL THEN 0
        ELSE T2.BUDGET 
    END AS BUDGETDETAILS
FROM EMPLOYEES AS T1
LEFT JOIN PROJECTS AS T2 -- result 1 
ON T1.EMP_ID = T2.EMP_ID
INNER JOIN DEPARTMENTS AS T3
ON T1.DEPT_ID = T3.DEPT_ID;


-- QUESTION 2 
/*
    List all projects started after March 1, 2023, along with project name, employee name, department, 
    and budget (only for Bangalore-based departments).
*/
SELECT
    T1.PROJ_NAME AS PROJ_NAME, 
    T2.EMP_NAME AS EMPLOYEE_NAME, 
    T1.START_DATE AS PROJECT_START_DATE, 
    T3.DEPT_NAME AS DEPARTMENT_NAME, 
    T3.LOCATION AS LOCATION
FROM PROJECTS AS T1
INNER JOIN EMPLOYEES AS T2
ON T1.EMP_ID = T2.EMP_ID
INNER JOIN DEPARTMENTS AS T3
ON T2.DEPT_ID = T3.DEPT_ID
WHERE 
    T1.START_DATE > '2023-03-01'
    AND 
    T3.LOCATION = 'Bangalore';




-- Changing the dataset 
CREATE OR REPLACE TABLE Weather (
    id INT PRIMARY KEY,
    record_date DATE,
    temperature INT
);

INSERT INTO Weather (id, record_date, temperature) VALUES
(1, '2023-03-01', 20),
(2, '2023-03-02', 25),
(3, '2023-03-03', 22),
(4, '2023-03-04', 26),
(5, '2023-03-05', 24);

SELECT *
FROM WEATHER;

-- Question 
/*
    We need to get all the dates where the temperature was higher than the previous recorded date.
    Return the result in the ascending order of the record date
*/
SELECT
    -- CURRENT_DAY.ID AS CURRENT_DAY_ID, 
    CURRENT_DAY.RECORD_DATE AS CURRENT_DATE, 
    -- CURRENT_DAY.TEMPERATURE AS CURRENT_TEMPERATURE,

    -- PREVIOUS_DAY.ID AS PREVIOUS_DAY_ID, 
    -- PREVIOUS_DAY.RECORD_DATE AS PREVIOUS_DATE, 
    -- PREVIOUS_DAY.TEMPERATURE AS PREVIOUS_TEMPERATURE
FROM WEATHER AS CURRENT_DAY
FULL JOIN WEATHER AS PREVIOUS_DAY
WHERE 
    DATEDIFF(DAY, PREVIOUS_DAY.RECORD_DATE, CURRENT_DAY.RECORD_DATE) = 1
    AND 
    CURRENT_DAY.TEMPERATURE > PREVIOUS_DAY.TEMPERATURE;




