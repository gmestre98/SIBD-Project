SELECT DISTINCT 
	den_cav.den_name AS medication_name, 
	den_cav.den_lab AS medication_lab
FROM 
 	(SELECT DISTINCT 
 		p.name AS inf_name, 
 		p.lab AS inf_lab
 	FROM 
 		diagnostic_code d, 
 		prescription p 
 	WHERE 
 		d.description!='infectious disease' 
 		AND d.ID=p.ID 
 		AND p.date_timestamp LIKE '2019%' 
 	ORDER BY 
 		d.id
 	) AS inf_dis 
	INNER JOIN
 	(SELECT DISTINCT 
 		p.name AS den_name,
 		p.lab AS den_lab
 	FROM 
 		diagnostic_code d, 
 		prescription p 
 	WHERE d.description='dental cavities' 
 		AND d.ID=p.ID 
 		AND p.date_timestamp LIKE '2019%' 
 	ORDER BY 
 		d.id
 	) AS den_cav 
 	ON 
 		(inf_dis.inf_name=den_cav.den_name 
 		AND inf_dis.inf_name=den_cav.den_name)
ORDER BY 
	den_cav.den_name, 
	den_cav.den_lab asc;