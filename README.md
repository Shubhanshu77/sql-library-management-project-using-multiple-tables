# sql-library-management-project-using-multiple-tables


## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql

 insert into books(isbn,book_title,category,rental_price,status,author, publisher)
       values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')

	    select * from books;

```
**Task 2: Update an Existing Member's Address**

```sql
update members 
set member_address = '125 main st'
where member_id = 'C101';

        select * from members;

```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql

delete from issues_status
where  issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
select * from issues_status
where Issued_emp_id ='E101';
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
select 
    issued_emp_id
	from issues_status
	group by 1
	having count (issued_id) > 1
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql

create table book_cnts
as
select 
b.isbn,
b.book_title,
  count(ist.issued_id) as no_issued
from books as b 
join issues_status as ist
on ist.issued_book_isbn = b.isbn
group by 1, 2;

select * from book_cnts

```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql

select 
 b.category,
 sum(b.rental_price),
 count(*)
   from books as b 
  join issues_status as ist 
  on ist .issued_book_isbn = b.isbn
  group by 1;
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
insert into members (member_id , member_name , member_address , reg_date)
      values ( 'C118' , 'sam' , '145 main ist' , '2024-12-01'),
              ( 'C119' , 'john' , '133 main ist' , '2024-12-25');
             
select * from members 
where reg_date >= current_date - interval ' 250days'
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql

  select 
  e1.*,
  b.manager_id,
  e2.emp_name as manager
  from 
  employees as e1
  join 
  branch as b 
  on b.branch_id = e1.branch_id
  join 
  employees as e2
  on b.manager_id = e2.emp_id
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
create table books_price
as
  select * from books
  where rental_price > 7

select * from books_price
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
alter table issues_status rename to  issued_status;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
select 
  ist.issued_member_id,
  m.member_name,
  bk.book_title,
  ist.issued_date,
   current_date - ist.issued_date as overdue_days
  
from issued_status as ist
join 
members as m
on m.member_id = ist.issued_member_id

 join 
 books as bk
 on bk.isbn = ist.issued_book_isbn

left join 
 return_status as rs
 on ist.issued_id = rs.issued_id

 where rs.return_date is null
       and   (current_date - ist.issued_date ) > 30 
	   order by 1
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
select * from  branch 
   select *  from issued_status 
   select * from employees
      select * from books
	  select * from return_status
	  
create table branch_report
as
 select *
  b.branch_id,
  b.manager_id,
  count(ist.issued_id) as number_book_issued,
  count(rs.return_id) as no_of_book_returned,
  sum(bk.rental_price) as total_revenue
 from issued_status as ist
  join employees as e
 on e.emp_id = ist.issued_emp_id
  join branch as b 
 on e.branch_id = b.branch_id
  join
 return_status as rs
 on rs.issued_id = ist.issued_id
  join 
 books as bk
 on ist.issued_book_isbn = bk.isbn
 group by 1,2
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql


select* from employees
select * from issued_status

create table active_members
as
select * from members
where member_id in 
                  (select 
                    distinct issued_member_id
                     from issued_status 
                               where 
                        issued_date >= current_date - interval '12 month '
                         )  

select * from active_members

```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
select 
   e.emp_name,
   b.*,
   count(ist.issued_id) as no_book_issued
from  issued_status as ist
 join 
 employees as e
 on e.emp_id = ist.issued_emp_id
 join
 branch as b
 on e.branch_id = b.branch_id
 group by 1,2
```   


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql
select * from books
select * from issued_status

create or replace procedure issue_book(p_issued_id varchar(30),p_issued_member_id varchar(50),p_issued_book_isbn varchar(30), p_issued_emp_id varchar(10))
 language plpgsql
 as $$


  declare 
       --all the variable
            v_status varchar(10);
  begin
      --all the code
	  --checking if book is available 'yes'
         
         select 
		 status
		 v_statys
		 from books
		 where isbn = p_issued_book_isbn;

		 if v_status = 'yes' then
		      insert into issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)   
		       values (p_issued_id,p_issued_member_id , current_date ,p_issued_book_isbn,p_issued_emp_id );
		 

		raise notice 'book records added successfully for book isbn : %' , p_issued_book_isbn;

			  update books
			  set status ='no'
			where isbn = p_issued_book_isbn;
           
             else
                raise notice 'book records is not added as it is not availabe at this moment for book isbn : %' , p_issued_book_isbn;
		 
		 end if ;
            
  end;
   $$


--"978-0-553-29698-2" no 
---"978-1-60129-456-2" yes
 
 call issue_book('IS155','C108','978-1-60129-456-2','E104');       
           
```



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.
