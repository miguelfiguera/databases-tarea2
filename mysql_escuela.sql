SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `escuela` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `escuela`;

DROP TABLE IF EXISTS `calificaciones`;
CREATE TABLE `calificaciones` (
  `id_calificacion` int(11) NOT NULL,
  `id_estudiante` int(11) DEFAULT NULL,
  `id_grado` int(11) DEFAULT NULL,
  `id_maestro` int(11) DEFAULT NULL,
  `materia` varchar(100) DEFAULT NULL,
  `calificacion` decimal(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `estudiantes`;
CREATE TABLE `estudiantes` (
  `id_estudiante` int(11) NOT NULL,
  `nombre_estudiante` varchar(100) DEFAULT NULL,
  `apellido_estudiante` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `id_grado` int(11) DEFAULT NULL,
  `id_representante` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `grados`;
CREATE TABLE `grados` (
  `id_grado` int(11) NOT NULL,
  `nombre_grado` varchar(50) DEFAULT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `maestros`;
CREATE TABLE `maestros` (
  `id_maestro` int(11) NOT NULL,
  `nombre_maestro` varchar(100) DEFAULT NULL,
  `apellido_maestro` varchar(100) DEFAULT NULL,
  `especialidad` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `representantes`;
CREATE TABLE `representantes` (
  `id_representante` int(11) NOT NULL,
  `nombre_representante` varchar(100) DEFAULT NULL,
  `apellido_representante` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_maestro` (`id_maestro`);

ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD KEY `id_grado` (`id_grado`),
  ADD KEY `id_representante` (`id_representante`);

ALTER TABLE `grados`
  ADD PRIMARY KEY (`id_grado`);

ALTER TABLE `maestros`
  ADD PRIMARY KEY (`id_maestro`);

ALTER TABLE `representantes`
  ADD PRIMARY KEY (`id_representante`);

ALTER TABLE `calificaciones`
  MODIFY `id_calificacion` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `grados`
  MODIFY `id_grado` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `maestros`
  MODIFY `id_maestro` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `representantes`
  MODIFY `id_representante` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `calificaciones`
  ADD CONSTRAINT `calificaciones_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `calificaciones_ibfk_2` FOREIGN KEY (`id_maestro`) REFERENCES `maestros` (`id_maestro`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `estudiantes`
  ADD CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`id_grado`) REFERENCES `grados` (`id_grado`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `estudiantes_ibfk_2` FOREIGN KEY (`id_representante`) REFERENCES `representantes` (`id_representante`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

INSERT INTO `grados` (`nombre_grado`, `descripcion`) VALUES
('Primer Grado', 'Nivel inicial de educación primaria.'),
('Segundo Grado', 'Segundo nivel de educación primaria.'),
('Tercer Grado', 'Tercer nivel de educación primaria.'),
('Cuarto Grado', 'Cuarto nivel de educación primaria.'),
('Quinto Grado', 'Quinto nivel de educación primaria.');

INSERT INTO `representantes` (`nombre_representante`, `apellido_representante`, `direccion`, `Telefono`, `email`) VALUES
('Carlos', 'Perez', 'Calle Sol 123, Ciudad Capital', '555-1111', 'carlos.perez@example.com'),
('Ana', 'Gomez', 'Avenida Luna 456, Ciudad Capital', '555-2222', 'ana.gomez@example.com'),
('Luis', 'Rodriguez', 'Boulevard Estrella 789, Ciudad Capital', '555-3333', 'luis.rodriguez@example.com'),
('Maria', 'Fernandez', 'Pasaje Cometa 101, Ciudad Capital', '555-4444', 'maria.fernandez@example.com'),
('Jorge', 'Martinez', 'Camino Galaxia 202, Ciudad Capital', '555-5555', 'jorge.martinez@example.com');

INSERT INTO `maestros` (`nombre_maestro`, `apellido_maestro`, `especialidad`, `email`, `telefono`) VALUES
('Laura', 'Sanchez', 'Matemáticas', 'laura.sanchez@escuela.com', '555-0011'),
('Pedro', 'Ramirez', 'Lengua y Literatura', 'pedro.ramirez@escuela.com', '555-0022'),
('Sofia', 'Hernandez', 'Ciencias Naturales', 'sofia.hernandez@escuela.com', '555-0033'),
('David', 'Torres', 'Historia y Geografía', 'david.torres@escuela.com', '555-0044'),
('Elena', 'Diaz', 'Artes Plásticas', 'elena.diaz@escuela.com', '555-0055');

INSERT INTO `estudiantes` (`nombre_estudiante`, `apellido_estudiante`, `fecha_nacimiento`, `direccion`, `telefono`, `email`, `id_grado`, `id_representante`) VALUES
('Juan', 'Perez', '2015-03-10', 'Calle Sol 123, Ciudad Capital', '555-1111', 'juan.perez@email.com', 1, 1),
('Sofia', 'Gomez', '2014-07-22', 'Avenida Luna 456, Ciudad Capital', '555-2222', 'sofia.gomez@email.com', 2, 2),
('Mateo', 'Rodriguez', '2013-11-05', 'Boulevard Estrella 789, Ciudad Capital', '555-3333', 'mateo.rodriguez@email.com', 3, 3),
('Camila', 'Fernandez', '2012-01-30', 'Pasaje Cometa 101, Ciudad Capital', '555-4444', 'camila.fernandez@email.com', 4, 4),
('Lucas', 'Martinez', '2011-09-18', 'Camino Galaxia 202, Ciudad Capital', '555-5555', 'lucas.martinez@email.com', 5, 5);

INSERT INTO `calificaciones` (`id_estudiante`, `id_grado`, `id_maestro`, `materia`, `calificacion`) VALUES
(1, 1, 1, 'Matemáticas I', 8.50),
(2, 2, 2, 'Lengua II', 9.00),
(3, 3, 3, 'Ciencias III', 7.75),
(4, 4, 4, 'Historia IV', 9.50),
(5, 5, 5, 'Artes V', 8.00);

SELECT * FROM `grados` LIMIT 1;
SELECT * FROM `representantes` LIMIT 1;
SELECT * FROM `maestros` LIMIT 1;
SELECT * FROM `estudiantes` LIMIT 1;
SELECT * FROM `calificaciones` LIMIT 1;

SELECT `id_grado`, `nombre_grado`, `descripcion` FROM `grados` LIMIT 1;
SELECT `id_representante`, `nombre_representante`, `email`, `Telefono` FROM `representantes` LIMIT 1;
SELECT `id_maestro`, `nombre_maestro`, `especialidad`, `email` FROM `maestros` LIMIT 1;
SELECT `id_estudiante`, `nombre_estudiante`, `apellido_estudiante`, `email`, `id_grado` FROM `estudiantes` LIMIT 1;
SELECT `id_calificacion`, `id_estudiante`, `materia`, `calificacion` FROM `calificaciones` LIMIT 1;

UPDATE `grados` SET `descripcion` = 'Nivel inicial de educación primaria formal.' WHERE `id_grado` = 1;
UPDATE `representantes` SET `Telefono` = '555-1112' WHERE `id_representante` = 1;
UPDATE `maestros` SET `especialidad` = 'Matemáticas Avanzadas' WHERE `id_maestro` = 1;
UPDATE `estudiantes` SET `telefono` = '555-1113' WHERE `id_estudiante` = 1;
UPDATE `calificaciones` SET `calificacion` = 8.75 WHERE `id_calificacion` = 1;

DELETE FROM `calificaciones` WHERE `id_calificacion` = 5;
DELETE FROM `estudiantes` WHERE `id_estudiante` = 5;
DELETE FROM `maestros` WHERE `id_maestro` = 5;
DELETE FROM `representantes` WHERE `id_representante` = 5;
DELETE FROM `grados` WHERE `id_grado` = 5;

COMMIT;