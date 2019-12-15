DROP view IF EXISTS dim_location_client;
CREATE VIEW facts_consult AS
SELECT 
	dc.VAT, 
	dd.date_timestamp AS 'date', 
	dl.zip, 
	COUNT(DISTINCT pres.name) as num_medications, 
	COUNT(DISTINCT pres.ID) as num_diagnostic_codes,
	COUNT(DISTINCT proc.name) as num_procedures
FROM 
	dim_client dc, 
	dim_date dd, 
	dim_location_client dl,
	client cl,
	appointment a
	LEFT OUTER JOIN consultation c 
	ON (c.date_timestamp = a.date_timestamp AND c.VAT_doctor=a.VAT_doctor)
	LEFT OUTER JOIN prescription pres 
	ON (c.date_timestamp = pres.date_timestamp AND c.VAT_doctor=pres.VAT_doctor)
	LEFT OUTER JOIN procedure_in_consultation proc 
	ON (c.date_timestamp = proc.date_timestamp AND c.VAT_doctor=proc.VAT_doctor)
WHERE 
	a.VAT_client=dc.VAT
	AND cl.VAT=dc.VAT
	AND cl.zip=dl.zip
	AND dd.date_timestamp=pres.date_timestamp 
	AND dd.date_timestamp=proc.date_timestamp
GROUP BY 
	dc.VAT, 
	dd.date_timestamp
ORDER BY 
	dc.VAT, 
	dd.date_timestamp;