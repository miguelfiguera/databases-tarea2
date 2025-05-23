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

-- Conectarse a la base de datos si es necesario 
-- \c exportadora_db

-- Inserciones
DO $$
DECLARE
    supplier1_id INTEGER;
    supplier2_id INTEGER;
    supplier3_id INTEGER;
    supplier4_id INTEGER;
    supplier5_id INTEGER;
    product1_id INTEGER;
    product2_id INTEGER;
    product3_id INTEGER;
    product4_id INTEGER;
    product5_id INTEGER;
    client1_id INTEGER;
    client2_id INTEGER;
    client3_id INTEGER;
    client4_id INTEGER;
    client5_id INTEGER;
    so1_id INTEGER;
    so2_id INTEGER;
    so3_id INTEGER;
    so4_id INTEGER;
    so5_id INTEGER;
    item1_id INTEGER;
    item2_id INTEGER;
    item3_id INTEGER;
    item4_id INTEGER;
    item5_id INTEGER;
    shipment1_id INTEGER;
    shipment2_id INTEGER;
    shipment3_id INTEGER;
    shipment4_id INTEGER;
    shipment5_id INTEGER;
    invoice1_id INTEGER;
    invoice2_id INTEGER;
    invoice3_id INTEGER;
    invoice4_id INTEGER;
    invoice5_id INTEGER;
BEGIN

INSERT INTO suppliers (name, contact_person, email, phone, address, payment_terms) VALUES
('AgroFresh Farms', 'Luisa Chen', 'luisa.chen@agrofresh.com', '555-0101', 'Valle Central, Finca #123', 'Net 30'),
('Bean Exporters Co.', 'Carlos Diaz', 'carlos.diaz@beanexport.com', '555-0102', 'Zona Cafetera, Lote 5B', 'Net 60'),
('Tropical Fruits Inc.', 'Maria Silva', 'maria.silva@tropical.com', '555-0103', 'Costa Tropical, Plantación Sol', 'Net 45'),
('Spice Route Traders', 'Ahmed Khan', 'ahmed.khan@spiceroute.com', '555-0104', 'Puerto Comercial, Bodega 7', 'COD'),
('Cocoa Dreams Ltd.', 'Sophie Dubois', 'sophie.dubois@cocoadreams.com', '555-0105', 'Región Amazónica, Hacienda Cacao', 'Net 30')
RETURNING id INTO supplier1_id, supplier2_id, supplier3_id, supplier4_id, supplier5_id;
supplier2_id := supplier1_id + 1; supplier3_id := supplier1_id + 2; supplier4_id := supplier1_id + 3; supplier5_id := supplier1_id + 4;


INSERT INTO products (sku, name, description, cost_price, unit_of_measure, supplier_id, country_of_origin, hs_code, weight_per_unit, dimension_l_cm, dimension_w_cm, dimension_h_cm) VALUES
('AVO-MEX-001', 'Aguacate Hass Premium', 'Aguacate Hass de exportación, calibre mediano', 1.50, 'kg', supplier1_id, 'México', '080440', 0.250, 10, 7, 7),
('COF-COL-002', 'Café Colombiano Supremo', 'Grano de café Arábica, tostado medio', 8.00, 'kg', supplier2_id, 'Colombia', '090121', 1.000, NULL, NULL, NULL),
('MAN-ECU-003', 'Mango Kent Fresco', 'Mango Kent madurado en árbol', 0.80, 'pieza', supplier3_id, 'Ecuador', '080450', 0.500, 15, 10, 8),
('CIN-LKA-004', 'Canela de Ceylán en Rama', 'Canela auténtica de Sri Lanka', 15.00, 'kg', supplier4_id, 'Sri Lanka', '090611', 0.100, NULL, NULL, NULL),
('CAC-PER-005', 'Cacao Criollo Orgánico', 'Granos de cacao orgánico tipo Criollo', 6.50, 'kg', supplier5_id, 'Perú', '180100', 1.000, NULL, NULL, NULL)
RETURNING id INTO product1_id, product2_id, product3_id, product4_id, product5_id;
product2_id := product1_id + 1; product3_id := product1_id + 2; product4_id := product1_id + 3; product5_id := product1_id + 4;


