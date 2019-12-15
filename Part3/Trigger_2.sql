#------------------< TRIGGER 2 >---------------------------------------------------------------------
#Write triggers to ensure that:

#------(a)--------------------------------------------------------------------------------------------
# an individual that is a receptionist or a nurse at the clinic cannot simultaneously be a doctor:

DROP  TRIGGER  IF  EXISTS  Doctor_Cannot_Be_receptionist_or_Nurse_I;
DELIMITER $$
CREATE TRIGGER Doctor_Cannot_Be_receptionist_or_Nurse_I BEFORE INSERT ON doctor
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT nurse.VAT FROM nurse WHERE nurse.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This employee is an Nurse';
	END IF; 
	IF (EXISTS (SELECT receptionist.VAT FROM receptionist WHERE receptionist.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This employee is an Receptionist'; 
	END IF;
END$$
DELIMITER ;
DROP  TRIGGER  IF  EXISTS  Doctor_Cannot_Be_receptionist_or_Nurse_U;
DELIMITER $$
CREATE TRIGGER Doctor_Cannot_Be_receptionist_or_Nurse_U BEFORE UPDATE ON doctor
	FOR EACH ROW 
	BEGIN
	IF( EXISTS (SELECT nurse.VAT FROM nurse WHERE nurse.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a Doctor. Should first DELETE or UPDATE the Nurse then INSERT the NEW VAT INTO Doctor.'; 
	END IF;	
	IF( EXISTS (SELECT receptionist.VAT FROM receptionist WHERE receptionist.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a Doctor. Should first DELETE or UPDATE the Nurse then INSERT the NEW VAT INTO Doctor.'; 
	END IF;
END$$
DELIMITER ;
#----------------< Tests done >-------------------------------------------------------------------
	# Cria uma nurse, um receptionist e um doctor para não alterar os valores do populate
	INSERT INTO employee VALUES (998442200,'Trigger_2_nurse', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 20, 2000);
	INSERT INTO nurse VALUES (998442200);
	INSERT INTO employee VALUES (998442201,'Trigger_2_receptionist', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 21, 2000);
	INSERT INTO receptionist VALUES (998442201);
	INSERT INTO employee VALUES (998442202,'Trigger_2_doctor', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 22, 2000);
	
	# Insere um doctor que já é uma nurse, uma receptionist, e um que não é nada ainda
	INSERT INTO doctor VALUES (998442200, 'Orthodontist', 'Description.', 'email20@dentesbrilhantes.com.br');
	SELECT * FROM employee NATURAL JOIN nurse WHERE VAT=998442200;
	INSERT INTO doctor VALUES (998442201, 'Orthodontist', 'Description.', 'email21@dentesbrilhantes.com.br');
	SELECT * FROM employee NATURAL JOIN receptionist WHERE VAT=998442201;
	INSERT INTO doctor VALUES (998442202, 'Orthodontist', 'Description.', 'email22@dentesbrilhantes.com.br');
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;

	# Atualiza um doctor para um vat que é uma nurse ou uma receptionist
	UPDATE doctor SET VAT = 998442201 WHERE VAT = 998442202;
	UPDATE doctor SET VAT = 998442200 WHERE VAT = 998442202;
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;
	SELECT * FROM employee NATURAL JOIN receptionist WHERE VAT=998442201;
	SELECT * FROM employee NATURAL JOIN nurse WHERE VAT=998442200;
DROP  TRIGGER  IF  EXISTS  Nurse_Cannot_Be_Doctor_I;
DELIMITER $$
CREATE TRIGGER Nurse_Cannot_Be_Doctor_I BEFORE INSERT ON nurse
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT doctor.VAT FROM doctor WHERE doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This employee is an Doctor';
	END IF;
END$$
DELIMITER ;
DROP  TRIGGER  IF  EXISTS  Nurse_Cannot_Be_Doctor_u;
DELIMITER $$
CREATE TRIGGER Nurse_Cannot_Be_Doctor_U BEFORE UPDATE ON nurse
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT doctor.VAT FROM doctor WHERE doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a Nurse. Should first DELETE or UPDATE the Doctor then INSERT the NEW VAT INTO Nurse.';
	END IF;
END$$
DELIMITER ;
#----------------< Tests done >-------------------------------------------------------------------
	INSERT INTO nurse VALUES (998442202);
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;
	INSERT INTO nurse VALUES (998442200);
	SELECT * FROM employee NATURAL JOIN nurse WHERE VAT=998442200;
	
	UPDATE nurse SET VAT = 998442202 WHERE VAT = 998442200;
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;
	SELECT * FROM employee NATURAL JOIN nurse WHERE VAT=998442200;
DROP  TRIGGER  IF  EXISTS  receptionist_Cannot_Be_Doctor_I;
DELIMITER $$
CREATE TRIGGER receptionist_Cannot_Be_Doctor_I BEFORE INSERT ON receptionist
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT doctor.VAT FROM doctor WHERE doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This employee is an Doctor';
	END IF;
END$$
DELIMITER ;
DROP  TRIGGER  IF  EXISTS  receptionist_Cannot_Be_Doctor_U;
DELIMITER $$
CREATE TRIGGER receptionist_Cannot_Be_Doctor_U BEFORE UPDATE ON receptionist
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT doctor.VAT FROM doctor WHERE doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a receptionist. Should first DELETE or UPDATE the Doctor then INSERT the NEW VAT INTO Receptionist.';
	END IF;
END$$
DELIMITER ;
#----------------< Tests done >-------------------------------------------------------------------
	INSERT INTO receptionist VALUES (998442202);
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;
	INSERT INTO receptionist VALUES (998442201);
	SELECT * FROM employee NATURAL JOIN receptionist WHERE VAT=998442201;
	
	UPDATE receptionist SET VAT = 998442202 WHERE VAT = 998442201;
	SELECT * FROM employee NATURAL JOIN doctor WHERE VAT=998442202;
	SELECT * FROM employee NATURAL JOIN receptionist WHERE VAT=998442201;
#------(b)---------------------------------------------------------------------------------------------
# doctors cannot simultaneously be trainees and permanent staff
DROP  TRIGGER  IF  EXISTS  PermanentDoctor_Cannot_Be_TraineeDoctor_I;
DELIMITER $$
CREATE TRIGGER PermanentDoctor_Cannot_Be_TraineeDoctor_I BEFORE INSERT ON permanent_doctor
	FOR EACH ROW
	BEGIN
	IF (EXISTS (SELECT trainee_doctor.VAT FROM trainee_doctor WHERE trainee_doctor.VAT = NEW.VAT)) 
		THEN DELETE 
			FROM trainee_doctor 
			WHERE trainee_doctor.VAT = NEW.VAT;
	END IF;
END$$
DELIMITER ;
DROP  TRIGGER  IF  EXISTS  PermanentDoctor_Cannot_Be_TraineeDoctor_U;
DELIMITER $$
CREATE TRIGGER PermanentDoctor_Cannot_Be_TraineeDoctor_U BEFORE UPDATE ON permanent_doctor
	FOR EACH ROW
	BEGIN
	IF (EXISTS (SELECT trainee_doctor.VAT FROM trainee_doctor WHERE trainee_doctor.VAT = NEW.VAT))
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a Permanent Doctor. Try INSERT INTO permanent_doctor (VAT, years)';
	END IF;
END$$
DELIMITER ;
#----------------< Tests done >-------------------------------------------------------------------
	# Cria três doctor (1 permanent e 2 trainee) para não alterar os valores do populate
	INSERT INTO employee VALUES (998442203,'Trigger_2_permanent', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 23, 2000);
	INSERT INTO employee VALUES (998442204,'Trigger_2_trainee', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 24, 2000);
	INSERT INTO employee VALUES (998442205,'Trigger_2_trainee', '1991-10-7','Broom Banks', 'Estersnow', '4429-551', 25, 2000);
	INSERT INTO doctor VALUES (998442203, 'Orthodontist', 'Description.', 'email23@dentesbrilhantes.com.br');
	INSERT INTO doctor VALUES (998442204, 'Orthodontist', 'Description.', 'email24@dentesbrilhantes.com.br');
	INSERT INTO doctor VALUES (998442205, 'Orthodontist', 'Description.', 'email25@dentesbrilhantes.com.br');
	INSERT INTO trainee_doctor VALUES (998442204, 977442106);
	INSERT INTO trainee_doctor VALUES (998442205, 977442106);

	# Insere um permanent doctor que já é um trainee, e um que não é nada ainda
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN permanent_doctor WHERE VAT=998442203;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN trainee_doctor WHERE VAT=998442204;
	INSERT INTO permanent_doctor VALUES (998442203, 14);
	INSERT INTO permanent_doctor VALUES (998442204, 3);
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN permanent_doctor WHERE VAT=998442203 OR VAT=998442204;

	# Atualiza um permanent doctor que já é uma trainee, e um que não é nada ainda
	UPDATE permanent_doctor SET VAT = 998442205 WHERE VAT = 998442203;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN permanent_doctor WHERE VAT=998442203;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN trainee_doctor WHERE VAT=998442205;
DROP  TRIGGER  IF  EXISTS  TraineeDoctor_Cannot_Be_PermanentDoctor_I;
DELIMITER $$
CREATE TRIGGER TraineeDoctor_Cannot_Be_PermanentDoctor_I BEFORE INSERT ON trainee_doctor
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT permanent_doctor.VAT FROM permanent_doctor WHERE permanent_doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This Doctor is Permanent';
	END IF;
END$$
DELIMITER ;
DROP  TRIGGER  IF  EXISTS  TraineeDoctor_Cannot_Be_PermanentDoctor_U;
DELIMITER $$
CREATE TRIGGER TraineeDoctor_Cannot_Be_PermanentDoctor_U BEFORE UPDATE ON trainee_doctor
	FOR EACH ROW 
	BEGIN
	IF (EXISTS (SELECT permanent_doctor.VAT FROM permanent_doctor WHERE permanent_doctor.VAT = NEW.VAT)) 
		THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot UPDATE VAT from a trainee_doctor. Should first DELETE the trainee_doctor then INSERT the NEW VAT INTO trainee_doctor.';
	END IF;
END$$
DELIMITER ;
#----------------< Tests done >-------------------------------------------------------------------
	INSERT INTO client VALUES (988444861,'Trigger_1', '1902-10-1','Durham Cross', 'Temecula', '8295-433', 'F', 9);
	SELECT * FROM client WHERE VAT=988444861;
	INSERT INTO appointment VALUES (977442106, '2020-1-4 7:00:00', 'Teeth hurt a lot', 988444861);
	SELECT * FROM client WHERE VAT=988444861;
	# Insere um permanent doctor que já é um trainee, e um que não é nada ainda
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN trainee_doctor WHERE VAT=998442205;
	INSERT INTO trainee_doctor VALUES (998442204, 3);
	INSERT INTO trainee_doctor VALUES (998442205, 3);
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN permanent_doctor WHERE VAT=998442203 OR VAT=998442204 OR VAT=998442205;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN trainee_doctor WHERE VAT=998442205;

	# Atualiza um permanent doctor que já é uma trainee, e um que não é nada ainda
	UPDATE trainee_doctor SET VAT = 998442204 WHERE VAT = 998442205;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN permanent_doctor WHERE VAT=998442204;
	SELECT * FROM employee NATURAL JOIN doctor NATURAL JOIN trainee_doctor WHERE VAT=998442204 OR VAT=998442205;





