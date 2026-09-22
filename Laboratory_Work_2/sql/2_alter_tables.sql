ALTER TABLE flights
    ALTER COLUMN departing_gate TYPE TEXT;

ALTER TABLE airline
    DROP COLUMN info;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'airline'
ORDER BY ordinal_position;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'booking'
ORDER BY ordinal_position;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'flights'
ORDER BY ordinal_position;