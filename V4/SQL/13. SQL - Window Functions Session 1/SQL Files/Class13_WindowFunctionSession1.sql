-- Aggregation functions 
/*
    Functions 
    1. SUM()
    2. COUNT()
    3. MIN()
    4. MAX()
    5. AVG()

    1. GROUP BY CLAUSE
    2. HAVING CLAUSE
    3. OVER()
    4. PARTITION BY 
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

-- CREATING A TABLE FOR THE SESSION
CREATE TABLE IF NOT EXISTS SALES (
    TRANSACTION_ID INT PRIMARY KEY,
    CATEGORY VARCHAR(50),
    SUBCATEGORY VARCHAR(50),
    TRANSACTION_DATE DATE,
    DELIVERY_DATE DATE,
    QUANTITY INT,
    UNIT_PRICE DECIMAL(10, 2),
    TOTAL_SALE DECIMAL(15, 2)
);


-- INSERTING VALUES INTO THE SALES_TRANSACTION TABLE 
INSERT INTO SALES (TRANSACTION_ID, CATEGORY, SUBCATEGORY, TRANSACTION_DATE, DELIVERY_DATE, QUANTITY, UNIT_PRICE, TOTAL_SALE)
VALUES
(1, 'Electronics', 'Mobile', '2025-01-01', '2025-01-05', 2, 400.00, 800.00),
(2, 'Electronics', 'Laptop', '2025-01-03', '2025-01-10', 1, 1200.00, 1200.00),
(3, 'Home Appliances', 'Refrigerator', '2025-01-05', '2025-01-12', 1, 1500.00, 1500.00),
(4, 'Home Appliances', 'Washing Machine', '2025-01-07', '2025-01-15', 1, 800.00, 800.00),
(5, 'Furniture', 'Sofa', '2025-01-09', '2025-01-18', 1, 2000.00, 2000.00),
(6, 'Furniture', 'Dining Table', '2025-01-11', '2025-01-20', 1, 1500.00, 1500.00),
(7, 'Electronics', 'Mobile', '2025-01-13', '2025-01-20', 3, 350.00, 1050.00),
(8, 'Home Appliances', 'Microwave', '2025-01-15', '2025-01-22', 2, 250.00, 500.00),
(9, 'Furniture', 'Chair', '2025-01-17', '2025-01-24', 4, 150.00, 600.00),
(10, 'Electronics', 'Tablet', '2025-01-19', '2025-01-27', 2, 300.00, 600.00),
(11, 'Electronics', 'Headphones', '2025-01-21', '2025-01-28', 5, 100.00, 500.00),
(12, 'Electronics', 'Smartwatch', '2025-01-22', '2025-01-29', 2, 150.00, 300.00),
(13, 'Home Appliances', 'Air Conditioner', '2025-01-23', '2025-01-30', 1, 1200.00, 1200.00),
(14, 'Home Appliances', 'Vacuum Cleaner', '2025-01-24', '2025-01-31', 2, 300.00, 600.00),
(15, 'Furniture', 'Bookshelf', '2025-01-25', '2025-02-01', 1, 700.00, 700.00),
(16, 'Furniture', 'Bed', '2025-01-26', '2025-02-03', 1, 2500.00, 2500.00),
(17, 'Electronics', 'Mobile', '2025-01-27', '2025-02-04', 4, 380.00, 1520.00),
(18, 'Home Appliances', 'Refrigerator', '2025-01-28', '2025-02-05', 1, 1400.00, 1400.00),
(19, 'Furniture', 'Wardrobe', '2025-01-29', '2025-02-06', 1, 1800.00, 1800.00),
(20, 'Electronics', 'Smart TV', '2025-01-30', '2025-02-07', 1, 900.00, 900.00),
(21, 'Electronics', 'Mobile', '2025-01-31', '2025-02-08', 3, 400.00, 1200.00),
(22, 'Furniture', 'Couch', '2025-02-01', '2025-02-09', 2, 2200.00, 4400.00),
(23, 'Home Appliances', 'Washing Machine', '2025-02-02', '2025-02-10', 1, 850.00, 850.00),
(24, 'Home Appliances', 'Dishwasher', '2025-02-03', '2025-02-11', 1, 950.00, 950.00),
(25, 'Electronics', 'Camera', '2025-02-04', '2025-02-12', 1, 650.00, 650.00);


-- Dataset
SELECT *
FROM SALES;


-- Question 1 
/*
    We need to find the total quantity sold for each category
*/
SELECT
    CATEGORY,
    SUM(QUANTITY) AS TOTAL_QTY_SOLD
