
CREATE TABLE airport (
                         airport_id SERIAL PRIMARY KEY,
                         airport_name VARCHAR(100) NOT NULL,
                         country VARCHAR(50),
                         state VARCHAR(50),
                         city VARCHAR(50),
                         created_at TIMESTAMP DEFAULT NOW(),
                         updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE airline (
                         airline_id SERIAL PRIMARY KEY,
                         airline_code VARCHAR(10) UNIQUE NOT NULL,
                         name VARCHAR(100) NOT NULL,
                         country VARCHAR(50),
                         created_at TIMESTAMP DEFAULT NOW(),
                         updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE passenger (
                           passenger_id SERIAL PRIMARY KEY,
                           first_name VARCHAR(50) NOT NULL,
                           last_name VARCHAR(50) NOT NULL,
                           gender VARCHAR(10),
                           date_of_birth DATE,
                           country_of_citizenship VARCHAR(50),
                           country_of_residence VARCHAR(50),
                           passport_number VARCHAR(20) UNIQUE NOT NULL,
                           created_at TIMESTAMP DEFAULT NOW(),
                           updated_at TIMESTAMP DEFAULT NOW()
);


-- =========================================
-- 2. MIDDLE LEVEL
-- =========================================

CREATE TABLE flight (
                        flight_id SERIAL PRIMARY KEY,

                        airline_id INT NOT NULL
                            REFERENCES airline(airline_id),

                        departure_airport_id INT NOT NULL
                            REFERENCES airport(airport_id),

                        arrival_airport_id INT NOT NULL
                            REFERENCES airport(airport_id),

                        departing_gate VARCHAR(10),
                        arriving_gate VARCHAR(10),

                        scheduled_departure_time TIMESTAMP NOT NULL,
                        scheduled_arrival_time TIMESTAMP NOT NULL,

                        actual_departure_time TIMESTAMP,
                        actual_arrival_time TIMESTAMP,

                        created_at TIMESTAMP DEFAULT NOW(),
                        updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE booking (
                         booking_id SERIAL PRIMARY KEY,

                         flight_id INT NOT NULL
                             REFERENCES flight(flight_id),

                         passenger_id INT NOT NULL
                             REFERENCES passenger(passenger_id),

                         status VARCHAR(20),
                         booking_platform VARCHAR(50),
                         ticket_price NUMERIC(10,2),

                         created_at TIMESTAMP DEFAULT NOW(),
                         updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE booking_change (
                                booking_change_id SERIAL PRIMARY KEY,

                                booking_id INT NOT NULL
                                    REFERENCES booking(booking_id),

                                change_description VARCHAR(255),

                                old_flight_id INT
                                    REFERENCES flight(flight_id),

                                new_flight_id INT
                                    REFERENCES flight(flight_id),

                                created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE boarding_pass (
                               boarding_pass_id SERIAL PRIMARY KEY,

                               booking_id INT NOT NULL UNIQUE
                                   REFERENCES booking(booking_id),

                               seat VARCHAR(10),
                               boarding_time TIMESTAMP,

                               created_at TIMESTAMP DEFAULT NOW(),
                               updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE baggage (
                         baggage_id SERIAL PRIMARY KEY,

                         booking_id INT NOT NULL
                             REFERENCES booking(booking_id),

                         weight_kg NUMERIC(5,2),

                         created_at TIMESTAMP DEFAULT NOW(),
                         updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE baggage_check (
                               baggage_check_id SERIAL PRIMARY KEY,

                               baggage_id INT NOT NULL UNIQUE
                                   REFERENCES baggage(baggage_id),

                               passenger_id INT NOT NULL
                                   REFERENCES passenger(passenger_id),

                               booking_id INT NOT NULL
                                   REFERENCES booking(booking_id),

                               check_result VARCHAR(50),

                               created_at TIMESTAMP DEFAULT NOW(),
                               updated_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE security_check (
                                security_check_id SERIAL PRIMARY KEY,

                                passenger_id INT NOT NULL
                                    REFERENCES passenger(passenger_id),

                                check_result VARCHAR(50),

                                created_at TIMESTAMP DEFAULT NOW(),
                                updated_at TIMESTAMP DEFAULT NOW()
);