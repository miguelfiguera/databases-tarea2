-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-05-2025 a las 02:41:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `poblacion`
--
CREATE DATABASE IF NOT EXISTS `poblacion`;
USE `poblacion`;

--
-- Estructura de tabla para la tabla `densidad_poblacion`
--
DROP TABLE IF EXISTS `densidad_poblacion`;
CREATE TABLE `densidad_poblacion` (
  `id_densidad` int(11) NOT NULL,
  `id_municipio_fk` int(11) NOT NULL,
  `anio` smallint(4) NOT NULL,
  `poblacion` int(11) NOT NULL,
  `densidad_km2` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Estructura de tabla para la tabla `dirigentes`
--
DROP TABLE IF EXISTS `dirigentes`;
CREATE TABLE `dirigentes` (
  `id_dirigente` int(11) NOT NULL,
  `nombre_completo` varchar(200) NOT NULL,
  `cargo` enum('Presidente','Gobernador','Alcalde') NOT NULL,
  `id_pais_fk` int(11) NOT NULL,
  `id_estado_fk` int(11) DEFAULT NULL,
  `id_municipio_fk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Estructura de tabla para la tabla `estados`
--
DROP TABLE IF EXISTS `estados`;
CREATE TABLE `estados` (
  `id_estado` int(11) NOT NULL,
  `nombre_estado` varchar(100) NOT NULL,
  `id_pais_fk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Estructura de tabla para la tabla `municipios`
--
DROP TABLE IF EXISTS `municipios`;
CREATE TABLE `municipios` (
  `id_Municipio` int(11) NOT NULL,
  `nombre_municipio` varchar(100) NOT NULL,
  `id_estado_fk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Estructura de tabla para la tabla `paises`
--
DROP TABLE IF EXISTS `paises`;
CREATE TABLE `paises` (
  `id_pais` int(11) NOT NULL,
  `nombre_pais` varchar(100) NOT NULL,
  `codigo_iso` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

ALTER TABLE `densidad_poblacion`
  ADD PRIMARY KEY (`id_densidad`),
  ADD KEY `id_municipio_fk` (`id_municipio_fk`),
  ADD KEY `anio` (`anio`);

ALTER TABLE `dirigentes`
  ADD PRIMARY KEY (`id_dirigente`),
  ADD KEY `id_pais_fk` (`id_pais_fk`),
  ADD KEY `id_estado_fk` (`id_estado_fk`),
  ADD KEY `id_municipio_fk` (`id_municipio_fk`);

ALTER TABLE `estados`
  ADD PRIMARY KEY (`id_estado`),
  ADD KEY `id_pais_fk` (`id_pais_fk`);

ALTER TABLE `municipios`
  ADD PRIMARY KEY (`id_Municipio`),
  ADD KEY `id_estado_fk` (`id_estado_fk`);

ALTER TABLE `paises`
  ADD PRIMARY KEY (`id_pais`),
  ADD UNIQUE KEY `codigo_iso` (`codigo_iso`);

--
-- AUTO_INCREMENT de las tablas volcadas
--
ALTER TABLE `densidad_poblacion`
  MODIFY `id_densidad` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `dirigentes`
  MODIFY `id_dirigente` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `estados`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `municipios`
  MODIFY `id_Municipio` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `paises`
  MODIFY `id_pais` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--
ALTER TABLE `densidad_poblacion`
  ADD CONSTRAINT `densidad_poblacion_ibfk_1` FOREIGN KEY (`id_municipio_fk`) REFERENCES `municipios` (`id_Municipio`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `dirigentes`
  ADD CONSTRAINT `dirigentes_ibfk_1` FOREIGN KEY (`id_pais_fk`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dirigentes_ibfk_2` FOREIGN KEY (`id_estado_fk`) REFERENCES `estados` (`id_estado`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dirigentes_ibfk_3` FOREIGN KEY (`id_municipio_fk`) REFERENCES `municipios` (`id_Municipio`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `estados`
  ADD CONSTRAINT `estados_ibfk_1` FOREIGN KEY (`id_pais_fk`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `municipios`
  ADD CONSTRAINT `municipios_ibfk_1` FOREIGN KEY (`id_estado_fk`) REFERENCES `estados` (`id_estado`) ON DELETE CASCADE ON UPDATE CASCADE;


-- 1. Inserción de Datos: Insertar cinco registros de ejemplo en cada una de las tablas.
INSERT INTO `paises` (`nombre_pais`, `codigo_iso`) VALUES
('México', 'MEX'),
('Estados Unidos', 'USA'),
('Canadá', 'CAN'),
('Brasil', 'BRA'),
('Argentina', 'ARG');

INSERT INTO `estados` (`nombre_estado`, `id_pais_fk`) VALUES
('Jalisco', 1),
('California', 2),
('Ontario', 3),
('São Paulo', 4),
('Buenos Aires', 5);

INSERT INTO `municipios` (`nombre_municipio`, `id_estado_fk`) VALUES
('Guadalajara', 1),
('Los Angeles', 2),
('Toronto', 3),
('São Paulo', 4), -- Municipio de São Paulo
('La Plata', 5);

INSERT INTO `densidad_poblacion` (`id_municipio_fk`, `anio`, `poblacion`, `densidad_km2`) VALUES
(1, 2023, 1460148, 9288.00),
(2, 2023, 3849000, 3200.50),
(3, 2023, 2794000, 4334.40),
(4, 2023, 12330000, 7946.90),
(5, 2023, 654324, 718.20);

INSERT INTO `dirigentes` (`nombre_completo`, `cargo`, `id_pais_fk`, `id_estado_fk`, `id_municipio_fk`) VALUES
('Andrés Manuel López Obrador', 'Presidente', 1, NULL, NULL),
('Joe Biden', 'Presidente', 2, NULL, NULL),
('Enrique Alfaro Ramírez', 'Gobernador', 1, 1, NULL),
('Gavin Newsom', 'Gobernador', 2, 2, NULL),
('Pablo Lemus Navarro', 'Alcalde', 1, 1, 1);


-- 2. Consulta de Datos: Consultar la primera fila de cada tabla, primero mostrando todas sus columnas y luego columnas específicas.
SELECT * FROM `paises` LIMIT 1;
SELECT `id_pais`, `nombre_pais`, `codigo_iso` FROM `paises` LIMIT 1;

SELECT * FROM `estados` LIMIT 1;
SELECT `id_estado`, `nombre_estado`, `id_pais_fk` FROM `estados` LIMIT 1;

SELECT * FROM `municipios` LIMIT 1;
SELECT `id_Municipio`, `nombre_municipio`, `id_estado_fk` FROM `municipios` LIMIT 1;

SELECT * FROM `densidad_poblacion` LIMIT 1;
SELECT `id_densidad`, `id_municipio_fk`, `anio`, `poblacion` FROM `densidad_poblacion` LIMIT 1;

SELECT * FROM `dirigentes` LIMIT 1;
SELECT `id_dirigente`, `nombre_completo`, `cargo`, `id_pais_fk` FROM `dirigentes` LIMIT 1;


-- 3. Modificación de Datos: Actualizar un campo específico en un registro (generalmente el primero) de cada una de las tablas.
UPDATE `paises` SET `codigo_iso` = 'MX' WHERE `id_pais` = 1;
UPDATE `estados` SET `nombre_estado` = 'Jalisco MX' WHERE `id_estado` = 1;
UPDATE `municipios` SET `nombre_municipio` = 'Guadalajara Centro' WHERE `id_Municipio` = 1;
UPDATE `densidad_poblacion` SET `poblacion` = 1500000 WHERE `id_densidad` = 1;
UPDATE `dirigentes` SET `nombre_completo` = 'Andrés M. López Obrador' WHERE `id_dirigente` = 1;


-- 4. Eliminación de Datos: Eliminar al menos un registro de cada una de las tablas.
DELETE FROM `densidad_poblacion` WHERE `id_municipio_fk` = 5 LIMIT 1;
DELETE FROM `dirigentes` WHERE `id_pais_fk` = 5 AND `cargo` = 'Presidente' LIMIT 1; 
DELETE FROM `municipios` WHERE `id_Municipio` = 5;
DELETE FROM `estados` WHERE `id_estado` = 5;
DELETE FROM `paises` WHERE `id_pais` = 5;
DELETE FROM `densidad_poblacion` WHERE `id_densidad` = (SELECT `id_densidad` FROM (SELECT `id_densidad` FROM `densidad_poblacion` ORDER BY `id_densidad` DESC LIMIT 1) as dp);
DELETE FROM `dirigentes` WHERE `id_dirigente` = (SELECT `id_dirigente` FROM (SELECT `id_dirigente` FROM `dirigentes` ORDER BY `id_dirigente` DESC LIMIT 1) as dr);
DELETE FROM `municipios` WHERE `id_Municipio` = (SELECT `id_Municipio` FROM (SELECT `id_Municipio` FROM `municipios` ORDER BY `id_Municipio` DESC LIMIT 1) as mn);
DELETE FROM `estados` WHERE `id_estado` = (SELECT `id_estado` FROM (SELECT `id_estado` FROM `estados` ORDER BY `id_estado` DESC LIMIT 1) as es);
DELETE FROM `paises` WHERE `id_pais` = (SELECT `id_pais` FROM (SELECT `id_pais` FROM `paises` ORDER BY `id_pais` DESC LIMIT 1) as pa);

COMMIT;