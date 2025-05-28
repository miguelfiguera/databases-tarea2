# Tarea 2 bases de datos:

## Equipo

- Miguel Figuera C.I: 23.558.789
- Iromy Leon C.I: V-30.243.131
- Alejandra Herde C.I: V-23.711.974
- Greimar Marin C.I: V-29.686.611

---

# Notas Previas:

- Hay dos bases de datos, una parte del equipo uso postgresql y la otra mysql o maria db que son analogas entre si.
- Para realizar una instalacion de la base de datos en postgresql, al menos en linux, se debe entrar en CLI de psql y colocar:

```bash
 \i psql_consultorio.psql
 \i psql_exportadora.sql
```

- Para mysql es mucho mas sencillo hacerlo desde la terminal de linux:

```bash
mysql -u <user> -p<password> mysql_deportes.sql < <ruta/al/archivo/mysql_deportes.sql>
mysql -u <user> -p<password> escuela.sql < <ruta/al/archivo/escuela.sql>
mysql -u <user> -p<password> fabrica.sql < <ruta/al/archivo/fabrica.sql>
```

- Posterior a esto deberia estar instalada la base de datos.

- La otra opcion es reconstruirla desde los dumps en la carpeta /sql_dumps.

# Codigos por base de datos:

## mysql_deportes.sql:

```sql
SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `deportes` (`id_deporte`, `nombre_deporte`, `descripcion`) VALUES
(1, 'Fútbol', 'Deporte de equipo jugado con un balón entre dos conjuntos de once jugadores.'),
(2, 'Baloncesto', 'Deporte de equipo jugado entre dos conjuntos de cinco jugadores cada uno.'),
(3, 'Tenis', 'Deporte de raqueta practicado entre dos jugadores o dos parejas.'),
(4, 'Voleibol', 'Deporte donde dos equipos se enfrentan sobre un terreno de juego liso separados por una red central.'),
(5, 'Atletismo', 'Conjunto de prácticas deportivas que comprende pruebas de velocidad, saltos y lanzamientos.');

INSERT INTO `equipos` (`id_equipo`, `nombre_equipo`, `id_deporte`, `fecha_creacion`) VALUES
(1, 'Real Madrid CF', 1, '1902-03-06'),
(2, 'FC Barcelona', 1, '1899-11-29'),
(3, 'Los Angeles Lakers', 2, '1947-01-01'),
(4, 'Golden State Warriors', 2, '1946-01-01'),
(5, 'Equipo Voley A', 4, '2020-05-10'),
(6, 'Equipo Voley B', 4, '2021-06-01');

INSERT INTO `torneos` (`id_torneo`, `nombre_torneo`, `id_deporte`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 'La Liga 2023-2024', 1, '2023-08-11', '2024-05-26'),
(2, 'Copa del Rey 2024', 1, '2023-10-31', '2024-04-06'),
(3, 'NBA Season 2023-2024', 2, '2023-10-24', '2024-06-23'),
(4, 'Roland Garros 2024', 3, '2024-05-26', '2024-06-09'),
(5, 'Mundial de Voleibol Femenino 2024', 4, '2024-09-01', '2024-09-30');

INSERT INTO `resultados_torneos` (`id_resultado`, `id_torneo`, `id_equipo_local`, `id_equipo_visitante`, `goles_local`, `goles_visitante`, `fecha_partido`) VALUES
(1, 1, 1, 2, 2, 1, '2024-01-10 20:00:00'),
(2, 2, 2, 1, 3, 1, '2024-02-15 19:30:00'),
(3, 3, 3, 4, 102, 100, '2024-03-01 21:00:00'),
(4, 4, NULL, NULL, 3, 2, '2024-06-08 15:00:00'),
(5, 5, 5, 6, 3, 1, '2024-09-10 18:00:00');

INSERT INTO `jugadores` (`id_jugador`, `nombre_jugador`, `apellido_jugador`, `id_equipo`, `fecha_nacimiento`, `posicion`) VALUES
(1, 'Vinicius', 'Junior', 1, '2000-07-12', 'Delantero'),
(2, 'Lamine', 'Yamal', 2, '2007-07-13', 'Delantero'),
(3, 'LeBron', 'James', 3, '1984-12-30', 'Alero'),
(4, 'Stephen', 'Curry', 4, '1988-03-14', 'Base'),
(5, 'Ana', 'Perez', 5, '1999-01-15', 'Central');

SET FOREIGN_KEY_CHECKS=1;

SELECT * FROM `deportes` LIMIT 1;
SELECT * FROM `equipos` LIMIT 1;
SELECT * FROM `torneos` LIMIT 1;
SELECT * FROM `resultados_torneos` LIMIT 1;
SELECT * FROM `jugadores` LIMIT 1;

SELECT `id_deporte`, `nombre_deporte`, `descripcion` FROM `deportes` LIMIT 1;
SELECT `id_equipo`, `nombre_equipo`, `id_deporte`, `fecha_creacion` FROM `equipos` LIMIT 1;
SELECT `id_torneo`, `nombre_torneo`, `id_deporte`, `fecha_inicio`, `fecha_fin` FROM `torneos` LIMIT 1;
SELECT `id_resultado`, `id_torneo`, `id_equipo_local`, `id_equipo_visitante`, `goles_local`, `goles_visitante` FROM `resultados_torneos` LIMIT 1;
SELECT `id_jugador`, `nombre_jugador`, `apellido_jugador`, `id_equipo`, `posicion` FROM `jugadores` LIMIT 1;

UPDATE `deportes` SET `descripcion` = 'Deporte de equipo con 11 jugadores por lado, objetivo marcar goles.' WHERE `id_deporte` = 1;
UPDATE `equipos` SET `nombre_equipo` = 'Real Madrid Club de Fútbol' WHERE `id_equipo` = 1;
UPDATE `torneos` SET `nombre_torneo` = 'La Liga Santander 2023-2024' WHERE `id_torneo` = 1;
UPDATE `resultados_torneos` SET `goles_local` = 3, `goles_visitante` = 0 WHERE `id_resultado` = 1;
UPDATE `jugadores` SET `posicion` = 'Extremo Izquierdo' WHERE `id_jugador` = 1;

SET FOREIGN_KEY_CHECKS=0;

DELETE FROM `resultados_torneos` WHERE `id_resultado` = 5;
DELETE FROM `torneos` WHERE `id_torneo` = 5;
DELETE FROM `jugadores` WHERE `id_jugador` = 5;
DELETE FROM `equipos` WHERE `id_equipo` = 5;
DELETE FROM `deportes` WHERE `id_deporte` = 5;

SET FOREIGN_KEY_CHECKS=1;

```

## mysql_escuela.sql:

