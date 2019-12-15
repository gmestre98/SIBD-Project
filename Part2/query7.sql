SELECT 
	c.ID AS 'diagnosis', 
	name AS 'medication name', 
	COUNT(name) AS 'Most common medication (has been prescripted __ times)'
FROM 
	prescription p,
	consultation_diagnostic c 
WHERE 
	c.ID=p.ID 
	AND c.VAT_doctor=p.VAT_doctor 
	AND c.date_timestamp=p.date_timestamp 
	AND c.date_timestamp LIKE '2019%'
GROUP BY 
	c.VAT_doctor, 
	c.date_timestamp, 
	c.id
ORDER BY c.ID;