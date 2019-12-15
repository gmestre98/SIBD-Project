#------------------< TRIGGER 1 >------------------------------------------

/* Write a trigger to update the age of the clients according to the birth date
and the current date. The trigger should fire whenever a new appointment
for a client is inserted into the database.*/

DELIMITER $$

CREATE TRIGGER Update_Age AFTER INSERT ON appointment
	FOR EACH ROW 
	BEGIN
	UPDATE client 
	SET AGE = TIMESTAMPDIFF(YEAR, birth_date,CURDATE())
	WHERE client.VAT = NEW.VAT_client;
END$$

DELIMITER ;


#----------------< Tests done >-------------------------------------------------------------------
INSERT INTO client VALUES (988444861,'Trigger_1', '1902-10-1','Durham Cross', 'Temecula', '8295-433', 'F', 9);
SELECT * FROM client WHERE VAT=988444861;
INSERT INTO appointment VALUES (977442106, '2020-1-4 7:00:00', 'Teeth hurt a lot', 988444861);
SELECT * FROM client WHERE VAT=988444861;
