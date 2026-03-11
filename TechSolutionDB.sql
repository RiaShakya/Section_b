-- create database TechSolutionsDB;
use TechSolutionsDB;


create table if not exists DEPARTMENT (
DeptID int primary key,
DeptName varchar(255) not null ,
Location varchar(255)
);

create table if not exists EMPLOYEE (
EmpID int primary key,
FirstName varchar(255),
LastName varchar(255),
Gender varchar(10),
Salary int,
HireDate date,
DeptID int,
foreign key(DeptID) references DEPARTMENT(DeptID)
);

create table if not exists PROJECT (
ProjectID int primary key,
ProjectName varchar (255),
StartDate date,
EndDate date,
Budget int
);

create table if not exists WORKS_ON (
EmpID int,
ProjectID int,
HoursWOrked int,
primary key (EmpID, ProjectID),
foreign key(EmpID) references EMPLOYEE(EmpID),
foreign key (ProjectID) references PROJECT(ProjectID)
);


INSERT INTO DEPARTMENT (DeptID, DeptName, Location) VALUES
(1, 'Human Resources', 'Kathmandu'),
(2, 'IT', 'Lalitpur'),
(3, 'Finance', 'Bhaktapur'),
(4, 'Marketing', 'Pokhara'),
(5, 'Operations', 'Chitwan');

INSERT INTO EMPLOYEE (EmpID, FirstName, LastName, Gender, Salary, HireDate, DeptID) VALUES
(101, 'Ram', 'Sharma', 'Male', 50000, '2022-01-10', 2),
(102, 'Sita', 'Thapa', 'Female', 45000, '2021-03-15', 1),
(103, 'Hari', 'Khadka', 'Male', 55000, '2020-07-20', 3),
(104, 'Gita', 'Gurung', 'Female', 48000, '2023-02-12', 4),
(105, 'Nabin', 'Rai', 'Male', 52000, '2022-11-05', 5);

INSERT INTO PROJECT (ProjectID, ProjectName, StartDate, EndDate, Budget) VALUES
(201, 'Website Development', '2023-01-01', '2023-06-30', 100000),
(202, 'Mobile App', '2023-02-01', '2023-08-30', 150000),
(203, 'Accounting System', '2023-03-10', '2023-09-15', 120000),
(204, 'Marketing Campaign', '2023-04-05', '2023-10-01', 90000),
(205, 'Inventory System', '2023-05-01', '2023-11-20', 110000);

INSERT INTO WORKS_ON (EmpID, ProjectID, HoursWorked) VALUES
(101, 201, 40),
(102, 202, 35),
(103, 203, 30),
(104, 204, 25),
(105, 205, 45);


UPDATE EMPLOYEE
SET Salary = Salary * 1.10
WHERE EmpID = 102;


DELETE FROM WORKS_ON
WHERE ProjectID = 205;
DELETE FROM PROJECT
WHERE ProjectID = 205;   

Select EmpID, FirstName, Salary
from EMPLOYEE where Salary >= 50000;

Select FirstName, LastName, Salary 
from EMPLOYEE order by Salary Desc;


Select EmpID, FirstName, LastName 
from EMPLOYEE where DeptID = 2 ;

SELECT DeptID, COUNT(EmpID) AS TotalEmployees
FROM EMPLOYEE
GROUP BY DeptID;

Select Firstname, LastName, HireDate
from EMPLOYEE where HireDate > '2022-01-01' ;


SELECT E.FirstName, E.LastName, D.DeptName
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DeptID = D.DeptID;

Select E.FirstName, E.LastName, P.ProjectName
from EMPLOYEE E 
join PROJECT P on E.ProjectID = P.ProjectID;

Select P.ProjectName, W.HoursWOrked 
from Project P 
join WORKS_ON W on P.ProjectID = W.ProjectID;


SELECT D.DeptName, AVG(E.Salary) AS AvgSalary
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DeptID = D.DeptID
GROUP BY D.DeptName;


SELECT D.DeptName, COUNT(E.EmpID) AS NumEmployees
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.DeptID = E.DeptID
GROUP BY D.DeptName
ORDER BY NumEmployees DESC
LIMIT 1;


SELECT FirstName, LastName, Salary
FROM EMPLOYEE
WHERE Salary > (SELECT AVG(Salary) FROM EMPLOYEE);


CREATE VIEW HighSalaryEmployees AS
SELECT EmpID, FirstName, LastName, Salary, DeptID
FROM EMPLOYEE
WHERE Salary > 60000;

CREATE INDEX idx_LastName
ON EMPLOYEE (LastName);

