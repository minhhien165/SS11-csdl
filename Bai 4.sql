USE session_11;
-- Bài 4
-- 2 
delimiter &&
create procedure UpdateSalaryByID(in employee_Id int, out newSalary decimal(10,2))
begin
	set newSalary = (select salary from employees where employeeId = employee_Id);
    if(newSalary < 20000000) then 
		set newSalary = newSalary * 1.1;
    else 
		set newSalary = newSalary * 1.05 ;
    end if;
end &&
delimiter && 

select * from employees;

set @newSalary = 0;
call UpdateSalaryByID(1, @newSalary);
SELECT @newSalary;

update employees
set salary = @newSalary
where employeeId = 1;

-- 3
delimiter &&
create procedure GetLoanAmountByCustomerID(in customer_id int, out total_amount decimal(15,2))
begin
	select sum(loanamount) into total_amount from loans 
    where customerid = customer_id
    group by customerid;
    if total_amount is null then set total_amount = 0;
    end if;
end &&
delimiter && 

set @total_amount = 0;
call GetLoanAmountByCustomerID(1, @total_amount);
select @total_amount;

-- 4
delimiter &&
create procedure DeleteAccountIfLowBalance(in account_Id int)
begin
	declare accountBalance decimal(15, 2);
	declare isDelete varchar(100);
    
	select balance into accountBalance from accounts
    where accountId = account_Id;
    
    if accountBalance < 1000000 then 
		delete from accounts
        where accountId = account_Id;
		set isDelete = 'Xóa thành công';
    else 
		set isDelete = 'Xóa thất bại';
    end if;
    
    select isDelete;
end &&
delimiter && 

call DeleteAccountIfLowBalance(8);

-- 5
delimiter &&
create procedure TransferMoney(in from_account int,in  to_account int, inout amount decimal)
begin
	-- Kiểm tra tài khoản gửi, tài khoản nhận có trong hệ thống không?
    declare is_exists bit default 0;
    declare is_morethan bit default 0;
    if(select count(accountId) from accounts where accountid = from_account) > 0 and (select count(accountId) from accounts where accountid = to_account) > 0
			then set is_exists = 1;
	end if;
    
    if is_exists = 1 then 
		if (select balance from accounts where accountid = from_account) > amount then
			set is_morethan = 1;
		end if;
	end if;
    
    -- Nếu tồn tại, kiểm tra balance >= amount
    if is_morethan = 1 then
    -- Nếu balance >= amount:
		-- Trừ balance của account from_account - amount
        update accounts
        set balance = balance - amount
        where accountId = from_account;
        -- Cộng balance của to_account + amount
        update accounts
        set balance = balance + amount
        where accountId = to_account;
	-- Nếu balance < amount set amount = 0
	else
		set amount = 0;
	end if;
end &&
delimiter && 

select * from accounts;

set @amount = 3000000;
call TransferMoney(1, 2, @amount);
select @amount;

-- 7
drop procedure UpdateSalaryByID;
drop procedure GetLoanAmountByCustomerID;
drop procedure DeleteAccountIfLowBalance;
drop procedure TransferMoney;