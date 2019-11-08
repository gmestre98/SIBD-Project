/** ------------------------------------------- UPDATE 3 ------------------------------------------**/
/** -------------- BEFORE -------------- **/
select e.name, count(distinct e.VAT), count(distinct d.VAT), count(a.VAT_doctor), count(c.VAT_doctor)
from employee e, doctor d LEFT OUTER JOIN appointment a 
ON d.VAT = a.VAT_doctor
NATURAL LEFT OUTER JOIN consultation c
where  e.VAT = d.VAT
and e.name = 'Jane Sweettooth'
group by e.VAT;

select *
from proceduretable
where exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and proceduretable.name = pc.name
	and e.name='Jane Sweettooth')
and not exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and proceduretable.name = pc.name
	and e.name<>'Jane Sweettooth')
;

select *
from diagnostic_code
where exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and diagnostic_code.ID = cd.ID
	and e.name='Jane Sweettooth')
and not exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and diagnostic_code.ID = cd.ID
	and e.name<>'Jane Sweettooth')
;

/** -------------- DELETE -------------- **/
delete from proceduretable
where exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and e.name='Jane Sweettooth')
and not exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and e.name<>'Jane Sweettooth')
;

delete from diagnostic_code
where exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and e.name='Jane Sweettooth')
and not exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and e.name<>'Jane Sweettooth')
;

delete from doctor
where VAT in (select VAT from employee
where name = 'Jane Sweettooth');

/** -------------- AFTER -------------- **/
select e.name, count(distinct e.VAT), count(distinct d.VAT), count(a.VAT_doctor), count(c.VAT_doctor)
from employee e, doctor d LEFT OUTER JOIN appointment a 
ON d.VAT = a.VAT_doctor
NATURAL LEFT OUTER JOIN consultation c
where  e.VAT = d.VAT
and e.name = 'Jane Sweettooth'
group by e.VAT;

select *
from proceduretable
where exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and e.name='Jane Sweettooth')
and not exists (select pc.name
	from procedure_in_consultation pc, employee e
	where pc.VAT_doctor=e.VAT
	and e.name<>'Jane Sweettooth')
;

select *
from diagnostic_code
where exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and e.name='Jane Sweettooth')
and not exists (select cd.ID
	from consultation_diagnostic cd, employee e
	where cd.VAT_doctor=e.VAT
	and e.name<>'Jane Sweettooth')
;
