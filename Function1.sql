--------------------------------------------------------------------------
---------------------------------FUNCTION---------------------------------
--------------------------------------------------------------------------

-- variable count: count for clients of given gender, age and year
-- variable s_count: count for clients of given gender, age and year that showed
-- count - s_count: count for clients of given gender, age and year thar didn't showed

DELIMITER ;

DROP FUNCTION IF EXISTS no_shows_count;

DELIMITER $$

CREATE FUNCTION no_shows_count(gender VARCHAR(15), lower_age INTEGER, upper_age INTEGER, year INTEGER)
	RETURNS INTEGER
BEGIN
	DECLARE count INTEGER;
	DECLARE s_count INTEGER;
	SELECT count(*) INTO count
	FROM appointment a1, client cl
	WHERE a1.VAT_client = cl.VAT
	AND cl.gender = gender
	AND cl.age BETWEEN lower_age AND upper_age
	AND year(a1.date_timestamp) = year;
	SELECT count(*) INTO s_count
	FROM client cl, consultation c LEFT JOIN appointment a
	ON (a.VAT_doctor = c.VAT_doctor AND a.date_timestamp = c.date_timestamp)
	WHERE a.VAT_client = cl.VAT
	AND cl.gender = gender
	AND cl.age BETWEEN lower_age AND upper_age
	AND year(a.date_timestamp) = year;
	RETURN count - s_count;
END $$

DELIMITER ;

SELECT no_shows_count('F', 80, 100, 2019) AS no_shows_count;

------------- QUERY TO CHECK RESULT: -------------

-- Clients of given gender, age and year that missed the appointment

SELECT a1.VAT_client, cl.name, cl.gender, cl.age, a1.date_timestamp, a1.VAT_doctor
FROM client cl, appointment a1
WHERE a1.VAT_client = cl.VAT
AND cl.gender = 'F'
AND cl.age BETWEEN 80 AND 100
AND year(a1.date_timestamp) = 2019
AND (a1.VAT_doctor, a1.date_timestamp) NOT IN (
	SELECT c.VAT_doctor, c.date_timestamp
	FROM consultation c LEFT JOIN appointment a2
	ON (a2.VAT_doctor = c.VAT_doctor AND a2.date_timestamp = c.date_timestamp));