INSERT INTO clients (company_name, contact_person, email, phone, billing_address, shipping_address, country, tax_id, credit_limit, payment_terms_agreed) VALUES
('Global Fruit Importers', 'John Smith', 'john.smith@globalfruit.com', '1-202-555-0173', '123 Main St, New York, NY, USA', 'Port of New York, Warehouse A', 'USA', 'US123456789', 50000.00, 'Net 30'),
('EuroBean Traders', 'Anna Müller', 'anna.muller@eurobean.de', '49-30-555-0188', 'Kurfürstendamm 10, Berlin, Germany', 'Port of Hamburg, Terminal B', 'Germany', 'DE987654321', 75000.00, 'Net 45'),
('Asian Spice Market', 'Kenji Tanaka', 'kenji.tanaka@asianspice.jp', '81-3-5555-0123', 'Shibuya Crossing 1, Tokyo, Japan', 'Port of Tokyo, Dock 5', 'Japan', 'JP112233445', 30000.00, 'Net 60'),
('Canadian Food Co-op', 'Sarah Tremblay', 'sarah.tremblay@canfood.ca', '1-514-555-0199', '1000 Rue Sherbrooke, Montreal, QC, Canada', 'Port of Montreal, Section C', 'Canada', 'CA556677889', 60000.00, 'Net 30'),
('UK Chocolate Makers', 'David Wilson', 'david.wilson@ukchoco.co.uk', '44-20-7946-0123', '5 Regent Street, London, UK', 'Port of Felixstowe, Bay 2', 'UK', 'GB123456789', 40000.00, 'Net 45')
RETURNING id INTO client1_id, client2_id, client3_id, client4_id, client5_id;
client2_id := client1_id + 1; client3_id := client1_id + 2; client4_id := client1_id + 3; client5_id := client1_id + 4;


INSERT INTO sales_orders (order_number, client_id, order_date, status, currency, total_amount, expected_ship_date, notes) VALUES
('SO-2024-001', client1_id, '2024-05-01', 'confirmed', 'USD', 0.00, '2024-05-15', 'Primer pedido del cliente.'),
('SO-2024-002', client2_id, '2024-05-03', 'processing', 'EUR', 0.00, '2024-05-20', 'Urgente para feria.'),
('SO-2024-003', client3_id, '2024-05-05', 'ready_for_shipment', 'JPY', 0.00, '2024-05-18', 'Empaque especial requerido.'),
('SO-2024-004', client1_id, '2024-05-08', 'pending_confirmation', 'USD', 0.00, '2024-05-25', 'Añadir muestras de nuevo producto.'),
('SO-2024-005', client4_id, '2024-05-10', 'confirmed', 'CAD', 0.00, '2024-05-22', NULL)
RETURNING id INTO so1_id, so2_id, so3_id, so4_id, so5_id;
so2_id := so1_id + 1; so3_id := so1_id + 2; so4_id := so1_id + 3; so5_id := so1_id + 4;


INSERT INTO order_items (sales_order_id, product_id, quantity, unit_price, discount_percentage, line_total) VALUES
(so1_id, product1_id, 1000, 2.00, 5.00, (1000 * 2.00 * (1 - 5.00/100.0))),
(so1_id, product3_id, 500, 1.20, 0.00, (500 * 1.20)),
(so2_id, product2_id, 200, 10.00, 2.00, (200 * 10.00 * (1 - 2.00/100.0))),
(so3_id, product4_id, 50, 20.00, 0.00, (50 * 20.00)),
(so5_id, product5_id, 300, 8.50, 3.00, (300 * 8.50 * (1 - 3.00/100.0)))
RETURNING id INTO item1_id, item2_id, item3_id, item4_id, item5_id;
item2_id := item1_id + 1; item3_id := item1_id + 2; item4_id := item1_id + 3; item5_id := item1_id + 4;

