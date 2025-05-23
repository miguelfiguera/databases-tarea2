DROP DATABASE IF EXISTS fabrica;
CREATE DATABASE fabrica;
USE fabrica;

CREATE TABLE proveedores (
    id_prov INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE productos (
    id_prod INT AUTO_INCREMENT PRIMARY KEY,
    id_prov INT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    FOREIGN KEY (id_prov) REFERENCES proveedores(id_prov) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE clientes (
    id_cli INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE vendedor (
    id_vend INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    comision DECIMAL(4,3) DEFAULT 0.050 CHECK (comision >= 0.000 AND comision <= 1.000)
);

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cli INT,
    id_vend INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) DEFAULT 0.00,
    FOREIGN KEY (id_cli) REFERENCES clientes(id_cli) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_vend) REFERENCES vendedor(id_vend) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_prod INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_prod) REFERENCES productos(id_prod) ON DELETE RESTRICT ON UPDATE CASCADE
);

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

COMMIT;