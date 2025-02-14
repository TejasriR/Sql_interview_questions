-- 1. Show first name, last name, and gender of patients whose gender is 'M'
SELECT first_name, last_name, gender 
FROM patients
WHERE gender = 'M';

-- 2. Show first name and last name of patients who do not have allergies
SELECT first_name, last_name 
FROM patients 
WHERE allergies IS NULL;

-- 3. Show the category_name and description from the categories table sorted by category_name
SELECT category_name, description 
FROM categories 
ORDER BY category_name;

-- 4. Show all the contact_name, address, city of customers not from 'Germany', 'Mexico', 'Spain'
SELECT contact_name, address, city 
FROM customers 
WHERE country NOT IN ('Germany', 'Mexico', 'Spain');

-- 5. Show orders placed on 2018 Feb 26
SELECT order_date, shipped_date, customer_id, freight 
FROM orders 
WHERE order_date = '2018-02-26';

-- 6. Show orders shipped later than required date
SELECT employee_id, order_id, customer_id, required_date, shipped_date 
FROM orders 
WHERE shipped_date > required_date;

-- 7. Show all even-numbered Order_id
SELECT order_id 
FROM orders 
WHERE MOD(order_id, 2) = 0;

-- 8. Show customers from cities containing 'L', sorted by contact_name
SELECT city, company_name, contact_name 
FROM customers 
WHERE city LIKE '%L%' 
ORDER BY contact_name;

-- 9. Show customers that have a fax number
SELECT company_name, contact_name, fax 
FROM customers 
WHERE fax IS NOT NULL;

-- 10. Show the most recently hired employee
SELECT first_name, last_name, MAX(hire_date) AS hire_date 
FROM employees;

-- 11. Show average unit price, total units in stock, total discontinued products
SELECT ROUND(AVG(unit_price), 2) AS average_price, 
       SUM(units_in_stock) AS total_stock, 
       SUM(discontinued) AS total_discontinued 
FROM products;

-- 12. Show ProductName, CompanyName, CategoryName
SELECT p.product_name, s.company_name, c.category_name 
FROM products p 
JOIN suppliers s ON p.supplier_id = s.supplier_id 
JOIN categories c ON p.category_id = c.category_id;

-- 13. Show category_name and average product unit price for each category
SELECT c.category_name, ROUND(AVG(unit_price), 2) AS average_unit_price 
FROM categories c 
JOIN products p ON c.category_id = p.category_id 
GROUP BY category_name;

-- 14. Show customers and suppliers merged with 'customers' or 'suppliers' label
SELECT city, company_name, contact_name, 'customers' AS relationship 
FROM customers
UNION 
SELECT city, company_name, contact_name, 'suppliers' AS relationship 
FROM suppliers;

-- 15. Show total amount of orders for each year/month
SELECT YEAR(order_date) AS order_year, 
       MONTH(order_date) AS order_month, 
       COUNT(order_id) AS no_of_orders 
FROM orders 
GROUP BY order_year, order_month;

-- 16. Show employee's first_name, last_name, num_orders, and shipment status
SELECT e.first_name, e.last_name, COUNT(o.order_id) AS num_orders, 
       CASE
           WHEN o.shipped_date = o.required_date THEN 'On Time' 
           WHEN o.shipped_date > o.required_date THEN 'Late' 
           WHEN o.shipped_date IS NULL THEN 'Not Shipped' 
       END AS shipped_status 
FROM employees e 
JOIN orders o ON e.employee_id = o.employee_id 
GROUP BY e.first_name, e.last_name, shipped_status 
ORDER BY e.first_name, e.last_name, num_orders DESC;

-- 17. Show unique birth years from patients
SELECT DISTINCT YEAR(birth_date) AS birth_year 
FROM patients 
ORDER BY birth_year ASC;

-- 18. Show unique first names occurring only once
SELECT first_name 
FROM patients 
GROUP BY first_name 
HAVING COUNT(*) = 1 
ORDER BY first_name;

-- 19. Show patients whose first_name starts and ends with 's' and is at least 6 characters long
SELECT patient_id, first_name 
FROM patients 
WHERE first_name LIKE 's%s' AND LENGTH(first_name) >= 6;

-- 20. Show patients diagnosed with 'Dementia'
SELECT p.patient_id, p.first_name, p.last_name 
FROM patients p 
JOIN admissions a ON p.patient_id = a.patient_id 
WHERE diagnosis = 'Dementia';

-- 21. Show first_name ordered by length, then alphabetically
SELECT first_name 
FROM patients 
ORDER BY LENGTH(first_name), first_name;

-- 22. Show total male and female patients
SELECT SUM(gender = 'M') AS male_count, 
       SUM(gender = 'F') AS female_count 
FROM patients;

-- 23. Show patients allergic to 'Penicillin' or 'Morphine'
SELECT first_name, last_name, allergies 
FROM patients 
WHERE allergies IN ('Penicillin', 'Morphine') 
ORDER BY allergies, first_name, last_name;

-- 24. Find patients admitted multiple times for the same diagnosis
SELECT patient_id, diagnosis 
FROM admissions 
GROUP BY patient_id, diagnosis 
HAVING COUNT(*) > 1;

-- 25. Show city and total number of patients
SELECT city, COUNT(patient_id) AS num_patients 
FROM patients 
GROUP BY city 
ORDER BY num_patients DESC, city ASC;

-- 26. Show first name, last name, and role (Patient or Doctor)
SELECT first_name, last_name, 'Patient' AS role 
FROM patients 
UNION ALL 
SELECT first_name, last_name, 'Doctor' AS role 
FROM doctors;

-- 27. Show weight groups and total patients in each
SELECT (weight / 10) * 10 AS weight_group, 
       COUNT(patient_id) AS patients_in_group 
FROM patients 
GROUP BY weight_group 
ORDER BY weight_group DESC;

-- 28. Show patients with isObese flag
SELECT patient_id, weight, height, 
       CASE 
           WHEN weight / POWER(height / 100.00, 2) >= 30 THEN 1 
           ELSE 0 
       END AS is_obese 
FROM patients;

-- 29. Show patients diagnosed with 'Epilepsy' under Dr. Lisa
SELECT p.patient_id, p.first_name, p.last_name, d.specialty 
FROM patients p 
JOIN admissions a ON p.patient_id = a.patient_id 
JOIN doctors d ON a.attending_doctor_id = d.doctor_id 
WHERE a.diagnosis = 'Epilepsy' AND d.first_name = 'Lisa';

-- 30. Generate temporary passwords for patients
SELECT DISTINCT p.patient_id, 
       CONCAT(p.patient_id, LENGTH(p.last_name), YEAR(p.birth_date)) AS temp_password 
FROM patients p 
JOIN admissions a ON p.patient_id = a.patient_id;

-- 31. Show total discounts given per year
SELECT ROUND(SUM(p.unit_price * od.quantity * od.discount), 2) AS discount_amount, 
       YEAR(o.order_date) AS order_year 
FROM orders o 
JOIN order_details od ON od.order_id = o.order_id 
JOIN products p ON od.product_id = p.product_id 
GROUP BY order_year 
ORDER BY order_year DESC;
