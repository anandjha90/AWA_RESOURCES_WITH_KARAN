-- USE ROLE 
USE ROLE ACCOUNTADMIN;

-- USE WAREHOUSE 
USE WAREHOUSE COMPUTE_WH;

-- CREATING A DATABASE 
CREATE DATABASE IF NOT EXISTS PRACTICESESSION2__DB;

-- USE DATABASE 
USE DATABASE PRACTICESESSION2__DB;

-- CREATE SCHEMA FOR THE TODAYS CLASS
CREATE SCHEMA IF NOT EXISTS PRACTICESESSION2__SCHEMA;

-- USE SCHEMA 
USE SCHEMA PRACTICESESSION2__SCHEMA;


-- Table definitions
CREATE OR REPLACE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    signup_date DATE,
    is_active BOOLEAN
);

CREATE OR REPLACE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100),
    description VARCHAR(255),
    parent_category_id INT
);

CREATE OR REPLACE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    category_id INT,
    price NUMBER(10,2),
    stock INT,
    created_date DATE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE OR REPLACE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    manager_id INT,
    department VARCHAR(50),
    salary NUMBER(12,2),
    hire_date DATE,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

CREATE OR REPLACE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    sales_rep_id INT,
    order_date TIMESTAMP_NTZ,
    status VARCHAR(50),
    total_amount NUMBER(12,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep_id) REFERENCES employees(employee_id)
);

