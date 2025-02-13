use sakila;
-- 3
create view view_film_category
as
	select f.film_Id, f.title, c.name as categoryname
    from film f
    join film_category fc on fc.film_id = f.film_id
    join category c on c.category_id = fc.category_id;

select * from view_film_category;

-- 4
create view view_high_value_customers
as 
	select c.customer_id, c.first_name, c.last_name, sum(pm.amount) as total_amount
    from customer c 
    join payment pm on pm.customer_id = c.customer_id
    group by pm.customer_id
    having sum(pm.amount) > 100;
    
select * from view_high_value_customers;

-- 5
create index idx_rental_rental_date on rental(rental_date); 

select * from rental
where rental_date between '2005-06-14 00:00:00' and '2005-06-14 23:59:59';

explain select * from rental
where rental_date between '2005-06-14 00:00:00' and '2005-06-14 23:59:59';

-- 6
delimiter &&
create procedure CountCustomerRentals(in customerId int, out rental_count int)
begin
	select count(rt.customer_id) into rental_count
    from rental rt 
    where rt.customer_id = customerid;
end &&
delimiter && 

set @rental_count = 0;
call CountCustomerRentals(2, @rental_count);
select @rental_count;

-- 7
delimiter &&
create procedure GetCustomerEmail(in customerId int)
begin
	select email from customer
    where customer_id = customerId;
end &&
delimiter && 

call GetCustomerEmail(3);

-- 8
drop view view_film_category;
drop view view_high_value_customers;
drop index idx_rental_rental_date on rental;
drop procedure CountCustomerRentals;
drop procedure GetCustomerEmail; 