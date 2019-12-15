SELECT app.name, app.street, app.city, app.zip
FROM (SELECT name, street, city, zip, COUNT(a.date_timestamp) AS count_a
    FROM client AS c, appointment AS a
    WHERE a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    GROUP BY c.VAT) AS app
JOIN
    (SELECT name, street, city, zip, COUNT(con.date_timestamp) AS count_b
    FROM client AS c, appointment AS a, consultation AS con
    WHERE a.VAT_client = c.VAT
    AND a.VAT_doctor = con.VAT_doctor
    AND a.date_timestamp LIKE '2019%'
    AND a.date_timestamp = con.date_timestamp
    GROUP BY c.VAT) co
ON app.count_a = co.count_b
AND app.name = co.name
AND app.street = co.street
AND app.city = co.city
AND app.zip = co.zip;