CREATE OR REPLACE TABLE order_items (
    order_id INT,
    order_item_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMBER(10,2),
    PRIMARY KEY(order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE OR REPLACE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date TIMESTAMP_NTZ,
    payment_method VARCHAR(50),
    amount NUMBER(12,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


-- Inserting Records into the table 
-- Customers (some emails are NULL to test NULL handling)
INSERT INTO customers (customer_id, first_name, last_name, email, city, state, country, signup_date, is_active) VALUES
    (1, 'John', 'Smith', 'john.smith@example.com', 'New York', 'NY', 'USA', '2024-11-30', TRUE),
    (2, 'Jane', 'Doe', NULL, 'Los Angeles', 'CA', 'USA', '2025-01-15', TRUE),
    (3, 'Alice', 'Wong', 'alice.wong@example.com', 'Seattle', 'WA', 'USA', '2025-06-10', FALSE),
    (4, 'Bob', 'Lee', 'bob.lee@example.com', 'Austin', 'TX', 'USA', '2025-03-22', TRUE),
    (5, 'Carlos', 'Garcia', 'carlos.garcia@example.com', 'Madrid', 'Madrid', 'Spain', '2024-08-05', TRUE),
    (6, 'Chen', 'Li', 'chen.li@example.com', 'Beijing', 'Beijing', 'China', '2025-02-14', TRUE),
    (7, 'Sara', 'Khan', 'sara.khan@example.com', 'Mumbai', 'MH', 'India', '2025-04-01', FALSE),
    (8, 'Daniel', 'Silva', NULL, 'São Paulo', 'SP', 'Brazil', '2025-07-25', TRUE),
    (9, 'Emma', 'Brown', 'emma.brown@example.com', 'London', 'London', 'UK', '2024-10-20', TRUE),
    (10, 'Liam', 'Johnson', 'liam.johnson@example.com', 'Toronto', 'ON', 'Canada', '2025-03-05', TRUE),
    (11, 'Olivia', 'Martinez', 'olivia.martinez@example.com', 'Chicago', 'IL', 'USA', '2025-05-12', TRUE),
    (12, 'Noah', 'Anderson', NULL, 'Houston', 'TX', 'USA', '2024-12-01', TRUE),
    (13, 'Isabella', 'Thomas', 'isabella.thomas@example.com', 'Phoenix', 'AZ', 'USA', '2025-08-18', TRUE),
    (14, 'James', 'Taylor', 'james.taylor@example.com', 'Dallas', 'TX', 'USA', '2025-02-11', FALSE),
    (15, 'Mia', 'Moore', NULL, 'San Diego', 'CA', 'USA', '2025-07-01', TRUE),
    (16, 'Lucas', 'Martin', 'lucas.martin@example.com', 'Paris', 'Ile-de-France', 'France', '2024-09-15', TRUE),
    (17, 'Amelia', 'Jackson', 'amelia.jackson@example.com', 'Berlin', 'Berlin', 'Germany', '2025-04-21', TRUE),
    (18, 'Ethan', 'White', NULL, 'Rome', 'Lazio', 'Italy', '2025-06-30', FALSE),
    (19, 'Harper', 'Harris', 'harper.harris@example.com', 'Barcelona', 'Catalonia', 'Spain', '2024-11-11', TRUE),
    (20, 'Benjamin', 'Clark', 'ben.clark@example.com', 'Lisbon', 'Lisbon', 'Portugal', '2025-03-19', TRUE),
    (21, 'Charlotte', 'Lewis', 'charlotte.lewis@example.com', 'Sydney', 'NSW', 'Australia', '2025-01-09', TRUE),
    (22, 'Henry', 'Walker', NULL, 'Melbourne', 'VIC', 'Australia', '2025-09-01', TRUE),
    (23, 'Evelyn', 'Hall', 'evelyn.hall@example.com', 'Auckland', 'Auckland', 'New Zealand', '2024-10-10', TRUE),
    (24, 'Alexander', 'Allen', 'alex.allen@example.com', 'Cape Town', 'Western Cape', 'South Africa', '2025-02-25', FALSE),
    (25, 'Sofia', 'Young', NULL, 'Dubai', 'Dubai', 'UAE', '2025-05-05', TRUE),
    (26, 'Daniel', 'King', 'daniel.king@example.com', 'Singapore', 'Central', 'Singapore', '2024-07-14', TRUE),
    (27, 'Aria', 'Wright', 'aria.wright@example.com', 'Tokyo', 'Tokyo', 'Japan', '2025-03-30', TRUE),
    (28, 'Matthew', 'Scott', NULL, 'Seoul', 'Seoul', 'South Korea', '2025-08-02', TRUE),
    (29, 'Scarlett', 'Green', 'scarlett.green@example.com', 'Bangkok', 'Bangkok', 'Thailand', '2024-12-22', TRUE),
    (30, 'David', 'Adams', 'david.adams@example.com', 'Kuala Lumpur', 'Kuala Lumpur', 'Malaysia', '2025-01-18', FALSE),
    (31, 'Ella', 'Baker', NULL, 'Mumbai', 'MH', 'India', '2025-07-10', TRUE),
    (32, 'Joseph', 'Gonzalez', 'joseph.gonzalez@example.com', 'Delhi', 'DL', 'India', '2025-06-12', TRUE),
    (33, 'Grace', 'Nelson', 'grace.nelson@example.com', 'Bangalore', 'KA', 'India', '2024-11-02', TRUE),
    (34, 'Samuel', 'Carter', NULL, 'Hyderabad', 'TS', 'India', '2025-04-14', FALSE),
    (35, 'Chloe', 'Mitchell', 'chloe.mitchell@example.com', 'Chennai', 'TN', 'India', '2025-02-28', TRUE),
    (36, 'Logan', 'Perez', 'logan.perez@example.com', 'Toronto', 'ON', 'Canada', '2024-09-19', TRUE),
    (37, 'Victoria', 'Roberts', NULL, 'Vancouver', 'BC', 'Canada', '2025-03-03', TRUE),
    (38, 'Jack', 'Turner', 'jack.turner@example.com', 'Montreal', 'QC', 'Canada', '2025-05-16', TRUE),
    (39, 'Lily', 'Phillips', 'lily.phillips@example.com', 'Dublin', 'Leinster', 'Ireland', '2025-01-27', FALSE),
    (40, 'Sebastian', 'Campbell', NULL, 'Edinburgh', 'Scotland', 'UK', '2024-10-05', TRUE);

-- Categories (self-join hierarchy: e.g., "Computers" under "Electronics")
INSERT INTO categories (category_id, category_name, description, parent_category_id) VALUES
    (1, 'Electronics', 'Electronic devices and gadgets', NULL),
    (2, 'Computers', 'Computing devices', 1),
    (3, 'Laptops', 'Portable computers', 2),
    (4, 'Desktops', 'Desktop computers', 2),
    (5, 'Mobiles', 'Smartphones and mobile devices', 1),
    (6, 'Accessories', 'Electronic accessories', 1),
    (7, 'Home', 'Home and kitchen appliances', NULL),
    (8, 'Furniture', 'Home and office furniture', 7),
    (9, 'Garden', 'Garden tools and plants', 7),
    (10, 'Fashion', 'Clothing and accessories', NULL);

-- Products (100 products with varied prices and stock levels)
INSERT INTO products (product_id, product_name, category_id, price, stock, created_date) VALUES
    (1, 'QuantumPhone X', 5, 799.99, 25, '2024-05-12'),
    (2, 'UltraLaptop Pro', 3, 1299.00, 15, '2024-07-23'),
    (3, 'OfficeDesk A1', 8, 249.50, 50, '2025-01-17'),
    (4, 'QuantumPhone Z', 5, 999.99, 18, '2025-02-11'),
    (5, 'SmartMax Lite', 5, 399.99, 60, '2024-09-05'),
    (6, 'NovaEdge 5G', 5, 699.50, 30, '2025-03-15'),
    (7, 'PixelCore Mini', 5, 299.99, 80, '2025-06-01'),
    (8, 'ZenBook Air', 3, 1099.00, 20, '2024-08-10'),
    (9, 'ProTech X15', 3, 1499.99, 10, '2025-01-22'),
    (10, 'LiteNote Student', 3, 549.99, 45, '2025-04-14'),
    (11, 'GamerStorm RTX', 3, 1899.99, 8, '2025-07-30'),
    (12, 'PowerDesk Elite', 4, 1199.99, 12, '2024-11-20'),
    (13, 'CompactCore i7', 4, 899.99, 25, '2025-02-18'),
    (14, 'OfficePro Tower', 4, 699.00, 35, '2025-05-12'),
    (15, 'Wireless Mouse Pro', 6, 49.99, 150, '2024-06-10'),
    (16, 'Mechanical Keyboard X', 6, 129.99, 75, '2025-01-05'),
    (17, 'USB-C Hub 8in1', 6, 79.99, 120, '2025-03-21'),
    (18, 'NoiseCancel Headphones', 6, 199.99, 40, '2025-06-18'),
    (19, 'Ergo Chair Deluxe', 8, 349.99, 22, '2024-12-01'),
    (20, 'Wooden Study Table', 8, 279.50, 30, '2025-04-09'),
    (21, 'Standing Desk Pro', 8, 499.99, 15, '2025-07-02'),
    (22, 'Garden Shovel Steel', 9, 29.99, 200, '2024-10-12'),
    (23, 'Water Hose 20m', 9, 39.99, 180, '2025-02-14'),
    (24, 'Electric Lawn Mower', 9, 249.99, 20, '2025-05-20'),
    (25, 'Air Purifier Max', 7, 299.99, 35, '2024-09-30'),
    (26, 'Microwave Oven X', 7, 199.99, 28, '2025-01-18'),
    (27, 'Smart Refrigerator 500L', 7, 899.99, 10, '2025-03-27'),
    (28, 'Men Leather Jacket', 10, 149.99, 55, '2024-11-15'),
    (29, 'Women Handbag Premium', 10, 199.50, 60, '2025-02-25'),
    (30, 'Running Shoes Pro', 10, 119.99, 100, '2025-06-10'),
    (31, 'Classic Wrist Watch', 10, 89.99, 75, '2025-07-19'),
    (32, 'Smart TV 55inch', 1, 799.00, 18, '2024-12-12'),
    (33, 'Bluetooth Speaker Max', 1, 129.99, 90, '2025-03-11'),
    (34, 'Home Theater System', 1, 499.99, 25, '2025-04-15'),
    (35, 'Mini PC Compact', 2, 599.99, 40, '2024-10-10'),
    (36, 'All-in-One PC 24"', 2, 999.99, 16, '2025-05-05'),
    (37, 'Basic Earphones', 6, 19.99, 250, '2025-06-01'),
    (38, 'Phone Case Silicone', 6, 9.99, 300, '2025-07-01'),
    (39, 'Notebook Diary', 10, 14.99, 200, '2024-08-08'),
    (40, 'LED Bulb 12W', 7, 7.99, 500, '2025-02-01'),
    (41, 'Garden Gloves', 9, 12.50, 180, '2025-03-03'),
    (42, 'Laptop Sleeve', 6, 24.99, 160, '2025-04-20'),
    (43, 'Desk Lamp Modern', 7, 34.99, 90, '2025-05-12');
  
-- Employees (sales reps with manager relationships, some NULL)
INSERT INTO employees (employee_id, first_name, last_name, manager_id, department, salary, hire_date) VALUES
    (1, 'Michael', 'Scott', NULL, 'Management', 150000.00, '2015-04-01'),
    (2, 'Dwight', 'Schrute', 1, 'Sales', 90000.00, '2016-01-15'),
    (3, 'Jim', 'Halpert', 1, 'Sales', 92000.00, '2016-02-15'),
    (4, 'Pam', 'Beesly', 2, 'HR', 80000.00, '2017-03-01'),
    (5, 'Angela', 'Martin', 2, 'HR', 78000.00, '2017-05-20'),
    (6, 'Stanley', 'Hudson', 3, 'Sales', 88000.00, '2018-06-10'),
    (7, 'Phyllis', 'Vance', 3, 'Support', 70000.00, '2018-08-25'),
    (8, 'Kevin', 'Malone', 3, 'Support', 71000.00, '2018-09-01'),
    (9, 'Oscar', 'Martinez', 1, 'Accounting', 95000.00, '2016-04-12'),
    (10, 'Meredith', 'Palmer', 1, 'IT', 68000.00, '2016-05-30'),
    (11, 'Robert', 'King', NULL, 'Management', 140000.00, '2014-09-15'),
    (12, 'Linda', 'Howard', 11, 'Management', 120000.00, '2017-02-10'),
    (13, 'Chris', 'Evans', 2, 'Sales', 85000.00, '2019-03-14'),
    (14, 'Natalie', 'Porter', 2, 'Sales', 87000.00, '2020-05-22'),
    (15, 'Mark', 'Bennett', 3, 'Sales', 91000.00, '2021-01-11'),
    (16, 'Sophia', 'Collins', 6, 'Sales', 83000.00, '2022-04-19'),
    (17, 'Ryan', 'Mitchell', 6, 'Sales', 79000.00, '2023-06-01'),
    (18, 'Olivia', 'Turner', 4, 'HR', 72000.00, '2021-08-30'),
    (19, 'Ethan', 'Reed', 5, 'HR', 69000.00, '2022-02-15'),
    (20, 'Grace', 'Ward', 7, 'Support', 65000.00, '2020-09-10'),
    (21, 'Daniel', 'Cook', 7, 'Support', 64000.00, '2021-12-05'),
    (22, 'Zoe', 'Morgan', 8, 'Support', 66000.00, '2023-03-17'),
    (23, 'Henry', 'Bell', 9, 'Accounting', 88000.00, '2019-11-20'),
    (24, 'Emma', 'Murphy', 9, 'Accounting', 92000.00, '2022-07-07'),
    (25, 'Lucas', 'Bailey', 10, 'IT', 75000.00, '2020-10-25'),
    (26, 'Ava', 'Rivera', 10, 'IT', 72000.00, '2021-06-18'),
    (27, 'Noah', 'Cooper', 11, 'Operations', 85000.00, '2018-04-14'),
    (28, 'Mason', 'Richardson', 27, 'Operations', 78000.00, '2021-09-01')
    (29, 'Isabella', 'Cox', 11, 'Marketing', 88000.00, '2019-05-05'),
    (30, 'Logan', 'Diaz', 29, 'Marketing', 73000.00, '2022-11-11');


-- Orders (multiple orders with different statuses and dates)
INSERT INTO orders (order_id, customer_id, sales_rep_id, order_date, status, total_amount) VALUES
    (1, 1, 2, '2025-01-05 10:30:00', 'Delivered', 1500.50),
    (2, 2, 2, '2025-02-14 16:45:00', 'Cancelled', 299.99),
    (3, 1, 3, '2025-03-20 09:10:00', 'Shipped', 750.00),
    (4, 5, 6, '2025-04-01 11:00:00', 'Delivered', 123.45),
    (5, 6, 2, '2025-06-15 14:20:00', 'Pending', 2000.00),
    (6, 3, 13, '2025-07-01 12:15:00', 'Delivered', 899.99),
    (7, 4, 14, '2025-07-03 15:40:00', 'Shipped', 349.99),
    (8, 7, 16, '2025-07-05 10:20:00', 'Pending', 1299.00),
    (9, 8, 15, '2025-07-08 18:10:00', 'Delivered', 499.50),
    (10, 9, 17, '2025-07-10 09:00:00', 'Cancelled', 79.99),
    (11, 10, 2, '2025-07-12 14:35:00', 'Delivered', 2499.99),
    (12, 11, 3, '2025-07-14 11:45:00', 'Shipped', 599.99),
    (13, 12, 6, '2025-07-15 13:20:00', 'Delivered', 199.99),
    (14, 13, 13, '2025-07-16 16:55:00', 'Pending', 749.00),
    (15, 14, 14, '2025-07-18 10:10:00', 'Delivered', 349.99),
    (16, 15, 15, '2025-07-19 12:30:00', 'Shipped', 129.99),
    (17, 16, 16, '2025-07-20 09:45:00', 'Delivered', 1899.99),
    (18, 17, 17, '2025-07-21 15:15:00', 'Pending', 459.00),
    (19, 18, 2, '2025-07-22 11:05:00', 'Cancelled', 299.99),
    (20, 19, 3, '2025-07-23 17:25:00', 'Delivered', 1099.00),
    (21, 20, 6, '2025-08-01 10:00:00', 'Delivered', 799.99),
    (22, 21, 13, '2025-08-02 14:20:00', 'Shipped', 599.50),
    (23, 22, 14, '2025-08-03 09:30:00', 'Delivered', 249.99),
    (24, 23, 15, '2025-08-04 12:40:00', 'Pending', 349.00),
    (25, 24, 16, '2025-08-05 16:10:00', 'Delivered', 499.99),
    (26, 25, 17, '2025-08-06 11:25:00', 'Cancelled', 89.99),
    (27, 26, 2, '2025-08-07 15:50:00', 'Delivered', 1399.00),
    (28, 27, 3, '2025-08-08 10:05:00', 'Shipped', 799.99),
    (29, 28, 6, '2025-08-09 13:45:00', 'Pending', 299.99),
    (30, 29, 13, '2025-08-10 18:00:00', 'Delivered', 649.99),
    (31, 30, 14, '2025-08-11 09:15:00', 'Delivered', 1199.99),
    (32, 31, 15, '2025-08-12 12:30:00', 'Shipped', 159.99),
    (33, 32, 16, '2025-08-13 16:45:00', 'Delivered', 459.99),
    (34, 33, 17, '2025-08-14 11:10:00', 'Pending', 249.50),
    (35, 34, 2, '2025-08-15 14:35:00', 'Delivered', 2999.99),
    (36, 35, 3, '2025-08-16 10:20:00', 'Cancelled', 79.99),
    (37, 36, 6, '2025-08-17 13:55:00', 'Delivered', 899.00),
    (38, 37, 13, '2025-08-18 17:40:00', 'Shipped', 349.99),
    (39, 38, 14, '2025-08-19 12:25:00', 'Delivered', 599.99),
    (40, 39, 15, '2025-08-20 15:30:00', 'Pending', 699.99),
    (41, 40, 16, '2025-08-21 09:50:00', 'Delivered', 1599.99),
    (42, 1, 17, '2025-08-22 11:45:00', 'Shipped', 899.99),
    (43, 2, 2, '2025-08-23 14:10:00', 'Delivered', 349.99),
    (44, 3, 3, '2025-08-24 16:20:00', 'Pending', 109.99),
    (45, 4, 6, '2025-08-25 10:35:00', 'Delivered', 749.99);

-- Order Items (each order has 1–5 line items)
INSERT INTO order_items (order_id, order_item_id, product_id, quantity, unit_price) VALUES
    (1, 1, 10, 2, 499.99),
    (1, 2, 20, 1, 400.52),
    (2, 1, 15, 1, 299.99),
    (3, 1, 10, 1, 499.99),
    (3, 2, 30, 2, 125.00),
    (4, 1, 50, 1, 123.45),
    (5, 1, 2, 4, 499.75),
    (6, 1, 8, 1, 1099.00),
    (6, 2, 15, 2, 49.99),
    (7, 1, 19, 1, 349.99),
    (8, 1, 2, 1, 1299.00),
    (9, 1, 34, 1, 499.99),
    (10, 1, 37, 2, 19.99),
    (11, 1, 11, 1, 1899.99),
    (11, 2, 16, 1, 129.99),
    (12, 1, 35, 1, 599.99),
    (13, 1, 26, 1, 199.99),
    (14, 1, 10, 1, 549.99),
    (14, 2, 17, 1, 79.99),
    (15, 1, 20, 1, 279.50),
    (16, 1, 31, 1, 89.99,
    (16, 2, 37, 2, 19.99),
    (17, 1, 11, 1, 1899.99),
    (18, 1, 33, 1, 129.99),
    (18, 2, 42, 3, 24.99),
    (19, 1, 23, 1, 39.99),
    (20, 1, 9, 1, 1499.99),
    (21, 1, 32, 1, 799.00),
    (22, 1, 36, 1, 999.99),
    (23, 1, 30, 2, 119.99),
    (24, 1, 21, 1, 499.99),
    (25, 1, 4, 1, 999.99),
    (26, 1, 38, 3, 9.99),
    (27, 1, 12, 1, 1199.99),
    (28, 1, 6, 1, 699.50),
    (29, 1, 24, 1, 249.99),
    (30, 1, 33, 1, 129.99),
    (30, 2, 15, 4, 49.99),
    (31, 1, 2, 1, 1299.00),
    (32, 1, 37, 5, 19.99),
    (33, 1, 18, 2, 199.99),
    (34, 1, 41, 4, 12.50),
    (35, 1, 11, 1, 1899.99),
    (35, 2, 9, 1, 1499.99),
    (36, 1, 37, 2, 19.99),
    (37, 1, 25, 3, 299.99),
    (38, 1, 28, 1, 149.99),
    (39, 1, 36, 1, 999.99),
    (40, 1, 21, 1, 499.99),
    (41, 1, 2, 1, 1299.00),
    (41, 2, 16, 2, 129.99),
    (42, 1, 8, 1, 1099.00),
    (43, 1, 20, 1, 279.50),
    (44, 1, 39, 2, 14.99),
    (45, 1, 6, 1, 699.50);

-- Payments (some orders are paid, others remain unpaid or partial)
INSERT INTO payments (payment_id, order_id, payment_date, payment_method, amount) VALUES
    (1, 1, '2025-01-05 12:00:00', 'Card', 1500.50),
    (2, 3, '2025-03-21 09:30:00', 'NetBanking', 750.00),
    (3, 4, '2025-04-02 10:15:00', 'Cash', 123.45),
    (4, 5, '2025-06-20 15:00:00', 'UPI', 1000.00),
    (5, 6, '2025-07-01 14:00:00', 'Card', 899.99),
    (6, 7, '2025-07-03 17:00:00', 'UPI', 349.99),
    (7, 9, '2025-07-08 19:00:00', 'NetBanking', 499.50),
    (8, 11, '2025-07-12 16:00:00', 'Card', 2499.99),
    (9, 13, '2025-07-15 14:30:00', 'UPI', 199.99),
    (10, 15, '2025-07-18 12:00:00', 'Card', 349.99),
    (11, 17, '2025-07-20 11:00:00', 'NetBanking', 1899.99),
    (12, 20, '2025-07-23 19:00:00', 'Card', 1099.00),
    (13, 21, '2025-08-01 12:00:00', 'UPI', 799.99),
    (14, 23, '2025-08-03 11:00:00', 'Card', 249.99),
    (15, 8, '2025-07-05 13:00:00', 'Card', 500.00),
    (16, 8, '2025-07-06 10:00:00', 'UPI', 799.00),
    (17, 14, '2025-07-16 18:00:00', 'NetBanking', 400.00),
    (18, 18, '2025-07-21 18:30:00', 'Card', 200.00),
    (19, 24, '2025-08-04 14:00:00', 'UPI', 150.00),
    (20, 29, '2025-08-09 16:00:00', 'Card', 150.00),
    (21, 34, '2025-08-14 13:00:00', 'NetBanking', 100.00),
    (22, 35, '2025-08-15 16:00:00', 'Card', 1500.00),
    (23, 35, '2025-08-16 11:00:00', 'UPI', 1499.99),
    (24, 41, '2025-08-21 11:00:00', 'Card', 1000.00),
    (25, 41, '2025-08-22 12:00:00', 'NetBanking', 599.99),
    (26, 25, '2025-08-05 18:00:00', 'Card', 499.99),
    (27, 27, '2025-08-07 17:00:00', 'UPI', 1399.00),
    (28, 28, '2025-08-08 13:00:00', 'Card', 799.99),
    (29, 30, '2025-08-10 19:00:00', 'NetBanking', 649.99),
    (30, 31, '2025-08-11 11:00:00', 'Card', 1199.99),
    (31, 32, '2025-08-12 14:00:00', 'UPI', 159.99),
    (32, 33, '2025-08-13 18:00:00', 'Card', 459.99),
    (33, 37, '2025-08-17 16:00:00', 'Card', 899.00),
    (34, 38, '2025-08-18 19:00:00', 'UPI', 349.99),
    (35, 39, '2025-08-19 14:00:00', 'NetBanking', 599.99),
    (36, 42, '2025-08-22 14:30:00', 'Card', 899.99),
    (37, 43, '2025-08-23 17:00:00', 'UPI', 349.99),
    (38, 45, '2025-08-25 12:00:00', 'Card', 749.99);