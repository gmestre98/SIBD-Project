SELECT 
    AVG(n0.cnurse) AS Nurse_avg_less_18,
    AVG(n1.cnurse) AS Nurse_avg_more_18,
    AVG(p0.cproced) AS Procedures_avg_less_18,
    AVG(p1.cproced) AS Procedures_avg_more_18,
    AVG(d0.diag) AS Diagnostics_avg_less_18,
    AVG(d1.diag) AS Diagnostics_avg_more_18,
    AVG(pr0.presc) AS Prescriptions_avg_less_18,
    AVG(pr1.presc) AS Prescriptions_avg_more_18
FROM
    (SELECT COUNT(DISTINCT VAT_nurse) as cnurse
    FROM consultation_assistant AS ca, appointment AS a, client AS c
    WHERE ca.VAT_doctor = a.VAT_doctor
    AND ca.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age <= 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS n0,

    (SELECT COUNT(DISTINCT VAT_nurse) as cnurse
    FROM consultation_assistant AS ca, appointment AS a, client AS c
    WHERE ca.VAT_doctor = a.VAT_doctor
    AND ca.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age > 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS n1,

   (SELECT COUNT(DISTINCT pc.name) AS cproced
    FROM procedure_in_consultation AS pc, appointment AS a, client AS c
    WHERE pc.VAT_doctor = a.VAT_doctor
    AND pc.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age <= 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS p0,

    (SELECT COUNT(DISTINCT pc.name) AS cproced
    FROM procedure_in_consultation AS pc, appointment AS a, client AS c
    WHERE pc.VAT_doctor = a.VAT_doctor
    AND pc.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age > 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS p1,
    
   (SELECT COUNT(DISTINCT cd.ID) AS diag
    FROM consultation_diagnostic AS cd, appointment AS a, client AS c
    WHERE cd.VAT_doctor = a.VAT_doctor
    AND cd.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age <= 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS d0,

    (SELECT COUNT(DISTINCT cd.ID) AS diag
    FROM consultation_diagnostic AS cd, appointment AS a, client AS c
    WHERE cd.VAT_doctor = a.VAT_doctor
    AND cd.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age > 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS d1,

   (SELECT COUNT(DISTINCT pr.name) AS presc
    FROM prescription AS pr, appointment AS a, client AS c
    WHERE pr.VAT_doctor = a.VAT_doctor
    AND pr.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age <= 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS pr0,

    (SELECT COUNT(DISTINCT pr.name) AS presc
    FROM prescription AS pr, appointment AS a, client AS c
    WHERE pr.VAT_doctor = a.VAT_doctor
    AND pr.date_timestamp = a.date_timestamp
    AND a.VAT_client = c.VAT
    AND a.date_timestamp LIKE '2019%'
    AND c.age > 18
    GROUP BY a.VAT_doctor, a.date_timestamp) AS pr1
;