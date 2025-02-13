use chinook;
-- 2
create view View_Track_Details
as
	select tr.trackId, tr.name as trackName, al.title as albumTitle, ar.name as artistName, tr.unitPrice
    from track tr
    join album al on al.albumId = tr.albumId
    join artist ar on ar.artistId - al.artistId
    where tr.unitPrice > 0.99;
    
select * from View_Track_Details;

-- 3
create view View_Customer_Invoice
as 
	select 
		c.customerId, 
        concat(c.lastName, ' ', c.firstName) as fullName, 
        c.email, 
        sum(iv.total) as total_spending, 
        e.firstName as SupportRep
	from customer c
    join employee e on e.employeeId = c.supportRepId
    join invoice iv on iv.customerId = c.customerId
    group by iv.customerId
    having sum(iv.total) > 40;
    
select * from View_Customer_Invoice;

-- 4
create view View_Top_Selling_Tracks
as
	select tr.trackId, tr.name as trackName, ge.name as genreName, sum(ivl.quantity) as Total_Sales
    from invoiceline ivl
    join track tr on ivl.trackId = tr.trackId
    join genre ge on ge.genreId = tr.genreId
    group by tr.trackId
    having sum(ivl.quantity) > 10;
    
select * from View_Top_Selling_Tracks;

-- 5
create index idx_Track_Name on track(name) using btree; 

select * from track
where name like '%Love%';

explain select * from track
where name like '%Love%';

-- 6
create index idx_Invoice_Total on invoice(total); 

select * from invoice
where total between 20 and 100;

explain select * from invoice
where total between 20 and 100;

-- 7
delimiter &&
create procedure GetCustomerSpending(in customerId int, out total_amount decimal(32,2))
begin
	select ifnull(sum(vci.total_spending), 0) into total_amount 
    from View_Customer_Invoice vci
    where vci.customerId = customerId;
    
end &&
delimiter && 

set @total_amount = 0;
call GetCustomerSpending(1, @total_amount);
select @total_amount;

-- 8
delimiter &&
create procedure SearchTrackByKeyword(in p_keyword char(10))
begin
	select * from track
    where name like concat('%', p_keyWord, '%');
end &&
delimiter && 

call SearchTrackByKeyword('lo');

-- 9
delimiter &&
create procedure GetTopSellingTracks(in p_minsale int, in p_maxsale int)
begin
	select trackName, total_sales from view_top_selling_tracks
    where total_sales between p_minsale and p_maxsale;
end &&
delimiter && 

call GetTopSellingTracks(4, 10);

-- 10
drop view View_Track_Details;
drop view View_Customer_Invoice;
drop index idx_Track_Name on track;
drop index idx_Invoice_Total on invoice;
drop procedure GetCustomerSpending;
drop procedure SearchTrackByKeyword;
drop procedure GetTopSellingTracks;