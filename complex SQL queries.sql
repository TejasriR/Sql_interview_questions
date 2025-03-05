use sampledata;
select * from user_details ;

-- Create the table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gpa DECIMAL(3,2),
    enrollment_date TIMESTAMP,
    major VARCHAR(50)
);

-- Insert data using CTE
INSERT INTO students (student_id, first_name, last_name, gpa, enrollment_date, major)
VALUES 
    (201, 'Shivansh', 'Mahajan', 8.79, '2021-09-01 09:30', 'Computer Science'),
    (202, 'Umesh', 'Sharma', 8.44, '2021-09-01 08:30', 'Mathematics'),
    (203, 'Rakesh', 'Kumar', 5.60, '2021-09-01 10:00', 'Biology'),
    (204, 'Radha', 'Sharma', 9.20, '2021-09-01 12:45', 'Chemistry'),
    (205, 'Kush', 'Kumar', 7.85, '2021-09-01 08:30', 'Physics'),
    (206, 'Prem', 'Chopra', 9.56, '2021-09-01 09:24', 'History'),
    (207, 'Pankaj', 'Vats', 9.78, '2021-09-01 02:30', 'English'),
    (208, 'Navleen', 'Kaur', 7.00, '2021-09-01 06:30', 'Mathematics');
    
select *from students;

CREATE TABLE student_programs (
    STUDENT_REF_ID INT PRIMARY KEY,
    PROGRAM_NAME VARCHAR(100),
    PROGRAM_START_DATE DATETIME
);

INSERT INTO student_programs (STUDENT_REF_ID, PROGRAM_NAME, PROGRAM_START_DATE) 
VALUES 
    (201, 'Computer Science', '2021-09-01 00:00:00'),
    (202, 'Mathematics', '2021-09-01 00:00:00'),
    (208, 'Mathematics', '2021-09-01 00:00:00'),
    (205, 'Physics', '2021-09-01 00:00:00'),
    (204, 'Chemistry', '2021-09-01 00:00:00'),
    (207, 'Psychology', '2021-09-01 00:00:00'),
    (206, 'History', '2021-09-01 00:00:00'),
    (203, 'Biology', '2021-09-01 00:00:00');




CREATE TABLE student_scholarships (
    STUDENT_REF_ID INT,
    SCHOLARSHIP_AMOUNT DECIMAL(10,2),
    SCHOLARSHIP_DATE DATETIME,
    PRIMARY KEY (STUDENT_REF_ID, SCHOLARSHIP_DATE),
    FOREIGN KEY (STUDENT_REF_ID) REFERENCES student_programs(STUDENT_REF_ID)
);

INSERT INTO student_scholarships (STUDENT_REF_ID, SCHOLARSHIP_AMOUNT, SCHOLARSHIP_DATE) 
VALUES 
    (201, 5000, '2021-10-15 00:00:00'),
    (202, 4500, '2022-08-18 00:00:00'),
    (203, 3000, '2022-01-25 00:00:00'),
    (204, 4000, '2021-10-15 00:00:00');

select * from student_scholarships;
select *from students;
select * from student_programs;

/* Write a SQL query to fetch "FIRST_NAME" from the Student table in upper
 case and use ALIAS name as STUDENT_NAME.*/
 
 select upper(first_name) as STUDENT_NAME from students;
 
 /*2. Write a SQL query to fetch unique values of MAJOR Subjects from Student table.*/

select distinct major from students;
SELECT major FROM students GROUP BY major;

/*3. Write a SQL query to print the first 3 characters of FIRST_NAME from Student table.*/
select  substr(first_name,1,3) from students ;

/*1. Find Students Who Have Received the Highest Scholarship*/

with Highest_Scholarship as( select st.first_name ,s.scholarship_amount from students st join student_scholarships s 
on st.student_id = s.student_ref_id )
select first_name,max(scholarship_amount)as highestamount from Highest_Scholarship
GROUP BY first_name;

SELECT  ss.SCHOLARSHIP_AMOUNT ,s.first_name
FROM student_scholarships ss
JOIN students s ON ss.STUDENT_REF_ID = s.student_id
WHERE SCHOLARSHIP_AMOUNT = (SELECT MAX(SCHOLARSHIP_AMOUNT) FROM student_scholarships);

/*2. Find Students Who Have Been in the Program for More Than 2 Years*/

SELECT s.first_name, TIMESTAMPDIFF(YEAR, sp.PROGRAM_START_DATE, NOW()) AS YEARS_IN_PROGRAM 
FROM student_programs sp join students s on s.student_id= sp.STUDENT_REF_ID
WHERE TIMESTAMPDIFF(YEAR, sp.PROGRAM_START_DATE, NOW()) > 2;

/*3. Rank Students Based on Scholarship Amount Using Window Function*/

with student_rank as (SELECT s.first_name, ss.SCHOLARSHIP_AMOUNT 
FROM student_scholarships ss join students s on s.student_id= ss.STUDENT_REF_ID
)select first_name ,scholarship_amount ,
dense_rank() over(order by scholarship_amount desc)as hrank from student_rank;

/*4. Find Students Who Have Received Multiple Scholarships*/
SELECT s.first_name, ss.STUDENT_REF_ID,count(*)
FROM student_scholarships ss join students s on s.student_id= ss.STUDENT_REF_ID 
group by ss.STUDENT_REF_ID HAVING COUNT(*) > 1;

/*5. Find Top 3 Students with Highest GPA Who Have Received a Scholarship*/
-- select student_id,first_name , gpa from students order by  gpa desc limit 3
 
SELECT s.student_id, s.first_name, s.gpa ,sch.SCHOLARSHIP_AMOUNT
FROM students s
JOIN student_scholarships sch ON s.student_id = sch.STUDENT_REF_ID
ORDER BY s.gpa DESC
LIMIT 3;

SELECT ss.STUDENT_REF_ID, sp.PROGRAM_NAME, COUNT(ss.SCHOLARSHIP_DATE) AS scholarship_count, 
       SUM(ss.SCHOLARSHIP_AMOUNT) AS total_scholarship
FROM student_scholarships ss
JOIN student_programs sp ON ss.STUDENT_REF_ID = sp.STUDENT_REF_ID
GROUP BY ss.STUDENT_REF_ID, sp.PROGRAM_NAME
HAVING COUNT(ss.SCHOLARSHIP_DATE) > 1;








