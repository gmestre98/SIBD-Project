DELETE FROM proceduretable
WHERE EXISTS (SELECT pc.name
	FROM procedure_in_consultation pc, employee e
	WHERE pc.VAT_doctor=e.VAT
	AND e.name='Jane Sweettooth')
AND NOT EXISTS (select pc.name
	FROM procedure_in_consultation pc, employee e
	WHERE pc.VAT_doctor=e.VAT
	AND e.name<>'Jane Sweettooth')
;

DELETE FROM, diagnostic_code
WHERE EXISTS (SELECT cd.ID
	FROM consultation_diagnostic cd, employee e
	WHERE cd.VAT_doctor=e.VAT
	AND e.name='Jane Sweettooth')
AND NOT EXISTS (SELECT cd.ID
	FROM consultation_diagnostic cd, employee e
	WHERE cd.VAT_doctor=e.VAT
	AND e.name<>'Jane Sweettooth')
;

DELETE FROM employee
WHERE name = 'Jane Sweettooth');