```sql
INSERT INTO `grados` (`nombre_grado`, `descripcion`) VALUES
('Primer Grado', 'Nivel inicial de educación primaria.'),
('Segundo Grado', 'Segundo nivel de educación primaria.'),
('Tercer Grado', 'Tercer nivel de educación primaria.'),
('Cuarto Grado', 'Cuarto nivel de educación primaria.'),
('Quinto Grado', 'Quinto nivel de educación primaria.');

INSERT INTO `representantes` (`nombre_representante`, `apellido_representante`, `direccion`, `Telefono`, `email`) VALUES
('Carlos', 'Perez', 'Calle Sol 123, Ciudad Capital', '555-1111', 'carlos.perez@example.com'),
('Ana', 'Gomez', 'Avenida Luna 456, Ciudad Capital', '555-2222', 'ana.gomez@example.com'),
('Luis', 'Rodriguez', 'Boulevard Estrella 789, Ciudad Capital', '555-3333', 'luis.rodriguez@example.com'),
('Maria', 'Fernandez', 'Pasaje Cometa 101, Ciudad Capital', '555-4444', 'maria.fernandez@example.com'),
('Jorge', 'Martinez', 'Camino Galaxia 202, Ciudad Capital', '555-5555', 'jorge.martinez@example.com');

INSERT INTO `maestros` (`nombre_maestro`, `apellido_maestro`, `especialidad`, `email`, `telefono`) VALUES
('Laura', 'Sanchez', 'Matemáticas', 'laura.sanchez@escuela.com', '555-0011'),
('Pedro', 'Ramirez', 'Lengua y Literatura', 'pedro.ramirez@escuela.com', '555-0022'),
('Sofia', 'Hernandez', 'Ciencias Naturales', 'sofia.hernandez@escuela.com', '555-0033'),
('David', 'Torres', 'Historia y Geografía', 'david.torres@escuela.com', '555-0044'),
('Elena', 'Diaz', 'Artes Plásticas', 'elena.diaz@escuela.com', '555-0055');

INSERT INTO `estudiantes` (`nombre_estudiante`, `apellido_estudiante`, `fecha_nacimiento`, `direccion`, `telefono`, `email`, `id_grado`, `id_representante`) VALUES
('Juan', 'Perez', '2015-03-10', 'Calle Sol 123, Ciudad Capital', '555-1111', 'juan.perez@email.com', 1, 1),
('Sofia', 'Gomez', '2014-07-22', 'Avenida Luna 456, Ciudad Capital', '555-2222', 'sofia.gomez@email.com', 2, 2),
('Mateo', 'Rodriguez', '2013-11-05', 'Boulevard Estrella 789, Ciudad Capital', '555-3333', 'mateo.rodriguez@email.com', 3, 3),
('Camila', 'Fernandez', '2012-01-30', 'Pasaje Cometa 101, Ciudad Capital', '555-4444', 'camila.fernandez@email.com', 4, 4),
('Lucas', 'Martinez', '2011-09-18', 'Camino Galaxia 202, Ciudad Capital', '555-5555', 'lucas.martinez@email.com', 5, 5);

INSERT INTO `calificaciones` (`id_estudiante`, `id_grado`, `id_maestro`, `materia`, `calificacion`) VALUES
(1, 1, 1, 'Matemáticas I', 8.50),
(2, 2, 2, 'Lengua II', 9.00),
(3, 3, 3, 'Ciencias III', 7.75),
(4, 4, 4, 'Historia IV', 9.50),
(5, 5, 5, 'Artes V', 8.00);

SELECT * FROM `grados` LIMIT 1;
SELECT * FROM `representantes` LIMIT 1;
SELECT * FROM `maestros` LIMIT 1;
SELECT * FROM `estudiantes` LIMIT 1;
SELECT * FROM `calificaciones` LIMIT 1;

SELECT `id_grado`, `nombre_grado`, `descripcion` FROM `grados` LIMIT 1;
SELECT `id_representante`, `nombre_representante`, `email`, `Telefono` FROM `representantes` LIMIT 1;
SELECT `id_maestro`, `nombre_maestro`, `especialidad`, `email` FROM `maestros` LIMIT 1;
SELECT `id_estudiante`, `nombre_estudiante`, `apellido_estudiante`, `email`, `id_grado` FROM `estudiantes` LIMIT 1;
SELECT `id_calificacion`, `id_estudiante`, `materia`, `calificacion` FROM `calificaciones` LIMIT 1;

UPDATE `grados` SET `descripcion` = 'Nivel inicial de educación primaria formal.' WHERE `id_grado` = 1;
UPDATE `representantes` SET `Telefono` = '555-1112' WHERE `id_representante` = 1;
UPDATE `maestros` SET `especialidad` = 'Matemáticas Avanzadas' WHERE `id_maestro` = 1;
UPDATE `estudiantes` SET `telefono` = '555-1113' WHERE `id_estudiante` = 1;
UPDATE `calificaciones` SET `calificacion` = 8.75 WHERE `id_calificacion` = 1;

DELETE FROM `calificaciones` WHERE `id_calificacion` = 5;
DELETE FROM `estudiantes` WHERE `id_estudiante` = 5;
DELETE FROM `maestros` WHERE `id_maestro` = 5;
DELETE FROM `representantes` WHERE `id_representante` = 5;
DELETE FROM `grados` WHERE `id_grado` = 5;

```

## mysql_fabrica.sql:

```sql
INSERT INTO proveedores (nombre, direccion, telefono, email) VALUES
('Proveedor A', 'Calle Falsa 123, Ciudad A', '555-0101', 'contacto@proveedora.com'),
('Proveedor B', 'Avenida Siempre Viva 742, Ciudad B', '555-0102', 'ventas@proveedorb.net'),
('Proveedor C', 'Plaza Mayor 1, Pueblo C', '555-0103', 'info@proveedorc.org'),
('Proveedor D', 'Camino Largo S/N, Villa D', '555-0104', 'soporte@proveedord.com'),
('Proveedor E', 'Ruta Industrial Km 5, Parque E', '555-0105', 'admin@proveedore.co');

INSERT INTO productos (id_prov, nombre, descripcion, precio, stock) VALUES
(1, 'Tornillos de Acero', 'Caja de 100 tornillos de acero inoxidable, cabeza Phillips.', 15.50, 500),
(2, 'Tuercas Hexagonales', 'Paquete de 50 tuercas M6.', 8.75, 300),
(1, 'Arandelas Planas', 'Bolsa de 200 arandelas de presión.', 5.25, 1000),
(3, 'Martillo de Carpintero', 'Martillo con cabeza de acero y mango de madera.', 22.00, 50),
(5, 'Destornillador Estrella', 'Juego de 5 destornilladores de estrella.', 18.90, 150);

INSERT INTO clientes (nombre, direccion, telefono, email) VALUES
('Cliente X Constructora', 'Gran Vía 10, Ciudad Capital', '555-0201', 'compras@clientex.com'),
('Cliente Y Ferretería', 'Calle Comercial 25, Barrio Nuevo', '555-0202', 'pedidos@clientey.es'),
('Cliente Z Taller', 'Polígono Industrial Nave 5, Zona Franca', '555-0203', 'tallerz@email.com'),
('Cliente W Hogar', 'Residencial Los Pinos Casa 1A', '555-0204', 'hogarw@mail.net'),
('Cliente V Bricolaje', 'Centro Comercial Sur Local 33', '555-0205', 'bricov@example.org');

INSERT INTO vendedor (nombre, comision) VALUES
('Ana García', 0.050),
('Carlos López', 0.065),
('Sofía Martínez', 0.055),
('David Rodríguez', 0.070),
('Laura Fernández', 0.060);

INSERT INTO ventas (id_cli, id_vend, fecha, total) VALUES
(1, 1, '2024-07-01 10:00:00', 155.00),
(2, 2, '2024-07-01 11:30:00', 87.50),
(3, 3, '2024-07-02 09:15:00', 110.00),
(4, 4, '2024-07-02 14:00:00', 37.80),
(5, 5, '2024-07-03 16:45:00', 94.50);

INSERT INTO detalle_venta (id_venta, id_prod, cantidad, precio_unitario) VALUES
(1, 1, 10, 15.50),
(2, 2, 10, 8.75),
(3, 4, 5, 22.00),
(4, 5, 2, 18.90),
(5, 5, 5, 18.90);

SELECT * FROM proveedores LIMIT 1;
SELECT * FROM productos LIMIT 1;
SELECT * FROM clientes LIMIT 1;
SELECT * FROM vendedor LIMIT 1;
SELECT * FROM ventas LIMIT 1;
SELECT * FROM detalle_venta LIMIT 1;

SELECT id_prov, nombre, email FROM proveedores LIMIT 1;
SELECT id_prod, nombre, precio, stock FROM productos LIMIT 1;
SELECT id_cli, nombre, telefono, email FROM clientes LIMIT 1;
SELECT id_vend, nombre, comision FROM vendedor LIMIT 1;
SELECT id_venta, id_cli, id_vend, fecha, total FROM ventas LIMIT 1;
SELECT id_detalle, id_venta, id_prod, cantidad, precio_unitario FROM detalle_venta LIMIT 1;

UPDATE proveedores SET telefono = '555-0199' WHERE id_prov = 1;
UPDATE productos SET precio = 16.00, stock = 490 WHERE id_prod = 1;
UPDATE clientes SET direccion = 'Gran Vía 10, Oficina 3, Ciudad Capital' WHERE id_cli = 1;
UPDATE vendedor SET comision = 0.052 WHERE id_vend = 1;
UPDATE ventas SET total = 160.00 WHERE id_venta = 1;
UPDATE detalle_venta SET cantidad = 10, precio_unitario = 16.00 WHERE id_detalle = 1;

SET FOREIGN_KEY_CHECKS=0;

DELETE FROM detalle_venta WHERE id_detalle = 5;
DELETE FROM ventas WHERE id_venta = 5;
DELETE FROM productos WHERE id_prod = 5;
DELETE FROM clientes WHERE id_cli = 5;
DELETE FROM vendedor WHERE id_vend = 5;
DELETE FROM proveedores WHERE id_prov = 5;

SET FOREIGN_KEY_CHECKS=1;
```

