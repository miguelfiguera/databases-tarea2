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
