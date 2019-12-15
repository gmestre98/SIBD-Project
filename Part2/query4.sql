SELECT DISTINCT name, VAT, street, city, zip
FROM client
WHERE VAT IN (SELECT a.VAT_client
	FROM appointment a LEFT OUTER JOIN consultation c
	ON a.VAT_doctor = c.VAT_doctor AND a.date_timestamp = c.date_timestamp
	GROUP BY VAT_client
	HAVING COUNT(c.date_timestamp) = 0);
