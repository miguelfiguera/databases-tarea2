CREATE DATABASE consultorio_medico;

\c consultorio_medico

-- Drop tables in reverse order of creation to avoid FK errors
DROP TABLE IF EXISTS Invoices CASCADE;
DROP TABLE IF EXISTS Office_Assignments CASCADE; -- Renamed from "Consultorios_Ocupacion"
DROP TABLE IF EXISTS Appointments CASCADE;
DROP TABLE IF EXISTS Applied_Treatments CASCADE;
DROP TABLE IF EXISTS Medical_Records CASCADE;
DROP TABLE IF EXISTS Patients CASCADE;
DROP TABLE IF EXISTS Doctors CASCADE;
DROP TABLE IF EXISTS Specialties CASCADE;
DROP TABLE IF EXISTS Treatments CASCADE;


-- NEW AND MODIFIED TABLES

-- 1. Specialties
CREATE TABLE Specialties (
    id SERIAL PRIMARY KEY,
    specialty_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- 2. Doctors
CREATE TABLE Doctors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialty_id INT, -- Foreign key to Specialties
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    professional_license_number VARCHAR(50) UNIQUE,
    CONSTRAINT fk_doctor_specialty
        FOREIGN KEY(specialty_id)
        REFERENCES Specialties(id)
        ON DELETE SET NULL -- If a specialty is deleted, the doctor's specialty is set to null
);

-- 3. Patients
CREATE TABLE Patients (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')), -- Male, Female, Other
    address TEXT,
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    social_security_number VARCHAR(50) UNIQUE -- Or national_id_number depending on context
);

-- 4. Medical_Records
CREATE TABLE Medical_Records (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL UNIQUE, -- One record per patient
    creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    personal_history TEXT,
    family_history TEXT,
    allergies TEXT,
    general_notes TEXT,
    CONSTRAINT fk_medical_record_patient
        FOREIGN KEY(patient_id)
        REFERENCES Patients(id)
        ON DELETE CASCADE -- If a patient is deleted, their medical record is also deleted
);

-- 5. Appointments
CREATE TABLE Appointments (
    id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    reason_for_visit TEXT,
    appointment_status VARCHAR(20) DEFAULT 'Scheduled' CHECK (appointment_status IN ('Scheduled', 'Confirmed', 'Cancelled', 'Completed', 'No Show')),
    appointment_notes TEXT, -- Specific notes for this appointment
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY(patient_id)
        REFERENCES Patients(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY(doctor_id)
        REFERENCES Doctors(id)
        ON DELETE RESTRICT -- Cannot delete a doctor if they have scheduled appointments
);
CREATE INDEX idx_appointments_datetime ON Appointments(appointment_datetime);
CREATE INDEX idx_appointments_doctor_datetime ON Appointments(doctor_id, appointment_datetime);
CREATE INDEX idx_appointments_patient_datetime ON Appointments(patient_id, appointment_datetime);


-- 6. Office_Assignments (Refined concept of "Consultorios" / "Rooms")
-- This table can record which doctor uses which office/room and when.
-- You could have a separate "Offices_Catalog" table if you have several physical rooms with distinct features.
CREATE TABLE Office_Assignments (
    id SERIAL PRIMARY KEY,
    doctor_id INT NOT NULL,
    office_identifier VARCHAR(20) NOT NULL, -- E.g., "Room 1", "Office A", "Consulting Room 3"
    start_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    end_datetime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    patients_seen_in_session INT DEFAULT 0,
    session_notes TEXT,
    CONSTRAINT fk_assignment_doctor
        FOREIGN KEY(doctor_id)
        REFERENCES Doctors(id)
        ON DELETE CASCADE, -- If the doctor is deleted, their assignment records are deleted
    CONSTRAINT chk_assignment_datetimes CHECK (end_datetime > start_datetime)
);
CREATE INDEX idx_assignment_doctor_datetime ON Office_Assignments(doctor_id, start_datetime);

-- 7. Treatments (Catalog of available treatments)
CREATE TABLE Treatments (
    id SERIAL PRIMARY KEY,
    treatment_name VARCHAR(255) UNIQUE NOT NULL,
    treatment_description TEXT,
    estimated_cost DECIMAL(10, 2) -- Optional, if you want to register base costs
);

-- 8. Applied_Treatments (Join table between Medical_Records/Appointments and Treatments)
-- A patient can have multiple treatments, and a treatment can be applied to multiple patients.
-- Can be linked to the general medical record or a specific appointment.
CREATE TABLE Applied_Treatments (
    id SERIAL PRIMARY KEY,
    medical_record_id INT, -- Can be associated with the general medical record
    appointment_id INT,    -- Or a specific appointment
    treatment_id INT NOT NULL,
    treatment_start_date DATE NOT NULL,
    treatment_end_date DATE,
    treatment_status VARCHAR(50) DEFAULT 'Prescribed' CHECK (treatment_status IN ('Prescribed', 'In Progress', 'Completed', 'Suspended', 'Cancelled')),
    treatment_notes TEXT,
    prescribing_doctor_id INT, -- Doctor who prescribed/supervises the treatment
    CONSTRAINT fk_applied_treatment_medical_record
        FOREIGN KEY(medical_record_id)
        REFERENCES Medical_Records(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_applied_treatment_appointment
        FOREIGN KEY(appointment_id)
        REFERENCES Appointments(id)
        ON DELETE SET NULL, -- If the appointment is deleted, the applied treatment might remain (unlinked)
    CONSTRAINT fk_applied_treatment_catalog
        FOREIGN KEY(treatment_id)
        REFERENCES Treatments(id)
        ON DELETE RESTRICT, -- Cannot delete a treatment from the catalog if it's in use
    CONSTRAINT fk_applied_treatment_prescribing_doctor
        FOREIGN KEY(prescribing_doctor_id)
        REFERENCES Doctors(id)
        ON DELETE SET NULL,
    CONSTRAINT chk_record_or_appointment CHECK ( (medical_record_id IS NOT NULL AND appointment_id IS NULL) OR (medical_record_id IS NULL AND appointment_id IS NOT NULL) OR (medical_record_id IS NOT NULL AND appointment_id IS NOT NULL) )
    -- Ensures the treatment is associated with at least a medical record or an appointment, or both.
    -- You could simplify this if the business rule is stricter (e.g., "a treatment is always associated with one or the other").
);

-- 9. Invoices
CREATE TABLE Invoices (
    id SERIAL PRIMARY KEY,
    appointment_id INT, -- The invoice can be associated with an appointment
    patient_id INT NOT NULL,
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending' CHECK (payment_status IN ('Pending', 'Paid', 'Partially Paid', 'Cancelled', 'Refunded')),
    payment_method VARCHAR(50),
    payment_date DATE,
    payment_reference VARCHAR(100),
    invoice_notes TEXT,
    CONSTRAINT fk_invoice_appointment
        FOREIGN KEY(appointment_id)
        REFERENCES Appointments(id)
        ON DELETE SET NULL, -- If the appointment is deleted, the invoice may remain
    CONSTRAINT fk_invoice_patient
        FOREIGN KEY(patient_id)
        REFERENCES Patients(id)
        ON DELETE RESTRICT -- Cannot delete a patient with pending/existing invoices
);
CREATE INDEX idx_invoice_patient ON Invoices(patient_id);
CREATE INDEX idx_invoice_payment_status ON Invoices(payment_status);


-- PostgreSQL

-- 1. Insertar cinco datos en cada tabla:

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