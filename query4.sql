
/** ------------------------------------------- 4 ------------------------------------------**/
/** 4. List the name, VAT and address (i.e., street, city and zip) of all
clients of the clinic that have had appointments but that never had
a consultation (i.e., clients that never showed to an appointment).**/

SELECT DISTINCT name, VAT, street, city, zip
FROM client, appointment
WHERE VAT IN (SELECT a.VAT_client
	FROM appointment a NATURAL LEFT OUTER JOIN consultation c
	GROUP BY VAT_client
	HAVING COUNT(c.date_timestamp) = 0);