FROM SALES
GROUP BY CATEGORY;

-- WINDOW FUNCTIONS
-- OVER() CLAUSE WITH PARTITION BY

-- Question 2 
/*
    Write a SQL Query to display the following, 
    1. Transaction ID
    2. Category
    3. Total Sale
    4. Total Sale for that category
    Order the solution by category asc
*/
-- Solution 
SELECT
    CATEGORY, 
    TOTAL_SALE, 
    SUM(TOTAL_SALE) OVER(PARTITION BY CATEGORY) AS TOTAL_CATEGORY_REVENUE
FROM SALES
ORDER BY CATEGORY ASC, TOTAL_SALE ASC;


-- Question 2
/*
    Write a sql query to return all the transactions as well as their total quantity sold for that subcategory only
*/

SELECT 
    TRANSACTION_ID,
    SUBCATEGORY, 
    QUANTITY,
    SUM(QUANTITY) OVER(PARTITION BY SUBCATEGORY) AS TOTAL_QTY_SUBC
FROM SALES
ORDER BY SUBCATEGORY ASC;




-- Changing the dataset 
-- Creating a table named as currentSales
CREATE TABLE IF NOT EXISTS currentSales(
	sales_id INT PRIMARY KEY, 
    sales_person_name VARCHAR(250) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    quantity_sold INT NOT NULL, 
    amount decimal(10,2) NOT NULL
);

