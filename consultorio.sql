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

-- \c consultorio_medico

DO $$
DECLARE
    spec1_id INTEGER; spec2_id INTEGER; spec3_id INTEGER; spec4_id INTEGER; spec5_id INTEGER;
    doc1_id INTEGER; doc2_id INTEGER; doc3_id INTEGER; doc4_id INTEGER; doc5_id INTEGER;
    pat1_id INTEGER; pat2_id INTEGER; pat3_id INTEGER; pat4_id INTEGER; pat5_id INTEGER;
    mr1_id INTEGER; mr2_id INTEGER; mr3_id INTEGER; mr4_id INTEGER; mr5_id INTEGER;
    app1_id INTEGER; app2_id INTEGER; app3_id INTEGER; app4_id INTEGER; app5_id INTEGER;
    off_assign1_id INTEGER; off_assign2_id INTEGER; off_assign3_id INTEGER; off_assign4_id INTEGER; off_assign5_id INTEGER;
    treat1_id INTEGER; treat2_id INTEGER; treat3_id INTEGER; treat4_id INTEGER; treat5_id INTEGER;
    app_treat1_id INTEGER; app_treat2_id INTEGER; app_treat3_id INTEGER; app_treat4_id INTEGER; app_treat5_id INTEGER;
    inv1_id INTEGER; inv2_id INTEGER; inv3_id INTEGER; inv4_id INTEGER; inv5_id INTEGER;
BEGIN

INSERT INTO Specialties (specialty_name, description) VALUES
('Cardiology', 'Diagnosis and treatment of heart disorders.'),
('Pediatrics', 'Medical care of infants, children, and adolescents.'),
('Oncology', 'Diagnosis and treatment of cancer.'),
('Neurology', 'Diagnosis and treatment of nervous system disorders.'),
('Dermatology', 'Diagnosis and treatment of skin disorders.')
RETURNING id INTO spec1_id;
spec2_id := spec1_id + 1; spec3_id := spec1_id + 2; spec4_id := spec1_id + 3; spec5_id := spec1_id + 4;

INSERT INTO Doctors (first_name, last_name, specialty_id, phone_number, email, professional_license_number) VALUES
('Elena', 'Rodriguez', spec1_id, '555-0101', 'elena.rodriguez@clinic.com', 'CARD12345'),
('Carlos', 'Gomez', spec2_id, '555-0102', 'carlos.gomez@clinic.com', 'PED67890'),
('Sofia', 'Martinez', spec3_id, '555-0103', 'sofia.martinez@clinic.com', 'ONC11223'),
('David', 'Lopez', spec4_id, '555-0104', 'david.lopez@clinic.com', 'NEU33445'),
('Laura', 'Fernandez', spec5_id, '555-0105', 'laura.fernandez@clinic.com', 'DER55667')
RETURNING id INTO doc1_id;
doc2_id := doc1_id + 1; doc3_id := doc1_id + 2; doc4_id := doc1_id + 3; doc5_id := doc1_id + 4;

INSERT INTO Patients (first_name, last_name, date_of_birth, gender, address, phone_number, email, social_security_number) VALUES
('Juan', 'Perez', '1980-05-15', 'M', '123 Main St, Cityville', '555-0201', 'juan.perez@email.com', 'SSN11122333'),
('Ana', 'Garcia', '1992-09-22', 'F', '456 Oak Ave, Townsville', '555-0202', 'ana.garcia@email.com', 'SSN44455666'),
('Luis', 'Sanchez', '1975-01-30', 'M', '789 Pine Ln, Villagetown', '555-0203', 'luis.sanchez@email.com', 'SSN77788999'),
('Maria', 'Torres', '2005-11-10', 'F', '321 Birch Rd, Hamlet City', '555-0204', 'maria.torres@email.com', 'SSN10111213'),
('Pedro', 'Ramirez', '1960-07-04', 'M', '654 Maple Dr, Boroughville', '555-0205', 'pedro.ramirez@email.com', 'SSN14151617')
RETURNING id INTO pat1_id;
pat2_id := pat1_id + 1; pat3_id := pat1_id + 2; pat4_id := pat1_id + 3; pat5_id := pat1_id + 4;

INSERT INTO Medical_Records (patient_id, personal_history, family_history, allergies, general_notes) VALUES
(pat1_id, 'Hypertension, managed with medication.', 'Father with heart disease.', 'Penicillin', 'Regular check-ups recommended.'),
(pat2_id, 'Asthma since childhood.', 'Mother with asthma.', 'Dust mites, Pollen', 'Requires inhaler during allergy season.'),
(pat3_id, 'Type 2 Diabetes, diet controlled.', 'No significant family history.', 'None known', 'Monitor blood sugar levels regularly.'),
(pat4_id, 'Generally healthy, occasional migraines.', 'Sister with migraines.', 'None known', 'Needs follow-up for headaches.'),
(pat5_id, 'Past appendectomy.', 'Grandfather with colon cancer.', 'Shellfish', 'Yearly physicals important.')
RETURNING id INTO mr1_id;
mr2_id := mr1_id + 1; mr3_id := mr1_id + 2; mr4_id := mr1_id + 3; mr5_id := mr1_id + 4;