UPDATE sales_orders SET total_amount = (SELECT SUM(line_total) FROM order_items WHERE sales_order_id = so1_id) WHERE id = so1_id;
UPDATE sales_orders SET total_amount = (SELECT SUM(line_total) FROM order_items WHERE sales_order_id = so2_id) WHERE id = so2_id;
UPDATE sales_orders SET total_amount = (SELECT SUM(line_total) FROM order_items WHERE sales_order_id = so3_id) WHERE id = so3_id;
UPDATE sales_orders SET total_amount = (SELECT SUM(line_total) FROM order_items WHERE sales_order_id = so5_id) WHERE id = so5_id;


INSERT INTO shipments (shipment_number, sales_order_id, ship_date, carrier_name, tracking_number, port_of_loading, port_of_discharge, estimated_arrival_date, status, freight_cost, insurance_cost) VALUES
('SHP-2024-A01', so1_id, '2024-05-16', 'Maersk Line', 'MSKU1234567', 'Veracruz, MX', 'New York, US', '2024-05-30', 'in_transit', 2500.00, 150.00),
('SHP-2024-B02', so2_id, '2024-05-21', 'DHL Global Forwarding', 'DHL7890123', 'Cartagena, CO', 'Hamburg, DE', '2024-06-05', 'shipped', 1800.00, 100.00),
('SHP-2024-C03', so3_id, '2024-05-19', 'NYK Line', 'NYKU4567890', 'Guayaquil, EC', 'Tokyo, JP', '2024-06-10', 'at_port_discharge', 3200.00, 200.00),
('SHP-2024-D04', NULL, '2024-05-23', 'MSC Cargo', 'MSCU9012345', 'Colombo, LK', 'Felixstowe, UK', '2024-06-15', 'pending_shipment', 2800.00, 180.00),
('SHP-2024-E05', so5_id, '2024-05-24', 'FedEx Trade Networks', 'FTN123ABC', 'Callao, PE', 'Montreal, CA', '2024-06-08', 'customs_clearance', 2200.00, 120.00)
RETURNING id INTO shipment1_id, shipment2_id, shipment3_id, shipment4_id, shipment5_id;
shipment2_id := shipment1_id + 1; shipment3_id := shipment1_id + 2; shipment4_id := shipment1_id + 3; shipment5_id := shipment1_id + 4;


INSERT INTO commercial_invoices (invoice_number, sales_order_id, client_id, issue_date, due_date, total_amount, currency, payment_status, notes) VALUES
('INV-2024-001', so1_id, client1_id, '2024-05-16', '2024-06-15', (SELECT total_amount FROM sales_orders WHERE id = so1_id), 'USD', 'pending', 'Factura para SO-2024-001'),
('INV-2024-002', so2_id, client2_id, '2024-05-21', '2024-07-05', (SELECT total_amount FROM sales_orders WHERE id = so2_id), 'EUR', 'partially_paid', 'Pago parcial recibido.'),
('INV-2024-003', so3_id, client3_id, '2024-05-19', '2024-07-18', (SELECT total_amount FROM sales_orders WHERE id = so3_id), 'JPY', 'paid', NULL),
('INV-2024-004', NULL, client4_id, '2024-05-23', '2024-06-22', 5800.00, 'CAD', 'pending', 'Factura proforma.'),
('INV-2024-005', so5_id, client4_id, '2024-05-24', '2024-07-08', (SELECT total_amount FROM sales_orders WHERE id = so5_id), 'CAD', 'pending', 'Factura para SO-2024-005')
RETURNING id INTO invoice1_id, invoice2_id, invoice3_id, invoice4_id, invoice5_id;
invoice2_id := invoice1_id + 1; invoice3_id := invoice1_id + 2; invoice4_id := invoice1_id + 3; invoice5_id := invoice1_id + 4;

RAISE NOTICE 'Datos de ejemplo insertados.';
END $$;


SELECT
    so.order_number,
    so.order_date,
    so.status AS order_status,
    c.company_name AS client_company,
    c.country AS client_country,
    oi.quantity,
    oi.unit_price,
    oi.line_total,
    p.name AS product_name,
    p.sku AS product_sku,
    s_prod.name AS product_supplier,
    sh.shipment_number,
    sh.status AS shipment_status,
    sh.carrier_name,
    ci.invoice_number,
    ci.payment_status AS invoice_payment_status