## psql_consultorio.sql:

```sql
- 1. Insertar cinco datos en cada tabla:

-- Specialties
INSERT INTO Specialties (specialty_name, description) VALUES
('Cardiology', 'Diagnosis and treatment of heart disorders.'),
('Neurology', 'Branch of medicine dealing with disorders of the nervous system.'),
('Pediatrics', 'Branch of medicine dealing with children and their diseases.'),
('Oncology', 'Branch of medicine that deals with tumors and cancer.'),
('Dermatology', 'Branch of medicine concerned with the skin and its diseases.');

-- Doctors
INSERT INTO Doctors (first_name, last_name, specialty_id, phone_number, email, professional_license_number) VALUES
('John', 'Doe', 1, '555-0101', 'john.doe@example.com', 'MD1001'),
('Jane', 'Smith', 2, '555-0102', 'jane.smith@example.com', 'MD1002'),
('Alice', 'Brown', 1, '555-0103', 'alice.brown@example.com', 'MD1003'),
('Bob', 'White', 3, '555-0104', 'bob.white@example.com', 'MD1004'),
('Eve', 'Black', 5, '555-0105', 'eve.black@example.com', 'MD1005');

-- Patients
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, address, phone_number, email, social_security_number) VALUES
('Carlos', 'Rivera', '1985-06-15', 'M', '123 Oak St, Cityville', '555-0201', 'carlos.rivera@example.com', 'SSN001'),
('Laura', 'Gomez', '1992-03-22', 'F', '456 Pine St, Townsville', '555-0202', 'laura.gomez@example.com', 'SSN002'),
('Pedro', 'Martinez', '1978-11-01', 'M', '789 Maple Ave, Villagetown', '555-0203', 'pedro.martinez@example.com', 'SSN003'),
('Sofia', 'Lopez', '2001-07-30', 'F', '101 Elm Rd, Boroughburg', '555-0204', 'sofia.lopez@example.com', 'SSN004'),
('Diego', 'Hernandez', '1995-01-10', 'M', '202 Birch Ln, Hamletville', '555-0205', 'diego.hernandez@example.com', 'SSN005');

-- Medical_Records (creation_date has DEFAULT CURRENT_TIMESTAMP)
INSERT INTO Medical_Records (patient_id, personal_history, family_history, allergies, general_notes) VALUES
(1, 'Healthy, non-smoker.', 'Father had hypertension.', 'Penicillin.', 'Annual check-up.'),
(2, 'Asthma diagnosed in childhood.', 'Mother had diabetes.', 'None known.', 'Follow-up for asthma.'),
(3, 'Previous knee surgery.', 'No significant family history.', 'Sulfa drugs.', 'Post-surgery check-up.'),
(4, 'Generally healthy.', 'Grandmother had breast cancer.', 'None known.', 'Routine physical.'),
(5, 'Type 1 Diabetes.', 'Father has Type 1 Diabetes.', 'Shellfish.', 'Diabetes management.');

-- Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_datetime, reason_for_visit, appointment_status, appointment_notes) VALUES
(1, 1, '2024-08-01 10:00:00', 'Chest pain evaluation', 'Scheduled', 'Patient reports intermittent chest pain.'),
(2, 2, '2024-08-01 11:00:00', 'Headache consultation', 'Confirmed', 'Persistent headaches for 2 weeks.'),
(1, 3, '2024-08-02 09:30:00', 'Follow-up cardiology', 'Scheduled', 'Review test results.'),
(4, 4, '2024-08-03 14:00:00', 'Child vaccination', 'Completed', 'Routine vaccinations administered.'),
(5, 5, '2024-08-03 15:00:00', 'Skin rash', 'Scheduled', 'New rash on arm.');

-- Office_Assignments
INSERT INTO Office_Assignments (doctor_id, office_identifier, start_datetime, end_datetime, session_notes) VALUES
(1, 'Office 101', '2024-08-01 08:00:00', '2024-08-01 12:00:00', 'Morning clinic session'),
(2, 'Office 102', '2024-08-01 09:00:00', '2024-08-01 13:00:00', 'Neurology consultations'),
(3, 'Office 101', '2024-08-02 08:00:00', '2024-08-02 12:00:00', 'Cardiology follow-ups'),
(4, 'Office 201', '2024-08-03 13:00:00', '2024-08-03 17:00:00', 'Pediatric clinic'),
(5, 'Office 202', '2024-08-03 14:00:00', '2024-08-03 18:00:00', 'Dermatology appointments');

-- Treatments
INSERT INTO Treatments (treatment_name, treatment_description, estimated_cost) VALUES
('ECG Test', 'Electrocardiogram to check heart rhythm.', 75.00),
('Neurological Exam', 'Comprehensive assessment of neurological function.', 150.00),
('Standard Vaccination Set', 'Set of standard childhood vaccines.', 120.00),
('Biopsy of Skin Lesion', 'Removal and examination of a skin sample.', 200.00),
('Topical Corticosteroid Cream', 'Cream for skin inflammation.', 30.00);

-- Applied_Treatments
INSERT INTO Applied_Treatments (medical_record_id, appointment_id, treatment_id, treatment_start_date, treatment_status, prescribing_doctor_id, treatment_notes) VALUES
(1, 1, 1, '2024-08-01', 'Completed', 1, 'ECG performed during appointment.'),
(2, 2, 2, '2024-08-01', 'In Progress', 2, 'Neurological exam initiated.'),
(1, 3, 1, '2024-08-02', 'Prescribed', 3, 'Further heart monitoring advised.'),
(4, 4, 3, '2024-08-03', 'Completed', 4, 'Vaccines administered as scheduled.'),
(5, 5, 5, '2024-08-03', 'Prescribed', 5, 'Prescribed cream for rash.');

-- Invoices (issue_date has DEFAULT CURRENT_DATE)
INSERT INTO Invoices (appointment_id, patient_id, total_amount, payment_status, payment_method) VALUES
(1, 1, 75.00, 'Pending', NULL),
(2, 2, 150.00, 'Paid', 'Credit Card'),
(3, 1, 50.00, 'Pending', NULL),
(4, 4, 120.00, 'Paid', 'Insurance'),
(5, 5, 30.00, 'Pending', NULL);


-- 2. Consultar los datos contenidos al menos en una fila de cada tabla:
SELECT * FROM Specialties FETCH FIRST 1 ROW ONLY;
SELECT * FROM Doctors FETCH FIRST 1 ROW ONLY;
SELECT * FROM Patients FETCH FIRST 1 ROW ONLY;
SELECT * FROM Medical_Records FETCH FIRST 1 ROW ONLY;
SELECT * FROM Appointments FETCH FIRST 1 ROW ONLY;
SELECT * FROM Office_Assignments FETCH FIRST 1 ROW ONLY;
SELECT * FROM Treatments FETCH FIRST 1 ROW ONLY;
SELECT * FROM Applied_Treatments FETCH FIRST 1 ROW ONLY;
SELECT * FROM Invoices FETCH FIRST 1 ROW ONLY;

-- Datos especificos de cada tabla:

SELECT id, specialty_name, description FROM Specialties FETCH FIRST 1 ROW ONLY;
SELECT id, first_name, last_name, email, professional_license_number FROM Doctors FETCH FIRST 1 ROW ONLY;
SELECT id, first_name, last_name, date_of_birth, email FROM Patients FETCH FIRST 1 ROW ONLY;
SELECT id, patient_id, creation_date, allergies FROM Medical_Records FETCH FIRST 1 ROW ONLY;
SELECT id, patient_id, doctor_id, appointment_datetime, appointment_status FROM Appointments FETCH FIRST 1 ROW ONLY;
SELECT id, doctor_id, office_identifier, start_datetime, end_datetime FROM Office_Assignments FETCH FIRST 1 ROW ONLY;
SELECT id, treatment_name, estimated_cost, treatment_description FROM Treatments FETCH FIRST 1 ROW ONLY;
SELECT id, medical_record_id, treatment_id, treatment_status, treatment_start_date FROM Applied_Treatments FETCH FIRST 1 ROW ONLY;
SELECT id, patient_id, total_amount, payment_status, issue_date FROM Invoices FETCH FIRST 1 ROW ONLY;


-- 3. Modificar los datos contenidos al menos en una fila de cada tabla:
UPDATE Specialties SET description = 'Specialized in heart and blood vessel diseases.' WHERE id = 1;
UPDATE Doctors SET phone_number = '555-0199' WHERE id = 1;
UPDATE Patients SET address = '123 Oak Street, New Cityville' WHERE id = 1;
UPDATE Medical_Records SET allergies = 'Penicillin, Aspirin' WHERE id = 1;
UPDATE Appointments SET appointment_status = 'Confirmed' WHERE id = 1;
UPDATE Office_Assignments SET office_identifier = 'Clinic Room A' WHERE id = 1;
UPDATE Treatments SET estimated_cost = 80.00 WHERE id = 1;
UPDATE Applied_Treatments SET treatment_status = 'In Progress' WHERE id = 1;
UPDATE Invoices SET payment_status = 'Partially Paid', total_amount = 70.00 WHERE id = 1;


-- 4. Eliminar los datos contenidos al menos en una fila de cada tabla (deleting record with id=5 for related tables):
DELETE FROM Invoices WHERE id = 5;
DELETE FROM Applied_Treatments WHERE id = 5;
DELETE FROM Appointments WHERE id = 5;
DELETE FROM Office_Assignments WHERE id = 5;
DELETE FROM Medical_Records WHERE id = 5;
DELETE FROM Patients WHERE id = 5;
DELETE FROM Doctors WHERE id = 5;
DELETE FROM Treatments WHERE id = 5;
DELETE FROM Specialties WHERE id = 5;

SELECT 'Script completado.' AS estado_final;
```

