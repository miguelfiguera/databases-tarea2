-- Script SQL para Sistema de Fábrica
-- MySQL 8.0 | Visual Studio Code

-- 1. Creación de la base de datos
DROP DATABASE IF EXISTS fabrica;
CREATE DATABASE fabrica;
USE fabrica;

-- 2. Tablas principales
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
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    FOREIGN KEY (id_prov) REFERENCES proveedores(id_prov)
);

CREATE TABLE clientes (
    id_cli INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- 3. Tablas de operaciones
CREATE TABLE vendedor (
    id_vend INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    comision DECIMAL(5,2) DEFAULT 0.05
);

CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cli INT,
    id_vend INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2),
    FOREIGN KEY (id_cli) REFERENCES clientes(id_cli),
    FOREIGN KEY (id_vend) REFERENCES vendedor(id_vend)
);

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_prod INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_prod) REFERENCES productos(id_prod)
);


-- Tarea 2 de Bases de Datos
USE fabrica;
USE fabrica;

INSERT INTO proveedores (nombre, direccion, telefono, email) VALUES
('Componentes Globales Ltd.', 'Polígono Industrial Sur, Nave 7', '910000003', 'info@componentesglobales.com'),
('Suministros Metalúrgicos Avanzados', 'Carretera Norte km 15', '930000004', 'ventas@sma.es'),
('Plásticos y Polímeros del Este', 'Av. Innovación 2020', '960000005', 'contacto@plasticoseste.net');

INSERT INTO productos (id_prov, nombre, descripcion, precio, stock) VALUES
(3, 'Rodamiento Industrial SKF 6205', 'Rodamiento rígido de bolas, alta precisión', 12.50, 150),
(4, 'Plancha de Acero Inoxidable 2mm', 'Calidad AISI 304, 1000x2000mm', 85.00, 30),
(1, 'Aceite Lubricante Multiuso WD-41', 'Botella de 500ml, protección contra corrosión', 7.99, 250);

INSERT INTO clientes (nombre, direccion, telefono, email) VALUES
('Taller Mecánico Hermanos López', 'Calle Freno 22, Madrid', '601123456', 'pedidos@lopeztaller.es'),
('Construcciones Segura S.L.', 'Av. Cemento 15, Valencia', '602234567', 'compras@construccionessegura.com'),
('Diseños Industriales Creativos', 'Plaza de la Forja 1, Bilbao', '603345678', 'info@dicreativos.net'),
('Innovaciones Agrícolas del Sur', 'Camino Rural 7, Sevilla', '604456789', 'admin@innovagri.es'),
('Reparaciones Express Hogar', 'Calle Fontanería 3, Barcelona', '605567890', 'urgencias@reparacionexpress.cat');

INSERT INTO vendedor (nombre, comision) VALUES
('Carlos Sánchez', 0.06),
('Laura Jiménez', 0.055),
('Pedro Ramírez', 0.065),
('Sofía Torres', 0.05),
('David Navarro', 0.07);

INSERT INTO ventas (id_cli, id_vend, fecha, total) VALUES
(1, 1, '2023-10-01 10:00:00', 0),
(2, 2, '2023-10-02 11:30:00', 0),
(1, 3, '2023-10-03 14:15:00', 0),
(3, 1, '2023-10-04 09:45:00', 0),
(4, 4, '2023-10-05 16:00:00', 0);

INSERT INTO detalle_venta (id_venta, id_prod, cantidad, precio_unitario) VALUES
(1, 1, 100, 0.75),
(1, 3, 10, 12.50),
(2, 2, 50, 0.15),
(3, 4, 2, 85.00),
(4, 5, 5, 7.99);

UPDATE ventas v
SET total = (SELECT SUM(dv.cantidad * dv.precio_unitario)
             FROM detalle_venta dv
             WHERE dv.id_venta = v.id_venta)
WHERE EXISTS (SELECT 1 FROM detalle_venta dv WHERE dv.id_venta = v.id_venta);

SELECT 'Datos de ejemplo insertados y totales de venta actualizados.' AS resultado;

SELECT
    vt.id_venta,
    vt.fecha AS fecha_venta,
    c.nombre AS cliente_nombre,
    c.email AS cliente_email,
    vd.nombre AS vendedor_nombre,
    p.nombre AS producto_nombre,
    p.descripcion AS producto_descripcion,
    pr.nombre AS proveedor_producto,
    dv.cantidad,
    dv.precio_unitario,
    (dv.cantidad * dv.precio_unitario) AS subtotal_linea,
    vt.total AS total_venta