INSERT INTO Treatments (treatment_name, treatment_description, estimated_cost) VALUES
('Echocardiogram', 'Ultrasound of the heart.', 350.00),
('Vaccination Series (Child)', 'Standard childhood immunizations.', 200.00),
('Chemotherapy Cycle (Basic)', 'Standard cycle for common cancers.', 1500.00),
('MRI Brain Scan', 'Magnetic Resonance Imaging of the brain.', 800.00),
('Allergy Skin Test', 'Test for common environmental and food allergens.', 150.00)
RETURNING id INTO treat1_id;
treat2_id := treat1_id + 1; treat3_id := treat1_id + 2; treat4_id := treat1_id + 3; treat5_id := treat1_id + 4;

INSERT INTO Appointments (patient_id, doctor_id, appointment_datetime, reason_for_visit, appointment_status, appointment_notes) VALUES
(pat1_id, doc1_id, '2024-06-01 10:00:00', 'Routine cardiology follow-up', 'Scheduled', 'Bring previous test results.'),
(pat2_id, doc2_id, '2024-06-03 14:30:00', 'Child wellness check and vaccinations', 'Confirmed', NULL),
(pat3_id, doc1_id, '2024-06-05 09:00:00', 'Diabetes management consultation', 'Scheduled', 'Fasting required before appointment.'),
(pat4_id, doc4_id, '2024-06-07 11:00:00', 'Persistent headaches evaluation', 'Completed', 'Prescribed medication for migraines.'),
(pat5_id, doc5_id, '2024-06-10 16:00:00', 'Skin rash examination', 'Scheduled', 'Avoid creams on rash area before visit.')
RETURNING id INTO app1_id;
app2_id := app1_id + 1; app3_id := app1_id + 2; app4_id := app1_id + 3; app5_id := app1_id + 4;

INSERT INTO Office_Assignments (doctor_id, office_identifier, start_datetime, end_datetime, patients_seen_in_session, session_notes) VALUES
(doc1_id, 'Cardio-01', '2024-06-01 08:00:00', '2024-06-01 12:00:00', 0, 'Morning clinic session.'),
(doc2_id, 'Pedia-02', '2024-06-03 13:00:00', '2024-06-03 17:00:00', 0, 'Afternoon pediatric consultations.'),
(doc4_id, 'Neuro-01', '2024-06-07 09:00:00', '2024-06-07 13:00:00', 1, 'Neurology patient follow-ups.'),
(doc5_id, 'Derma-03', '2024-06-10 15:00:00', '2024-06-10 18:00:00', 0, 'Dermatology new patient intake.'),
(doc1_id, 'Cardio-01', '2024-06-05 08:00:00', '2024-06-05 12:00:00', 0, 'Mid-week cardiology session.')
RETURNING id INTO off_assign1_id;
off_assign2_id := off_assign1_id + 1; off_assign3_id := off_assign1_id + 2; off_assign4_id := off_assign1_id + 3; off_assign5_id := off_assign1_id + 4;

INSERT INTO Applied_Treatments (medical_record_id, appointment_id, treatment_id, treatment_start_date, treatment_status, treatment_notes, prescribing_doctor_id) VALUES
(mr1_id, app1_id, treat1_id, '2024-06-01', 'Prescribed', 'To be performed next week.', doc1_id),
(NULL, app2_id, treat2_id, '2024-06-03', 'Completed', 'All due vaccines administered.', doc2_id),
(mr4_id, app4_id, treat4_id, '2024-06-07', 'In Progress', 'Scan scheduled, follow up after results.', doc4_id),
(mr5_id, app5_id, treat5_id, '2024-06-10', 'Prescribed', 'Patient to monitor reaction.', doc5_id),
(mr3_id, NULL, treat1_id, '2024-05-20', 'Completed', 'Routine heart check due to diabetes.', doc1_id)
RETURNING id INTO app_treat1_id;
app_treat2_id := app_treat1_id + 1; app_treat3_id := app_treat1_id + 2; app_treat4_id := app_treat1_id + 3; app_treat5_id := app_treat1_id + 4;

