-- library management system 

-- first we will create the branch table


drop table if exists branch;
create table branch(
branch_id varchar(30) primary key,
manager_id varchar(30),
branch_address varchar(60),
contact_no varchar(10)
);

alter table branch 
alter column contact_no type varchar(20)


-- ok now one table is created and now i am creating the second table that is employee table 

drop table if exists employees
create table employees (
emp_id varchar(30) primary key,
emp_name varchar(20),
position varchar(20),
salary INT,
branch_id varchar(20)
)
ALTER TABLE employees
ALTER COLUMN salary TYPE NUMERIC(10,2);
--ok now we are going to creaete the books table.

drop table if exists books 
create table books(
isbn varchar(25) primary key,
book_title varchar(75),
category varchar(25),
rental_price float,
status varchar(10),
author varchar(30),
publisher varchar(50)
)
alter table books 
alter column category type varchar(30)

-- now we are going to creaete the table named members 

drop table if exists members
create table members(
member_id varchar(20) primary key,
member_name varchar(20),
member_address varchar(20),
reg_date varchar(20)
)

-- now we are going to make another table named return status


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
);



DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
            issued_id VARCHAR(10) PRIMARY KEY,-- primary key is not null and unique.
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10)
            )



/*now i am going to do data modeling . this tells the relation between the data base and it 
 uses foreign key for this purpose. for making the column foreign it should primary key in 
other table. */

--now look

alter table issued_status
add constraint fk_members -- this is just name 
FOREIGN KEY(issued_member_id)   --for column to become foreign key it should be primary key of another table.
references members(member_id); -- this refernce support member_id that it can become foreign giving giving refrence that it is primary key in member table.

-- this will simply connect your tables 
-- now lets to do more 
alter table issued_status
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn);

-- now lets do some more table 
alter table issued_status 
add constraint fk_employees
foreign key(issued_emp_id)
references employees(emp_id);

alter table employees 
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);

alter table return_status 
add constraint fk_issued_status
foreign key(issued_id)
references issued_status(issued_id);



select *from books;
select *from branch;
select * from employees;
select * from members;
select *from issued_status;
select*from return_status;


-- ok all the tables returned the values . now solving the questions 

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--Task 2: Update an Existing Member's Address

update members
set member_address='333 usa'
where member_id='C101';

--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE   issued_id =   'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select *from issued_status 
where issued_emp_id='E101';


--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select 
issued_emp_id,
count(*)
from issued_status
group by 1 
having count(*)>1


/* CRUD Operations create,read,update,delete . these were the operations what we did now 
now going to do the further questions.*/


/* CTAS (Create Table As Select) . this the next question
Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt*
task 6:Create a new table using a SELECT query that shows each book and the total number of times it has been issued.*/

create table for_question as
select b.isbn,b.book_title,count(ist.issued_id)as issu_count
from issued_status as ist
join books as b
on ist.issued_book_isbn=b.isbn
group by b.isbn,b.book_title;


/* here what i did is that i first created the table book as now i have to show book and number of times 
 it has been issued . so first of all 2 tables will be used in this books and issued_status .
 now i have to join these 2 tables . but can only join on some matching column . in this case is isbn 
 this is present in both the tables. so in the 2nd line i have selected isbn,book title and also the 
count of number for that book and issued_id for count from issued_status table . 
now just joining them ussing the similar isbn and then after just grouping them */

 select* from for_question;

--Data Analysis & Findings. 
-- questions from now on till i say will be on this topic.
--Task 7. Retrieve All Books in a Specific Category:

select *from books
where category='Fiction';

--Task 8: Find Total Rental Income by Category:

select 
b.category,
sum(b.rental_price)as income
from books as b 
join issued_status as ist
on ist.issued_book_isbn=b.isbn
group by 1

--task 9 : List Members Who Registered in the Last 180 Days:


SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


--task 10-List Employees with Their Branch Manager's Name and their branch details:


-- we can see that we will have to join 2 tables to make this work.
-- employess and branch are the 2 .

select 
e.emp_id,
e.emp_name,
e.position,
e.salary,
e.branch_id,
e2.emp_id as manager
from employees as e
join branch as b
on e.branch_id=b.branch_id
join employees as e2
on e2.emp_id=b.manager_id



--task 11 - Create a Table of Books with Rental Price Above a Certain Threshold:


create table book_threshold as 
select * from books 
where rental_price>=7;

select * from book_threshold

-- task 12 - Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;




select *from books;
select *from branch;
select * from employees;
select * from members;
select *from issued_status;
select*from return_status;



-- now going to solve some advance sql problems
/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.*/

-- issued_status+members+books+return_status.

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
-- here the delay days are calculated 
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1
/* here first we join several tables like issued status, members, books, return status . you know 
how to join them  there should be some common column in 2 tables. then i selected the all the required 
inputs from all the tables as asked in the qustion. 
last but the important task inside this task was to find the delay days. for this i substracted the issued
date from the current date to get the solution*/



/*Task 14: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of
books issued, the number of books returned, and the total revenue generated from book rentals.*/


select *from books;
select *from branch;
select * from employees;
select * from members;
select *from issued_status;
select*from return_status;

create table task_15 as
select 
b.branch_id,
b.manager_id,
count(ist.issued_id)as books_issued,
count(rs.return_id)as books_returned,
sum(bk.rental_price)as revenue_generated
from issued_status as ist
join employees as e  on 
e.emp_id=ist.issued_emp_id
join 
branch as b
on 
b.branch_id=e.branch_id
 left join return_status as rs 
on 
rs.issued_id=ist.issued_id
join 
books as bk
on 
ist.issued_book_isbn=bk.isbn

group by 1


select * from task_15


/*Task 15: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing
members who have issued at least one book in the last 6 months.

*/

select 
distinct issued_member_id
from issued_status
where issued_date>= current_date - interval'10 days'


/*Task 16: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues.
Display the employee name, number of books processed, and their branch. */

 select 
 e.emp_name as name_of_employee,
 count(ist.issued_id) as books_processed,
 b.branch_id as their_branch
 from issued_status as ist
 join employees as e 
 on e.emp_id=ist.issued_emp_id
 join branch as b
 on b.branch_id=e.branch_id
 group by 1,3
 