## psql_exportadora.sql:

```sql
-- 1. Insertar cinco datos:

-- suppliers
INSERT INTO suppliers (name, contact_person, email, phone, address, payment_terms) VALUES
('Global Fruit Exporters', 'Maria Rodriguez', 'maria.r@globalfruit.com', '555-0101', '123 Fruit Lane, AgroCity', 'Net 30 days'),
('Organic Veggies Co.', 'John Green', 'john.g@organicveggies.com', '555-0102', '456 Veggie Road, Farmville', 'Net 45 days'),
('Artisan Goods Ltd.', 'Sophie Dubois', 'sophie.d@artisangoods.com', '555-0103', '789 Craft Ave, Handcrafton', 'COD'),
('Tech Components Inc.', 'Raj Patel', 'raj.p@techcomp.com', '555-0104', '101 Circuit St, Techburg', 'Net 60 days'),
('Premium Coffee Beans', 'Luisa Fernandez', 'luisa.f@premiumbeans.com', '555-0105', '202 Bean Blvd, Coffeton', 'Prepayment');

-- products
INSERT INTO products (sku, name, description, cost_price, unit_of_measure, supplier_id, country_of_origin, hs_code, weight_per_unit, dimension_l_cm, dimension_w_cm, dimension_h_cm) VALUES
('FRT-AVO-001', 'Fresh Avocados', 'Hass avocados, premium quality', 1.50, 'kg', 1, 'Mexico', '080440', 0.250, 10, 7, 7),
('VEG-TOM-005', 'Organic Tomatoes', 'Vine-ripened organic tomatoes', 2.20, 'kg', 2, 'Spain', '070200', 0.150, 8, 8, 6),
('ART-CER-012', 'Handmade Ceramic Mug', 'Artisan ceramic mug, blue glaze', 12.00, 'pieza', 3, 'Portugal', '691200', 0.400, 9, 9, 10),
('TEC-RAM-128', 'RAM Module 8GB DDR4', '8GB DDR4 Desktop RAM', 35.50, 'pieza', 4, 'Taiwan', '847330', 0.050, 13.3, 0.5, 3.1),
('COF-ARA-002', 'Arabica Coffee Beans', 'Whole Arabica coffee beans, medium roast', 15.75, 'bolsa', 5, 'Colombia', '090121', 1.000, 20, 10, 30);

-- clients
INSERT INTO clients (company_name, contact_person, email, phone, billing_address, shipping_address, country, tax_id, credit_limit, payment_terms_agreed) VALUES
('SuperMarket Chain EU', 'Peter Schmidt', 'peter.s@supermarket.eu', '+49 123 456789', 'Europa Allee 1, Berlin, Germany', 'Central Warehouse, Hamburg Port, Germany', 'Germany', 'DE123456789', 50000.00, 'Net 30 days'),
('Fine Foods Inc. USA', 'Alice Wonderland', 'alice.w@finefoods.com', '+1 212 555 0123', '1 Gourmet Plaza, New York, NY, USA', 'East Coast Distribution, NJ, USA', 'USA', 'US987654321', 75000.00, 'Net 45 days'),
('Boutique Delights FR', 'Antoine Moreau', 'antoine.m@boutiquefr.com', '+33 1 2345 6789', '5 Rue de la Paix, Paris, France', '5 Rue de la Paix, Paris, France', 'France', 'FR9876543210', 20000.00, 'COD'),
('Tech Solutions JP', 'Kenji Tanaka', 'kenji.t@techjp.com', '+81 3 1234 5678', '1-1-1 Chiyoda, Tokyo, Japan', 'Tech Park, Yokohama, Japan', 'Japan', 'JP1234567890123', 100000.00, 'Net 60 days'),
('Cafe World UK', 'Sarah Miller', 'sarah.m@cafeworld.uk', '+44 20 7123 4567', '10 Coffee Lane, London, UK', '10 Coffee Lane, London, UK', 'UK', 'GB123456789', 15000.00, 'Net 15 days');

-- sales_orders
INSERT INTO sales_orders (order_number, client_id, order_date, status, currency, total_amount, expected_ship_date, notes) VALUES
('SO-2024-001', 1, '2024-07-01', 'confirmed', 'EUR', 1500.00, '2024-07-10', 'Urgent order for avocados'),
('SO-2024-002', 2, '2024-07-03', 'processing', 'USD', 2200.00, '2024-07-15', 'Organic tomatoes, check quality certificates'),
('SO-2024-003', 3, '2024-07-05', 'ready_for_shipment', 'EUR', 120.00, '2024-07-08', 'Handle with care - fragile items'),
('SO-2024-004', 4, '2024-07-06', 'pending_confirmation', 'JPY', 355000.00, '2024-07-20', 'RAM modules for new office setup'),
('SO-2024-005', 5, '2024-07-07', 'shipped', 'GBP', 315.00, '2024-07-09', '20 bags of coffee beans');

-- order_items
-- line_total = quantity * unit_price * (1 - discount_percentage / 100.0)
INSERT INTO order_items (sales_order_id, product_id, quantity, unit_price, discount_percentage, line_total) VALUES
(1, 1, 1000, 1.50, 0.00, 1500.00), -- Avocados for SO-2024-001
(2, 2, 1000, 2.20, 0.00, 2200.00), -- Tomatoes for SO-2024-002
(3, 3, 10, 12.00, 0.00, 120.00),   -- Mugs for SO-2024-003
(4, 4, 100, 35.50, 5.00, 3372.50), -- RAM for SO-2024-004
(5, 5, 20, 15.75, 0.00, 315.00);   -- Coffee for SO-2024-005

-- shipments
INSERT INTO shipments (shipment_number, sales_order_id, ship_date, carrier_name, tracking_number, port_of_loading, port_of_discharge, estimated_arrival_date, status, freight_cost, insurance_cost) VALUES
('SHP-001-EU', 1, '2024-07-10', 'Maersk Line', 'MSKU1234567', 'Port of Veracruz', 'Port of Hamburg', '2024-07-25', 'in_transit', 300.00, 15.00),
('SHP-002-US', 2, '2024-07-15', 'DHL Express', 'DHL789101112', 'Madrid Airport', 'JFK Airport', '2024-07-18', 'pending_delivery', 450.00, 22.00),
('SHP-003-FR', 3, '2024-07-08', 'FedEx Ground', 'FDX234567890', 'Handcrafton Hub', 'Paris CDG', '2024-07-12', 'delivered', 20.00, 1.00),
('SHP-004-JP', NULL, NULL, 'Nippon Express', NULL, 'Taoyuan Port', 'Port of Tokyo', '2024-07-30', 'pending_shipment', 150.00, 7.50),
('SHP-005-UK', 5, '2024-07-09', 'Royal Mail', 'RM345678901GB', 'Bogota El Dorado', 'London Heathrow', '2024-07-14', 'delivered', 50.00, 2.50);

-- commercial_invoices
INSERT INTO commercial_invoices (invoice_number, sales_order_id, client_id, issue_date, due_date, total_amount, currency, payment_status, notes) VALUES
('INV-2024-001', 1, 1, '2024-07-10', '2024-08-09', 1500.00, 'EUR', 'pending', 'Avocado shipment invoice'),
('INV-2024-002', 2, 2, '2024-07-15', '2024-08-29', 2200.00, 'USD', 'partially_paid', 'Tomatoes shipment invoice, partial payment received'),
('INV-2024-003', 3, 3, '2024-07-08', '2024-07-08', 120.00, 'EUR', 'paid', 'Ceramic mugs, COD'),
('INV-2024-004', 4, 4, '2024-07-06', '2024-09-04', 337250.00, 'JPY', 'pending', 'RAM modules, initial invoice based on order SO-2024-004. Assuming unit price was in JPY for order_items here.'),
('INV-2024-005', 5, 5, '2024-07-09', '2024-07-24', 315.00, 'GBP', 'paid', 'Coffee beans shipment');

-- 2. Consultar los datos contenidos al menos en una fila de cada tabla:
SELECT * FROM suppliers FETCH FIRST 1 ROW ONLY;
SELECT * FROM products FETCH FIRST 1 ROW ONLY;
SELECT * FROM clients FETCH FIRST 1 ROW ONLY;
SELECT * FROM sales_orders FETCH FIRST 1 ROW ONLY;
SELECT * FROM order_items FETCH FIRST 1 ROW ONLY;
SELECT * FROM shipments FETCH FIRST 1 ROW ONLY;
SELECT * FROM commercial_invoices FETCH FIRST 1 ROW ONLY;


-- Datos especificos en cada tabla para que no sea solo "*"
SELECT id, name, email, phone FROM suppliers FETCH FIRST 1 ROW ONLY;
SELECT id, sku, name, cost_price, unit_of_measure FROM products FETCH FIRST 1 ROW ONLY;
SELECT id, company_name, email, country, credit_limit FROM clients FETCH FIRST 1 ROW ONLY;
SELECT id, order_number, client_id, status, total_amount FROM sales_orders FETCH FIRST 1 ROW ONLY;
SELECT id, sales_order_id, product_id, quantity, line_total FROM order_items FETCH FIRST 1 ROW ONLY;
SELECT id, shipment_number, sales_order_id, status, carrier_name FROM shipments FETCH FIRST 1 ROW ONLY;
SELECT id, invoice_number, client_id, total_amount, payment_status FROM commercial_invoices FETCH FIRST 1 ROW ONLY;

-- 3. Modificar los datos contenidos al menos en una fila de cada tabla:
UPDATE suppliers SET phone = '555-0199' WHERE id = 1;
UPDATE products SET cost_price = 1.60 WHERE id = 1;
UPDATE clients SET credit_limit = 55000.00 WHERE id = 1;
UPDATE sales_orders SET status = 'ready_for_shipment', notes = 'Urgent order for avocados, confirmed ready' WHERE id = 1;
UPDATE order_items SET quantity = 950, line_total = (950 * 1.50 * (1 - 0.00 / 100.0)) WHERE id = 1;
UPDATE shipments SET carrier_name = 'MSC', estimated_arrival_date = '2024-07-26' WHERE id = 1;
UPDATE commercial_invoices SET payment_status = 'paid', due_date = '2024-07-15' WHERE id = 3;

-- 4. Eliminar los datos contenidos al menos en una fila de cada tabla.

DELETE FROM order_items WHERE product_id = 5;
DELETE FROM commercial_invoices WHERE client_id = 5;
DELETE FROM sales_orders WHERE client_id = 5;
DELETE FROM commercial_invoices WHERE id = 5;
DELETE FROM shipments WHERE id = 5;
DELETE FROM order_items WHERE id = 5;
DELETE FROM sales_orders WHERE id = 5;
DELETE FROM products WHERE id = 5;
DELETE FROM clients WHERE id = 5;
DELETE FROM suppliers WHERE id = 5;
```

