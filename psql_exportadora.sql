CREATE DATABASE exportadora_db;

\c exportadora_db

DROP TABLE IF EXISTS commercial_invoices CASCADE;
DROP TABLE IF EXISTS shipments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS sales_orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS clients CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

DROP TYPE IF EXISTS payment_status_enum CASCADE;
DROP TYPE IF EXISTS order_status_enum CASCADE;
DROP TYPE IF EXISTS unit_of_measure_enum CASCADE;

CREATE TYPE unit_of_measure_enum AS ENUM (
    'kg',
    'g',
    'mg',
    'l',
    'ml',
    'pieza',
    'docena',
    'paquete',
    'caja',
    'bolsa',
    'botella',
    'metro',
    'cm',
    'm2',
    'm3',
    'lb',
    'oz',
    'gal',
    'par',
    'juego',
    'rollo'
);

CREATE TYPE order_status_enum AS ENUM (
    'pending_confirmation',
    'confirmed',
    'processing',
    'ready_for_shipment',
    'partially_shipped',
    'shipped',
    'delivered',
    'completed',
    'cancelled',
    'on_hold'
);

CREATE TYPE payment_status_enum AS ENUM (
    'pending',
    'partially_paid',
    'paid',
    'overdue',
    'refunded'
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50),
    address TEXT,
    payment_terms VARCHAR(255)
);
CREATE INDEX IF NOT EXISTS idx_suppliers_email ON suppliers(email);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    cost_price DECIMAL(12, 2) NOT NULL CHECK (cost_price >= 0),
    unit_of_measure unit_of_measure_enum NOT NULL,
    supplier_id INTEGER REFERENCES suppliers(id) ON DELETE SET NULL,
    country_of_origin VARCHAR(100),
    hs_code VARCHAR(50),
    weight_per_unit DECIMAL(10, 3),
    dimension_l_cm DECIMAL(10, 2),
    dimension_w_cm DECIMAL(10, 2),
    dimension_h_cm DECIMAL(10, 2)
);
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_supplier_id ON products(supplier_id);

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    billing_address TEXT,
    shipping_address TEXT,
    country VARCHAR(100) NOT NULL,
    tax_id VARCHAR(100),
    credit_limit DECIMAL(12, 2) DEFAULT 0.00,
    payment_terms_agreed VARCHAR(255)
);
CREATE INDEX IF NOT EXISTS idx_clients_company_name ON clients(company_name);
CREATE INDEX IF NOT EXISTS idx_clients_country ON clients(country);

CREATE TABLE sales_orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status order_status_enum DEFAULT 'pending_confirmation',
    currency CHAR(3) NOT NULL DEFAULT 'USD',
    total_amount DECIMAL(15, 2) DEFAULT 0.00,
    expected_ship_date DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_sales_orders_client_id ON sales_orders(client_id);
CREATE INDEX IF NOT EXISTS idx_sales_orders_order_date ON sales_orders(order_date);
CREATE INDEX IF NOT EXISTS idx_sales_orders_status ON sales_orders(status);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    sales_order_id INTEGER NOT NULL REFERENCES sales_orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL CHECK (unit_price >= 0),
    discount_percentage DECIMAL(5, 2) DEFAULT 0.00 CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
    line_total DECIMAL(15, 2)
);
CREATE INDEX IF NOT EXISTS idx_order_items_sales_order_id ON order_items(sales_order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);

CREATE TABLE shipments (
    id SERIAL PRIMARY KEY,
    shipment_number VARCHAR(100) UNIQUE,
    sales_order_id INTEGER REFERENCES sales_orders(id) ON DELETE SET NULL,
    ship_date DATE,
    carrier_name VARCHAR(255),
    tracking_number VARCHAR(255),
    port_of_loading VARCHAR(255),
    port_of_discharge VARCHAR(255),
    estimated_arrival_date DATE,
    actual_arrival_date DATE,
    status VARCHAR(100) DEFAULT 'pending_shipment',
    freight_cost DECIMAL(12, 2),
    insurance_cost DECIMAL(12, 2),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_shipments_sales_order_id ON shipments(sales_order_id);
CREATE INDEX IF NOT EXISTS idx_shipments_ship_date ON shipments(ship_date);
CREATE INDEX IF NOT EXISTS idx_shipments_tracking_number ON shipments(tracking_number);

CREATE TABLE commercial_invoices (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    sales_order_id INTEGER REFERENCES sales_orders(id) ON DELETE SET NULL,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE,
    total_amount DECIMAL(15, 2) NOT NULL,
    currency CHAR(3) NOT NULL DEFAULT 'USD',
    payment_status payment_status_enum DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_commercial_invoices_sales_order_id ON commercial_invoices(sales_order_id);
CREATE INDEX IF NOT EXISTS idx_commercial_invoices_client_id ON commercial_invoices(client_id);
CREATE INDEX IF NOT EXISTS idx_commercial_invoices_issue_date ON commercial_invoices(issue_date);
CREATE INDEX IF NOT EXISTS idx_commercial_invoices_payment_status ON commercial_invoices(payment_status);

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
