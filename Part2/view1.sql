DROP view IF EXISTS dim_date;
CREATE VIEW dim_date AS
SELECT date_timestamp, DAY(date_timestamp) AS day, MONTH(date_timestamp) AS month, YEAR(date_timestamp) AS year
FROM consultation;