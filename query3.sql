SELECT name, city, VAT
FROM client AS cl, appointment AS a1, consultation AS c
WHERE cl.VAT = a1.VAT_client
AND a1.VAT_doctor = c.VAT_doctor
AND a1.date_timestamp = c.date_timestamp
AND (SOAP_O LIKE '%gingivitis%' OR SOAP_O LIKE '%periodontitis%')
AND c.date_timestamp = (SELECT MAX(a2.date_timestamp) FROM appointment a2 WHERE a1.VAT_client = a2.VAT_client)
ORDER BY name ASC;
