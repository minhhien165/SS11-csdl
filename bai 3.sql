USE session_11;
-- 2 
delimiter &&
create procedure GetCustomerByPhone(in phoneNumber varchar(20))
begin
	select c.customerId, c.fullname, c.dateofBirth, c.address, c.email
    from customers c
    where c.phoneNumber = phoneNumber;
end &&
delimiter && 

-- 3
delimiter &&
create procedure GetTotalBalance(in customerId int, out totalBalance int)
begin 
	set totalBalance = (select sum(a.balance)
		from accounts a
		where a.customerId = customerId
		group by a.customerId);
end &&
delimiter && 

-- 4
delimiter &&
create procedure IncreaseEmployeeSalary(in employee_id int, out new_salary decimal(10,2))
begin
	set new_salary = (select (salary * 1.1) from employees where employeeId = employee_id);
end &&
delimiter &&
 
-- 5
call GetCustomerByPhone('0901234567');

call GetTotalBalance(1, @totalBalance);
select @totalBalance;

set @new_salary = 0;
call IncreaseEmployeeSalary(4, @new_salary);
select @new_salary; 

-- 6
drop procedure GetCustomerByPhone;
drop procedure GetTotalBalance;
drop procedure IncreaseEmployeeSalary;

