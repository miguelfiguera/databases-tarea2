-- Optional: Drop and create the database for a fresh start from psql
-- \c postgres
 DROP DATABASE IF EXISTS fabric_maquinary_db;
 CREATE DATABASE fabric_maquinary_db;
 \c fabric_maquinary_db

DROP TABLE IF EXISTS Department_Machinery CASCADE;
DROP TABLE IF EXISTS Salaries CASCADE;
DROP TABLE IF EXISTS Employees CASCADE;
DROP TABLE IF EXISTS Positions CASCADE;
DROP TABLE IF EXISTS Departments CASCADE;

CREATE TABLE Departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    location VARCHAR(100),
    cost_center_code VARCHAR(50),
    creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Positions (
    id SERIAL PRIMARY KEY,
    position_title VARCHAR(100) UNIQUE NOT NULL,
    responsibilities_description TEXT,
    hierarchical_level INT,
    minimum_salary DECIMAL(10, 2) CHECK (minimum_salary >= 0),
    maximum_salary DECIMAL(10, 2) CHECK (maximum_salary >= minimum_salary),
    creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    national_id_number VARCHAR(20) UNIQUE NOT NULL,
    date_of_birth DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    address TEXT,
    phone_number VARCHAR(20),
    corporate_email VARCHAR(100) UNIQUE,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    department_id INT,
    position_id INT,
    supervisor_id INT,
    employee_status VARCHAR(20) DEFAULT 'Active' CHECK (employee_status IN ('Active', 'Inactive', 'Suspended', 'Terminated')),
    creation_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_updated_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_department
        FOREIGN KEY(department_id)
        REFERENCES Departments(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_employee_position
        FOREIGN KEY(position_id)
        REFERENCES Positions(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_employee_supervisor
        FOREIGN KEY(supervisor_id)
        REFERENCES Employees(id)
        ON DELETE SET NULL
);
CREATE INDEX idx_employees_department ON Employees(department_id);
CREATE INDEX idx_employees_position ON Employees(position_id);
CREATE INDEX idx_employees_email ON Employees(corporate_email);

CREATE TABLE Salaries (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    salary_amount DECIMAL(12, 2) NOT NULL CHECK (salary_amount >= 0),
    effective_start_date DATE NOT NULL,
    effective_end_date DATE,
    currency_code CHAR(3) DEFAULT 'USD' NOT NULL,
    payment_frequency VARCHAR(50) DEFAULT 'Monthly' CHECK (payment_frequency IN ('Weekly', 'Bi-Weekly', 'Monthly', 'Annual')),
    notes TEXT,
    record_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_salary_employee
        FOREIGN KEY(employee_id)
        REFERENCES Employees(id)
        ON DELETE CASCADE,
    CONSTRAINT chk_salary_dates CHECK (effective_end_date IS NULL OR effective_end_date > effective_start_date)
);
CREATE INDEX idx_salaries_employee ON Salaries(employee_id);
CREATE INDEX idx_salaries_start_date ON Salaries(effective_start_date);

CREATE TABLE Department_Machinery (
    id SERIAL PRIMARY KEY,
    machine_name VARCHAR(150) NOT NULL,
    inventory_code VARCHAR(50) UNIQUE,
    department_id INT NOT NULL,
    usage_description TEXT,
    brand VARCHAR(100),
    model VARCHAR(100),
    serial_number VARCHAR(100) UNIQUE,
    acquisition_date DATE,
    acquisition_cost DECIMAL(15, 2),
    machine_status VARCHAR(50) DEFAULT 'Operational' CHECK (machine_status IN ('Operational', 'Under Maintenance', 'Damaged', 'Obsolete', 'Decommissioned')),
    last_maintenance_date DATE,
    notes TEXT,
    record_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_updated_date TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_machinery_department
        FOREIGN KEY(department_id)
        REFERENCES Departments(id)
        ON DELETE RESTRICT
);
CREATE INDEX idx_machinery_department ON Department_Machinery(department_id);
CREATE INDEX idx_machinery_inventory_code ON Department_Machinery(inventory_code);

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