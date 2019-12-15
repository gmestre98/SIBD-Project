DROP view IF EXISTS dim_location_client;
CREATE VIEW dim_location_client AS
SELECT zip, city
FROM client;