## mysql_zapateria.sql

```sql


-- 1. Inserción de Datos: Insertar cinco registros de ejemplo en cada una de las tablas.

INSERT INTO `proveedores` (`nombre_proveedor`, `direccion`, `telefono`, `email`) VALUES
('Calzados El Sol', 'Calle Sol 123, Ciudad Grande', '555-1001', 'ventas@elsol.com'),
('Botas Fuertes Inc.', 'Avenida Roble 45, Villa Montaña', '555-1002', 'contacto@botasfuertes.com'),
('Sandalias Playeras Ltd.', 'Paseo Marítimo 7, Costa Bella', '555-1003', 'info@sandaliasplayeras.com'),
('Zapatillas Rápidas Co.', 'Carrera Veloz 99, Metrópolis', '555-1004', 'pedidos@zapatillasrapidas.com'),
('Elegancia Formal S.A.', 'Boulevard Glamour 21, Capital', '555-1005', 'soporte@eleganciaformal.com');

INSERT INTO `clientes` (`nombre_cliente`, `apellido_cliente`, `direccion`, `Telefono`, `email`) VALUES
('Ana', 'Pérez', 'Calle Luna 10, Barrio Centro', '555-0201', 'ana.perez@email.com'),
('Luis', 'Gómez', 'Avenida Estrella 25, Colonia Norte', '555-0202', 'luis.gomez@email.com'),
('Sofía', 'Martínez', 'Pasaje Flores 3, Residencial Sur', '555-0203', 'sofia.martinez@email.com'),
('Carlos', 'Rodríguez', 'Camino Viejo 88, Zona Oeste', '555-0204', 'carlos.rodriguez@email.com'),
('Laura', 'Fernández', 'Plaza Principal 1, Pueblo Nuevo', '555-0205', 'laura.fernandez@email.com');

INSERT INTO `vendedor` (`nombre_vendedor`, `apellido_vendedor`, `email`, `Telefono`) VALUES
('Juan', 'López', 'juan.lopez@zapateria.com', '555-0301'),
('María', 'García', 'maria.garcia@zapateria.com', '555-0302'),
('Pedro', 'Sánchez', 'pedro.sanchez@zapateria.com', '555-0303'),
('Lucía', 'Díaz', 'lucia.diaz@zapateria.com', '555-0304'),
('Miguel', 'Hernández', 'miguel.hernandez@zapateria.com', '555-0305');

INSERT INTO `productos_deposito` (`nombre_producto`, `descripcion`, `precio_costo`, `precio_venta`, `stock`, `id_proveedor`) VALUES
('Zapato Casual Hombre', 'Zapato de cuero marrón, talla 42', 25.50, 49.99, 50, 1),
('Bota de Montaña Mujer', 'Bota impermeable, color gris, talla 38', 40.00, 79.90, 30, 2),
('Sandalia Playa Unisex', 'Sandalia de goma, varios colores, talla M', 8.00, 15.00, 100, 3),
('Zapatilla Deportiva Niño', 'Zapatilla para correr, azul y verde, talla 30', 18.75, 35.50, 75, 4),
('Zapato de Vestir Hombre', 'Zapato de charol negro, elegante, talla 43', 55.00, 99.99, 20, 5);

INSERT INTO `ventas` (`id_cliente`, `id_vendedor`, `fecha_venta`, `total_venta`, `detalles_venta`) VALUES
(1, 1, '2024-05-10 10:30:00', 49.99, '1x Zapato Casual Hombre (ID:1)'),
(2, 2, '2024-05-11 15:00:00', 79.90, '1x Bota de Montaña Mujer (ID:2)'),
(3, 3, '2024-05-12 12:15:00', 15.00, '1x Sandalia Playa Unisex (ID:3)'),
(4, 4, '2024-05-13 17:45:00', 35.50, '1x Zapatilla Deportiva Niño (ID:4)'),
(5, 5, '2024-05-14 09:00:00', 99.99, '1x Zapato de Vestir Hombre (ID:5)');


-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.
SELECT * FROM `proveedores` LIMIT 1;
SELECT `id_proveedor`, `nombre_proveedor`, `email` FROM `proveedores` LIMIT 1;

SELECT * FROM `clientes` LIMIT 1;
SELECT `id_cliente`, `nombre_cliente`, `apellido_cliente`, `email` FROM `clientes` LIMIT 1;

SELECT * FROM `vendedor` LIMIT 1;
SELECT `id_Vendedor`, `nombre_vendedor`, `apellido_vendedor`, `email` FROM `vendedor` LIMIT 1;

SELECT * FROM `productos_deposito` LIMIT 1;
SELECT `id_producto`, `nombre_producto`, `precio_venta`, `stock` FROM `productos_deposito` LIMIT 1;

SELECT * FROM `ventas` LIMIT 1;
SELECT `id_venta`, `id_cliente`, `id_vendedor`, `fecha_venta`, `total_venta` FROM `ventas` LIMIT 1;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (generalmente el primero) de cada una de las tablas.
UPDATE `proveedores` SET `telefono` = '555-1099' WHERE `id_proveedor` = 1;
UPDATE `clientes` SET `direccion` = 'Calle Luna 10, Barrio Centro (Actualizado)' WHERE `id_cliente` = 1;
UPDATE `vendedor` SET `Telefono` = '555-0399' WHERE `id_Vendedor` = 1;
UPDATE `productos_deposito` SET `stock` = 45 WHERE `id_producto` = 1;
UPDATE `ventas` SET `total_venta` = 50.00 WHERE `id_venta` = 1;


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.
SET FOREIGN_KEY_CHECKS=0; -- Desactivar temporalmente para facilitar borrados si hay dependencias no deseadas

DELETE FROM `ventas` WHERE `id_venta` = (SELECT `id_venta` FROM (SELECT `id_venta` FROM `ventas` ORDER BY `id_venta` DESC LIMIT 1) as v);
DELETE FROM `productos_deposito` WHERE `id_producto` = (SELECT `id_producto` FROM (SELECT `id_producto` FROM `productos_deposito` ORDER BY `id_producto` DESC LIMIT 1) as pd);
DELETE FROM `vendedor` WHERE `id_Vendedor` = (SELECT `id_Vendedor` FROM (SELECT `id_Vendedor` FROM `vendedor` ORDER BY `id_Vendedor` DESC LIMIT 1) as vd);
DELETE FROM `clientes` WHERE `id_cliente` = (SELECT `id_cliente` FROM (SELECT `id_cliente` FROM `clientes` ORDER BY `id_cliente` DESC LIMIT 1) as cl);
DELETE FROM `proveedores` WHERE `id_proveedor` = (SELECT `id_proveedor` FROM (SELECT `id_proveedor` FROM `proveedores` ORDER BY `id_proveedor` DESC LIMIT 1) as pr);

SET FOREIGN_KEY_CHECKS=1; -- Reactivar chequeo de claves foráneas


```

