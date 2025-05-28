-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-05-2025 a las 05:42:47
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `zapateria`
--
CREATE DATABASE IF NOT EXISTS `zapateria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `zapateria`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--
DROP TABLE IF EXISTS `ventas`;
DROP TABLE IF EXISTS `productos_deposito`;
DROP TABLE IF EXISTS `proveedores`;
DROP TABLE IF EXISTS `vendedor`;
DROP TABLE IF EXISTS `clientes`;


CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre_cliente` varchar(100) DEFAULT NULL,
  `apellido_cliente` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) NOT NULL, -- Cambiado de INT a VARCHAR
  `Telefono` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `id_proveedor` int(11) NOT NULL,
  `nombre_proveedor` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_deposito`
--

CREATE TABLE `productos_deposito` (
  `id_producto` int(11) NOT NULL,
  `nombre_producto` varchar(100) DEFAULT NULL,
  `descripcion` text NOT NULL,
  `precio_costo` decimal(10,2) DEFAULT NULL,
  `precio_venta` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor`
--

CREATE TABLE `vendedor` (
  `id_Vendedor` int(11) NOT NULL,
  `nombre_vendedor` varchar(100) DEFAULT NULL,
  `apellido_vendedor` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `Telefono` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_vendedor` int(11) DEFAULT NULL,
  `fecha_venta` datetime DEFAULT NULL,
  `total_venta` decimal(10,2) DEFAULT NULL,
  `detalles_venta` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `productos_deposito`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_proveedor` (`id_proveedor`);

ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`id_Vendedor`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_vendedor` (`id_vendedor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `productos_deposito`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `proveedores`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `vendedor`
  MODIFY `id_Vendedor` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

ALTER TABLE `productos_deposito`
  ADD CONSTRAINT `productos_deposito_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedores` (`id_proveedor`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ventas_ibfk_2` FOREIGN KEY (`id_vendedor`) REFERENCES `vendedor` (`id_Vendedor`) ON DELETE CASCADE ON UPDATE CASCADE;
  -- Se eliminó la restricción ventas_ibfk_3 que era conceptualmente incorrecta y causaría problemas.


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

COMMIT;