FROM ventas vt
JOIN clientes c ON vt.id_cli = c.id_cli
JOIN vendedor vd ON vt.id_vend = vd.id_vend
JOIN detalle_venta dv ON vt.id_venta = dv.id_venta
JOIN productos p ON dv.id_prod = p.id_prod
JOIN proveedores pr ON p.id_prov = pr.id_prov
WHERE vt.id_venta = 1;

SELECT
    p.id_prod,
    p.nombre AS producto_nombre,
    p.stock,
    p.precio,
    pr.nombre AS proveedor_nombre,
    pr.telefono AS proveedor_telefono
FROM productos p
JOIN proveedores pr ON p.id_prov = pr.id_prov
WHERE p.stock < 50;

SELECT
    v.id_vend,
    v.nombre AS vendedor_nombre,
    v.comision AS tasa_comision,
    COUNT(DISTINCT vt.id_venta) AS numero_ventas,
    SUM(vt.total) AS total_vendido,
    SUM(vt.total * v.comision) AS comision_ganada
FROM vendedor v
LEFT JOIN ventas vt ON v.id_vend = vt.id_vend
GROUP BY v.id_vend, v.nombre, v.comision
ORDER BY comision_ganada DESC;

SELECT 'Consultas de ejemplo ejecutadas.' AS resultado;

UPDATE proveedores
SET email = 'nuevo.email@proveedorindustrial.com', telefono = '900123123'
WHERE id_prov = 1;

UPDATE productos
SET precio = 0.80, stock = stock + 100
WHERE id_prod = 1;

UPDATE clientes
SET direccion = 'Calle Freno 22, Nave B, Madrid'
WHERE id_cli = 1;

UPDATE vendedor
SET comision = 0.065
WHERE id_vend = 1;

UPDATE ventas
SET fecha = '2023-10-02 12:00:00', total = total - 5.00
WHERE id_venta = 2;

UPDATE detalle_venta
SET cantidad = 120
WHERE id_detalle = 1;

UPDATE ventas v
SET total = (SELECT SUM(dv.cantidad * dv.precio_unitario)
             FROM detalle_venta dv
             WHERE dv.id_venta = v.id_venta)
WHERE v.id_venta = (SELECT id_venta FROM detalle_venta WHERE id_detalle = 1);

SELECT 'Datos modificados en cada tabla.' AS resultado;

INSERT INTO proveedores (nombre) VALUES ('Proveedor a Eliminar');
SET @id_prov_eliminar = LAST_INSERT_ID();

INSERT INTO productos (id_prov, nombre, precio, stock) VALUES (@id_prov_eliminar, 'Producto a Eliminar', 1.00, 10);
SET @id_prod_eliminar = LAST_INSERT_ID();

INSERT INTO clientes (nombre) VALUES ('Cliente a Eliminar');
SET @id_cli_eliminar = LAST_INSERT_ID();

INSERT INTO vendedor (nombre) VALUES ('Vendedor a Eliminar');
SET @id_vend_eliminar = LAST_INSERT_ID();

INSERT INTO ventas (id_cli, id_vend, total) VALUES (@id_cli_eliminar, @id_vend_eliminar, 10.00);
SET @id_venta_eliminar = LAST_INSERT_ID();

INSERT INTO detalle_venta (id_venta, id_prod, cantidad, precio_unitario) VALUES (@id_venta_eliminar, @id_prod_eliminar, 1, 10.00);
SET @id_detalle_eliminar = LAST_INSERT_ID();

DELETE FROM detalle_venta WHERE id_detalle = @id_detalle_eliminar;
SELECT CONCAT('Detalle de venta con id ', @id_detalle_eliminar, ' eliminado.') AS resultado_eliminacion;

DELETE FROM ventas WHERE id_venta = @id_venta_eliminar;
SELECT CONCAT('Venta con id ', @id_venta_eliminar, ' eliminada.') AS resultado_eliminacion;

DELETE FROM productos WHERE id_prod = @id_prod_eliminar;
SELECT CONCAT('Producto con id ', @id_prod_eliminar, ' eliminado.') AS resultado_eliminacion;

DELETE FROM proveedores WHERE id_prov = @id_prov_eliminar;
SELECT CONCAT('Proveedor con id ', @id_prov_eliminar, ' eliminado.') AS resultado_eliminacion;

DELETE FROM clientes WHERE id_cli = @id_cli_eliminar;
SELECT CONCAT('Cliente con id ', @id_cli_eliminar, ' eliminado.') AS resultado_eliminacion;

DELETE FROM vendedor WHERE id_vend = @id_vend_eliminar;
SELECT CONCAT('Vendedor con id ', @id_vend_eliminar, ' eliminado.') AS resultado_eliminacion;

SELECT 'Datos eliminados de cada tabla (usando registros sacrificables).' AS resultado;

SELECT 'Script completado. Se han insertado, consultado, modificado y eliminado datos.' AS ESTADO_FINAL;
