
/** ------------------------------------------- UPDATE 2 ------------------------------------------**/

select VAT, salary
from employee e
where (select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;

update employee e
set salary = 1.05*salary
where ( select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;

select VAT, salary
from employee e
where (select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;