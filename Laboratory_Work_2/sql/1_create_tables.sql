CREATE TABLE Airline_info(
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    info VARCHAR(50) NOT NULL
);

CREATE TABLE Baggage_check (
                               baggage_check_id INT PRIMARY KEY,
                               check_result VARCHAR(50) NOT NULL,
                               created_at TIMESTAMP NOT NULL,
                               updated_at TIMESTAMP NOT NULL,
                               booking_id INT NOT NULL,
                               passenger_id INT NOT NULL
);

CREATE TABLE Baggage (
                         baggage_id INT PRIMARY KEY,
                         weight_in_kg DECIMAL(4,2) NOT NULL,
                         created_at TIMESTAMP NOT NULL,
                         updated_at TIMESTAMP NOT NULL,
                         booking_id INT NOT NULL
);

CREATE TABLE Boarding_pass (
                               boarding_pass_id INT PRIMARY KEY,
                               booking_id INT NOT NULL,
                               seat VARCHAR(50) NOT NULL,
                               boarding_time TIMESTAMP NOT NULL,
                               created_at TIMESTAMP NOT NULL,
                               updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking_flight (
                                booking_flight_id INT PRIMARY KEY,
                                booking_id INT NOT NULL,
                                flight_id INT NOT NULL,
                                created_at TIMESTAMP NOT NULL,
                                updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking (
                         booking_id INT PRIMARY KEY,
                         flight_id INT NOT NULL,
                         passenger_id INT NOT NULL,
                         booking_platform VARCHAR(50) NOT NULL,
                         created_at TIMESTAMP NOT NULL,
                         updated_at TIMESTAMP NOT NULL,
                         status VARCHAR(50) NOT NULL,
                         price DECIMAL(7,2) NOT NULL
);

CREATE TABLE Flights (
                         flight_id INT PRIMARY KEY,
                         sch_departure_time TIMESTAMP NOT NULL,
                         sch_arrival_time TIMESTAMP NOT NULL,
                         departing_airport_id INT NOT NULL,
                         arriving_airport_id INT NOT NULL,
                         departing_gate VARCHAR(50) NOT NULL,
                         arriving_gate VARCHAR(50) NOT NULL,
                         airline_id INT NOT NULL,
                         act_departure_time TIMESTAMP NOT NULL,
                         act_arrival_time TIMESTAMP NOT NULL,
                         created_at TIMESTAMP NOT NULL,
                         updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Passengers (
                            passenger_id INT PRIMARY KEY,
                            first_name VARCHAR(50) NOT NULL,
                            last_name VARCHAR(50) NOT NULL,
                            date_of_birth DATE NOT NULL,
                            gender VARCHAR(50) NOT NULL,
                            country_of_citizenship VARCHAR(50) NOT NULL,
                            country_of_residence VARCHAR(50) NOT NULL,
                            passport_number VARCHAR(20) NOT NULL,
                            created_at TIMESTAMP NOT NULL,
                            updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Security_check (
                                security_check_id INT PRIMARY KEY,
                                check_result VARCHAR(20) NOT NULL,
                                created_at TIMESTAMP NOT NULL,
                                updated_at TIMESTAMP NOT NULL,
                                passenger_id INT NOT NULL
);
CREATE TABLE Airport (
                         airport_id INT PRIMARY KEY,
                         airport_name VARCHAR(50) NOT NULL,
                         country VARCHAR(50) NOT NULL,
                         state VARCHAR(50) NOT NULL,
                         city VARCHAR(50) NOT NULL,
                         created_at TIMESTAMP NOT NULL,
                         updated_at TIMESTAMP NOT NULL
);

INSERT INTO airport
(airport_id, airport_name, country, state, city, created_at, updated_at)
VALUES
(1, 'Alatau International Airport', 'Kazakhstan', 'Almaty Region', 'Almaty', NOW(), NOW()),
(2, 'Golden Steppe Airport', 'Kazakhstan', 'Astana Region', 'Astana', NOW(), NOW()),
(3, 'Caspian Gate Airport', 'Kazakhstan', 'Mangystau Region', 'Aktau', NOW(), NOW()),
(4, 'Southern Star Airport', 'Kazakhstan', 'Shymkent Region', 'Shymkent', NOW(), NOW()),
(5, 'Orda Airport', 'Kazakhstan', 'Karaganda Region', 'Karaganda', NOW(), NOW()),
(6, 'Blue Lake Airport', 'Kazakhstan', 'East Kazakhstan Region', 'Oskemen', NOW(), NOW()),
(7, 'Irtysh Airport', 'Kazakhstan', 'Pavlodar Region', 'Pavlodar', NOW(), NOW()),
(8, 'Silk Road Airport', 'Uzbekistan', 'Tashkent Region', 'Tashkent', NOW(), NOW()),
(9, 'Samarkand Heritage Airport', 'Uzbekistan', 'Samarkand Region', 'Samarkand', NOW(), NOW()),
(10, 'Bukhara Gate Airport', 'Uzbekistan', 'Bukhara Region', 'Bukhara', NOW(), NOW()),
(11, 'Kyrgyz Peak Airport', 'Kyrgyzstan', 'Chuy Region', 'Bishkek', NOW(), NOW()),
(12, 'Issyk Kul Airport', 'Kyrgyzstan', 'Issyk-Kul Region', 'Karakol', NOW(), NOW()),
(13, 'Caucasus Star Airport', 'Georgia', 'Tbilisi Region', 'Tbilisi', NOW(), NOW()),
(14, 'Black Sea Airport', 'Georgia', 'Adjara', 'Batumi', NOW(), NOW()),
(15, 'Anatolia Central Airport', 'Turkey', 'Ankara Province', 'Ankara', NOW(), NOW()),
(16, 'Bosphorus Airport', 'Turkey', 'Istanbul Province', 'Istanbul', NOW(), NOW()),
(17, 'Cappadocia Airport', 'Turkey', 'Nevsehir Province', 'Nevsehir', NOW(), NOW()),
(18, 'Eiffel Gateway Airport', 'France', 'Ile-de-France', 'Paris', NOW(), NOW()),
(19, 'Lyon Central Airport', 'France', 'Auvergne-Rhone-Alpes', 'Lyon', NOW(), NOW()),
(20, 'French Riviera Airport', 'France', 'Provence-Alpes-Cote dAzur', 'Nice', NOW(), NOW()),
(21, 'Berlin Central Airport', 'Germany', 'Berlin', 'Berlin', NOW(), NOW()),
(22, 'Bavaria Gate Airport', 'Germany', 'Bavaria', 'Munich', NOW(), NOW()),
(23, 'Rhine Airport', 'Germany', 'North Rhine-Westphalia', 'Cologne', NOW(), NOW()),
(24, 'Amsterdam Crown Airport', 'Netherlands', 'North Holland', 'Amsterdam', NOW(), NOW()),
(25, 'Rotterdam Harbor Airport', 'Netherlands', 'South Holland', 'Rotterdam', NOW(), NOW()),
(26, 'Brussels Grand Airport', 'Belgium', 'Brussels Capital Region', 'Brussels', NOW(), NOW()),
(27, 'Madrid Central Airport', 'Spain', 'Madrid', 'Madrid', NOW(), NOW()),
(28, 'Barcelona Coast Airport', 'Spain', 'Catalonia', 'Barcelona', NOW(), NOW()),
(29, 'Valencia Sun Airport', 'Spain', 'Valencian Community', 'Valencia', NOW(), NOW()),
(30, 'Lisbon Ocean Airport', 'Portugal', 'Lisbon', 'Lisbon', NOW(), NOW()),
(31, 'Porto North Airport', 'Portugal', 'Porto', 'Porto', NOW(), NOW()),
(32, 'Rome Imperial Airport', 'Italy', 'Lazio', 'Rome', NOW(), NOW()),
(33, 'Milan Fashion Airport', 'Italy', 'Lombardy', 'Milan', NOW(), NOW()),
(34, 'Venice Lagoon Airport', 'Italy', 'Veneto', 'Venice', NOW(), NOW()),
(35, 'Athens Olympic Airport', 'Greece', 'Attica', 'Athens', NOW(), NOW()),
(36, 'Thessaloniki North Airport', 'Greece', 'Central Macedonia', 'Thessaloniki', NOW(), NOW()),
(37, 'Vienna Imperial Airport', 'Austria', 'Vienna', 'Vienna', NOW(), NOW()),
(38, 'Prague Castle Airport', 'Czech Republic', 'Prague', 'Prague', NOW(), NOW()),
(39, 'Warsaw Central Airport', 'Poland', 'Masovian', 'Warsaw', NOW(), NOW()),
(40, 'Krakow Heritage Airport', 'Poland', 'Lesser Poland', 'Krakow', NOW(), NOW()),
(41, 'Budapest Danube Airport', 'Hungary', 'Budapest', 'Budapest', NOW(), NOW()),
(42, 'Bucharest Crown Airport', 'Romania', 'Bucharest', 'Bucharest', NOW(), NOW()),
(43, 'Sofia Mountain Airport', 'Bulgaria', 'Sofia', 'Sofia', NOW(), NOW()),
(44, 'Belgrade River Airport', 'Serbia', 'Belgrade', 'Belgrade', NOW(), NOW()),
(45, 'Zagreb Central Airport', 'Croatia', 'Zagreb', 'Zagreb', NOW(), NOW()),
(46, 'Stockholm Nordic Airport', 'Sweden', 'Stockholm', 'Stockholm', NOW(), NOW()),
(47, 'Oslo Fjord Airport', 'Norway', 'Oslo', 'Oslo', NOW(), NOW()),
(48, 'Helsinki North Airport', 'Finland', 'Uusimaa', 'Helsinki', NOW(), NOW()),
(49, 'Copenhagen Harbor Airport', 'Denmark', 'Capital Region', 'Copenhagen', NOW(), NOW()),
(50, 'Reykjavik Arctic Airport', 'Iceland', 'Capital Region', 'Reykjavik', NOW(), NOW()),
(51, 'London Royal Airport', 'United Kingdom', 'England', 'London', NOW(), NOW()),
(52, 'Manchester North Airport', 'United Kingdom', 'England', 'Manchester', NOW(), NOW()),
(53, 'Dublin Emerald Airport', 'Ireland', 'Leinster', 'Dublin', NOW(), NOW()),
(54, 'Zurich Alpine Airport', 'Switzerland', 'Zurich', 'Zurich', NOW(), NOW()),
(55, 'Geneva Lake Airport', 'Switzerland', 'Geneva', 'Geneva', NOW(), NOW()),
(56, 'Bratislava Danube Airport', 'Slovakia', 'Bratislava', 'Bratislava', NOW(), NOW()),
(57, 'Ljubljana Green Airport', 'Slovenia', 'Central Slovenia', 'Ljubljana', NOW(), NOW()),
(58, 'Tallinn Baltic Airport', 'Estonia', 'Harju', 'Tallinn', NOW(), NOW()),
(59, 'Riga Baltic Airport', 'Latvia', 'Riga', 'Riga', NOW(), NOW()),
(60, 'Vilnius Old Town Airport', 'Lithuania', 'Vilnius', 'Vilnius', NOW(), NOW()),
(61, 'Toronto Maple Airport', 'Canada', 'Ontario', 'Toronto', NOW(), NOW()),
(62, 'Vancouver Pacific Airport', 'Canada', 'British Columbia', 'Vancouver', NOW(), NOW()),
(63, 'Montreal North Airport', 'Canada', 'Quebec', 'Montreal', NOW(), NOW()),
(64, 'New York Liberty Airport', 'United States', 'New York', 'New York', NOW(), NOW()),
(65, 'Chicago Lakeside Airport', 'United States', 'Illinois', 'Chicago', NOW(), NOW()),
(66, 'Los Angeles Sun Airport', 'United States', 'California', 'Los Angeles', NOW(), NOW()),
(67, 'San Francisco Bay Airport', 'United States', 'California', 'San Francisco', NOW(), NOW()),
(68, 'Miami Ocean Airport', 'United States', 'Florida', 'Miami', NOW(), NOW()),
(69, 'Seattle Rain Airport', 'United States', 'Washington', 'Seattle', NOW(), NOW()),
(70, 'Boston Harbor Airport', 'United States', 'Massachusetts', 'Boston', NOW(), NOW()),
(71, 'Houston Space Airport', 'United States', 'Texas', 'Houston', NOW(), NOW()),
(72, 'Dallas Frontier Airport', 'United States', 'Texas', 'Dallas', NOW(), NOW()),
(73, 'Denver Mountain Airport', 'United States', 'Colorado', 'Denver', NOW(), NOW()),
(74, 'Phoenix Desert Airport', 'United States', 'Arizona', 'Phoenix', NOW(), NOW()),
(75, 'Atlanta Southern Airport', 'United States', 'Georgia', 'Atlanta', NOW(), NOW()),
(76, 'Mexico City Central Airport', 'Mexico', 'Mexico City', 'Mexico City', NOW(), NOW()),
(77, 'Cancun Caribbean Airport', 'Mexico', 'Quintana Roo', 'Cancun', NOW(), NOW()),
(78, 'Havana Caribbean Airport', 'Cuba', 'Havana', 'Havana', NOW(), NOW()),
(79, 'San Juan Island Airport', 'Puerto Rico', 'San Juan', 'San Juan', NOW(), NOW()),
(80, 'Panama Canal Airport', 'Panama', 'Panama', 'Panama City', NOW(), NOW()),
(81, 'Bogota Andes Airport', 'Colombia', 'Cundinamarca', 'Bogota', NOW(), NOW()),
(82, 'Medellin Valley Airport', 'Colombia', 'Antioquia', 'Medellin', NOW(), NOW()),
(83, 'Quito Equator Airport', 'Ecuador', 'Pichincha', 'Quito', NOW(), NOW()),
(84, 'Lima Pacific Airport', 'Peru', 'Lima', 'Lima', NOW(), NOW()),
(85, 'Santiago Andes Airport', 'Chile', 'Santiago Metropolitan', 'Santiago', NOW(), NOW()),
(86, 'Buenos Aires River Airport', 'Argentina', 'Buenos Aires', 'Buenos Aires', NOW(), NOW()),
(87, 'Sao Paulo Central Airport', 'Brazil', 'Sao Paulo', 'Sao Paulo', NOW(), NOW()),
(88, 'Rio Carnival Airport', 'Brazil', 'Rio de Janeiro', 'Rio de Janeiro', NOW(), NOW()),
(89, 'Brasilia Capital Airport', 'Brazil', 'Federal District', 'Brasilia', NOW(), NOW()),
(90, 'Montevideo River Airport', 'Uruguay', 'Montevideo', 'Montevideo', NOW(), NOW()),
(91, 'Johannesburg Gold Airport', 'South Africa', 'Gauteng', 'Johannesburg', NOW(), NOW()),
(92, 'Cape Town Ocean Airport', 'South Africa', 'Western Cape', 'Cape Town', NOW(), NOW()),
(93, 'Nairobi Safari Airport', 'Kenya', 'Nairobi', 'Nairobi', NOW(), NOW()),
(94, 'Cairo Nile Airport', 'Egypt', 'Cairo', 'Cairo', NOW(), NOW()),
(95, 'Alexandria Mediterranean Airport', 'Egypt', 'Alexandria', 'Alexandria', NOW(), NOW()),
(96, 'Casablanca Atlantic Airport', 'Morocco', 'Casablanca', 'Casablanca', NOW(), NOW()),
(97, 'Marrakesh Desert Airport', 'Morocco', 'Marrakesh-Safi', 'Marrakesh', NOW(), NOW()),
(98, 'Lagos Atlantic Airport', 'Nigeria', 'Lagos', 'Lagos', NOW(), NOW()),
(99, 'Accra Gold Coast Airport', 'Ghana', 'Greater Accra', 'Accra', NOW(), NOW()),
(100, 'Addis Highlands Airport', 'Ethiopia', 'Addis Ababa', 'Addis Ababa', NOW(), NOW()),
(101, 'Dubai Desert Gate Airport', 'United Arab Emirates', 'Dubai', 'Dubai', NOW(), NOW()),
(102, 'Abu Dhabi Pearl Airport', 'United Arab Emirates', 'Abu Dhabi', 'Abu Dhabi', NOW(), NOW()),
(103, 'Doha Gulf Airport', 'Qatar', 'Doha', 'Doha', NOW(), NOW()),
(104, 'Riyadh Desert Airport', 'Saudi Arabia', 'Riyadh', 'Riyadh', NOW(), NOW()),
(105, 'Jeddah Red Sea Airport', 'Saudi Arabia', 'Makkah', 'Jeddah', NOW(), NOW()),
(106, 'Kuwait City Airport', 'Kuwait', 'Al Asimah', 'Kuwait City', NOW(), NOW()),
(107, 'Muscat Sultan Airport', 'Oman', 'Muscat', 'Muscat', NOW(), NOW()),
(108, 'Manama Gulf Airport', 'Bahrain', 'Capital Governorate', 'Manama', NOW(), NOW()),
(109, 'Tehran Central Airport', 'Iran', 'Tehran', 'Tehran', NOW(), NOW()),
(110, 'Dubai Creek Airport', 'United Arab Emirates', 'Dubai', 'Al Ain', NOW(), NOW()),
(111, 'Delhi Capital Airport', 'India', 'Delhi', 'Delhi', NOW(), NOW()),
(112, 'Mumbai Ocean Airport', 'India', 'Maharashtra', 'Mumbai', NOW(), NOW()),
(113, 'Bangalore Tech Airport', 'India', 'Karnataka', 'Bangalore', NOW(), NOW()),
(114, 'Chennai South Airport', 'India', 'Tamil Nadu', 'Chennai', NOW(), NOW()),
(115, 'Kolkata East Airport', 'India', 'West Bengal', 'Kolkata', NOW(), NOW()),
(116, 'Kathmandu Himalaya Airport', 'Nepal', 'Bagmati', 'Kathmandu', NOW(), NOW()),
(117, 'Dhaka Bengal Airport', 'Bangladesh', 'Dhaka', 'Dhaka', NOW(), NOW()),
(118, 'Colombo Island Airport', 'Sri Lanka', 'Western Province', 'Colombo', NOW(), NOW()),
(119, 'Male Atoll Airport', 'Maldives', 'Kaafu Atoll', 'Male', NOW(), NOW()),
(120, 'Islamabad Capital Airport', 'Pakistan', 'Islamabad Capital Territory', 'Islamabad', NOW(), NOW()),
(121, 'Karachi Harbor Airport', 'Pakistan', 'Sindh', 'Karachi', NOW(), NOW()),
(122, 'Beijing Dragon Airport', 'China', 'Beijing', 'Beijing', NOW(), NOW()),
(123, 'Shanghai Harbor Airport', 'China', 'Shanghai', 'Shanghai', NOW(), NOW()),
(124, 'Guangzhou South Airport', 'China', 'Guangdong', 'Guangzhou', NOW(), NOW()),
(125, 'Shenzhen Tech Airport', 'China', 'Guangdong', 'Shenzhen', NOW(), NOW()),
(126, 'Chengdu Panda Airport', 'China', 'Sichuan', 'Chengdu', NOW(), NOW()),
(127, 'Hong Kong Harbor Airport', 'China', 'Hong Kong', 'Hong Kong', NOW(), NOW()),
(128, 'Tokyo Sky Airport', 'Japan', 'Tokyo', 'Tokyo', NOW(), NOW()),
(129, 'Osaka Castle Airport', 'Japan', 'Osaka', 'Osaka', NOW(), NOW()),
(130, 'Kyoto Heritage Airport', 'Japan', 'Kyoto', 'Kyoto', NOW(), NOW()),
(131, 'Seoul Han Airport', 'South Korea', 'Seoul', 'Seoul', NOW(), NOW()),
(132, 'Busan Ocean Airport', 'South Korea', 'Busan', 'Busan', NOW(), NOW()),
(133, 'Taipei Formosa Airport', 'Taiwan', 'Taipei', 'Taipei', NOW(), NOW()),
(134, 'Singapore Lion Airport', 'Singapore', 'Central Region', 'Singapore', NOW(), NOW()),
(135, 'Kuala Lumpur Palm Airport', 'Malaysia', 'Selangor', 'Kuala Lumpur', NOW(), NOW()),
(136, 'Jakarta Island Airport', 'Indonesia', 'Jakarta', 'Jakarta', NOW(), NOW()),
(137, 'Bali Paradise Airport', 'Indonesia', 'Bali', 'Denpasar', NOW(), NOW()),
(138, 'Manila Bay Airport', 'Philippines', 'Metro Manila', 'Manila', NOW(), NOW()),
(139, 'Bangkok Royal Airport', 'Thailand', 'Bangkok', 'Bangkok', NOW(), NOW()),
(140, 'Phuket Beach Airport', 'Thailand', 'Phuket', 'Phuket', NOW(), NOW()),
(141, 'Hanoi Dragon Airport', 'Vietnam', 'Hanoi', 'Hanoi', NOW(), NOW()),
(142, 'Ho Chi Minh City Airport', 'Vietnam', 'Ho Chi Minh City', 'Ho Chi Minh City', NOW(), NOW()),
(143, 'Phnom Penh Mekong Airport', 'Cambodia', 'Phnom Penh', 'Phnom Penh', NOW(), NOW()),
(144, 'Yangon Golden Airport', 'Myanmar', 'Yangon', 'Yangon', NOW(), NOW()),
(145, 'Sydney Harbour Airport', 'Australia', 'New South Wales', 'Sydney', NOW(), NOW()),
(146, 'Melbourne Southern Airport', 'Australia', 'Victoria', 'Melbourne', NOW(), NOW()),
(147, 'Brisbane River Airport', 'Australia', 'Queensland', 'Brisbane', NOW(), NOW()),
(148, 'Perth Western Airport', 'Australia', 'Western Australia', 'Perth', NOW(), NOW()),
(149, 'Auckland Kiwi Airport', 'New Zealand', 'Auckland', 'Auckland', NOW(), NOW()),
(150, 'Wellington Harbour Airport', 'New Zealand', 'Wellington', 'Wellington', NOW(), NOW()),
(151, 'Moscow Red Square Airport', 'Russia', 'Moscow', 'Moscow', NOW(), NOW()),
(152, 'Saint Petersburg Neva Airport', 'Russia', 'Leningrad Region', 'Saint Petersburg', NOW(), NOW()),
(153, 'Novosibirsk Siberia Airport', 'Russia', 'Novosibirsk Region', 'Novosibirsk', NOW(), NOW()),
(154, 'Vladivostok Pacific Airport', 'Russia', 'Primorsky Krai', 'Vladivostok', NOW(), NOW()),
(155, 'Kyiv Dnipro Airport', 'Ukraine', 'Kyiv', 'Kyiv', NOW(), NOW()),
(156, 'Lviv Heritage Airport', 'Ukraine', 'Lviv Region', 'Lviv', NOW(), NOW()),
(157, 'Minsk Belarus Airport', 'Belarus', 'Minsk', 'Minsk', NOW(), NOW()),
(158, 'Minsk North Airport', 'Belarus', 'Minsk Region', 'Barysaw', NOW(), NOW()),
(159, 'Chisinau Moldova Airport', 'Moldova', 'Chisinau', 'Chisinau', NOW(), NOW()),
(160, 'Tbilisi East Airport', 'Georgia', 'Kakheti', 'Telavi', NOW(), NOW()),
(161, 'Astana Steppe Airport', 'Kazakhstan', 'Akmola Region', 'Kokshetau', NOW(), NOW()),
(162, 'Taraz Ancient Airport', 'Kazakhstan', 'Zhambyl Region', 'Taraz', NOW(), NOW()),
(163, 'Turkistan Silk Airport', 'Kazakhstan', 'Turkistan Region', 'Turkistan', NOW(), NOW()),
(164, 'Semey Irtysh Airport', 'Kazakhstan', 'Abai Region', 'Semey', NOW(), NOW()),
(165, 'Kostanay North Airport', 'Kazakhstan', 'Kostanay Region', 'Kostanay', NOW(), NOW()),
(166, 'Atyrau Caspian Airport', 'Kazakhstan', 'Atyrau Region', 'Atyrau', NOW(), NOW()),
(167, 'Oral West Airport', 'Kazakhstan', 'West Kazakhstan Region', 'Oral', NOW(), NOW()),
(168, 'Petropavl North Airport', 'Kazakhstan', 'North Kazakhstan Region', 'Petropavl', NOW(), NOW()),
(169, 'Kyzylorda Syr Darya Airport', 'Kazakhstan', 'Kyzylorda Region', 'Kyzylorda', NOW(), NOW()),
(170, 'Zhezkazgan Central Airport', 'Kazakhstan', 'Ulytau Region', 'Zhezkazgan', NOW(), NOW()),
(171, 'Mlawe Central Airport', 'Randomland', NULL, 'Mlawe', NOW(), NOW()),
(172, 'Kepuh Regional Airport', 'Randomland', NULL, 'Kepuh', NOW(), NOW()),
(173, 'Emerald Valley Airport', 'Ireland', 'Munster', 'Cork', NOW(), NOW()),
(174, 'Loire Valley Airport', 'France', 'Pays de la Loire', 'Nantes', NOW(), NOW()),
(175, 'Bordeaux Wine Airport', 'France', 'Nouvelle-Aquitaine', 'Bordeaux', NOW(), NOW()),
(176, 'Marseille Port Airport', 'France', 'Provence-Alpes-Cote dAzur', 'Marseille', NOW(), NOW()),
(177, 'Frankfurt Main Airport', 'Germany', 'Hesse', 'Frankfurt', NOW(), NOW()),
(178, 'Hamburg Harbor Airport', 'Germany', 'Hamburg', 'Hamburg', NOW(), NOW()),
(179, 'Dresden Elbe Airport', 'Germany', 'Saxony', 'Dresden', NOW(), NOW()),
(180, 'Zurich Valley Airport', 'Switzerland', 'Zurich', 'Winterthur', NOW(), NOW()),
(181, 'Fes Medina Airport', 'Morocco', 'Fes-Meknes', 'Fes', NOW(), NOW()),
(182, 'Tangier Strait Airport', 'Morocco', 'Tangier-Tetouan-Al Hoceima', 'Tangier', NOW(), NOW()),
(183, 'Dar es Salaam Ocean Airport', 'Tanzania', 'Dar es Salaam', 'Dar es Salaam', NOW(), NOW()),
(184, 'Kampala Lake Airport', 'Uganda', 'Central Region', 'Kampala', NOW(), NOW()),
(185, 'Accra Central Airport', 'Ghana', 'Greater Accra', 'Tema', NOW(), NOW()),
(186, 'Dakar Atlantic Airport', 'Senegal', 'Dakar', 'Dakar', NOW(), NOW()),
(187, 'Luanda Atlantic Airport', 'Angola', 'Luanda Province', 'Luanda', NOW(), NOW()),
(188, 'Maputo Bay Airport', 'Mozambique', 'Maputo', 'Maputo', NOW(), NOW()),
(189, 'Windhoek Desert Airport', 'Namibia', 'Khomas', 'Windhoek', NOW(), NOW()),
(190, 'Harare Zimbabwe Airport', 'Zimbabwe', 'Harare', 'Harare', NOW(), NOW()),
(191, 'Peru Highlands Airport', 'Peru', 'Cusco', 'Cusco', NOW(), NOW()),
(192, 'La Paz Altitude Airport', 'Bolivia', 'La Paz', 'La Paz', NOW(), NOW()),
(193, 'Asuncion Paraguay Airport', 'Paraguay', 'Central', 'Asuncion', NOW(), NOW()),
(194, 'Quito Valley Airport', 'Ecuador', 'Pichincha', 'Ambato', NOW(), NOW()),
(195, 'Georgetown Caribbean Airport', 'Guyana', 'Demerara-Mahaica', 'Georgetown', NOW(), NOW()),
(196, 'Kingston Jamaica Airport', 'Jamaica', 'Kingston', 'Kingston', NOW(), NOW()),
(197, 'Bridgetown Island Airport', 'Barbados', 'Saint Michael', 'Bridgetown', NOW(), NOW()),
(198, 'Nassau Bahamas Airport', 'Bahamas', 'New Providence', 'Nassau', NOW(), NOW()),
(199, 'Port Louis Mauritius Airport', 'Mauritius', 'Port Louis', 'Port Louis', NOW(), NOW()),
(200, 'Victoria Seychelles Airport', 'Seychelles', 'Mahe', 'Victoria', NOW(), NOW());


INSERT INTO airline
(airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(1, 'KAZ', 'KazAir', 'Kazakhstan', NOW(), NOW());

SELECT *
FROM airline
WHERE airline_name = 'KazAir';

UPDATE airline
SET airline_country = 'Turkey'
WHERE airline_name = 'KazAir';

SELECT *
FROM airline
WHERE airline_name = 'KazAir';


INSERT INTO airline
(airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES
(2, 'AE', 'AirEasy', 'France', NOW(), NOW()),
(3, 'FH', 'FlyHigh', 'Brazil', NOW(), NOW()),
(4, 'FF', 'FlyFly', 'Poland', NOW(), NOW());

INSERT INTO passengers (
    passenger_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    country_of_citizenship,
    country_of_residence,
    passport_number,
    created_at,
    updated_at
)
SELECT
    gs,
    'Passenger' || gs,
    'Surname' || gs,
    DATE '1980-01-01'
        + (random() * 12000)::INT,
    CASE
        WHEN random() < 0.5 THEN 'Male'
        ELSE 'Female'
    END,
    'Kazakhstan',
    'Kazakhstan',
    'P' || LPAD(gs::TEXT, 7, '0'),
    NOW(),
    NOW()
FROM generate_series(1, 200) AS gs;

INSERT INTO flights (
    flight_id,
    sch_departure_time,
    sch_arrival_time,
    departing_airport_id,
    arriving_airport_id,
    departing_gate,
    arriving_gate,
    airline_id,
    act_departure_time,
    act_arrival_time,
    created_at,
    updated_at
)
SELECT
    gs,
    departure_time,
    departure_time + INTERVAL '3 hours',
    departure_airport,
    CASE
        WHEN arrival_airport = departure_airport
        THEN arrival_airport % 200 + 1
        ELSE arrival_airport
    END,
    'A' || (floor(random() * 20) + 1)::INT,
    'B' || (floor(random() * 20) + 1)::INT,
    (floor(random() * 4) + 1)::INT,
    departure_time + INTERVAL '10 minutes',
    departure_time + INTERVAL '3 hours 10 minutes',
    NOW(),
    NOW()
FROM generate_series(1, 200) AS gs
CROSS JOIN LATERAL (
    SELECT
        TIMESTAMP '2025-01-01'
            + random() * INTERVAL '365 days'
            + gs * INTERVAL '1 second' AS departure_time,
        (floor(random() * 200) + 1)::INT AS departure_airport,
        (floor(random() * 200) + 1)::INT AS arrival_airport
) AS random_data;

INSERT INTO booking (
    booking_id,
    flight_id,
    passenger_id,
    booking_platform,
    created_at,
    updated_at,
    status,
    ticket_price
)
SELECT
    gs,
    gs,
    gs,
    CASE
        WHEN random() < 0.5 THEN 'Website'
        ELSE 'Mobile App'
    END,
    NOW(),
    NOW(),
    'Confirmed',
    ROUND((5000 + random() * 195000)::numeric, 2)
FROM generate_series(1, 200) AS gs;

SELECT
    COUNT(*) AS total_bookings,
    MIN(ticket_price) AS min_price,
    MAX(ticket_price) AS max_price
FROM booking;

UPDATE booking
SET ticket_price = ticket_price * 1.15
WHERE ticket_price > 0;

SELECT booking_id, ticket_price
FROM booking;

DELETE FROM booking
WHERE ticket_price < 10000;

SELECT *
FROM booking
WHERE ticket_price < 10000;


SELECT COUNT(*) AS remaining_tickets
FROM booking;

UPDATE airline
SET airline_code = 'UNK'
WHERE airline_code IS NULL;

SELECT *
FROM airline;


SELECT *
FROM baggage_check
WHERE created_at < '2023-06-01'
AND check_result = 'Not checked';

SELECT *
FROM baggage_check;

INSERT INTO baggage_check
(baggage_check_id, check_result, created_at,
 updated_at, booking_id, passenger_id)
SELECT
    1,
    'Not checked',
    '2020-05-15',
    '2020-05-15',
    booking_id,
    passenger_id
FROM booking
WHERE booking_id = 1;

SELECT booking_id, passenger_id
FROM booking
LIMIT 10;

SELECT *
FROM baggage_check;

INSERT INTO baggage_check
(baggage_check_id, check_result, created_at,
 updated_at, booking_id, passenger_id)
VALUES
(2, 'Checked', '2020-08-20', '2020-08-20', 2, 2),
(3, 'Not checked', '2021-05-10', '2021-05-10', 3, 3),
(4, 'Checked', '2021-11-12', '2021-11-12', 4, 4),
(5, 'Not checked', '2022-04-18', '2022-04-18', 5, 5),
(6, 'Checked', '2022-09-25', '2022-09-25', 6, 6),
(7, 'Not checked', '2023-05-20', '2023-05-20', 7, 7),
(8, 'Checked', '2023-07-14', '2023-07-14', 9, 9),
(9, 'Not checked', '2024-03-10', '2024-03-10', 11, 11),
(10, 'Not checked', '2024-03-22', '2024-03-22', 12, 12);


DELETE FROM baggage_check
WHERE created_at < '2023-06-01'
AND check_result = 'Not checked';

SELECT *
FROM baggage_check;

SELECT *
FROM airport
WHERE state IS NULL
AND city IN ('Mlawe', 'Kepuh');


DELETE FROM airport
WHERE state IS NULL
AND city IN ('Mlawe', 'Kepuh');


SELECT *
FROM airport
WHERE city IN ('Mlawe', 'Kepuh');


INSERT INTO baggage_check
(baggage_check_id, check_result, created_at,
 updated_at, booking_id, passenger_id)
VALUES
(11, 'Not checked', NOW(), NOW(), 1, 1)
RETURNING baggage_check_id, created_at;

SELECT *
FROM baggage_check;


UPDATE airline
SET airline_country = UPPER(airline_country)
WHERE airline_country <> UPPER(airline_country);



SELECT airline_name, airline_country
FROM airline;



SELECT *
FROM airline
WHERE airline_id = 5;




INSERT INTO airline
(airline_id, airline_code, airline_name,
 airline_country, created_at, updated_at)
VALUES
(5, 'GA', 'Test Airways',
 'Kazakhstan', NOW(), NOW());



UPDATE airline
SET airline_name = 'Global Airways',
    airline_country = 'United Kingdom',
    updated_at = NOW()
WHERE airline_id = 5;



SELECT *
FROM airline
WHERE airline_id = 5;



UPDATE airport
SET state = 'Capital District'
WHERE city IN ('Astana', 'London', 'Tokyo');


SELECT airport_id, city, state
FROM airport
WHERE city IN ('Astana', 'London', 'Tokyo');


UPDATE baggage_check
SET check_result = 'Checked'
WHERE created_at >= '2024-03-01'
AND created_at < '2024-04-01'
AND check_result = 'Not checked';



SELECT baggage_check_id, check_result, created_at
FROM baggage_check
WHERE created_at >= '2024-03-01'
AND created_at < '2024-04-01';


DELETE FROM flights
WHERE sch_arrival_time >= '2024-01-01'
AND sch_arrival_time < '2025-01-01';

SELECT *
FROM flights
WHERE sch_arrival_time >= '2024-01-01'
AND sch_arrival_time < '2025-01-01';