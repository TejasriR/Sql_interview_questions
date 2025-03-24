use employee;
select * from employee;

-- Create the employee Table in SQL ?
CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id VARCHAR(50),
    manager_id INT,
    salary INT,
    expertise VARCHAR(20),
    date DATE
);
-- Insert Sample Data ?
INSERT INTO employee (employee_id, first_name, last_name, dept_id, manager_id, salary, expertise, date) VALUES
(101, 'Mary', 'Danner', 'Account', 109, 80000, 'Junior', '2024-01-03'),
(102, 'Ann', 'Lynn', 'Sales', 107, 140000, 'Semisenior', '2024-01-03'),
(103, 'Peter', 'Oconnor', 'IT', 110, 130000, 'Senior', '2025-02-04'),
(106, 'Sue', 'Sanchez', 'Sales', 107, 110000, 'Junior', '2025-01-01'),
(107, 'Marta', 'Doe', 'Sales', 110, 180000, 'Senior', '2025-02-04'),
(109, 'Ann', 'Danner', 'Account', 110, 90000, 'Senior', '2025-01-01'),
(110, 'Simon', 'Yang', 'CEO', NULL, 250000, 'Senior', '2025-01-01'),
(111, 'Juan', 'Graue', 'Sales', 102, 37000, 'Junior', '2025-01-01');


-- Write an SQL query to retrieve the employee_id, first_name, and salary of all employees from the employee table ?
SELECT employee_id,first_name ,salary from employee ; 

-- Write an SQL query to extract the year from the date column in the employee table.?

select date_format (date,'%Y') year
from employee;
 
 -- Retrieve the first name and salary of employees who have the highest salary in the company ?
 
 select first_name, salary from employee where salary in(select  max(salary) from employee) ;

-- Write an SQL query to find the highest and lowest salaries for each department from the employee table?
SELECT dept_id, MAX(salary) AS max_salary, MIN(salary) AS min_salary 
FROM employee
GROUP BY dept_id;

-- Retrieve each employee's ID and first name along with the month of their joining date, grouping the results by employee ID, first name, and month ?
select employee_id,first_name,Month(date) as month_wise from employee group by  month_wise,employee_id,first_name;

-- Retrieve the employees grouped by month from the date column ?
select Month(date) as month_wise from employee group by  month_wise;

-- Extracting month-wise employee data ?
select employee_id,first_name,Month(date) as month_wise from employee group by  month_wise
order by employee_id,first_name;

-- What is the SQL query to retrieve the full month name from the current date?
select date_format(now() ,'%M') as Month;

-- Write a recursive SQL query to generate numbers from 1 to 12, representing the months of a year ?
WITH RECURSIVE months AS (
    SELECT 1 AS month_num
    UNION ALL
    SELECT month_num + 1 FROM months WHERE month_num < 12
)
SELECT DATE_FORMAT(STR_TO_DATE(month_num, '%m'), '%M') AS month_name
FROM months;

-- How can you retrieve the date that was 30 days ago from the current date in SQL?

SELECT NOW() - INTERVAL '30' DAY AS seven_days_back;

-- Employees who are earning more than their manager's salary ?

with more_than_manager_salary as( select e.first_name, e.employee_id,e.salary as employee_salary ,e.manager_id , m.salary as manager_salary from employee e left join employee m 
 on e.manager_id = m.employee_id  )
 select first_name,employee_salary ,employee_id from more_than_manager_salary where employee_salary < manager_salary;

-- Retrieve the employees who report to the manager with ID 107 ?

select e.first_name, e.employee_id,e.manager_id  from employee e left join employee m 
 on e.manager_id = m.employee_id  where e.manager_id = 107;
 
 -- Write a PySpark query to find all employees who do not have a manager?
 
select e.first_name, e.employee_id,e.manager_id  from employee e left join employee m 
on e.manager_id = m.employee_id where e.manager_id IS NULL;
 




