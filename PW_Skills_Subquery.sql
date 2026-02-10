-- PW Skills Subquery Assignment
-- Creating Database
Create Database company;
-- Selecting Database
Use company;

-- Creating Department Table
Create Table department (
department_id varchar(5) Primary Key,
dep_name varchar(50),
location varchar(50)
);

-- Inserting Values in department table
Insert into department
Values
('D01','Sales','Mumbai'),
('D02','Marketing','Delhi'),
('D03','Finance','Pune'),
('D04','HR','Bengaluru'),
('D05','IT','Hyderabad');

-- Creating Employee Table
Create Table employee (
emp_id int Primary Key,
name varchar(50),
department_id varchar(5),
salary int,
foreign key (department_id) references department(department_id)
);

-- Inserting Values into Employee Table
Insert into employee 
Values
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham', 'D01', 58000),
(103, 'Priya', 'D02', 67000),
(104, 'Ravi', 'D04', 60000),
(105, 'Neha', 'D02', 64000),
(106, 'Aman', 'D03', 55000),
(107, 'Rohit', 'D05', 70000),
(108, 'Sneha', 'D04', 75000),
(109, 'Kiran', 'D03', 72000),
(110, 'Tanuja', 'D05', 65000);

-- Creating Sales Table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employee (emp_id)
);

-- Inserting Values into Sales Table
INSERT INTO sales VALUES
(201, 101, 4500, '2025-01-05'),
(202, 102, 7800, '2025-01-10'),
(203, 103, 6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105, 9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107, 3200, '2025-02-09'),
(208, 108, 5100, '2025-02-15'),
(209, 109, 3900, '2025-02-20'),
(210, 110, 7200, '2025-03-01');

-- Basic Level
-- 1- Retrieve the names of employees who earn more than the average salary of all employees.
SELECT name
FROM employee
WHERE salary > (
    SELECT AVG(salary)
    FROM employee
);

-- 2- Find the employees who belong to the department with the highest average salary.
SELECT name
FROM employee
WHERE department_id = (
    SELECT department_id
    FROM employee
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
    LIMIT 1
);

-- 3- List all employees who have made at least one sale.
SELECT DISTINCT e.name
FROM employee e
JOIN sales s
  ON e.emp_id = s.emp_id;

-- 4- Find the employee with the highest sale amount.
SELECT e.name, s.sale_amount
FROM employee e
JOIN sales s
  ON e.emp_id = s.emp_id
ORDER BY s.sale_amount DESC
LIMIT 1;

-- 5- Retrieve the names of employees whose salaries are higher than Shubham’s salary.
SELECT name
FROM employee
WHERE salary > (
    SELECT salary
    FROM employee
    WHERE name = 'Shubham'
);

-- Intermediate Level
-- 1- Find employees who work in the same department as Abhishek.
SELECT name
FROM employee
WHERE department_id = (
    SELECT department_id
    FROM employee
    WHERE name = 'Abhishek'
)
AND name <> 'Abhishek';

-- 2- List departments that have at least one employee earning more than ₹60,000.
SELECT DISTINCT e.department_id
FROM employee e
WHERE e.salary > 60000;

-- 3- Find the department name of the employee who made the highest sale.
SELECT d.dep_name
FROM department d
JOIN employee e
  ON d.department_id = e.department_id
JOIN sales s
  ON e.emp_id = s.emp_id
WHERE s.sale_amount = (
    SELECT MAX(sale_amount)
    FROM sales
);

-- 4- Retrieve employees who have made sales greater than the average sale amount.
SELECT DISTINCT e.name
FROM employee e
JOIN sales s
  ON e.emp_id = s.emp_id
WHERE s.sale_amount > (
    SELECT AVG(sale_amount)
    FROM sales
);

-- 5- Find the total sales made by employees who earn more than the average salary.
SELECT 
    SUM(s.sale_amount) AS total_sales
FROM Employee e
JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM Employee
);

-- Advanced Level
-- 1- Find employees who have not made any sales.
SELECT 
    e.emp_id,
    e.name
FROM Employee e
LEFT JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.emp_id IS NULL;

-- 2- List departments where the average salary is above ₹55,000.
SELECT 
    d.dep_name,
    AVG(e.salary) AS avg_salary
FROM Employee e
JOIN Department d
    ON e.department_id = d.department_id
GROUP BY d.dep_name
HAVING AVG(e.salary) > 55000;

-- 3- Retrieve department names where the total sales exceed ₹10,000.
SELECT 
    d.dep_name,
    SUM(s.sale_amount) AS total_sales
FROM Department d
JOIN Employee e
    ON d.department_id = e.department_id
JOIN Sales s
    ON e.emp_id = s.emp_id
GROUP BY d.dep_name
HAVING SUM(s.sale_amount) > 10000;

-- 4- Find the employee who has made the second-highest sale.
SELECT 
    e.emp_id,
    e.name,
    s.sale_amount
FROM Employee e
JOIN Sales s
    ON e.emp_id = s.emp_id
WHERE s.sale_amount = (
    SELECT MAX(sale_amount)
    FROM Sales
    WHERE sale_amount < (
        SELECT MAX(sale_amount)
        FROM Sales
    )
);

-- 5- Retrieve the names of employees whose salary is greater than the highest sale amount recorded.
SELECT 
    name
FROM Employee
WHERE salary > (
    SELECT MAX(sale_amount)
    FROM Sales
);