-- Inserting values into the table
INSERT INTO currentSales (sales_id, sales_person_name, product_name, location, quantity_sold, amount) VALUES
(1, 'Rajesh Sharma', 'Vadapav', 'Maharashtra', 30, 1500.00),
(2, 'Anjali Mehta', 'Vadapav', 'Gujarat', 25, 1250.00),
(3, 'Suresh Patil', 'Vadapav', 'Madhya Pradesh', 40, 2000.00),
(4, 'Priya Kumar', 'Vadapav', 'Rajasthan', 20, 1000.00),
(5, 'Manoj Gupta', 'Vadapav', 'Karnataka', 35, 1750.00),
(6, 'Rohit Singh', 'Vadapav', 'Uttar Pradesh', 50, 2500.00),
(7, 'Sunita Yadav', 'Vadapav', 'Punjab', 45, 2250.00),
(8, 'Vijay Deshmukh', 'Vadapav', 'Maharashtra', 60, 3000.00),
(9, 'Neha Verma', 'Vadapav', 'Tamil Nadu', 55, 2750.00),
(10, 'Karan Patel', 'Vadapav', 'Gujarat', 70, 3500.00),
(11, 'Arjun Reddy', 'Vadapav', 'Andhra Pradesh', 80, 4000.00),
(12, 'Nikita Jain', 'Vadapav', 'Delhi', 65, 3250.00),
(13, 'Vikas Malhotra', 'Vadapav', 'Haryana', 30, 1500.00),
(14, 'Shruti Rao', 'Vadapav', 'Telangana', 40, 2000.00),
(15, 'Akash Pandey', 'Vadapav', 'Uttar Pradesh', 45, 2250.00),
(16, 'Meera Shah', 'Vadapav', 'Maharashtra', 50, 2500.00),
(17, 'Ravi Sinha', 'Vadapav', 'Bihar', 35, 1750.00),
(18, 'Divya Kapoor', 'Vadapav', 'Punjab', 25, 1250.00),
(19, 'Amit Khanna', 'Vadapav', 'West Bengal', 60, 3000.00),
(20, 'Simran Kaur', 'Vadapav', 'Himachal Pradesh', 55, 2750.00),
(21, 'Deepak Bhatt', 'Vadapav', 'Uttarakhand', 20, 1000.00),
(22, 'Ayesha Khan', 'Vadapav', 'Maharashtra', 70, 3500.00),
(23, 'Pankaj Mishra', 'Vadapav', 'Odisha', 80, 4000.00),
(24, 'Ritika Joshi', 'Vadapav', 'Kerala', 65, 3250.00),
(25, 'Shivani Desai', 'Vadapav', 'Goa', 30, 1500.00),
(26, 'Abhinav Choudhary', 'Vadapav', 'Rajasthan', 40, 2000.00),
(27, 'Harsh Agarwal', 'Vadapav', 'Madhya Pradesh', 45, 2250.00),
(28, 'Tanya Srivastava', 'Vadapav', 'Uttar Pradesh', 50, 2500.00),
(29, 'Ramesh Joshi', 'Vadapav', 'Haryana', 35, 1750.00),
(30, 'Sneha Saxena', 'Vadapav', 'Karnataka', 25, 1250.00),
(31, 'Gaurav Nair', 'Vadapav', 'Tamil Nadu', 60, 3000.00),
(32, 'Anita Bhatia', 'Vadapav', 'Gujarat', 55, 2750.00),
(33, 'Puja Chatterjee', 'Vadapav', 'West Bengal', 70, 3500.00),
(34, 'Rahul Tripathi', 'Vadapav', 'Delhi', 80, 4000.00),
(35, 'Kavita Reddy', 'Vadapav', 'Andhra Pradesh', 65, 3250.00),
(36, 'Sanjay Iyer', 'Vadapav', 'Kerala', 30, 1500.00),
(37, 'Vidya Pillai', 'Vadapav', 'Karnataka', 40, 2000.00),
(38, 'Dinesh Chauhan', 'Vadapav', 'Punjab', 45, 2250.00),
(39, 'Rajiv Kapoor', 'Vadapav', 'Himachal Pradesh', 50, 2500.00),
(40, 'Mona Sharma', 'Vadapav', 'Uttarakhand', 35, 1750.00),
(41, 'Rahul Yadav', 'Vadapav', 'Bihar', 25, 1250.00),
(42, 'Ishita Gupta', 'Vadapav', 'Madhya Pradesh', 60, 3000.00),
(43, 'Nitin Shukla', 'Vadapav', 'Maharashtra', 55, 2750.00),
(44, 'Veena Singh', 'Vadapav', 'Rajasthan', 70, 3500.00),
(45, 'Ashok Nair', 'Vadapav', 'Tamil Nadu', 80, 4000.00),
(46, 'Rohini Kulkarni', 'Vadapav', 'Karnataka', 65, 3250.00),
(47, 'Shubham Rao', 'Vadapav', 'Telangana', 30, 1500.00),
(48, 'Nisha Patil', 'Vadapav', 'Maharashtra', 40, 2000.00),
(49, 'Keshav Sinha', 'Vadapav', 'Uttar Pradesh', 45, 2250.00),
(50, 'Payal Chauhan', 'Vadapav', 'Haryana', 50, 2500.00),
(51, 'Vikram Sharma', 'Samosa', 'Maharashtra', 30, 600.00),
(52, 'Pooja Mehta', 'Samosa', 'Gujarat', 25, 500.00),
(53, 'Sanjay Patil', 'Samosa', 'Madhya Pradesh', 40, 800.00),
(54, 'Deepika Kumar', 'Samosa', 'Rajasthan', 20, 400.00),
(55, 'Ankit Gupta', 'Samosa', 'Karnataka', 35, 700.00),
(56, 'Vivek Singh', 'Samosa', 'Uttar Pradesh', 50, 1000.00),
(57, 'Nidhi Yadav', 'Samosa', 'Punjab', 45, 900.00),
(58, 'Rakesh Deshmukh', 'Samosa', 'Maharashtra', 60, 1200.00),
(59, 'Seema Verma', 'Samosa', 'Tamil Nadu', 55, 1100.00),
(60, 'Abhay Patel', 'Samosa', 'Gujarat', 70, 1400.00),
(61, 'Vishal Reddy', 'Samosa', 'Andhra Pradesh', 80, 1600.00),
(62, 'Priyanka Jain', 'Samosa', 'Delhi', 65, 1300.00),
(63, 'Rahul Malhotra', 'Samosa', 'Haryana', 30, 600.00),
(64, 'Kriti Rao', 'Samosa', 'Telangana', 40, 800.00),
(65, 'Vishnu Pandey', 'Samosa', 'Uttar Pradesh', 45, 900.00),
(66, 'Radhika Shah', 'Samosa', 'Maharashtra', 50, 1000.00),
(67, 'Manish Sinha', 'Samosa', 'Bihar', 35, 700.00),
(68, 'Juhi Kapoor', 'Samosa', 'Punjab', 25, 500.00),
(69, 'Ashish Khanna', 'Samosa', 'West Bengal', 60, 1200.00),
(70, 'Ritu Kaur', 'Samosa', 'Himachal Pradesh', 55, 1100.00),
(71, 'Deepak Bhatt', 'Samosa', 'Uttarakhand', 20, 400.00),
(72, 'Alok Khan', 'Samosa', 'Maharashtra', 70, 1400.00),
(73, 'Harshit Mishra', 'Samosa', 'Odisha', 80, 1600.00),
(74, 'Lavanya Joshi', 'Samosa', 'Kerala', 65, 1300.00),
(75, 'Nikhil Desai', 'Samosa', 'Goa', 30, 600.00),
(76, 'Ishaan Choudhary', 'Samosa', 'Rajasthan', 40, 800.00),
(77, 'Prateek Agarwal', 'Samosa', 'Madhya Pradesh', 45, 900.00),
(78, 'Sneha Srivastava', 'Samosa', 'Uttar Pradesh', 50, 1000.00),
(79, 'Sumit Joshi', 'Samosa', 'Haryana', 35, 700.00),
(80, 'Megha Saxena', 'Samosa', 'Karnataka', 25, 500.00),
(81, 'Kunal Nair', 'Samosa', 'Tamil Nadu', 60, 1200.00),
(82, 'Tanvi Bhatia', 'Samosa', 'Gujarat', 55, 1100.00),
(83, 'Shalini Chatterjee', 'Samosa', 'West Bengal', 70, 1400.00),
(84, 'Naveen Tripathi', 'Samosa', 'Delhi', 80, 1600.00),
(85, 'Anusha Reddy', 'Samosa', 'Andhra Pradesh', 65, 1300.00),
(86, 'Ganesh Iyer', 'Samosa', 'Kerala', 30, 600.00),
(87, 'Swati Pillai', 'Samosa', 'Karnataka', 40, 800.00),
(88, 'Mohan Chauhan', 'Samosa', 'Punjab', 45, 900.00),
(89, 'Rohit Kapoor', 'Samosa', 'Himachal Pradesh', 50, 1200.00),
(90, 'Shalini Sharma', 'Samosa', 'Uttarakhand', 35, 701.00),
(91, 'Amit Yadav', 'Samosa', 'Bihar', 25, 502.00),
(92, 'Priya Gupta', 'Samosa', 'Madhya Pradesh', 60, 1210.00),
(93, 'Rajat Shukla', 'Samosa', 'Maharashtra', 55, 1110.00),
(94, 'Nikita Singh', 'Samosa', 'Rajasthan', 70, 1420.00),
(95, 'Siddharth Nair', 'Samosa', 'Tamil Nadu', 80, 1633.00),
(96, 'Pallavi Kulkarni', 'Samosa', 'Karnataka', 65, 1333.00),
(97, 'Varun Rao', 'Samosa', 'Telangana', 30, 601.00),
(98, 'Sneha Patil', 'Samosa', 'Maharashtra', 40, 807.00),
(99, 'Raj Sinha', 'Samosa', 'Uttar Pradesh', 45, 902.00),
(100, 'Komal Chauhan', 'Samosa', 'Haryana', 50, 1003.00),
(101, 'Rakesh Sharma', 'Dosa', 'Maharashtra', 20, 402.10),
(102, 'Aarti Mehta', 'Pani Puri', 'Gujarat', 35, 525.00),
(103, 'Siddharth Patil', 'Jalebi', 'Madhya Pradesh', 40, 803.00),
(104, 'Priya Kumar', 'Dosa', 'Rajasthan', 25, 509.00),
(105, 'Rohit Gupta', 'Pani Puri', 'Karnataka', 50, 70.00),
(106, 'Vikram Singh', 'Jalebi', 'Uttar Pradesh', 30, 610.00),
(107, 'Sunil Yadav', 'Dosa', 'Punjab', 60, 12.00),
(108, 'Nitin Deshmukh', 'Pani Puri', 'Maharashtra', 45, 6.00),
(109, 'Seema Verma', 'Jalebi', 'Tamil Nadu', 55, 1.00),
(110, 'Ankit Patel', 'Dosa', 'Gujarat', 70, 14.00),
(111, 'Praveen Reddy', 'Pani Puri', 'Andhra Pradesh', 80, 1.00),
(112, 'Nikita Jain', 'Jalebi', 'Delhi', 65, 130.00),
(113, 'Rakesh Malhotra', 'Dosa', 'Haryana', 30, 60.00),
(114, 'Pooja Rao', 'Pani Puri', 'Telangana', 40, 70.00),
(115, 'Ravi Pandey', 'Jalebi', 'Uttar Pradesh', 45, 91.00),
(116, 'Nidhi Shah', 'Dosa', 'Maharashtra', 50, 1001.00),
(117, 'Raj Sinha', 'Pani Puri', 'Bihar', 35, 525.00),
(118, 'Anjali Kapoor', 'Jalebi', 'Punjab', 25, 500.00),
(119, 'Amit Khanna', 'Dosa', 'West Bengal', 60, 1200.00),
(120, 'Ritu Kaur', 'Pani Puri', 'Himachal Pradesh', 55, 825.00),
(121, 'Deepak Bhatt', 'Jalebi', 'Uttarakhand', 20, 400.00),
(122, 'Ajay Khan', 'Dosa', 'Maharashtra', 70, 1400.00),
(123, 'Pankaj Mishra', 'Pani Puri', 'Odisha', 80, 1200.00),
(124, 'Lavanya Joshi', 'Jalebi', 'Kerala', 65, 1300.00),
(125, 'Ishaan Desai', 'Dosa', 'Goa', 30, 600.00),
(126, 'Ankit Choudhary', 'Pani Puri', 'Rajasthan', 40, 600.00),
(127, 'Ravi Agarwal', 'Jalebi', 'Madhya Pradesh', 45, 900.00),
(128, 'Sonal Srivastava', 'Dosa', 'Uttar Pradesh', 50, 1000.00),
(129, 'Sumit Joshi', 'Pani Puri', 'Haryana', 35, 525.00),
(130, 'Megha Saxena', 'Jalebi', 'Karnataka', 25, 500.00),
(131, 'Gaurav Nair', 'Dosa', 'Tamil Nadu', 60, 1200.00),
(132, 'Anita Bhatia', 'Pani Puri', 'Gujarat', 55, 825.00),
(133, 'Puja Chatterjee', 'Jalebi', 'West Bengal', 70, 1400.00),
(134, 'Rohit Tripathi', 'Dosa', 'Delhi', 80, 1600.00),
(135, 'Kavita Reddy', 'Pani Puri', 'Andhra Pradesh', 65, 975.00),
(136, 'Ganesh Iyer', 'Jalebi', 'Kerala', 30, 600.00),
(137, 'Vidya Pillai', 'Dosa', 'Karnataka', 40, 800.00),
(138, 'Dinesh Chauhan', 'Pani Puri', 'Punjab', 45, 675.00),
(139, 'Rajiv Kapoor', 'Jalebi', 'Himachal Pradesh', 50, 1000.00),
(140, 'Mona Sharma', 'Dosa', 'Uttarakhand', 35, 700.00),
(141, 'Rahul Yadav', 'Pani Puri', 'Bihar', 25, 375.00),
(142, 'Priya Gupta', 'Jalebi', 'Madhya Pradesh', 60, 1200.00),
(143, 'Rajat Shukla', 'Dosa', 'Maharashtra', 55, 1100.00),
(144, 'Nikita Singh', 'Pani Puri', 'Rajasthan', 70, 1050.00),
(145, 'Siddharth Nair', 'Jalebi', 'Tamil Nadu', 80, 1600.00),
(146, 'Pallavi Kulkarni', 'Dosa', 'Karnataka', 65, 1300.00),
(147, 'Varun Rao', 'Pani Puri', 'Telangana', 30, 450.00),
(148, 'Sneha Patil', 'Jalebi', 'Maharashtra', 40, 800.00),
(149, 'Keshav Sinha', 'Dosa', 'Uttar Pradesh', 45, 900.00),
(150, 'Komal Chauhan', 'Pani Puri', 'Haryana', 50, 750.00),
(151, 'Sumit Joshi', 'Pani Puri', 'Haryana', 35, 5233.00),
(152, 'Megha Saxena', 'Jalebi', 'Karnataka', 25, 521.00),
(153, 'Gaurav Nair', 'Dosa', 'Tamil Nadu', 60, 123.00),
(154, 'Anita Bhatia', 'Pani Puri', 'Gujarat', 55, 823.00),
(155, 'Puja Chatterjee', 'Jalebi', 'West Bengal', 70, 142.00),
(156, 'Rohit Tripathi', 'Dosa', 'Delhi', 80, 164.00),
(157, 'Kavita Reddy', 'Pani Puri', 'Andhra Pradesh', 65, 1745.00),
(158, 'Ganesh Iyer', 'Jalebi', 'Kerala', 30, 1223.00),
(159, 'Vidya Pillai', 'Dosa', 'Karnataka', 40, 81.00),
(160, 'Dinesh Chauhan', 'Pani Puri', 'Punjab', 45, 67.00),
(161, 'Rajiv Kapoor', 'Jalebi', 'Himachal Pradesh', 50, 10.00),
(162, 'Mona Sharma', 'Dosa', 'Uttarakhand', 35, 99.00),
(163, 'Rahul Yadav', 'Pani Puri', 'Bihar', 25, 382.00),
(164, 'Priya Gupta', 'Jalebi', 'Madhya Pradesh', 60, 140.00),
(165, 'Rajat Shukla', 'Dosa', 'Maharashtra', 55, 123.00),
(166, 'Nikita Singh', 'Pani Puri', 'Rajasthan', 70, 11.00),
(167, 'Siddharth Nair', 'Jalebi', 'Tamil Nadu', 80, 1610.00),
(168, 'Pallavi Kulkarni', 'Dosa', 'Karnataka', 65, 1320.00),
(169, 'Varun Rao', 'Pani Puri', 'Telangana', 30, 400.00),
(170, 'Sneha Patil', 'Jalebi', 'Maharashtra', 40, 81.00),
(171, 'Keshav Sinha', 'Dosa', 'Uttar Pradesh', 45, 91.00),
(172, 'Komal Chauhan', 'Pani Puri', 'Haryana', 50, 75.00),
(173, 'Karan Shah', 'Jalebi', 'Madhya Pradesh', 60, 140.00),
(174, 'Karan Shah', 'Dosa', 'Maharashtra', 55, 123.00),
(175, 'Karan Shah', 'Pani Puri', 'Rajasthan', 70, 11.00),
(176, 'Karan Shah', 'Jalebi', 'Tamil Nadu', 80, 1610.00),
(177, 'Karan Shah', 'Dosa', 'Karnataka', 65, 1320.00),
(178, 'Karan Shah', 'Pani Puri', 'Telangana', 30, 400.00),
(179, 'Karan Shah', 'Jalebi', 'Maharashtra', 40, 81.00),
(180, 'Varun Rao', 'Dosa', 'Uttar Pradesh', 45, 91.00),
(181, 'Varun Rao', 'Pani Puri', 'Haryana', 50, 75.00),
(182, 'Rajesh Sharma', 'Jalebi', 'Madhya Pradesh', 60, 140.00),
(183, 'Rajesh Sharma', 'Dosa', 'Maharashtra', 55, 123.00),
(184, 'Rajesh Sharma', 'Pani Puri', 'Rajasthan', 70, 11.00),
(185, 'Varun Rao', 'Jalebi', 'Tamil Nadu', 80, 1610.00),
(186, 'Sneha Patil', 'Dosa', 'Karnataka', 65, 1320.00),
(187, 'Sneha Patil', 'Pani Puri', 'Telangana', 30, 400.00),
(188, 'Raj Sinha', 'Jalebi', 'Maharashtra', 40, 81.00),
(189, 'Komal Chauhan', 'Dosa', 'Uttar Pradesh', 45, 91.00),
(190, 'Varun Rao', 'Pani Puri', 'Haryana', 50, 75.00);

