--------------------------------------------------------------------------
---------------------------------PROCEDURE--------------------------------
--------------------------------------------------------------------------

DELIMITER ;

DROP PROCEDURE IF EXISTS change_salary;

DELIMITER $$

CREATE PROCEDURE change_salary(IN n_years INTEGER)
BEGIN
	UPDATE employee e
	SET e.salary = 1.05 * e.salary
	WHERE (SELECT count(*) FROM consultation c WHERE e.VAT = c.VAT_doctor AND year(c.date_timestamp) = year(CURDATE()) GROUP BY c.VAT_doctor) <= 100
	AND (SELECT pd.years FROM permanent_doctor pd WHERE e.VAT = pd.VAT) > n_years;
	UPDATE employee e
	SET e.salary = 1.1 * e.salary
	WHERE (SELECT count(*) FROM consultation c WHERE e.VAT = c.VAT_doctor AND year(c.date_timestamp) = year(CURDATE()) GROUP BY c.VAT_doctor) > 100
	AND (SELECT pd.years FROM permanent_doctor pd WHERE e.VAT = pd.VAT) > n_years;
END$$

DELIMITER ;

CALL change_salary(10);
