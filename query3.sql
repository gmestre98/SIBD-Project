/** ------------------------------------------- 3 ------------------------------------------**/
/** 3. List the name, city, and VAT for all clients where the most recent
consultation has the objective part of the SOAP_O note mentioning the
terms gingivitis or periodontitis.**/

SELECT name, city, VAT
FROM client, appointment a1 NATURAL JOIN consultation
WHERE VAT = VAT_client
AND (SOAP_O LIKE '%gingivitis%' OR SOAP_O LIKE '%periodontitis%')
AND date_timestamp = (SELECT MAX(date_timestamp) FROM appointment a2 WHERE a1.VAT_client = a2.VAT_client)
ORDER BY name asc;

SELECT name, city, VAT
FROM client AS cl, appointment AS a1, consultation AS c
WHERE cl.VAT = a1.VAT_client
AND a1.VAT_doctor = c.VAT_doctor
AND a1.date_timestamp = c.date_timestamp
AND (SOAP_O LIKE '%gingivitis%' OR SOAP_O LIKE '%periodontitis%')
AND c.date_timestamp = (SELECT MAX(a2.date_timestamp) FROM appointment a2 WHERE a1.VAT_client = a2.VAT_client)
ORDER BY name ASC;