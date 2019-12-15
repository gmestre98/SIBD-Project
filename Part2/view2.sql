DROP view IF EXISTS dim_client;
CREATE VIEW dim_client AS
SELECT VAT, gender, age
FROM client;
