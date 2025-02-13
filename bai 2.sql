USE session_11;
-- bài 2
-- 2
create index idx_phonenumber on customers(phonenumber);  

explain select * from customers where phonenumber = '0901234567';

-- 3
create index idx_branchid_salary on employees(branchid, salary);

explain select * from employees where branchid = 1 and salary > 20000000;

-- 4
create unique index idx_accountid_customerid on accounts(accountid, customerid); 

-- 5
show index from employees;
show index from customers;
show index from accounts;

-- 6
alter table employees drop foreign key employees_ibfk_1;
drop index idx_phonenumber on customers;
drop index idx_branchid_salary on employees;
drop index idx_accountid_customerid on accounts;

alter table employees add constraint employees_ibfk_1 foreign key (branchid) references branch(branchid);
