
UPDATE employee e
SET salary = 1.05*salary
WHERE(SELECT COUNT(*)
	FROM appointment a
	WHERE e.VAT = a.VAT_doctor
	AND YEAR(a.date_timestamp)=2019
	GROUP BY VAT_doctor) > 100;