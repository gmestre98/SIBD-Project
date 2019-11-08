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
FROM client cl, appointment a1, consultation c
WHERE cl.VAT = a1.VAT_client
AND a1.VAT_doctor = c.VAT_doctor
AND a1.date_timestamp = c.date_timestamp
AND (SOAP_O LIKE '%gingivitis%' OR SOAP_O LIKE '%periodontitis%')
AND date_timestamp = (SELECT MAX(date_timestamp) FROM appointment a2 WHERE a1.VAT_client = a2.VAT_client)
ORDER BY name ASC;

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

/** ------------------------------------------- 5 ------------------------------------------**/
/** 5. For each possible diagnosis, presenting the code together with the
description, list the number of distinct medication names that have
been prescribed to treat that condition. Sort the results according
to the number of distinct medication names, in ascending order.**/

SELECT DISTINCT diagnostic_code.ID, diagnostic_code.description, COUNT(DISTINCT prescription.name) AS n_medication
FROM diagnostic_code
LEFT JOIN consultation_diagnostic
USING (ID)
LEFT JOIN prescription
USING (ID)
GROUP BY diagnostic_code.ID
ORDER BY COUNT(DISTINCT prescription.name);

SELECT DISTINCT d.ID, d.description, COUNT(DISTINCT p.name) AS number_medication
FROM diagnostic_code d, prescription p
WHERE d.ID = p.ID
GROUP BY d.ID
ORDER BY COUNT(DISTINCT p.name) ASC;

/** ------------------------------------------- UPDATE 2 ------------------------------------------**/

select VAT, salary
from employee e
where (select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;

update employee e
set salary = 1.05*salary
where ( select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;

select VAT, salary
from employee e
where (select count(*)
	from appointment a
	where e.VAT = a.VAT_doctor
	and year(a.date_timestamp)=2019
	group by VAT_doctor) > 100;

/** ------------------------------------------- UPDATE 3 ------------------------------------------**/

select e.name, count(distinct e.VAT), count(distinct d.VAT), count(a.VAT_doctor), count(c.VAT_doctor)
from employee e, doctor d, appointment a, consultation c
where e.VAT = d.VAT
and a.VAT_doctor = d.VAT
and e.name = 'Waylon Glisson'
group by a.VAT_doctor;

select e.name, count(e.VAT), count(d.VAT)
from employee e, doctor d
where e.VAT = d.VAT
and e.name = 'Waylon Glisson';


select *
from employee e NATURAL JOIN doctor d
RIGHT OUTER JOIN appointment a
ON d.VAT = a.VAT_doctor
NATURAL LEFT OUTER JOIN consultation c
WHERE e.name = 'Waylon Glisson';





select e.name, count(distinct e.VAT), count(distinct d.VAT), count(a.VAT_doctor), count(c.VAT_doctor), count(pc.VAT_doctor IS NOT NULL)
from employee e, doctor d LEFT OUTER JOIN appointment a 
ON d.VAT = a.VAT_doctor
NATURAL LEFT OUTER JOIN consultation c 
LEFT OUTER JOIN procedure_in_consultation pc
ON c.VAT_doctor = pc.VAT_doctor
where  e.VAT = d.VAT
and e.name = 'Waylon Glisson'
group by e.VAT;


delete from doctor
where VAT in (select VAT from employee
where name = 'Waylon Glisson');







/** ------------------------------------------- UPDATE 4 ------------------------------------------**/









