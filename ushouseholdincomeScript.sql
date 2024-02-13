SELECT * FROM us_household.ushouseholdincome;
SELECT * FROM us_household.ushouseholdincome_statistics;

alter table ushouseholdincome_statistics rename column `ï»¿id` to `id`;

select id, count(id)
from ushouseholdincome
group by id
having count(id) > 1
;

select *
from (
select row_id,
id,
row_number() over(partition by id order by id) row_num
from us_household.ushouseholdincome
) duplicates
where row_num > 1
;

delete from ushouseholdincome
where row_id in (
	select row_id
	from (
		select row_id,
		id,
		row_number() over(partition by id order by id) row_num
		from us_household.ushouseholdincome
		) duplicates
	where row_num > 1)
;

select id, count(id)
from ushouseholdincome_statistics
group by id
having count(id) > 1
;

select State_Name, count(State_Name)
from ushouseholdincome
group by State_Name
;

update ushouseholdincome
set State_Name = 'Georgia'
where State_Name = 'georia'
;

update ushouseholdincome
set State_Name = 'Alabama'
where State_Name = 'alabama'
;

select distinct State_ab
from ushouseholdincome
order by 1
;

select *
from ushouseholdincome
where Place = ''
order by 1
;

update ushouseholdincome
set Place = 'Autaugaville'
where County = 'Autauga County'
and City = 'Vinemont'
;

select Type, count(Type)
from ushouseholdincome
group by Type
;

update ushouseholdincome
set Type = 'Borough'
where Type = 'Boroughs'
;

select ALand, AWater
from ushouseholdincome
where (AWater = 0 or AWater = '' or AWater is null)
and (ALand = 0 or ALand = '' or ALand is null)
;



select State_Name, sum(ALand), sum(AWater)
from ushouseholdincome
group by State_Name
order by 2 desc
;

select State_Name, sum(ALand), sum(AWater)
from ushouseholdincome
group by State_Name
order by 3 desc
;

select * 
from ushouseholdincome u 
inner join ushouseholdincome_statistics us
	on u.id=us.id
#where u.id is null;
;

select u.State_Name, round(avg(Mean),1), round(avg(Median),1)
from ushouseholdincome u 
inner join ushouseholdincome_statistics us
	on u.id=us.id
where Mean != 0
group by u.State_Name
order by 3 desc
limit 10
;

select `Type`, count(`Type`),round(avg(Mean),1), round(avg(Median),1)
from ushouseholdincome u 
inner join ushouseholdincome_statistics us
	on u.id=us.id
where Mean != 0
group by `Type`
order by 3 desc
#limit 10
;

select `Type`, count(`Type`),round(avg(Mean),1), round(avg(Median),1)
from ushouseholdincome u 
inner join ushouseholdincome_statistics us
	on u.id=us.id
where Mean != 0
group by `Type`
having count(`Type`) > 100
order by 4 desc
#limit 10
;

select u.State_Name, City ,round(avg(Mean),1), round(avg(Median),1)
from ushouseholdincome u 
inner join ushouseholdincome_statistics us
	on u.id=us.id
group by u.State_Name, City
order by round(avg(Mean),1) desc
;