INSERT INTO Invoices (appointment_id, patient_id, total_amount, payment_status, payment_method, payment_date, invoice_notes) VALUES
(app1_id, pat1_id, 150.00, 'Pending', NULL, NULL, 'Consultation fee.'),
(app2_id, pat2_id, 250.00, 'Paid', 'Credit Card', '2024-06-03', 'Consultation and vaccines.'),
(app4_id, pat4_id, 120.00, 'Pending', NULL, NULL, 'Neurology consultation.'),
(NULL, pat5_id, 75.00, 'Partially Paid', 'Cash', '2024-06-10', 'Initial dermatology visit, partial payment.'),
(app5_id, pat5_id, 90.00, 'Pending', NULL, NULL, 'Follow-up for rash, includes minor procedure.')
RETURNING id INTO inv1_id;
inv2_id := inv1_id + 1; inv3_id := inv1_id + 2; inv4_id := inv1_id + 3; inv5_id := inv1_id + 4;

RAISE NOTICE 'Datos de ejemplo insertados.';
END $$;


SELECT
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    a.appointment_datetime,
    a.reason_for_visit,
    a.appointment_status,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    s.specialty_name,
    oa.office_identifier,
    oa.start_datetime AS office_session_start
FROM Appointments a
JOIN Patients p ON a.patient_id = p.id
JOIN Doctors d ON a.doctor_id = d.id
JOIN Specialties s ON d.specialty_id = s.id
LEFT JOIN Office_Assignments oa ON d.id = oa.doctor_id
    AND a.appointment_datetime >= oa.start_datetime
    AND a.appointment_datetime < oa.end_datetime
ORDER BY a.appointment_datetime DESC
LIMIT 5;

SELECT
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    mr.allergies,
    mr.personal_history,
    t.treatment_name,
    at.treatment_start_date,
    at.treatment_status,
    pres_doc.first_name AS prescribing_doc_first,
    pres_doc.last_name AS prescribing_doc_last
FROM Patients p
JOIN Medical_Records mr ON p.id = mr.patient_id
LEFT JOIN Applied_Treatments at ON mr.id = at.medical_record_id OR at.appointment_id IN (SELECT id FROM Appointments WHERE patient_id = p.id)
LEFT JOIN Treatments t ON at.treatment_id = t.id
LEFT JOIN Doctors pres_doc ON at.prescribing_doctor_id = pres_doc.id
WHERE p.id = (SELECT id FROM Patients ORDER BY RANDOM() LIMIT 1)
LIMIT 5;

SELECT
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    s.specialty_name,
    COUNT(DISTINCT a.id) AS total_appointments_scheduled,
    COUNT(DISTINCT inv.id) AS total_invoices_generated_from_apps,
    SUM(inv.total_amount) AS total_invoiced_amount_from_apps,
    STRING_AGG(DISTINCT oa.office_identifier, ', ') AS offices_used
FROM Doctors d
JOIN Specialties s ON d.specialty_id = s.id
LEFT JOIN Appointments a ON d.id = a.doctor_id
LEFT JOIN Office_Assignments oa ON d.id = oa.doctor_id
LEFT JOIN Invoices inv ON a.id = inv.appointment_id
GROUP BY d.id, s.id
ORDER BY total_appointments_scheduled DESC
LIMIT 5;


DO $$
DECLARE
    s_id_mod INTEGER; d_id_mod INTEGER; p_id_mod INTEGER; mr_id_mod INTEGER;
    a_id_mod INTEGER; oa_id_mod INTEGER; t_id_mod INTEGER; at_id_mod INTEGER; i_id_mod INTEGER;
BEGIN
    SELECT id INTO s_id_mod FROM Specialties ORDER BY RANDOM() LIMIT 1;
    UPDATE Specialties SET description = description || ' (Updated ' || CURRENT_DATE || ')' WHERE id = s_id_mod;

    SELECT id INTO d_id_mod FROM Doctors ORDER BY RANDOM() LIMIT 1;
    UPDATE Doctors SET phone_number = '555-123-NEW' WHERE id = d_id_mod;

    SELECT id INTO p_id_mod FROM Patients ORDER BY RANDOM() LIMIT 1;
    UPDATE Patients SET address = 'New Address, Updated City' WHERE id = p_id_mod;

    SELECT id INTO mr_id_mod FROM Medical_Records ORDER BY RANDOM() LIMIT 1;
    UPDATE Medical_Records SET general_notes = general_notes || ' // Follow-up required.' WHERE id = mr_id_mod;

    SELECT id INTO a_id_mod FROM Appointments WHERE appointment_status = 'Scheduled' ORDER BY RANDOM() LIMIT 1;
    IF a_id_mod IS NOT NULL THEN
        UPDATE Appointments SET appointment_status = 'Confirmed', appointment_notes = 'Patient confirmed attendance.' WHERE id = a_id_mod;
    ELSE
        RAISE NOTICE 'No scheduled appointment found to modify.';
    END IF;

    SELECT id INTO oa_id_mod FROM Office_Assignments ORDER BY RANDOM() LIMIT 1;
    UPDATE Office_Assignments SET session_notes = 'Session extended by 30 mins.' WHERE id = oa_id_mod;

    SELECT id INTO t_id_mod FROM Treatments ORDER BY RANDOM() LIMIT 1;
    UPDATE Treatments SET estimated_cost = estimated_cost * 1.05 WHERE id = t_id_mod;

    SELECT id INTO at_id_mod FROM Applied_Treatments WHERE treatment_status = 'Prescribed' ORDER BY RANDOM() LIMIT 1;
    IF at_id_mod IS NOT NULL THEN
        UPDATE Applied_Treatments SET treatment_status = 'In Progress' WHERE id = at_id_mod;
    ELSE
        RAISE NOTICE 'No prescribed treatment found to modify.';
    END IF;

    SELECT id INTO i_id_mod FROM Invoices WHERE payment_status = 'Pending' ORDER BY RANDOM() LIMIT 1;
    IF i_id_mod IS NOT NULL THEN
        UPDATE Invoices SET payment_status = 'Partially Paid', total_amount = total_amount - 10.00 WHERE id = i_id_mod;
    ELSE
        RAISE NOTICE 'No pending invoice found to modify.';
    END IF;

    RAISE NOTICE 'Datos modificados.';
