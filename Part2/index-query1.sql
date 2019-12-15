CREATE INDEX client_name
ON client(name);

CREATE INDEX appointment_vat_client
ON appointment(VAT_client);

CREATE INDEX phone_client_vat
ON phone_number_client(VAT);
