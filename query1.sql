SELECT DISTINCT c.VAT, c.name, phone
FROM employee AS e, appointment AS a, consultation AS con, client AS c LEFT OUTER JOIN phone_number_client
ON c.VAT = phone_number_client.VAT
WHERE e.VAT = con.VAT_doctor
AND con.VAT_doctor = a.VAT_doctor AND con.date_timestamp = a.date_timestamp
AND c.VAT = a.VAT_client
AND e.name = 'Jane Sweettooth'
ORDER BY c.name;