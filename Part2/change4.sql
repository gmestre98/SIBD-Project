select ID
from diagnostic_code
where description = 'gingivitis';

INSERT INTO diagnostic_code
VALUES ('A-1069', 'periodontitis');

select pc.name, pc.VAT, pc.date_timestamp, avg(pc.measure) as average_gap, dc.description
from consultation_diagnostic cd inner join procedure_charting pc
on cd.VAT_doctor = pc.VAT
inner join diagnostic_code dc
on cd.ID = dc.ID
where cd.date_timestamp = pc.date_timestamp
and cd.ID IN (select ID from diagnostic_code where description = 'gingivitis')
group by pc.VAT, pc.date_timestamp
having avg(measure) > 4;

update consultation_diagnostic cd
set cd.ID = (select dc.ID from diagnostic_code dc where dc.description = 'periodontitis')
where (select avg(measure) from procedure_charting pc
    	where pc.VAT=cd.VAT_doctor
  	and pc.date_timestamp=cd.date_timestamp
  	group by pc.VAT, pc.date_timestamp) > 4
and cd.ID = (select dc.ID from diagnostic_code dc where dc.description = 'gingivitis');

select pc.name, pc.VAT, pc.date_timestamp, avg(pc.measure) as average_gap, dc.description
from consultation_diagnostic cd inner join procedure_charting pc
on cd.VAT_doctor = pc.VAT
inner join diagnostic_code dc
on cd.ID = dc.ID
where cd.date_timestamp = pc.date_timestamp
and cd.ID IN (select ID from diagnostic_code where description = 'periodontitis)
group by pc.VAT, pc.date_timestamp;