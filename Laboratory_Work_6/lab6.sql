SELECT a.airline_id, a.airline_name
FROM airline a
LEFT JOIN flights f
    ON a.airline_id = f.airline_id
    AND f.sch_departure_time >= '2026-12-01'
    AND f.sch_departure_time <  '2027-01-01'
WHERE f.flight_id IS NULL;