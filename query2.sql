SELECT e.name, t.VAT,     
    (SELECT e1.name
    FROM employee AS e1
    WHERE e1.VAT = t.supervisor) AS doctor_name,
    r.evaluation, r.description
FROM trainee_doctor AS t, employee AS e, supervision_report AS r
WHERE t.VAT = e.VAT
AND r.VAT = t.VAT
AND (r.evaluation < 3
OR r.description LIKE '%insufficient%')
ORDER BY r.evaluation DESC;