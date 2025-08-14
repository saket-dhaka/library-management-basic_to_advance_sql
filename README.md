# library-management-basic_to_advance-
📚 Library Management System (SQL Project)
📌 Overview

This project is a Library Management System developed using SQL.
It demonstrates database design, data modeling, and complex query writing to manage a library’s branches, employees, books, members, issued books, and return records.

The system covers:

Relational database creation with constraints

CRUD operations

CTAS (Create Table As Select) for summary tables

Analytical queries for insights like overdue books, active members, and branch performance

🗂 Database Schema

The database contains six main tables:

branch – Stores library branch details (ID, manager, address, contact number).

employees – Stores employee details, linked to branches.

books – Stores book details including ISBN, title, category, price, status, author, and publisher.

members – Stores member details with registration dates.

issued_status – Tracks books issued to members by employees.

return_status – Tracks books returned, linked to issued books.

Relationships:

Employees belong to a branch (branch_id FK).

Issued books are linked to a member, a book, and an employee.

Returned books are linked to issued books.

⚙ Features Implemented
1. Database Creation & Modeling

Created normalized tables with primary and foreign keys.

Established relationships between branches, employees, books, and members.

2. CRUD Operations

Create: Insert new book records.

Read: Retrieve issued books by employee or category.

Update: Modify member address.

Delete: Remove records from issued books.

3. Advanced SQL Features

Joins (INNER, LEFT) for combining data from multiple tables.

Aggregate functions for counts, sums, averages.

GROUP BY / HAVING for grouped analysis.

CTAS for creating summary tables from queries.

4. Analytical Queries

Books not returned yet.

Members with overdue books (30+ days).

Branch performance (books issued, returned, and revenue).

Top employees by number of book issues processed.

Active members in the last 6 months.

Revenue by category.
