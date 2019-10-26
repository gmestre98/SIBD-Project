SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS phone_number_employee;
DROP TABLE IF EXISTS receptionist;
DROP TABLE IF EXISTS doctor;
DROP TABLE IF EXISTS nurse;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS phone_number_client;
DROP TABLE IF EXISTS permanent_doctor;
DROP TABLE IF EXISTS trainee_doctor;
DROP TABLE IF EXISTS supervision_report;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS consultation;
DROP TABLE IF EXISTS consultation_assistant;
DROP TABLE IF EXISTS diagnostic_code;
DROP TABLE IF EXISTS diagnostic_code_relation;
DROP TABLE IF EXISTS consultation_diagnostic;
DROP TABLE IF EXISTS medication;
DROP TABLE IF EXISTS prescription;
DROP TABLE IF EXISTS proceduretable;
DROP TABLE IF EXISTS procedure_in_consultation;
DROP TABLE IF EXISTS procedure_radiology;
DROP TABLE IF EXISTS teeth;
DROP TABLE IF EXISTS procedure_charting;
SET FOREIGN_KEY_CHECKS=1;


CREATE TABLE employee
	(VAT INTEGER,
	name VARCHAR(15),
	birth_date DATE,
	street VARCHAR(35),
	city VARCHAR(15),
	zip VARCHAR(15),
	IBAN INTEGER,
	salary INTEGER,
	PRIMARY KEY(VAT),
	UNIQUE(IBAN),
	CHECK(salary > 0));
	
	
CREATE TABLE phone_number_employee
	(VAT INTEGER,
	phone INTEGER,
	PRIMARY KEY(VAT, phone),
	FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE);


CREATE TABLE receptionist
	(VAT INTEGER,
	PRIMARY KEY(VAT),
	FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE);


CREATE TABLE doctor
	(VAT INTEGER,
	specialization VARCHAR(15),
	biography VARCHAR(255),
	email VARCHAR(35),
	PRIMARY KEY(VAT),
	FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE,
	UNIQUE(email));
	
	
CREATE TABLE nurse
	(VAT INTEGER,
	PRIMARY KEY(VAT),
	FOREIGN KEY(VAT) REFERENCES employee(VAT) ON DELETE CASCADE);


CREATE TABLE client
	(VAT INTEGER,
	name VARCHAR(15),
	birth_date DATE,
	street VARCHAR(35),
	city VARCHAR(15),
	zip VARCHAR(15),
	gender VARCHAR(15),
	age INTEGER,
	PRIMARY KEY(VAT),
	CHECK(age > 0));
	
	
CREATE TABLE phone_number_client
	(VAT INTEGER,
	phone INTEGER,
	PRIMARY KEY(VAT, phone),
	FOREIGN KEY(VAT) REFERENCES client(VAT) ON DELETE CASCADE);


CREATE TABLE permanent_doctor
	(VAT INTEGER,
	years INTEGER,
	PRIMARY KEY(VAT),
	FOREIGN KEY(VAT) REFERENCES doctor(VAT) ON DELETE CASCADE);
	
	
CREATE TABLE trainee_doctor
	(VAT INTEGER,
	supervisor INTEGER,
	PRIMARY KEY(VAT),
	FOREIGN KEY(VAT) REFERENCES doctor(VAT) ON DELETE CASCADE,
	FOREIGN KEY(supervisor) REFERENCES permanent_doctor(VAT) ON DELETE CASCADE);
	
	
CREATE TABLE supervision_report
	(VAT INTEGER,
	date_timestamp TIMESTAMP,
	description VARCHAR(255) NOT NULL,
	evaluation INTEGER,
	PRIMARY KEY(VAT, date_timestamp),
	FOREIGN KEY(VAT) REFERENCES trainee_doctor(VAT) ON DELETE CASCADE,
	CHECK(evaluation >= 1),
	CHECK(evaluation <= 5));
	
	
CREATE TABLE appointment
	(VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	description VARCHAR(255),
	VAT_client INTEGER,
	PRIMARY KEY(VAT_doctor, date_timestamp),
	FOREIGN KEY(VAT_doctor) REFERENCES doctor(VAT) ON DELETE CASCADE,
	FOREIGN KEY(VAT_client) REFERENCES client(VAT) ON DELETE CASCADE);
	

