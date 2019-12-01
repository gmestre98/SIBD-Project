--------------------------------------------------------------------------
---------------------------------TRIGGER----------------------------------
--------------------------------------------------------------------------

------------------- TRIGGER -------------------
-- Checks when inserting new phone number for employee

DELIMITER ;

DROP TRIGGER IF EXISTS Phone_employee_I;

DELIMITER $$

CREATE TRIGGER Phone_employee_I BEFORE INSERT ON phone_number_employee
FOR EACH ROW
BEGIN
	IF (EXISTS (SELECT pne.phone FROM phone_number_employee pne WHERE pne.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to an employee.';
	END IF;
	IF (EXISTS (SELECT pnc.phone FROM phone_number_client pnc WHERE pnc.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to a client.';
	END IF;
END$$

DELIMITER ;

------------------- TRIGGER -------------------
-- Checks when updating new phone number for employee (AND pne.VAT <> OLD.VAT)

DELIMITER ;

DROP TRIGGER IF EXISTS Phone_employee_U;

DELIMITER $$

CREATE TRIGGER Phone_employee_U BEFORE UPDATE ON phone_number_employee
FOR EACH ROW
BEGIN
	IF (EXISTS (SELECT pne.phone FROM phone_number_employee pne WHERE pne.phone = NEW.phone AND pne.VAT <> OLD.VAT))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to an employee.';
	END IF;
	IF (EXISTS (SELECT pnc.phone FROM phone_number_client pnc WHERE pnc.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to a client.';
	END IF;
END$$

DELIMITER ;

------------------- TRIGGER -------------------
-- Checks when inserting new phone number for client

DELIMITER ;

DROP TRIGGER IF EXISTS Phone_client_I;

DELIMITER $$

CREATE TRIGGER Phone_client_I BEFORE INSERT ON phone_number_client
FOR EACH ROW
BEGIN
	IF (EXISTS (SELECT pne.phone FROM phone_number_employee pne WHERE pne.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to an employee.';
	END IF;
	IF (EXISTS (SELECT pnc.phone FROM phone_number_client pnc WHERE pnc.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to a client.';
	END IF;
END$$

DELIMITER ;

------------------- TRIGGER -------------------
-- Checks when updating new phone number for client (AND pnc.VAT <> OLD.VAT)

DELIMITER ;

DROP TRIGGER IF EXISTS Phone_client_U;

DELIMITER $$

CREATE TRIGGER Phone_client_U BEFORE UPDATE ON phone_number_client
FOR EACH ROW
BEGIN
	IF (EXISTS (SELECT pne.phone FROM phone_number_employee pne WHERE pne.phone = NEW.phone))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to an employee.';
	END IF;
	IF (EXISTS (SELECT pnc.phone FROM phone_number_client pnc WHERE pnc.phone = NEW.phone AND pnc.VAT <> OLD.VAT))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This phone number is already associated to a client.';
	END IF;
END$$

DELIMITER ;
