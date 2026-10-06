SELECT UPPER(airline_name) AS airline_name_uppercase
FROM airline;

SELECT REPLACE(airline_name, 'Air', 'Aero') AS modified_airline_name
FROM airline;

SELECT flight_id
FROM flights
WHERE airline_id IN (1, 2);

SELECT *
FROM airport
WHERE airport_name ILIKE '%Reginal%'

  AND airport_name ILIKE '%Air%';




SELECT
    first_name,
    last_name,
    TO_CHAR(date_of_birth, 'FMMonth DD, YYYY') AS formatted_birth_date
FROM passengers;

SELECT DISTINCT flight_id
FROM flights
WHERE act_arrival_time > sch_arrival_time;




SELECT *
FROM flights
WHERE act_arrival_time > sch_arrival_time;

SELECT *
FROM airline
WHERE airline_country IN ('France', 'Portugal', 'Poland')
  AND created_at BETWEEN '2023-11-01' AND '2024-03-31';

SELECT *
FROM baggage
WHERE weight_in_kg > 25
ORDER BY weight_in_kg DESC
LIMIT 3;

SELECT CONCAT(first_name, ' ', last_name) AS full_name, date_of_birth
FROM passengers
ORDER BY date_of_birth DESC
LIMIT 1;

SELECT
    booking_platform,
    MIN(ticket_price) AS cheapest_price
FROM booking
GROUP BY booking_platform;

SELECT *
FROM airline
WHERE airline_code ~ '[0-9]';

SELECT *
FROM airline
ORDER BY created_at DESC
LIMIT 5;

SELECT *
FROM baggage_check
WHERE booking_id BETWEEN 200 AND 300
  AND check_result <> 'Checked';

SELECT *
FROM baggage_check
WHERE DATE_TRUNC('month', updated_at) = DATE_TRUNC('month', created_at)
  AND updated_at < created_at;