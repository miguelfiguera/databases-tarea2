-- Optional: Drop and create the database for a fresh start from psql
-- \c postgres
DROP DATABASE IF EXISTS library_system;
CREATE DATABASE library_system;
\c library_system

DROP TABLE IF EXISTS Book_Categories CASCADE;
DROP TABLE IF EXISTS Aisle_Categories CASCADE;
DROP TABLE IF EXISTS Categories CASCADE;
DROP TABLE IF EXISTS Loans CASCADE;
DROP TABLE IF EXISTS Inventory CASCADE;
DROP TABLE IF EXISTS Library_Users CASCADE;
DROP TABLE IF EXISTS Books CASCADE;
DROP TABLE IF EXISTS Aisles CASCADE;

CREATE TABLE Aisles (
    id SERIAL PRIMARY KEY,
    aisle_number VARCHAR(10) UNIQUE NOT NULL,
    number_of_shelves INT NOT NULL CHECK (number_of_shelves > 0),
    rows_per_shelf INT NOT NULL CHECK (rows_per_shelf > 0),
    location_description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Books (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    publication_year INT CHECK (publication_year > 0 AND publication_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1),
    isbn VARCHAR(20) UNIQUE,
    call_number VARCHAR(50) UNIQUE NOT NULL,
    publisher VARCHAR(150),
    edition VARCHAR(50),
    language VARCHAR(50),
    number_of_pages INT CHECK (number_of_pages > 0),
    summary TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_books_author ON Books(author);
CREATE INDEX idx_books_call_number ON Books(call_number);

CREATE TABLE Library_Users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    membership_id VARCHAR(50) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Suspended', 'Inactive')),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_library_users_email ON Library_Users(email);
CREATE INDEX idx_library_users_membership_id ON Library_Users(membership_id);

CREATE TABLE Inventory (
    id SERIAL PRIMARY KEY,
    book_id INT NOT NULL,
    aisle_id INT,
    shelf_number INT,
    row_number INT,
    copy_number INT DEFAULT 1,
    acquisition_date DATE,
    condition VARCHAR(50) DEFAULT 'Good' CHECK (condition IN ('New', 'Good', 'Fair', 'Poor', 'Damaged', 'Lost')),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'On Loan', 'Reserved', 'In Repair', 'Lost')),
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_book
        FOREIGN KEY(book_id)
        REFERENCES Books(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_inventory_aisle
        FOREIGN KEY(aisle_id)
        REFERENCES Aisles(id)
        ON DELETE SET NULL
);
CREATE INDEX idx_inventory_book_id ON Inventory(book_id);
CREATE INDEX idx_inventory_aisle_id ON Inventory(aisle_id);
CREATE INDEX idx_inventory_status ON Inventory(status);

CREATE TABLE Loans (
    id SERIAL PRIMARY KEY,
    inventory_id INT NOT NULL UNIQUE,
    user_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Returned', 'Overdue', 'Lost')),
    fine_amount DECIMAL(8, 2) DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_loan_inventory
        FOREIGN KEY(inventory_id)
        REFERENCES Inventory(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_loan_user
        FOREIGN KEY(user_id)
        REFERENCES Library_Users(id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_loan_dates CHECK (due_date >= loan_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= loan_date)
);
CREATE INDEX idx_loans_inventory_id ON Loans(inventory_id);
CREATE INDEX idx_loans_user_id ON Loans(user_id);
CREATE INDEX idx_loans_due_date ON Loans(due_date);
CREATE INDEX idx_loans_status ON Loans(status);

CREATE TABLE Categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Book_Categories (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (book_id, category_id),
    CONSTRAINT fk_book_category_book
        FOREIGN KEY(book_id)
        REFERENCES Books(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_book_category_category
        FOREIGN KEY(category_id)
        REFERENCES Categories(id)
        ON DELETE CASCADE
);

CREATE TABLE Aisle_Categories (
    aisle_id INT NOT NULL,
    category_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (aisle_id, category_id),
    CONSTRAINT fk_aisle_category_aisle
        FOREIGN KEY(aisle_id)
        REFERENCES Aisles(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_aisle_category_category
        FOREIGN KEY(category_id)
        REFERENCES Categories(id)
        ON DELETE CASCADE
);

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