## mysql_poblacion.sql

```sql


-- 1. Inserción de Datos: Insertar cinco registros de ejemplo en cada una de las tablas.
INSERT INTO `paises` (`nombre_pais`, `codigo_iso`) VALUES
('México', 'MEX'),
('Estados Unidos', 'USA'),
('Canadá', 'CAN'),
('Brasil', 'BRA'),
('Argentina', 'ARG');

INSERT INTO `estados` (`nombre_estado`, `id_pais_fk`) VALUES
('Jalisco', 1),
('California', 2),
('Ontario', 3),
('São Paulo', 4),
('Buenos Aires', 5);

INSERT INTO `municipios` (`nombre_municipio`, `id_estado_fk`) VALUES
('Guadalajara', 1),
('Los Angeles', 2),
('Toronto', 3),
('São Paulo', 4), -- Municipio de São Paulo
('La Plata', 5);

INSERT INTO `densidad_poblacion` (`id_municipio_fk`, `anio`, `poblacion`, `densidad_km2`) VALUES
(1, 2023, 1460148, 9288.00),
(2, 2023, 3849000, 3200.50),
(3, 2023, 2794000, 4334.40),
(4, 2023, 12330000, 7946.90),
(5, 2023, 654324, 718.20);

INSERT INTO `dirigentes` (`nombre_completo`, `cargo`, `id_pais_fk`, `id_estado_fk`, `id_municipio_fk`) VALUES
('Andrés Manuel López Obrador', 'Presidente', 1, NULL, NULL),
('Joe Biden', 'Presidente', 2, NULL, NULL),
('Enrique Alfaro Ramírez', 'Gobernador', 1, 1, NULL),
('Gavin Newsom', 'Gobernador', 2, 2, NULL),
('Pablo Lemus Navarro', 'Alcalde', 1, 1, 1);


-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.
SELECT * FROM `paises` LIMIT 1;
SELECT `id_pais`, `nombre_pais`, `codigo_iso` FROM `paises` LIMIT 1;

SELECT * FROM `estados` LIMIT 1;
SELECT `id_estado`, `nombre_estado`, `id_pais_fk` FROM `estados` LIMIT 1;

SELECT * FROM `municipios` LIMIT 1;
SELECT `id_Municipio`, `nombre_municipio`, `id_estado_fk` FROM `municipios` LIMIT 1;

SELECT * FROM `densidad_poblacion` LIMIT 1;
SELECT `id_densidad`, `id_municipio_fk`, `anio`, `poblacion` FROM `densidad_poblacion` LIMIT 1;

SELECT * FROM `dirigentes` LIMIT 1;
SELECT `id_dirigente`, `nombre_completo`, `cargo`, `id_pais_fk` FROM `dirigentes` LIMIT 1;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (generalmente el primero) de cada una de las tablas.
UPDATE `paises` SET `codigo_iso` = 'MX' WHERE `id_pais` = 1;
UPDATE `estados` SET `nombre_estado` = 'Jalisco MX' WHERE `id_estado` = 1;
UPDATE `municipios` SET `nombre_municipio` = 'Guadalajara Centro' WHERE `id_Municipio` = 1;
UPDATE `densidad_poblacion` SET `poblacion` = 1500000 WHERE `id_densidad` = 1;
UPDATE `dirigentes` SET `nombre_completo` = 'Andrés M. López Obrador' WHERE `id_dirigente` = 1;


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.
DELETE FROM `densidad_poblacion` WHERE `id_municipio_fk` = 5 LIMIT 1;
DELETE FROM `dirigentes` WHERE `id_pais_fk` = 5 AND `cargo` = 'Presidente' LIMIT 1;
DELETE FROM `municipios` WHERE `id_Municipio` = 5;
DELETE FROM `estados` WHERE `id_estado` = 5;
DELETE FROM `paises` WHERE `id_pais` = 5;
DELETE FROM `densidad_poblacion` WHERE `id_densidad` = (SELECT `id_densidad` FROM (SELECT `id_densidad` FROM `densidad_poblacion` ORDER BY `id_densidad` DESC LIMIT 1) as dp);
DELETE FROM `dirigentes` WHERE `id_dirigente` = (SELECT `id_dirigente` FROM (SELECT `id_dirigente` FROM `dirigentes` ORDER BY `id_dirigente` DESC LIMIT 1) as dr);
DELETE FROM `municipios` WHERE `id_Municipio` = (SELECT `id_Municipio` FROM (SELECT `id_Municipio` FROM `municipios` ORDER BY `id_Municipio` DESC LIMIT 1) as mn);
DELETE FROM `estados` WHERE `id_estado` = (SELECT `id_estado` FROM (SELECT `id_estado` FROM `estados` ORDER BY `id_estado` DESC LIMIT 1) as es);
DELETE FROM `paises` WHERE `id_pais` = (SELECT `id_pais` FROM (SELECT `id_pais` FROM `paises` ORDER BY `id_pais` DESC LIMIT 1) as pa);


```