SELECT *
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah';

-- Question 3
/*
    Write a sql query that returns the total quantity sold for each sales person within their products sold
    along with the sales transaction done
*/
SELECT 
    SALES_PERSON_NAME, 
    PRODUCT_NAME,
    QUANTITY_SOLD, 
    SUM(QUANTITY_SOLD) OVER(PARTITION BY SALES_PERSON_NAME, PRODUCT_NAME) AS QUANTITY_SOLD_PER_PERSON
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah'
ORDER BY SALES_PERSON_NAME ASC, PRODUCT_NAME ASC;


SELECT
    SALES_PERSON_NAME, 
    PRODUCT_NAME,  
    SUM(QUANTITY_SOLD) AS TOTAL_QTY
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah'
GROUP BY SALES_PERSON_NAME, PRODUCT_NAME
ORDER BY SALES_PERSON_NAME ASC, PRODUCT_NAME ASC;


-- Question 4
/*
    Show each salesperson's quantity sold, and the minimum and maximum quantity sold based on the locations
    Order by Salesperson asc, Location asc
*/
/*
    FUNCTION_NAME() OVER(PARTITION BY <COLUMN*>)
*/
SELECT
    SALES_PERSON_NAME, 
    LOCATION,
    MIN(QUANTITY_SOLD) OVER(PARTITION BY SALES_PERSON_NAME) AS MIN_QTY_SOLD,
    QUANTITY_SOLD, 
    MAX(QUANTITY_SOLD) OVER(PARTITION BY SALES_PERSON_NAME) AS MAX_QTY_SOLD
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah'
ORDER BY SALES_PERSON_NAME ASC, LOCATION ASC;

