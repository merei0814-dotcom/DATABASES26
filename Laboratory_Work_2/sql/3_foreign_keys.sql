ALTER TABLE Security_check
ADD CONSTRAINT fk_security_check_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

ALTER TABLE Booking
ADD CONSTRAINT fk_booking_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_passenger
FOREIGN KEY (passenger_id)
REFERENCES Passengers(passenger_id);

ALTER TABLE Baggage_check
ADD CONSTRAINT fk_baggage_check_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Baggage
ADD CONSTRAINT fk_baggage_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Boarding_pass
ADD CONSTRAINT fk_boarding_pass_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_booking
FOREIGN KEY (booking_id)
REFERENCES Booking(booking_id);

ALTER TABLE Booking_flight
ADD CONSTRAINT fk_booking_flight_flight
FOREIGN KEY (flight_id)
REFERENCES Flights(flight_id);

ALTER TABLE Flights
ADD CONSTRAINT fk_flight_departing_airport
FOREIGN KEY (departing_airport_id)
REFERENCES Airport(airport_id);

ALTER TABLE Flights
ADD CONSTRAINT fk_flight_arriving_airport
FOREIGN KEY (arriving_airport_id)
REFERENCES Airport(airport_id);

ALTER TABLE Flights
ADD CONSTRAINT fk_flight_airline
FOREIGN KEY (airline_id)
REFERENCES airline(airline_id);