FROM sales_orders so
JOIN clients c ON so.client_id = c.id
JOIN order_items oi ON so.id = oi.sales_order_id
JOIN products p ON oi.product_id = p.id
LEFT JOIN suppliers s_prod ON p.supplier_id = s_prod.id
LEFT JOIN shipments sh ON so.id = sh.sales_order_id
LEFT JOIN commercial_invoices ci ON so.id = ci.sales_order_id AND c.id = ci.client_id
WHERE so.order_number = 'SO-2024-001'
LIMIT 5;

SELECT
    p.name AS product_name,
    p.sku,
    p.cost_price,
    p.unit_of_measure,
    s.name AS supplier_name,
    s.contact_person AS supplier_contact,
    s.email AS supplier_email,
    COUNT(oi.id) AS times_ordered
FROM products p
LEFT JOIN suppliers s ON p.supplier_id = s.id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, s.id
ORDER BY times_ordered DESC
LIMIT 5;

SELECT
    c.company_name,
    c.country,
    COUNT(DISTINCT so.id) AS total_orders,
    SUM(so.total_amount) AS total_value_orders_usd_equivalent,
    AVG(so.total_amount) AS avg_order_value_usd_equivalent,
    COUNT(DISTINCT ci.id) AS total_invoices,
    STRING_AGG(DISTINCT ci.payment_status::text, ', ') AS payment_statuses
FROM clients c
LEFT JOIN sales_orders so ON c.id = so.client_id AND so.currency = 'USD'
LEFT JOIN commercial_invoices ci ON c.id = ci.client_id
GROUP BY c.id
ORDER BY total_value_orders_usd_equivalent DESC NULLS LAST
LIMIT 5;


DO $$
DECLARE
    supplier_to_update INTEGER;
    product_to_update INTEGER;
    client_to_update INTEGER;
    so_to_update INTEGER;
    item_to_update INTEGER;
    shipment_to_update INTEGER;
    invoice_to_update INTEGER;
BEGIN
    SELECT id INTO supplier_to_update FROM suppliers ORDER BY RANDOM() LIMIT 1;
    UPDATE suppliers SET phone = '555-9999', payment_terms = 'Net 90' WHERE id = supplier_to_update;

    SELECT id INTO product_to_update FROM products ORDER BY RANDOM() LIMIT 1;
    UPDATE products SET cost_price = cost_price * 1.10, description = 'Descripción actualizada y mejorada.' WHERE id = product_to_update;

    SELECT id INTO client_to_update FROM clients ORDER BY RANDOM() LIMIT 1;
    UPDATE clients SET credit_limit = credit_limit + 10000, shipping_address = 'Nueva Dirección de Envío, Almacén Central' WHERE id = client_to_update;

    SELECT id INTO so_to_update FROM sales_orders WHERE status != 'completed' AND status != 'cancelled' ORDER BY RANDOM() LIMIT 1;
    IF so_to_update IS NOT NULL THEN
        UPDATE sales_orders SET status = 'on_hold', notes = 'Pedido en espera por revisión de crédito.' WHERE id = so_to_update;
    ELSE
        RAISE NOTICE 'No se encontró una SO para actualizar según criterios.';
    END IF;

    SELECT id INTO item_to_update FROM order_items ORDER BY RANDOM() LIMIT 1;
    UPDATE order_items SET quantity = quantity + 1, discount_percentage = 2.50
    WHERE id = item_to_update
    RETURNING sales_order_id INTO so_to_update;
    UPDATE order_items SET line_total = quantity * unit_price * (1 - discount_percentage / 100.0) WHERE id = item_to_update;
    IF so_to_update IS NOT NULL THEN
        UPDATE sales_orders SET total_amount = (SELECT SUM(line_total) FROM order_items WHERE sales_order_id = so_to_update) WHERE id = so_to_update;
        UPDATE commercial_invoices SET total_amount = (SELECT total_amount FROM sales_orders WHERE id = so_to_update) WHERE sales_order_id = so_to_update;
    END IF;

    SELECT id INTO shipment_to_update FROM shipments WHERE status != 'delivered' ORDER BY RANDOM() LIMIT 1;
     IF shipment_to_update IS NOT NULL THEN
        UPDATE shipments SET carrier_name = 'Nuevo Transportista Express', actual_arrival_date = CURRENT_DATE WHERE id = shipment_to_update;
    ELSE
        RAISE NOTICE 'No se encontró un shipment para actualizar según criterios.';
    END IF;


    SELECT id INTO invoice_to_update FROM commercial_invoices WHERE payment_status != 'paid' AND payment_status != 'refunded' ORDER BY RANDOM() LIMIT 1;
    IF invoice_to_update IS NOT NULL THEN
        UPDATE commercial_invoices SET due_date = due_date + INTERVAL '15 days', payment_status = 'overdue' WHERE id = invoice_to_update;
    ELSE
        RAISE NOTICE 'No se encontró una invoice para actualizar según criterios.';
    END IF;

    RAISE NOTICE 'Datos modificados.';