SELECT
    SALES_PERSON_NAME,
    LOCATION,
    MIN(QUANTITY_SOLD) OVER (PARTITION BY LOCATION) as MIN_QT,
    QUANTITY_SOLD,
    MAX(QUANTITY_SOLD) OVER (PARTITION BY LOCATION) as MAX_QT
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah'
ORDER BY SALES_PERSON_NAME ASC, LOCATION ASC;

SELECT
    LOCATION,
    MIN(QUANTITY_SOLD) AS MIN_QTY, 
    MAX(QUANTITY_SOLD) AS MAX_QTY
FROM CURRENTSALES
GROUP BY LOCATION;


-- Question 5
/*
    We need to display the sales id, sales person name, product name, quantity sold, total quantity sold. 
    Note that we need to display the running total of the quantity sold
*/
SELECT
    SALES_ID, 
    SALES_PERSON_NAME, 
    PRODUCT_NAME, 
    QUANTITY_SOLD, 
    -- Aggregation / Ranking
    SUM(QUANTITY_SOLD) OVER(PARTITION BY SALES_PERSON_NAME, PRODUCT_NAME ORDER BY QUANTITY_SOLD DESC) AS TOTAL_QTY
FROM CURRENTSALES
WHERE SALES_PERSON_NAME = 'Karan Shah'
ORDER BY SALES_PERSON_NAME ASC, PRODUCT_NAME desc, TOTAL_QTY asc; -- result will be ordered 