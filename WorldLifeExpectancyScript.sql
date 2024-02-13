SELECT * FROM world_life_expectancy
;

select country, year, concat(country,year), count(concat(country,year))
from world_life_expectancy
group by country, year, concat(country,year)
having count(concat(country,year)) > 1
;

select * from (
	SELECT row_id,
    concat(country,year),
    row_number() over(partition by concat(country,year) order by concat(country,year)) as row_num
	FROM world_life_expectancy
	) as row_table
where row_num > 1
;

delete from world_life_expectancy
where
	row_id in (
    select row_id from (
	SELECT row_id,
    concat(country,year),
    row_number() over(partition by concat(country,year) order by concat(country,year)) as row_num
	FROM world_life_expectancy
	) as row_table
where row_num > 1
)
;

SELECT * 
FROM world_life_expectancy
;

SELECT distinct(status) 
FROM world_life_expectancy
where status != ''
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country
set t1.status='Developed'
where t1.status=''
and t2.status != ''
and t2.status='Developed'
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country=t2.country
set t1.status='Developing'
where t1.status=''
and t2.status != ''
and t2.status='Developing'
;

select t1.Country, t1.Year, t1.`Life expectancy`,
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
round((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country=t2.Country
    and t1.Year=t2.Year-1
join world_life_expectancy t3
	on t1.Country=t3.Country
    and t1.Year=t3.Year+1
where t1.`Life expectancy`=''
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.Country=t2.Country
    and t1.Year=t2.Year-1
join world_life_expectancy t3
	on t1.Country=t3.Country
    and t1.Year=t3.Year+1
set t1.`Life expectancy`=round((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
where t1.`Life expectancy`=''
;

SELECT Country,
min(`Life expectancy`), 
max(`Life expectancy`),
round(max(`Life expectancy`)-min(`Life expectancy`),1) as life_inc
FROM world_life_expectancy
group by Country
having min(`Life expectancy`) != 0
and max(`Life expectancy`) != 0
order by life_inc desc
;

select Year, round(avg(`Life expectancy`),2)
FROM world_life_expectancy
where `Life expectancy` != 0
group by Year
order by Year
;

select Country, ROUND(AVG(`Life expectancy`),1) as life_exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by Country
having life_exp > 0
and GDP > 0
order by GDP desc
;

select
sum(case
	when GDP >= 1200 then 1
	else 0
end) High_GDP_Count,
avg(case
	when GDP >= 1200 then `Life expectancy`
	else null end) High_GDP_Count_Exp,
sum(case
	when GDP <= 1200 then 1
	else 0
end) Low_GDP_Count,
avg(case
	when GDP <= 1200 then `Life expectancy`
	else null end) Low_GDP_Count_Exp
from world_life_expectancy
;

select `Status`, round(avg(`Life expectancy`),1)
from world_life_expectancy
group by `Status`
;

select `Status`, count(distinct Country), round(avg(`Life expectancy`),1)
from world_life_expectancy
group by `Status`
;

select Country, ROUND(AVG(`Life expectancy`),1) as life_exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by Country
having life_exp > 0
and BMI > 0
order by BMI desc
;

select Country,
`Year`,
`Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by Country order by `Year`) as rolling_total
from world_life_expectancy
where Country = 'Finland'
;