END $$;


DO $$
DECLARE
    s_id_del INTEGER;
    p_id_del INTEGER;
    c_id_del INTEGER;
    so_id_del INTEGER;
    oi_id_del INTEGER;
    sh_id_del INTEGER;
    ci_id_del INTEGER;
BEGIN
    INSERT INTO suppliers (name, email) VALUES ('Proveedor Para Eliminar', 'del_s@example.com') RETURNING id INTO s_id_del;
    INSERT INTO products (sku, name, cost_price, unit_of_measure, supplier_id) VALUES ('DEL-SKU', 'Producto Para Eliminar', 1.00, 'pieza', s_id_del) RETURNING id INTO p_id_del;
    INSERT INTO clients (company_name, email, country) VALUES ('Cliente Para Eliminar', 'del_c@example.com', 'Narnia') RETURNING id INTO c_id_del;
    INSERT INTO sales_orders (order_number, client_id) VALUES ('SO-DEL-001', c_id_del) RETURNING id INTO so_id_del;
    INSERT INTO order_items (sales_order_id, product_id, quantity, unit_price, line_total) VALUES (so_id_del, p_id_del, 1, 1.00, 1.00) RETURNING id INTO oi_id_del;
    UPDATE sales_orders SET total_amount = 1.00 WHERE id = so_id_del;
    INSERT INTO shipments (shipment_number, sales_order_id) VALUES ('SHP-DEL-001', so_id_del) RETURNING id INTO sh_id_del;
    INSERT INTO commercial_invoices (invoice_number, sales_order_id, client_id, total_amount) VALUES ('INV-DEL-001', so_id_del, c_id_del, 1.00) RETURNING id INTO ci_id_del;

    DELETE FROM order_items WHERE id = oi_id_del;
    RAISE NOTICE 'Order Item eliminado: %', oi_id_del;

    DELETE FROM commercial_invoices WHERE id = ci_id_del;
    RAISE NOTICE 'Commercial Invoice eliminada: %', ci_id_del;

    DELETE FROM shipments WHERE id = sh_id_del;
    RAISE NOTICE 'Shipment eliminado: %', sh_id_del;

    DELETE FROM sales_orders WHERE id = so_id_del;
    RAISE NOTICE 'Sales Order eliminado: % (sus items deberían haberse eliminado en cascada si no se hizo antes)', so_id_del;

    DELETE FROM products WHERE id = p_id_del;
    RAISE NOTICE 'Product eliminado: %', p_id_del;
    
    DELETE FROM clients WHERE id = c_id_del;
    RAISE NOTICE 'Client eliminado: %', c_id_del;

    DELETE FROM suppliers WHERE id = s_id_del;
    RAISE NOTICE 'Supplier eliminado: %', s_id_del;

    RAISE NOTICE 'Datos de prueba eliminados.';
END $$;

SELECT 'Script completado.' AS estado_final;
