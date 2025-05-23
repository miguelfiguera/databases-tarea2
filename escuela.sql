-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-05-2025 a las 05:40:26
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `escuela`
--
CREATE DATABASE IF NOT EXISTS `escuela` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `escuela`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificaciones`
--

DROP TABLE IF EXISTS `calificaciones`;
CREATE TABLE `calificaciones` (
  `id_calificacion` int(11) NOT NULL,
  `id_estudiante` int(11) DEFAULT NULL,
  `id_grado` int(11) DEFAULT NULL,
  `id_maestro` int(11) DEFAULT NULL,
  `materia` varchar(100) DEFAULT NULL,
  `calificacion` decimal(4,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `calificaciones`:
--   `id_estudiante`
--       `estudiantes` -> `id_estudiante`
--   `id_maestro`
--       `maestros` -> `id_maestro`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiantes`
--

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

--
-- RELACIONES PARA LA TABLA `estudiantes`:
--   `id_grado`
--       `grados` -> `id_grado`
--   `id_representante`
--       `representantes` -> `id_representante`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grados`
--

DROP TABLE IF EXISTS `grados`;
CREATE TABLE `grados` (
  `id_grado` int(11) NOT NULL,
  `nombre_grado` varchar(50) DEFAULT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `grados`:
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maestros`
--

