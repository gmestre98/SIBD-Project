SELECT COUNT(DISTINCT p.name) AS medication_usage, d.ID, d.description 
FROM diagnostic_code AS d LEFT OUTER JOIN prescription AS p
ON d.ID = p.ID
GROUP BY d.ID
ORDER BY COUNT(DISTINCT p.name);