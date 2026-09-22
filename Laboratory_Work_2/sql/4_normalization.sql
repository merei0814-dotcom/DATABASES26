CREATE TABLE Booking_receipt (
booking_id INT NOT NULL,
passenger_full_name VARCHAR(100) NOT NULL,
passenger_passport_number VARCHAR(20) NOT NULL,
flight_number VARCHAR(20) NOT NULL,
departure_airport_name VARCHAR(100) NOT NULL,
departure_city VARCHAR(50) NOT NULL,
arrival_airport_name VARCHAR(100) NOT NULL,
arrival_city VARCHAR(50) NOT NULL,
airline_name VARCHAR(100) NOT NULL,
seat_numbers VARCHAR(100) NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL
);

INSERT INTO Booking_receipt VALUES
(1, 'John Smith', 'P10001', 'KC101', 'Almaty International Airport', 'Almaty', 'Nursultan Nazarbayev International Airport', 'Astana', 'Air Astana', '12A, 12B', 120000.00),
(2, 'Alice Brown', 'P10002', 'DV701', 'Almaty International Airport', 'Almaty', 'Aktau International Airport', 'Aktau', 'SCAT Airlines', '15C', 95000.00),
(3, 'Jane Smith', 'P10003', 'KC201', 'Nursultan Nazarbayev International Airport', 'Astana', 'Almaty International Airport', 'Almaty', 'Air Astana', '14B', 125000.00),
(4, 'Michael Lee', 'P10004', 'LH100', 'Frankfurt Airport', 'Frankfurt', 'Istanbul Airport', 'Istanbul', 'Lufthansa', '3A', 210000.00),
(5, 'David Wilson', 'P10005', 'TK350', 'Istanbul Airport', 'Istanbul', 'Almaty International Airport', 'Almaty', 'Turkish Airlines', '8D', 180000.00);


CREATE TABLE Booking_receipt_1NF (
booking_id INT NOT NULL,
passenger_full_name VARCHAR(100) NOT NULL,
passenger_passport_number VARCHAR(20) NOT NULL,
flight_number VARCHAR(20) NOT NULL,
departure_airport_name VARCHAR(100) NOT NULL,
departure_city VARCHAR(50) NOT NULL,
arrival_airport_name VARCHAR(100) NOT NULL,
arrival_city VARCHAR(50) NOT NULL,
airline_name VARCHAR(100) NOT NULL,
seat_number VARCHAR(10) NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL,
PRIMARY KEY (booking_id, passenger_passport_number)
);
CREATE TABLE Booking_2NF (
booking_id INT PRIMARY KEY,
flight_number VARCHAR(20) NOT NULL,
departure_airport_name VARCHAR(100) NOT NULL,
departure_city VARCHAR(50) NOT NULL,
arrival_airport_name VARCHAR(100) NOT NULL,
arrival_city VARCHAR(50) NOT NULL,
airline_name VARCHAR(100) NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL
);
CREATE TABLE Passenger_2NF (
passenger_passport_number VARCHAR(20) PRIMARY KEY,
passenger_full_name VARCHAR(100) NOT NULL
);
CREATE TABLE Booking_Passenger_2NF (
booking_id INT NOT NULL,
passenger_passport_number VARCHAR(20) NOT NULL,
seat_number VARCHAR(10) NOT NULL,
PRIMARY KEY (booking_id, passenger_passport_number),
FOREIGN KEY (booking_id) REFERENCES Booking_2NF(booking_id),
FOREIGN KEY (passenger_passport_number) REFERENCES Passenger_2NF(passenger_passport_number)
);
CREATE TABLE Booking_Passenger_3NF (
booking_id INT NOT NULL,
passenger_passport_number VARCHAR(20) NOT NULL,
seat_number VARCHAR(10) NOT NULL,
PRIMARY KEY (booking_id, passenger_passport_number, seat_number),
FOREIGN KEY (booking_id) REFERENCES Booking_3NF(booking_id),
FOREIGN KEY (passenger_passport_number) REFERENCES Passenger_3NF(passenger_passport_number)
);

CREATE TABLE Airline_3NF (
airline_id INT PRIMARY KEY,
airline_name VARCHAR(100) NOT NULL
);

CREATE TABLE Airport_3NF (
airport_id INT PRIMARY KEY,
airport_name VARCHAR(100) NOT NULL,
city VARCHAR(50) NOT NULL
);

CREATE TABLE Flight_3NF (
flight_id INT PRIMARY KEY,
flight_number VARCHAR(20) NOT NULL,
departure_airport_id INT NOT NULL,
arrival_airport_id INT NOT NULL,
airline_id INT NOT NULL,
FOREIGN KEY (departure_airport_id) REFERENCES Airport_3NF(airport_id),
FOREIGN KEY (arrival_airport_id) REFERENCES Airport_3NF(airport_id),
FOREIGN KEY (airline_id) REFERENCES Airline_3NF(airline_id)
);

CREATE TABLE Booking_3NF (
booking_id INT PRIMARY KEY,
flight_id INT NOT NULL,
ticket_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (flight_id) REFERENCES Flight_3NF(flight_id)
);

CREATE TABLE Passenger_3NF (
passenger_passport_number VARCHAR(20) PRIMARY KEY,
passenger_full_name VARCHAR(100) NOT NULL
);

CREATE TABLE Booking_Passenger_3NF (
booking_id INT NOT NULL,
passenger_passport_number VARCHAR(20) NOT NULL,
seat_number VARCHAR(10) NOT NULL,
PRIMARY KEY (booking_id, passenger_passport_number, seat_number),
FOREIGN KEY (booking_id) REFERENCES Booking_3NF(booking_id),
FOREIGN KEY (passenger_passport_number) REFERENCES Passenger_3NF(passenger_passport_number)
);

INSERT INTO Airline_3NF VALUES
(1, 'Air Astana'),
(2, 'SCAT Airlines'),
(3, 'Lufthansa'),
(4, 'Turkish Airlines');

INSERT INTO Airport_3NF VALUES
(1, 'Almaty International Airport', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Astana'),
(3, 'Aktau International Airport', 'Aktau'),
(4, 'Frankfurt Airport', 'Frankfurt'),
(5, 'Istanbul Airport', 'Istanbul');

INSERT INTO Flight_3NF VALUES
(1, 'KC101', 1, 2, 1),
(2, 'DV701', 1, 3, 2),
(3, 'KC201', 2, 1, 1),
(4, 'LH100', 4, 5, 3),
(5, 'TK350', 5, 1, 4);

INSERT INTO Booking_3NF VALUES
(1, 1, 120000.00),
(2, 2, 95000.00),
(3, 3, 125000.00),
(4, 4, 210000.00),
(5, 5, 180000.00);

INSERT INTO Passenger_3NF VALUES
('P10001', 'John Smith'),
('P10002', 'Alice Brown'),
('P10003', 'Jane Smith'),
('P10004', 'Michael Lee'),
('P10005', 'David Wilson');

INSERT INTO Booking_Passenger_3NF VALUES
(1, 'P10001', '12A'),
(1, 'P10001', '12B'),
(2, 'P10002', '15C'),
(3, 'P10003', '14B'),
(4, 'P10004', '3A'),
(5, 'P10005', '8D');

SELECT * FROM Airline_3NF;
SELECT * FROM Airport_3NF;
SELECT * FROM Flight_3NF;
SELECT * FROM Booking_3NF;
SELECT * FROM Passenger_3NF;
SELECT * FROM Booking_Passenger_3NF;

