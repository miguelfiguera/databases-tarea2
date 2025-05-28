 CREATE DATABASE aerolinea;
 \c aerolinea

DROP TABLE IF EXISTS plane_details CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS personel CASCADE;
DROP TABLE IF EXISTS passengers CASCADE;
DROP TABLE IF EXISTS planes CASCADE;

DROP TYPE IF EXISTS replenished_status CASCADE;
DROP TYPE IF EXISTS fuel_status CASCADE;
DROP TYPE IF EXISTS maintenance_status CASCADE;
DROP TYPE IF EXISTS personel_rol CASCADE;

CREATE TYPE replenished_status AS ENUM('pending', 'replenished', 'empty', 'used');
CREATE TYPE fuel_status AS ENUM ('refueled', 'pending');
CREATE TYPE maintenance_status AS ENUM('pending', 'performed');
CREATE TYPE personel_rol AS ENUM ('stewardess', 'copilot', 'pilot', 'steward');

CREATE TABLE planes (
	id SERIAL PRIMARY KEY,
	model VARCHAR(50) NOT NULL
);

CREATE TABLE passengers (
	id SERIAL PRIMARY KEY,
	dni VARCHAR(20) UNIQUE NOT NULL,
	name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	email VARCHAR(75) UNIQUE NOT NULL,
	dob DATE,
	active BOOLEAN DEFAULT true,
	phone VARCHAR(20) NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_passengers_dni ON passengers(dni);
CREATE INDEX IF NOT EXISTS idx_passengers_last_name ON passengers(last_name, name);

CREATE TABLE personel (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	dni VARCHAR(20) UNIQUE NOT NULL,
	rol personel_rol NOT NULL,
	plane_id INTEGER REFERENCES planes(id),
	flight_hours INTEGER DEFAULT 0 NOT NULL,
	years_of_service INTEGER DEFAULT 0 NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_personel_dni ON personel(dni);
CREATE INDEX IF NOT EXISTS idx_personel_rol ON personel(rol);
CREATE INDEX IF NOT EXISTS idx_personel_plane_id ON personel(plane_id);

CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	city_of_arrival VARCHAR(50) NOT NULL,
	city_of_departure VARCHAR(50) NOT NULL,
	arrival_datetime TIMESTAMP WITH TIME ZONE,
	departure_datetime TIMESTAMP WITH TIME ZONE,
	plane_id INTEGER REFERENCES planes(id)
);
CREATE INDEX IF NOT EXISTS idx_flights_plane_id ON flights(plane_id);
CREATE INDEX IF NOT EXISTS idx_flights_departure_arrival_city ON flights(city_of_departure, city_of_arrival);
CREATE INDEX IF NOT EXISTS idx_flights_departure_datetime ON flights(departure_datetime);

CREATE TABLE tickets (
	id SERIAL PRIMARY KEY,
	passenger_id INTEGER NOT NULL REFERENCES passengers(id),
	flight_id INTEGER NOT NULL REFERENCES flights(id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	amount DECIMAL(8, 2),
	confirmed BOOLEAN DEFAULT false,
	seat_number VARCHAR(10),
	luggage_kg DECIMAL(4, 1) DEFAULT 0.0
);
CREATE INDEX IF NOT EXISTS idx_tickets_passenger_id ON tickets(passenger_id);
CREATE INDEX IF NOT EXISTS idx_tickets_flight_id ON tickets(flight_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_tickets_flight_seat ON tickets(flight_id, seat_number);

CREATE TABLE plane_details (
	id SERIAL PRIMARY KEY,
	plane_id INTEGER UNIQUE NOT NULL REFERENCES planes(id) ON DELETE CASCADE,
	captain_id INTEGER REFERENCES personel(id),
	copilot_id INTEGER REFERENCES personel(id),
	stewardess_one_id INTEGER REFERENCES personel(id),
	stewardess_two_id INTEGER REFERENCES personel(id),
	stewardess_three_id INTEGER REFERENCES personel(id),
	vip_capacity INTEGER NOT NULL CHECK (vip_capacity >= 0),
	commercial_capacity INTEGER NOT NULL CHECK (commercial_capacity >= 0),
	fuel_capacity_liters INTEGER NOT NULL CHECK (fuel_capacity_liters >= 0),
	extinguishers INTEGER NOT NULL CHECK (extinguishers >= 0),
	last_maintenance_date DATE,
	last_replenish_date DATE,
	last_refueled_date DATE,
	replenish_status replenished_status DEFAULT 'pending',
	fuel_level_status fuel_status DEFAULT 'pending',
	maintenance_status maintenance_status DEFAULT 'pending'
);
CREATE INDEX IF NOT EXISTS idx_plane_details_plane_id ON plane_details(plane_id);
CREATE INDEX IF NOT EXISTS idx_plane_details_captain_id ON plane_details(captain_id);
CREATE INDEX IF NOT EXISTS idx_plane_details_copilot_id ON plane_details(copilot_id);

-- 1. Inserción de Datos: Insertar registros de ejemplo en cada una de las tablas.

-- Planes
INSERT INTO planes (model) VALUES
('Boeing 737'), ('Airbus A320'), ('Boeing 777'), ('Airbus A350'), ('Embraer E190');

-- Passengers
INSERT INTO passengers (dni, name, last_name, email, dob, phone) VALUES
('11111111A', 'Alice', 'Smith', 'alice.smith@example.com', '1990-05-15', '555-0101'),
('22222222B', 'Bob', 'Johnson', 'bob.johnson@example.com', '1985-08-20', '555-0102'),
('33333333C', 'Charlie', 'Brown', 'charlie.brown@example.com', '1992-11-30', '555-0103'),
('44444444D', 'Diana', 'Prince', 'diana.prince@example.com', '1988-02-10', '555-0104'),
('55555555E', 'Edward', 'Davis', 'edward.davis@example.com', '1975-07-25', '555-0105');

-- Personel (IDs 1-12)
INSERT INTO personel (name, last_name, dni, rol, plane_id, flight_hours, years_of_service) VALUES
('John', 'Doe', 'P001', 'pilot', 1, 5000, 10),        -- ID 1 (Captain for Plane 1 details)
('Jane', 'Roe', 'C001', 'copilot', 1, 3000, 5),       -- ID 2 (Copilot for Plane 1 details)
('Peter', 'Pan', 'S001', 'stewardess', 1, 2000, 3),   -- ID 3 (Stewardess for Plane 1 details)
('Wendy', 'Darling', 'S002', 'stewardess', 1, 1500, 2),-- ID 4 (Stewardess for Plane 1 details)
('Michael', 'Jordan', 'P002', 'pilot', 2, 6000, 12),  -- ID 5 (Captain for Plane 2 details)
('Scottie', 'Pippen', 'C002', 'copilot', 2, 3500, 6),  -- ID 6 (Copilot for Plane 2 details)
('Lisa', 'Simpson', 'S003', 'stewardess', 2, 2200, 4), -- ID 7 (Stewardess for Plane 2 details)
('Bart', 'Simpson', 'S004', 'steward', 2, 1800, 3),   -- ID 8 (Steward for Plane 2 details)
('Clark', 'Kent', 'P003', 'pilot', 5, 7000, 15),      -- ID 9 (Captain for Plane 5 details, to be deleted)
('Lois', 'Lane', 'C003', 'copilot', 5, 4000, 7),      -- ID 10 (Copilot for Plane 5 details)
('Bruce', 'Wayne', 'S005', 'steward', 3, 2500, 5),    -- ID 11
('Selina', 'Kyle', 'S006', 'stewardess', 4, 1000, 1); -- ID 12

-- Flights
INSERT INTO flights (city_of_arrival, city_of_departure, arrival_datetime, departure_datetime, plane_id) VALUES
('New York', 'London', '2024-08-01 18:00:00+00', '2024-08-01 10:00:00+00', 1),
('Paris', 'Rome', '2024-08-02 15:00:00+00', '2024-08-02 12:00:00+00', 2),
('Tokyo', 'Los Angeles', '2024-08-03 22:00:00+00', '2024-08-03 08:00:00+00', 3),
('Dubai', 'Singapore', '2024-08-04 10:00:00+00', '2024-08-04 02:00:00+00', 4),
('Berlin', 'Madrid', '2024-08-05 14:00:00+00', '2024-08-05 11:00:00+00', 5);

-- Plane Details
INSERT INTO plane_details (plane_id, captain_id, copilot_id, stewardess_one_id, stewardess_two_id, vip_capacity, commercial_capacity, fuel_capacity_liters, extinguishers, last_maintenance_date, replenish_status, fuel_level_status, maintenance_status) VALUES
(1, 1, 2, 3, 4, 10, 150, 20000, 5, '2024-07-01', 'replenished', 'refueled', 'performed'),
(2, 5, 6, 7, 8, 12, 160, 22000, 6, '2024-07-05', 'pending', 'pending', 'pending'),
(3, NULL, NULL, 11, NULL, 20, 250, 35000, 8, '2024-06-20', 'replenished', 'refueled', 'performed'),
(4, NULL, NULL, 12, NULL, 15, 200, 30000, 7, '2024-06-15', 'pending', 'pending', 'pending'),
(5, 9, 10, NULL, NULL, 8, 120, 15000, 4, '2024-07-10', 'empty', 'pending', 'pending');

-- Tickets
INSERT INTO tickets (passenger_id, flight_id, amount, confirmed, seat_number, luggage_kg) VALUES
(1, 1, 550.00, true, '12A', 23.0),
(2, 2, 300.00, true, '5B', 15.5),
(3, 3, 800.00, false, '21F', 20.0),
(4, 4, 750.00, true, '3C', 0.0),
(5, 5, 200.00, true, '10D', 10.0);

-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.
SELECT * FROM planes FETCH FIRST 1 ROW ONLY;
SELECT id, model FROM planes FETCH FIRST 1 ROW ONLY;

SELECT * FROM passengers FETCH FIRST 1 ROW ONLY;
SELECT id, dni, name, last_name, email FROM passengers FETCH FIRST 1 ROW ONLY;

SELECT * FROM personel FETCH FIRST 1 ROW ONLY;
SELECT id, name, last_name, rol, plane_id FROM personel FETCH FIRST 1 ROW ONLY;

SELECT * FROM flights FETCH FIRST 1 ROW ONLY;
SELECT id, city_of_departure, city_of_arrival, departure_datetime, plane_id FROM flights FETCH FIRST 1 ROW ONLY;

SELECT * FROM plane_details FETCH FIRST 1 ROW ONLY;
SELECT id, plane_id, captain_id, vip_capacity, commercial_capacity, maintenance_status FROM plane_details FETCH FIRST 1 ROW ONLY;

SELECT * FROM tickets FETCH FIRST 1 ROW ONLY;
SELECT id, passenger_id, flight_id, seat_number, amount, confirmed FROM tickets FETCH FIRST 1 ROW ONLY;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (generalmente el primero) de cada una de las tablas.
UPDATE planes SET model = 'Boeing 737 MAX' WHERE id = 1;
UPDATE passengers SET phone = '555-111-2222' WHERE id = 1;
UPDATE personel SET flight_hours = 5100 WHERE id = 1;
UPDATE flights SET arrival_datetime = '2024-08-01 18:30:00+00' WHERE id = 1;
UPDATE plane_details SET maintenance_status = 'pending', last_maintenance_date = '2024-07-15' WHERE plane_id = 1;
UPDATE tickets SET confirmed = true, amount = 560.00 WHERE id = 3;


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.
DELETE FROM tickets WHERE id = 5;

DELETE FROM plane_details WHERE plane_id = 5;

DELETE FROM flights WHERE id = 5;

DELETE FROM personel WHERE id = 9;

DELETE FROM passengers WHERE id = 5;

DELETE FROM planes WHERE id = 5;