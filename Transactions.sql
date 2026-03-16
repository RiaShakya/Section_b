# TRANSACTIONS
# 1. Create a database named BankDB and create a table accounts with the fields : account_id,
# account_holder, balance 

Create database if not exists BankDB;
use BankDB;

Create table IF NOT EXISTS accounts (
account_id int primary key,
account_holder varchar (100),
balance decimal(10,2)
);

INSERT INTO accounts (account_id, account_holder, balance) VALUES
(1, 'Ram Sharma', 15000.50),
(2, 'Sita Karki', 23000.75),
(3, 'Hari Thapa', 12000.00),
(4, 'Gita Rai', 5400.25),
(5, 'Bikash Gurung', 9800.60);

# Write a transaction that transfers Rs.5000 from Ram's account to Gita's account

start transaction;
update accounts 
set balance = balance - 5000
where account_id = 1;

update accounts 
set balance = balance + 5000
where account_id = 4;
commit;


# Write a transaction that transfers Rs 10000 from Sita's account and demonstrate the use of ROLLBACK
start transaction;
update accounts 
set balance = balance - 10000
where account_id = 2;

update accounts 
set balance = balance + 10000
where account_id = 1;
commit;
ROLLBACK;

# Write a transaction that demonstrates the use of SAVEPOINT while updating account balances.

start transaction;
update accounts
set balance = balance - 2000
where account_id = 1;
savepoint sp1;
update accounts set balance = balance + 2000
where account_id = 2;
rollback to sp1;
commit;

# TRIGGERS
#1 Create a table employees with the fields : emp_id, name, salary

Create table employees(
emp_id int primary key,
name varchar(100),
salary decimal (10,2)
);

# 2. Create another table salary_log  to record employee salary changes with fields: log_id, emp_id,
# old_salary, new_salary,Update_at.

Create table salary_log (
log_id int auto_increment primary key,
emp_id int,
old_salary decimal (10,2),
new_salary decimal(10,2),
updated_at timestamp default current_timestamp
);

# Create a BEFORE INSERT trigger on employees that prevents inserting employees whose salary is less than 10000.

Delimiter $$
	Create trigger check_salary
	before insert on employees
	for each row
	begin
	if new.salary < 10000 then
	signal sqlstate '45000'
	set message_text = "salary must be atleast 10000";
	end if ;
	end $$ 
Delimiter ;

# Create an AFTER UPDATE trigger on employees that records salary changes into the salary_log table.

Delimiter $$
create trigger log_salary_update
after update on employees 
for each row
begin
insert into salary_log(emp_id, old_salary, new_salary)
values (old.emp_id, old.salary, new.salary);
end $$
DELIMITER ;

# Stored procedure
# Create a stored procedure that retrieves all records from the employees table

Delimiter $$

Create procedure getEmployees()
begin
select * from employees;
end $$

Delimiter ;

call getEmployees();


#Create a stored procedure that inserts a new employee into the employees table using paramaters
Delimiter $$
create procedure addEmployee(
IN p_id int,
IN p_name varchar(100),
IN p_salary decimal (10,2)
)
begin
insert into employees values(p_id, p_name, p_salary);
end $$
Delimiter ;
call addEmployee (5, 'Hari', 20000);

# Create a stored procedcure that updates the salary of an employee based on employee ID
 Delimiter $$
 create procedure updateSalary(
 in p_id int, in new_salary decimal (10,2))
 begin 
 update employees
 set salary = new_salary
 where emp_id = p_id;
 end $$
 Delimiter ;
 call updateSalary(1,30000);
 
 # Create a stored procedure that transfers money between two accounts using a transaction
 
 Delimiter $$
 
 Create procedure transferMoney(
 in from_account int, in to_account int, in amount decimal)
 begin
 start transaction;
update accounts 
set balance = balance - amount
where account_id = from_account;

update accounts 
set balance = balance + amount
where account_id = to_account;
commit;
 
 end $$
 Delimiter ;
 call tranferMoney(1,4,5000);
 
 