CREATE TABLE consultation
	(VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	SOAP_S VARCHAR(255),
	SOAP_O VARCHAR(255),
	SOAP_A VARCHAR(255),
	SOAP_P VARCHAR(255),
	PRIMARY KEY(VAT_doctor, date_timestamp),
	FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES appointment(VAT_doctor, date_timestamp) ON DELETE CASCADE);
	

CREATE TABLE consultation_assistant
	(VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	VAT_nurse INTEGER,
	PRIMARY KEY(VAT_doctor, date_timestamp),
	FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES appointment(VAT_doctor, date_timestamp) ON DELETE CASCADE,
	FOREIGN KEY(VAT_nurse) REFERENCES nurse(VAT) ON DELETE CASCADE);


CREATE TABLE diagnostic_code
	(ID INTEGER,
	description VARCHAR(255),
	PRIMARY KEY(ID));
	

CREATE TABLE diagnostic_code_relation
	(ID1 INTEGER,
	ID2 INTEGER,
	type_ VARCHAR(255),
	PRIMARY KEY(ID1, ID2),
	FOREIGN KEY(ID1) REFERENCES diagnostic_code(ID) ON DELETE CASCADE,
	FOREIGN KEY(ID2) REFERENCES diagnostic_code(ID) ON DELETE CASCADE);
	
	
CREATE TABLE consultation_diagnostic
	(VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	ID INTEGER,
	PRIMARY KEY(VAT_doctor, date_timestamp, ID),
	FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES consultation(VAT_doctor, date_timestamp) ON DELETE CASCADE,
	FOREIGN KEY(ID) REFERENCES diagnostic_code(ID) ON DELETE CASCADE);
	

CREATE TABLE medication
	(name VARCHAR(15),
	lab VARCHAR(35),
	PRIMARY KEY(name, lab));


CREATE TABLE prescription
	(name VARCHAR(15),
	lab VARCHAR(35),
	VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	ID INTEGER,
	dosage INTEGER,
	description VARCHAR(255),
	PRIMARY KEY(name, lab, VAT_doctor, date_timestamp, ID),
	FOREIGN KEY(name, lab) REFERENCES medication(name, lab) ON DELETE CASCADE,
	FOREIGN KEY(VAT_doctor, date_timestamp, ID) REFERENCES
		consultation_diagnostic(VAT_doctor, date_timestamp, ID) ON DELETE CASCADE);
		
	
CREATE TABLE proceduretable
	(name VARCHAR(15),
	type_ VARCHAR(35),
	PRIMARY KEY(name));
	
	
CREATE TABLE procedure_in_consultation
	(name VARCHAR(15),
	VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	description VARCHAR(255),
	PRIMARY KEY(name, VAT_doctor, date_timestamp),
	FOREIGN KEY(name) REFERENCES proceduretable(name) ON DELETE CASCADE,
	FOREIGN KEY(VAT_doctor, date_timestamp) REFERENCES consultation(VAT_doctor, date_timestamp) ON DELETE CASCADE);


CREATE TABLE procedure_radiology
	(name VARCHAR(15),
	file_ VARCHAR(35),
	VAT_doctor INTEGER,
	date_timestamp TIMESTAMP,
	PRIMARY KEY(name, file_, VAT_doctor, date_timestamp),
	FOREIGN KEY(name, VAT_doctor, date_timestamp) REFERENCES
		procedure_in_consultation(name, VAT_doctor, date_timestamp) ON DELETE CASCADE);
		

CREATE TABLE teeth
	(quadrant INTEGER,
	number_ INTEGER,
	name VARCHAR(15),
	PRIMARY KEY(quadrant, number_));
	

CREATE TABLE procedure_charting
	(name VARCHAR(15),
	VAT INTEGER,
	date_timestamp TIMESTAMP,
	quadrant INTEGER,
	number_ INTEGER,
	desc_ VARCHAR(255),
	measure INTEGER,
	PRIMARY KEY(name, VAT, date_timestamp, quadrant, number_),
	FOREIGN KEY(name, VAT, date_timestamp) REFERENCES
		procedure_in_consultation(name, VAT_doctor, date_timestamp) ON DELETE CASCADE,
	FOREIGN KEY(quadrant, number_) REFERENCES teeth(quadrant, number_) ON DELETE CASCADE);