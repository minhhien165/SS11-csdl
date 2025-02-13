use chinook;
-- 3
create view View_Album_Artist
as 
	select al.albumId, al.title as album_title, ar.name as artist_name
    from artist ar
    join album al on al.artistId = ar.artistId;
    
select * from View_Album_Artist;

-- 4
create view View_Customer_Spending
as
	select c.customerId, c.firstName, c.lastName, c.email, sum(iv.total) as total_money
    from customer c
    join invoice iv on iv.customerId = c.customerId
    group by iv.customerId;
    
select * from View_Customer_Spending;

-- 5
create index idx_Employee_LastName on employee(lastName);

select * from employee
where lastName like '%King';

explain select * from employee
where lastName like '%King';

-- 6
delimiter &&
create procedure GetTracksByGenre(genreId int)
begin
	select tr.trackId, tr.name as trackName, al.title as albumTitle, ar.name as artistName
    from artist ar
    join album al on ar.artistId = al.artistId
    join track tr on tr.albumId = al.albumId
    where tr.genreId = genreId;
end &&
delimiter &&

call GetTracksByGenre(2);

-- 7
delimiter &&
create procedure GetTrackCountByAlbum(p_albumId int)
begin
	select al.title as albumName, count(tr.albumId) as count_tracks
    from album al
    join track tr on tr.albumId = al.albumId
    where al.albumId = p_albumId
    group by al.title;
end &&
delimiter &&

call GetTrackCountByAlbum(4);

-- 8
drop view View_Album_Artist;
drop view View_Customer_Spending;
drop index idx_Employee_LastName on employee;
drop procedure GetTracksByGenre;
drop procedure GetTrackCountByAlbum;