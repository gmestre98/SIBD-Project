
/** ------------------------------------------- 5 ------------------------------------------**/
/** 5. For each possible diagnosis, presenting the code together with the
description, list the number of distinct medication names that have
been prescribed to treat that condition. Sort the results according
to the number of distinct medication names, in ascending order.**/

SELECT DISTINCT diagnostic_code.ID, diagnostic_code.description, COUNT(DISTINCT prescription.name) AS n_medication
FROM diagnostic_code
LEFT JOIN consultation_diagnostic
USING (ID)
LEFT JOIN prescription
USING (ID)
GROUP BY diagnostic_code.ID
ORDER BY COUNT(DISTINCT prescription.name);

SELECT DISTINCT d.ID, d.description, COUNT(DISTINCT p.name) AS number_medication
FROM diagnostic_code d, prescription p
WHERE d.ID = p.ID
GROUP BY d.ID
ORDER BY COUNT(DISTINCT p.name) ASC;