-- create database COMPANYDB ;
use COMPANYDB;

create table IF NOT EXISTS DEPPARTMENT(
DNAME varchar(20),
DNUMBER int primary key,
MGRSSN varchar(15),
MGRSTARTDATE date
);

create table IF NOT EXISTS EMPLOYEE (
FNAME varchar(20),
MINIT char(1),
LNAME varchar(15),
SSN varchar(15) primary key,
BDATE date,
ADDRESS varchar(100),
SEX char(1),
SALARY int,
SUPERSSN varchar(15),
DNO int,
foreign key(DNO) references DEPARTMENT(DNUMBER)
);

INSERT INTO DEPARTMENT (DNAME, DNUMBER, MGRSSN, MGRSTARTDATE)
VALUES ('Research', 1, '123-45-6789', '2022-01-15'),
 ('Human Resources', 2, '987-65-4321', '2021-06-10'),
 ('IT Support', 3, '456-78-9123', '2023-03-20');
 
 INSERT INTO EMPLOYEE (FNAME, MINIT, LNAME, SSN, BDATE, ADDRESS, SEX, SALARY, SUPERSSN, DNO) VALUES
('John', 'A', 'Smith', '111-11-1111', '1990-05-15', 'Kathmandu, Nepal', 'M', 60000, NULL, 1),
('Rita', 'B', 'Shrestha', '222-22-2222', '1995-08-20', 'Lalitpur, Nepal', 'F', 50000, '111-11-1111', 1),
('Suman', 'C', 'Thapa', '333-33-3333', '1988-03-10', 'Bhaktapur, Nepal', 'M', 55000, '111-11-1111', 2),
('Anita', 'D', 'Karki', '444-44-4444', '1992-11-25', 'Pokhara, Nepal', 'F', 48000, '333-33-3333', 2),
('Ram', 'E', 'Gurung', '555-55-5555', '1997-07-05', 'Chitwan, Nepal', 'M', 45000, '333-33-3333', 3);

select * from DEPARTMENT;
select * from EMPLOYEE; 

#1. 10% SALARY RAISE for research department
select E.FNAME, E.LNAME,
E.SALARY * 1.1 as increased_salary
from EMPLOYEE E
join DEPARTMENT D on E.DNO = D.DNUMBER
where D.DNAME = "Research";

#2 Salary statistics of Human Resources Department sum, max, min, avg for department administration
select 
SUM(E.SALARY) as total, 
MAX(E.SALARY) as max, 
MIN(E.SALARY) as min, 
avg(E.SALARY) as average
from EMPLOYEE E
join DEPARTMENT D on E.DNO = D.DNUMBER
where D.DNAME = "Human Resources";

#3. Employee controlled by department no 3 
/*SELECT FNAME, LNAME FROM EMPLOYEE E
WHERE EXISTS (
    SELECT *
    FROM EMPLOYEE e
    WHERE e.DNO = 3
    AND E.SSN = e.SSN
);*/
SELECT E.NAME, E.LNAME from EMPLOYEE E
where E.DNO = 3;

#4 Departments having at least two employees
select D.DNAME, count(*) as Emp_Count
from EMPLOYEE E
join DEPARTMENT D on E.DNO = D.DNUMBER 
group by D.DNUMBER, D.DNAME
having count(*) >=2;

#5. Employees born in 1990's (1950-1999)
select * from EMPLOYEE
where year(BDATE) between 1955 and 1999;