DROP TABLE IF EXISTS `maestros`;
CREATE TABLE `maestros` (
  `id_maestro` int(11) NOT NULL,
  `nombre_maestro` varchar(100) DEFAULT NULL,
  `apellido_maestro` varchar(100) DEFAULT NULL,
  `especialidad` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefono` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `maestros`:
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `representantes`
--

DROP TABLE IF EXISTS `representantes`;
CREATE TABLE `representantes` (
  `id_representante` int(11) NOT NULL,
  `nombre_representante` varchar(100) DEFAULT NULL,
  `apellido_representante` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- RELACIONES PARA LA TABLA `representantes`:
--

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD PRIMARY KEY (`id_calificacion`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `id_maestro` (`id_maestro`);

--
-- Indices de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD KEY `id_grado` (`id_grado`),
  ADD KEY `id_representante` (`id_representante`);

--
-- Indices de la tabla `grados`
--
ALTER TABLE `grados`
  ADD PRIMARY KEY (`id_grado`);

--
-- Indices de la tabla `maestros`
--
ALTER TABLE `maestros`
  ADD PRIMARY KEY (`id_maestro`);

--
-- Indices de la tabla `representantes`
--
ALTER TABLE `representantes`
  ADD PRIMARY KEY (`id_representante`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  MODIFY `id_calificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  MODIFY `id_estudiante` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `grados`
--
ALTER TABLE `grados`
  MODIFY `id_grado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `maestros`
--
ALTER TABLE `maestros`
  MODIFY `id_maestro` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `representantes`
--
ALTER TABLE `representantes`
  MODIFY `id_representante` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `calificaciones`
--
ALTER TABLE `calificaciones`
  ADD CONSTRAINT `calificaciones_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `calificaciones_ibfk_2` FOREIGN KEY (`id_maestro`) REFERENCES `maestros` (`id_maestro`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `estudiantes`
--
ALTER TABLE `estudiantes`
  ADD CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`id_grado`) REFERENCES `grados` (`id_grado`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `estudiantes_ibfk_2` FOREIGN KEY (`id_representante`) REFERENCES `representantes` (`id_representante`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

USE escuela;

INSERT INTO grados (nombre_grado, descripcion) VALUES
('1ro Primaria', 'Primer año de educación primaria básica'),
('2do Primaria', 'Segundo año de educación primaria básica'),
('1ro Secundaria', 'Primer año de educación secundaria obligatoria'),
('2do Secundaria', 'Segundo año de educación secundaria obligatoria'),
('3ro Secundaria', 'Tercer año de educación secundaria obligatoria');

SET @id_grado1 = (SELECT id_grado FROM grados WHERE nombre_grado = '1ro Primaria');
SET @id_grado2 = (SELECT id_grado FROM grados WHERE nombre_grado = '2do Primaria');
SET @id_grado3 = (SELECT id_grado FROM grados WHERE nombre_grado = '1ro Secundaria');
SET @id_grado4 = (SELECT id_grado FROM grados WHERE nombre_grado = '2do Secundaria');
SET @id_grado5 = (SELECT id_grado FROM grados WHERE nombre_grado = '3ro Secundaria');

INSERT INTO representantes (nombre_representante, apellido_representante, direccion, Telefono, email) VALUES
('Ana', 'Pérez', 'Calle Falsa 123, Ciudad Capital', '555-0101', 'ana.perez@example.com'),
('Luis', 'Gómez', 'Avenida Siempreviva 742, Pueblo Nuevo', '555-0102', 'luis.gomez@example.com'),
('María', 'Rodríguez', 'Paseo del Sol 45, Villa Serena', '555-0103', 'maria.r@example.com'),
('Carlos', 'López', 'Boulevard de los Sueños 88, Puerto Alegre', '555-0104', 'carlos.lopez@example.com'),
('Sofía', 'Martínez', 'Calle Luna 9, Monte Claro', '555-0105', 'sofia.m@example.com');

SET @id_rep1 = (SELECT id_representante FROM representantes WHERE email = 'ana.perez@example.com');
SET @id_rep2 = (SELECT id_representante FROM representantes WHERE email = 'luis.gomez@example.com');
SET @id_rep3 = (SELECT id_representante FROM representantes WHERE email = 'maria.r@example.com');
SET @id_rep4 = (SELECT id_representante FROM representantes WHERE email = 'carlos.lopez@example.com');
SET @id_rep5 = (SELECT id_representante FROM representantes WHERE email = 'sofia.m@example.com');

INSERT INTO maestros (nombre_maestro, apellido_maestro, especialidad, email, telefono) VALUES
('Laura', 'García', 'Matemáticas', 'laura.garcia@escuela.edu', '555-0201'),
('Pedro', 'Sánchez', 'Historia', 'pedro.sanchez@escuela.edu', '555-0202'),
('Isabel', 'Díaz', 'Lengua y Literatura', 'isabel.diaz@escuela.edu', '555-0203'),
('Javier', 'Fernández', 'Ciencias Naturales', 'javier.f@escuela.edu', '555-0204'),
('Elena', 'Ruiz', 'Artes Plásticas', 'elena.ruiz@escuela.edu', '555-0205');

SET @id_maestro1 = (SELECT id_maestro FROM maestros WHERE email = 'laura.garcia@escuela.edu');
SET @id_maestro2 = (SELECT id_maestro FROM maestros WHERE email = 'pedro.sanchez@escuela.edu');
SET @id_maestro3 = (SELECT id_maestro FROM maestros WHERE email = 'isabel.diaz@escuela.edu');
SET @id_maestro4 = (SELECT id_maestro FROM maestros WHERE email = 'javier.f@escuela.edu');
SET @id_maestro5 = (SELECT id_maestro FROM maestros WHERE email = 'elena.ruiz@escuela.edu');

INSERT INTO estudiantes (nombre_estudiante, apellido_estudiante, fecha_nacimiento, direccion, telefono, email, id_grado, id_representante) VALUES
('Juan', 'Pérez', '2010-03-15', 'Calle Falsa 123, Ciudad Capital', '555-0301', 'juan.perez@est.escuela.edu', @id_grado1, @id_rep1),
('Lucía', 'Gómez', '2011-07-22', 'Avenida Siempreviva 742, Pueblo Nuevo', '555-0302', 'lucia.gomez@est.escuela.edu', @id_grado1, @id_rep2),
('Marcos', 'Rodríguez', '2009-01-10', 'Paseo del Sol 45, Villa Serena', '555-0303', 'marcos.r@est.escuela.edu', @id_grado2, @id_rep3),
('Andrea', 'López', '2008-09-05', 'Boulevard de los Sueños 88, Puerto Alegre', '555-0304', 'andrea.lopez@est.escuela.edu', @id_grado3, @id_rep4),
('David', 'Martínez', '2007-12-30', 'Calle Luna 9, Monte Claro', '555-0305', 'david.m@est.escuela.edu', @id_grado4, @id_rep5);

SET @id_est1 = (SELECT id_estudiante FROM estudiantes WHERE email = 'juan.perez@est.escuela.edu');
SET @id_est2 = (SELECT id_estudiante FROM estudiantes WHERE email = 'lucia.gomez@est.escuela.edu');
SET @id_est3 = (SELECT id_estudiante FROM estudiantes WHERE email = 'marcos.r@est.escuela.edu');
SET @id_est4 = (SELECT id_estudiante FROM estudiantes WHERE email = 'andrea.lopez@est.escuela.edu');
SET @id_est5 = (SELECT id_estudiante FROM estudiantes WHERE email = 'david.m@est.escuela.edu');

INSERT INTO calificaciones (id_estudiante, id_grado, id_maestro, materia, calificacion) VALUES
(@id_est1, @id_grado1, @id_maestro1, 'Matemáticas I', 8.50),
(@id_est1, @id_grado1, @id_maestro2, 'Historia Universal I', 7.75),
(@id_est2, @id_grado1, @id_maestro1, 'Matemáticas I', 9.00),
(@id_est3, @id_grado2, @id_maestro3, 'Lengua II', 6.50),
(@id_est4, @id_grado3, @id_maestro4, 'Ciencias Naturales III', 9.25);

SELECT 'Datos de ejemplo insertados en todas las tablas.' AS resultado;

SELECT
    e.nombre_estudiante,
    e.apellido_estudiante,
    g.nombre_grado AS grado_estudiante,
    c.materia,
    c.calificacion,
    m.nombre_maestro,
    m.apellido_maestro AS apellido_maestro_materia
FROM calificaciones c
JOIN estudiantes e ON c.id_estudiante = e.id_estudiante
JOIN maestros m ON c.id_maestro = m.id_maestro
JOIN grados g ON c.id_grado = g.id_grado
WHERE e.id_estudiante = @id_est1;

SELECT
    g.nombre_grado,
    e.nombre_estudiante,
    e.apellido_estudiante,
    e.email AS email_estudiante,
    r.nombre_representante,
    r.apellido_representante AS apellido_representante,
    r.Telefono AS telefono_representante
FROM estudiantes e
JOIN grados g ON e.id_grado = g.id_grado
JOIN representantes r ON e.id_representante = r.id_representante
ORDER BY g.nombre_grado, e.apellido_estudiante;

SELECT
    m.nombre_maestro,
    m.apellido_maestro,
    m.especialidad,
    COUNT(DISTINCT c.materia) AS numero_materias_calificadas,
    AVG(c.calificacion) AS promedio_calificaciones_dadas
FROM maestros m
LEFT JOIN calificaciones c ON m.id_maestro = c.id_maestro
GROUP BY m.id_maestro, m.nombre_maestro, m.apellido_maestro, m.especialidad
ORDER BY numero_materias_calificadas DESC;

SELECT 'Consultas de ejemplo ejecutadas.' AS resultado;

UPDATE grados
SET descripcion = 'Primer año de educación primaria, enfocada en fundamentos.'
WHERE id_grado = @id_grado1;

UPDATE representantes
SET Telefono = '555-1111'
WHERE id_representante = @id_rep1;

UPDATE maestros
SET especialidad = 'Matemáticas y Física'
WHERE id_maestro = @id_maestro1;

UPDATE estudiantes
SET direccion = 'Calle Nueva 456, Ciudad Capital'
WHERE id_estudiante = @id_est1;

UPDATE calificaciones
SET calificacion = 8.75
WHERE id_estudiante = @id_est1 AND id_maestro = @id_maestro1 AND materia = 'Matemáticas I';

SELECT 'Datos modificados en cada tabla.' AS resultado;

INSERT INTO grados (nombre_grado, descripcion) VALUES ('Grado Temporal Elim', 'Para eliminar');
SET @id_grado_elim = LAST_INSERT_ID();
INSERT INTO representantes (nombre_representante, apellido_representante, direccion, Telefono, email) VALUES ('Rep', 'Elim', 'Dir Elim', '000', 'rep.elim@example.com');
SET @id_rep_elim = LAST_INSERT_ID();
INSERT INTO maestros (nombre_maestro, apellido_maestro, especialidad, email, telefono) VALUES ('Maestro', 'Elim', 'Especialidad Elim', 'maestro.elim@escuela.edu', '000');
SET @id_maestro_elim = LAST_INSERT_ID();
INSERT INTO estudiantes (nombre_estudiante, apellido_estudiante, fecha_nacimiento, direccion, telefono, email, id_grado, id_representante) VALUES ('Estudiante', 'Elim', '2000-01-01', 'Dir Elim', '000', 'est.elim@est.escuela.edu', @id_grado_elim, @id_rep_elim);
SET @id_est_elim = LAST_INSERT_ID();
INSERT INTO calificaciones (id_estudiante, id_grado, id_maestro, materia, calificacion) VALUES (@id_est_elim, @id_grado_elim, @id_maestro_elim, 'Materia Elim', 5.00);
SET @id_calif_elim = LAST_INSERT_ID();

DELETE FROM calificaciones WHERE id_calificacion = @id_calif_elim;
SELECT CONCAT('Calificación con id ', @id_calif_elim, ' eliminada.') AS resultado_eliminacion;

DELETE FROM estudiantes WHERE id_estudiante = @id_est_elim;
SELECT CONCAT('Estudiante con id ', @id_est_elim, ' eliminado.') AS resultado_eliminacion;

DELETE FROM maestros WHERE id_maestro = @id_maestro_elim;
SELECT CONCAT('Maestro con id ', @id_maestro_elim, ' eliminado.') AS resultado_eliminacion;

DELETE FROM representantes WHERE id_representante = @id_rep_elim;
SELECT CONCAT('Representante con id ', @id_rep_elim, ' eliminado.') AS resultado_eliminacion;

DELETE FROM grados WHERE id_grado = @id_grado_elim;
SELECT CONCAT('Grado con id ', @id_grado_elim, ' eliminado.') AS resultado_eliminacion;

SELECT 'Datos eliminados (usando registros sacrificables) de cada tabla.' AS resultado;

SELECT 'Script para BD ESCUELA completado.' AS ESTADO_FINAL;