END $$;


DO $$
DECLARE
    s_id_del INTEGER; d_id_del INTEGER; p_id_del INTEGER; mr_id_del INTEGER;
    a_id_del INTEGER; oa_id_del INTEGER; t_id_del INTEGER; at_id_del INTEGER; i_id_del INTEGER;
BEGIN
    INSERT INTO Specialties (specialty_name) VALUES ('To Delete Specialty') RETURNING id INTO s_id_del;
    INSERT INTO Doctors (first_name, last_name, specialty_id, email, professional_license_number) VALUES ('Del', 'Doctor', s_id_del, 'del.doc@clinic.com', 'DELDOC001') RETURNING id INTO d_id_del;
    INSERT INTO Patients (first_name, last_name, date_of_birth, email, social_security_number) VALUES ('Del', 'Patient', '2000-01-01', 'del.pat@email.com', 'DELSSN001') RETURNING id INTO p_id_del;
    INSERT INTO Medical_Records (patient_id) VALUES (p_id_del) RETURNING id INTO mr_id_del;
    INSERT INTO Treatments (treatment_name) VALUES ('To Delete Treatment') RETURNING id INTO t_id_del;
    INSERT INTO Appointments (patient_id, doctor_id, appointment_datetime) VALUES (p_id_del, d_id_del, CURRENT_TIMESTAMP) RETURNING id INTO a_id_del;
    INSERT INTO Office_Assignments (doctor_id, office_identifier, start_datetime, end_datetime) VALUES (d_id_del, 'DEL-ROOM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '1 hour') RETURNING id INTO oa_id_del;
    INSERT INTO Applied_Treatments (appointment_id, treatment_id, treatment_start_date, prescribing_doctor_id) VALUES (a_id_del, t_id_del, CURRENT_DATE, d_id_del) RETURNING id INTO at_id_del;
    INSERT INTO Invoices (appointment_id, patient_id, total_amount) VALUES (a_id_del, p_id_del, 10.00) RETURNING id INTO i_id_del;

    DELETE FROM Invoices WHERE id = i_id_del;
    RAISE NOTICE 'Invoice eliminada: %', i_id_del;
    DELETE FROM Applied_Treatments WHERE id = at_id_del;
    RAISE NOTICE 'Applied Treatment eliminado: %', at_id_del;
    DELETE FROM Office_Assignments WHERE id = oa_id_del;
    RAISE NOTICE 'Office Assignment eliminado: %', oa_id_del;
    DELETE FROM Appointments WHERE id = a_id_del;
    RAISE NOTICE 'Appointment eliminado: %', a_id_del;
    DELETE FROM Medical_Records WHERE id = mr_id_del;
    RAISE NOTICE 'Medical Record eliminado: % (debería eliminar en cascada al paciente si no se hizo antes)', mr_id_del;
    DELETE FROM Patients WHERE id = p_id_del;
    RAISE NOTICE 'Patient eliminado: %', p_id_del;
    DELETE FROM Doctors WHERE id = d_id_del;
    RAISE NOTICE 'Doctor eliminado: %', d_id_del;
    DELETE FROM Treatments WHERE id = t_id_del;
    RAISE NOTICE 'Treatment eliminado: %', t_id_del;
    DELETE FROM Specialties WHERE id = s_id_del;
    RAISE NOTICE 'Specialty eliminada: %', s_id_del;

    RAISE NOTICE 'Datos de prueba eliminados.';
END $$;

SELECT 'Script completado.' AS estado_final;
