ALTER TABLE passengers
ADD CONSTRAINT check_passenger_age
CHECK (date_of_birth <= DATE '2016-10-12');

ALTER TABLE booking
ADD CONSTRAINT check_booking_price
CHECK (ticket_price >= 0 AND ticket_price <= 50000)

ALTER TABLE baggage
ADD CONSTRAINT check_baggage_weight
CHECK (weight_in_kg >= 1 AND weight_in_kg <= 23);

ALTER TABLE airport
ADD CONSTRAINT check_airport_name_length
CHECK (LENGTH(airport_name) >= 10);

ALTER TABLE passengers
ADD CONSTRAINT uq_passengers_passport
UNIQUE (passport_number);

ALTER TABLE passengers
ADD CONSTRAINT check_passenger_gender_age
CHECK (
    (gender = 'Male' AND date_of_birth <= DATE '2008-10-12')
    OR
    (gender = 'Female' AND date_of_birth <= DATE '2007-10-12')
);

ALTER TABLE passengers
ADD CONSTRAINT check_citizenship_age
CHECK (
    (country_of_citizenship = 'Kazakhstan'
     AND date_of_birth <= DATE '2008-10-12')
    OR
    (country_of_citizenship = 'France'
     AND date_of_birth <= DATE '2009-10-12')
    OR
    (country_of_citizenship NOT IN ('Kazakhstan', 'France')
     AND date_of_birth <= DATE '2007-10-12')
);

SELECT passenger_id, country_of_citizenship, date_of_birth
FROM passengers
WHERE (country_of_citizenship = 'Kazakhstan'
       AND date_of_birth > DATE '2008-10-12')
   OR (country_of_citizenship = 'France'
       AND date_of_birth > DATE '2009-10-12')
   OR (country_of_citizenship NOT IN ('Kazakhstan', 'France')
       AND date_of_birth > DATE '2007-10-12');

ALTER TABLE booking
ADD CONSTRAINT check_ticket_discount
CHECK (
    (created_at > DATE '2024-01-01'
     AND ticket_discount = ROUND(ticket_price * 0.05, 2))
    OR
    (created_at < DATE '2024-01-01'
     AND ticket_discount = ROUND(ticket_price * 0.10, 2))
);


ALTER TABLE booking
ALTER COLUMN status SET DEFAULT 'Confirmed';

SELECT booking_id, booking_platform, status, ticket_price
FROM booking
ORDER BY booking_id DESC
LIMIT 1;

INSERT INTO booking (
    booking_id,
    flight_id,
    passenger_id,
    booking_platform,
    created_at,
    updated_at,
    ticket_price
)
VALUES (
    1003,
    1,
    1,
    'Online',
    CURRENT_DATE,
    CURRENT_DATE,
    500
);


ALTER TABLE booking
ALTER COLUMN created_at
SET DEFAULT CURRENT_DATE;