## psql_biblioteca.sql

```sql

-- 1. Inserción de Datos: Insertar cinco registros de ejemplo en cada una de las tablas.

-- Aisles
INSERT INTO Aisles (aisle_number, number_of_shelves, rows_per_shelf, location_description) VALUES
('A1', 5, 3, 'Fiction Section, 1st Floor East'),
('B2', 6, 4, 'Non-Fiction, 1st Floor West'),
('C3', 4, 3, 'Science & Technology, 2nd Floor North'),
('D4', 5, 2, 'History & Biographies, 2nd Floor South'),
('E5', 3, 5, 'Childrens Books, Ground Floor');

-- Books
INSERT INTO Books (title, author, publication_year, isbn, call_number, publisher, edition, language, number_of_pages, summary) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925, '978-0743273565', 'FIC FIT 1925', 'Charles Scribners Sons', '1st', 'English', 180, 'A story of wealth, love, and the American Dream in the Jazz Age.'),
('To Kill a Mockingbird', 'Harper Lee', 1960, '978-0061120084', 'FIC LEE 1960', 'J.B. Lippincott & Co.', '1st', 'English', 281, 'A novel about innocence, justice, and racial prejudice in the American South.'),
('1984', 'George Orwell', 1949, '978-0451524935', 'FIC ORW 1949', 'Secker & Warburg', '1st', 'English', 328, 'A dystopian novel set in a totalitarian society.'),
('Cosmos', 'Carl Sagan', 1980, '978-0345539434', 'SCI SAG 1980', 'Random House', '1st', 'English', 384, 'An exploration of the universe and our place within it.'),
('A Brief History of Time', 'Stephen Hawking', 1988, '978-0553380163', 'SCI HAW 1988', 'Bantam Books', '1st', 'English', 256, 'A landmark volume in science writing by one of the great minds of our time.');

-- Library_Users
INSERT INTO Library_Users (first_name, last_name, email, phone_number, address, membership_id, status) VALUES
('Alice', 'Wonder', 'alice.wonder@example.com', '555-0101', '123 Wonderland Ave', 'MEM001', 'Active'),
('Bob', 'Builder', 'bob.builder@example.com', '555-0102', '456 Construction Rd', 'MEM002', 'Active'),
('Charlie', 'Chocolate', 'charlie.chocolate@example.com', '555-0103', '789 Factory Ln', 'MEM003', 'Suspended'),
('Diana', 'Prince', 'diana.prince@example.com', '555-0104', '101 Themyscira Way', 'MEM004', 'Active'),
('Edward', 'Elric', 'edward.elric@example.com', '555-0105', '202 Alchemy St', 'MEM005', 'Inactive');

-- Categories
INSERT INTO Categories (category_name, description) VALUES
('Fiction', 'Narrative literary works whose content is produced by the imagination.'),
('Non-Fiction', 'Informational books based on facts, real events, and real people.'),
('Science', 'Books related to scientific disciplines like physics, astronomy, biology.'),
('History', 'Books detailing past events, societies, and civilizations.'),
('Childrens', 'Books written for children.');

-- Inventory (linking to first 5 books and first 5 aisles for simplicity)
INSERT INTO Inventory (book_id, aisle_id, shelf_number, row_number, copy_number, acquisition_date, condition, status) VALUES
(1, 1, 2, 1, 1, '2020-01-15', 'Good', 'Available'),
(2, 1, 3, 2, 1, '2020-02-20', 'New', 'Available'),
(3, 2, 1, 1, 1, '2021-03-10', 'Fair', 'Available'),
(4, 3, 4, 1, 1, '2021-05-05', 'Good', 'Available'),
(5, 3, 2, 3, 1, '2022-06-25', 'Good', 'Available');

-- Update inventory status for items that will be loaned out
UPDATE Inventory SET status = 'On Loan' WHERE id IN (1, 2, 3, 4, 5); -- Simulate all 5 are loaned out for initial loan data

-- Loans
INSERT INTO Loans (inventory_id, user_id, loan_date, due_date, status) VALUES
(1, 1, CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '4 days', 'Active'),
(2, 2, CURRENT_DATE - INTERVAL '20 days', CURRENT_DATE - INTERVAL '6 days', 'Returned'),
(3, 3, CURRENT_DATE - INTERVAL '5 days', CURRENT_DATE + INTERVAL '9 days', 'Active'),
(4, 4, CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE - INTERVAL '2 days', 'Overdue'),
(5, 5, CURRENT_DATE - INTERVAL '2 days', CURRENT_DATE + INTERVAL '12 days', 'Active');
-- Manually update return_date for the returned loan
UPDATE Loans SET return_date = CURRENT_DATE - INTERVAL '5 days' WHERE id = 2;

-- Book_Categories
INSERT INTO Book_Categories (book_id, category_id) VALUES
(1, 1), -- The Great Gatsby -> Fiction
(2, 1), -- To Kill a Mockingbird -> Fiction
(3, 1), -- 1984 -> Fiction
(4, 3), -- Cosmos -> Science
(5, 3); -- A Brief History of Time -> Science

-- Aisle_Categories
INSERT INTO Aisle_Categories (aisle_id, category_id) VALUES
(1, 1), -- A1 -> Fiction
(2, 2), -- B2 -> Non-Fiction
(3, 3), -- C3 -> Science
(4, 4), -- D4 -> History
(5, 5); -- E5 -> Childrens


-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.
SELECT * FROM Aisles FETCH FIRST 1 ROW ONLY;
SELECT id, aisle_number, location_description FROM Aisles FETCH FIRST 1 ROW ONLY;

SELECT * FROM Books FETCH FIRST 1 ROW ONLY;
SELECT id, title, author, call_number FROM Books FETCH FIRST 1 ROW ONLY;

SELECT * FROM Library_Users FETCH FIRST 1 ROW ONLY;
SELECT id, first_name, last_name, email, membership_id FROM Library_Users FETCH FIRST 1 ROW ONLY;

SELECT * FROM Categories FETCH FIRST 1 ROW ONLY;
SELECT id, category_name FROM Categories FETCH FIRST 1 ROW ONLY;

SELECT * FROM Inventory FETCH FIRST 1 ROW ONLY;
SELECT id, book_id, aisle_id, status, condition FROM Inventory FETCH FIRST 1 ROW ONLY;

SELECT * FROM Loans FETCH FIRST 1 ROW ONLY;
SELECT id, inventory_id, user_id, loan_date, due_date, status FROM Loans FETCH FIRST 1 ROW ONLY;

SELECT * FROM Book_Categories FETCH FIRST 1 ROW ONLY;
SELECT book_id, category_id FROM Book_Categories FETCH FIRST 1 ROW ONLY;

SELECT * FROM Aisle_Categories FETCH FIRST 1 ROW ONLY;
SELECT aisle_id, category_id FROM Aisle_Categories FETCH FIRST 1 ROW ONLY;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (generalmente el primero) de cada una de las tablas.
UPDATE Aisles SET location_description = 'Fiction Section, 1st Floor East Wing' WHERE id = 1;
UPDATE Books SET publication_year = 1926 WHERE id = 1;
UPDATE Library_Users SET phone_number = '555-0199' WHERE id = 1;
UPDATE Categories SET description = 'Narrative literary works whose content is produced by the imagination and story-telling.' WHERE id = 1;
UPDATE Inventory SET condition = 'Very Good', notes = 'Slight wear on cover' WHERE id = 1;
UPDATE Loans SET fine_amount = 5.00, notes = 'User notified of overdue status.' WHERE status = 'Overdue' AND id = 4; -- Target specific loan
UPDATE Book_Categories SET category_id = (SELECT id FROM Categories WHERE category_name = 'Non-Fiction' LIMIT 1) WHERE book_id = 1 AND category_id = (SELECT id FROM Categories WHERE category_name = 'Fiction' LIMIT 1); -- Change Gatsby's category
UPDATE Aisle_Categories SET category_id = (SELECT id FROM Categories WHERE category_name = 'Non-Fiction' LIMIT 1) WHERE aisle_id = 1 AND category_id = (SELECT id FROM Categories WHERE category_name = 'Fiction' LIMIT 1); -- Change Aisle 1's category


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.


DELETE FROM Loans WHERE id = 5;
DELETE FROM Book_Categories WHERE book_id = 5 AND category_id = (SELECT id FROM Categories WHERE category_name = 'Science');
DELETE FROM Aisle_Categories WHERE aisle_id = 5 AND category_id = (SELECT id FROM Categories WHERE category_name = 'Childrens');
DELETE FROM Inventory WHERE id = 5;
DELETE FROM Library_Users WHERE id = 5;
DELETE FROM Books WHERE id = 5;
DELETE FROM Categories WHERE id = 5;
DELETE FROM Aisles WHERE id = 5;

```

## psql_aerolinea.sql

```sql
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
```

## psql_fabricaMaquinaria.sql

```sql
-- 1. Inserción de Datos: Insertar cinco registros de ejemplo en cada una de las tablas.

-- Departments
INSERT INTO Departments (department_name, description, location, cost_center_code) VALUES
('Manufacturing', 'Handles all production processes', 'Building A, Floor 1', 'MFG100'),
('Engineering', 'Designs and improves products and machinery', 'Building B, Floor 2', 'ENG200'),
('Human Resources', 'Manages employee relations and recruitment', 'Building C, Floor 1', 'HR300'),
('Sales & Marketing', 'Promotes and sells company products', 'Building C, Floor 2', 'SM400'),
('Logistics', 'Manages warehousing and shipment of goods', 'Warehouse Complex 1', 'LOG500');

-- Positions
INSERT INTO Positions (position_title, responsibilities_description, hierarchical_level, minimum_salary, maximum_salary) VALUES
('Machine Operator', 'Operates and maintains production machinery.', 1, 30000.00, 45000.00),
('Mechanical Engineer', 'Designs mechanical systems and components.', 3, 60000.00, 90000.00),
('HR Specialist', 'Handles recruitment, onboarding, and employee benefits.', 2, 45000.00, 65000.00),
('Sales Representative', 'Develops client relationships and achieves sales targets.', 2, 40000.00, 75000.00),
('Logistics Coordinator', 'Manages inventory and coordinates shipments.', 2, 42000.00, 60000.00);

-- Employees
INSERT INTO Employees (first_name, last_name, national_id_number, date_of_birth, gender, address, phone_number, corporate_email, hire_date, department_id, position_id, supervisor_id, employee_status) VALUES
('John', 'Doe', 'NID12345601', '1985-03-15', 'M', '123 Production Way', '555-1001', 'john.doe@fabric.com', '2015-06-01', 1, 1, NULL, 'Active'),
('Jane', 'Smith', 'NID12345602', '1990-07-22', 'F', '456 Engineer Blvd', '555-1002', 'jane.smith@fabric.com', '2018-01-10', 2, 2, NULL, 'Active'),
('Robert', 'Brown', 'NID12345603', '1988-11-05', 'M', '789 HR Lane', '555-1003', 'robert.brown@fabric.com', '2019-03-15', 3, 3, 2, 'Active'),
('Emily', 'White', 'NID12345604', '1992-01-30', 'F', '101 Sales St', '555-1004', 'emily.white@fabric.com', '2020-07-01', 4, 4, 2, 'Active'),
('Michael', 'Green', 'NID12345605', '1983-09-12', 'M', '202 Logistics Dr', '555-1005', 'michael.green@fabric.com', '2016-11-20', 5, 5, 2, 'Active');

-- Salaries
INSERT INTO Salaries (employee_id, salary_amount, effective_start_date, currency_code, payment_frequency, notes) VALUES
(1, 40000.00, '2015-06-01', 'USD', 'Monthly', 'Initial salary for John Doe'),
(2, 75000.00, '2018-01-10', 'USD', 'Monthly', 'Initial salary for Jane Smith'),
(3, 55000.00, '2019-03-15', 'USD', 'Monthly', 'Initial salary for Robert Brown'),
(4, 60000.00, '2020-07-01', 'USD', 'Monthly', 'Initial salary for Emily White'),
(5, 50000.00, '2016-11-20', 'USD', 'Monthly', 'Initial salary for Michael Green');

-- Department_Machinery
INSERT INTO Department_Machinery (machine_name, inventory_code, department_id, usage_description, brand, model, serial_number, acquisition_date, acquisition_cost, machine_status, last_maintenance_date) VALUES
('CNC Milling Machine Alpha', 'CNCMA001', 1, 'Precision part manufacturing', 'Haas', 'VF-2', 'SNCNCMA001', '2017-05-20', 120000.00, 'Operational', '2023-12-15'),
('Laser Cutter Beta', 'LSCB002', 1, 'Sheet metal cutting', 'Trumpf', 'TruLaser 3030', 'SNLSCB002', '2019-08-10', 250000.00, 'Operational', '2024-01-20'),
('3D Printer DesignPro', '3DPDP003', 2, 'Prototyping and R&D', 'Stratasys', 'F170', 'SN3DPDP003', '2020-02-01', 35000.00, 'Operational', '2023-11-05'),
('Packaging Machine Gamma', 'PKGGM004', 5, 'Automated product packaging', 'Bosch', 'Pack 202', 'SNPKGGM004', '2018-06-15', 85000.00, 'Operational', '2024-02-10'),
('Heavy-Duty Forklift', 'FORKL005', 5, 'Warehouse material handling', 'Toyota', '8FGCU25', 'SNFORKL005', '2021-03-01', 45000.00, 'Under Maintenance', '2024-03-01');

-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.

-- Departments
SELECT * FROM Departments FETCH FIRST 1 ROW ONLY;
SELECT id, department_name, location FROM Departments FETCH FIRST 1 ROW ONLY;

-- Positions
SELECT * FROM Positions FETCH FIRST 1 ROW ONLY;
SELECT id, position_title, minimum_salary, maximum_salary FROM Positions FETCH FIRST 1 ROW ONLY;

-- Employees
SELECT * FROM Employees FETCH FIRST 1 ROW ONLY;
SELECT id, first_name, last_name, corporate_email, department_id FROM Employees FETCH FIRST 1 ROW ONLY;

-- Salaries
SELECT * FROM Salaries FETCH FIRST 1 ROW ONLY;
SELECT id, employee_id, salary_amount, effective_start_date FROM Salaries FETCH FIRST 1 ROW ONLY;

-- Department_Machinery
SELECT * FROM Department_Machinery FETCH FIRST 1 ROW ONLY;
SELECT id, machine_name, inventory_code, department_id, machine_status FROM Department_Machinery FETCH FIRST 1 ROW ONLY;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (el primero) de cada una de las tablas.

UPDATE Departments SET location = 'Building A, Floor 1 - Main Office' WHERE id = 1;
UPDATE Positions SET minimum_salary = 32000.00, maximum_salary = 48000.00 WHERE id = 1;
UPDATE Employees SET phone_number = '555-999-0001' WHERE id = 1;
UPDATE Salaries SET salary_amount = 42000.00, notes = 'Salary adjustment for John Doe, effective 2024-04-01' WHERE id = 1;
UPDATE Department_Machinery SET machine_status = 'Operational', last_maintenance_date = '2024-03-10', notes = 'Returned to service after minor checkup.' WHERE id = 1;


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.
DELETE FROM Salaries WHERE id = 5;
DELETE FROM Employees WHERE id = 5;
DELETE FROM Positions WHERE id = 5;
DELETE FROM Department_Machinery WHERE department_id = 5;
DELETE FROM Departments WHERE id = 5;
```
