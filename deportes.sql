-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-05-2025 a las 02:43:43
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
-- Base de datos: `deportes`
--
CREATE DATABASE IF NOT EXISTS `deportes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `deportes`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `deportes`
--

DROP TABLE IF EXISTS `deportes`;
CREATE TABLE `deportes` (
  `id_deporte` int(11) NOT NULL,
  `nombre_deporte` varchar(100) DEFAULT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

DROP TABLE IF EXISTS `equipos`;
CREATE TABLE `equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre_equipo` varchar(100) DEFAULT NULL,
  `id_deporte` int(11) DEFAULT NULL,
  `fecha_creacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jugadores`
--

DROP TABLE IF EXISTS `jugadores`;
CREATE TABLE `jugadores` (
  `id_jugador` int(11) NOT NULL,
  `nombre_jugador` varchar(100) DEFAULT NULL,
  `apellido_jugador` varchar(100) DEFAULT NULL,
  `id_equipo` int(11) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `posicion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resultados_torneos`
--

DROP TABLE IF EXISTS `resultados_torneos`;
CREATE TABLE `resultados_torneos` (
  `id_resultado` int(11) NOT NULL,
  `id_torneo` int(11) DEFAULT NULL,
  `id_equipo_local` int(11) DEFAULT NULL,
  `id_equipo_visitante` int(11) DEFAULT NULL,
  `goles_local` int(11) DEFAULT NULL,
  `goles_visitante` int(11) DEFAULT NULL,
  `fecha_partido` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `torneos`
--

DROP TABLE IF EXISTS `torneos`;
CREATE TABLE `torneos` (
  `id_torneo` int(11) NOT NULL,
  `nombre_torneo` varchar(100) DEFAULT NULL,
  `id_deporte` int(11) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `deportes`
--
ALTER TABLE `deportes`
  ADD PRIMARY KEY (`id_deporte`);

--
-- Indices de la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `fk_equipos_deporte` (`id_deporte`);

--
-- Indices de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD PRIMARY KEY (`id_jugador`),
  ADD KEY `fk_jugadores_deporte` (`id_equipo`);

--
-- Indices de la tabla `resultados_torneos`
--
ALTER TABLE `resultados_torneos`
  ADD PRIMARY KEY (`id_resultado`),
  ADD KEY `fk_resultados_torneos` (`id_torneo`),
  ADD KEY `id_equipo_local` (`id_equipo_local`),
  ADD KEY `id_equipo_visitante` (`id_equipo_visitante`);

--
-- Indices de la tabla `torneos`
--
ALTER TABLE `torneos`
  ADD PRIMARY KEY (`id_torneo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `deportes`
--
ALTER TABLE `deportes`
  MODIFY `id_deporte` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `equipos`
--
ALTER TABLE `equipos`
  MODIFY `id_equipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jugadores`
--
ALTER TABLE `jugadores`
  MODIFY `id_jugador` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resultados_torneos`
--
ALTER TABLE `resultados_torneos`
  MODIFY `id_resultado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `torneos`
--
ALTER TABLE `torneos`
  MODIFY `id_torneo` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `fk_equipos_deporte` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `jugadores`
--
ALTER TABLE `jugadores`
  ADD CONSTRAINT `fk_jugadores_deporte` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resultados_torneos`
--
ALTER TABLE `resultados_torneos`
  ADD CONSTRAINT `fk_resultados_torneos` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resultados_torneos_ibfk_1` FOREIGN KEY (`id_equipo_local`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resultados_torneos_ibfk_2` FOREIGN KEY (`id_equipo_visitante`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `torneos`
--
ALTER TABLE `torneos`
  ADD CONSTRAINT `fk_torneos_deporte` FOREIGN KEY (`id_torneo`) REFERENCES `resultados_torneos` (`id_resultado`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

USE deportes;

INSERT INTO deportes (nombre_deporte, descripcion) VALUES
('Fútbol', 'Deporte de equipo jugado con un balón entre dos conjuntos de once jugadores.'),
('Baloncesto', 'Deporte de equipo jugado entre dos conjuntos de cinco jugadores cada uno.'),
('Tenis', 'Deporte de raqueta practicado sobre una pista rectangular, individual o dobles.'),
('Voleibol', 'Deporte donde dos equipos se enfrentan sobre un terreno de juego liso separados por una red central.'),
('Atletismo', 'Conjunto de pruebas deportivas que incluye carreras, saltos y lanzamientos.');

SET @id_futbol = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Fútbol');
SET @id_baloncesto = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Baloncesto');
SET @id_tenis = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Tenis');
SET @id_voleibol = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Voleibol');
SET @id_atletismo = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Atletismo');

INSERT INTO equipos (nombre_equipo, id_deporte, fecha_creacion) VALUES
('Real Madrid CF', @id_futbol, '1902-03-06'),
('FC Barcelona', @id_futbol, '1899-11-29'),
('Los Angeles Lakers', @id_baloncesto, '1947-01-01'),
('Chicago Bulls', @id_baloncesto, '1966-01-16'),
('Selección Española Voleibol Fem', @id_voleibol, '1980-01-01');

SET @id_rm = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'Real Madrid CF');
SET @id_fcb = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'FC Barcelona');
SET @id_lakers = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'Los Angeles Lakers');
SET @id_bulls = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'Chicago Bulls');
SET @id_sel_vol_fem = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'Selección Española Voleibol Fem');

INSERT INTO jugadores (nombre_jugador, apellido_jugador, id_equipo, fecha_nacimiento, posicion) VALUES
('Vinícius', 'Júnior', @id_rm, '2000-07-12', 'Delantero'),
('Pedri', 'González', @id_fcb, '2002-11-25', 'Centrocampista'),
('LeBron', 'James', @id_lakers, '1984-12-30', 'Alero'),
('DeMar', 'DeRozan', @id_bulls, '1989-08-07', 'Escolta'),
('María Segura', 'Pallerés', @id_sel_vol_fem, '1992-06-10', 'Receptora-atacante');

INSERT INTO resultados_torneos (id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, fecha_partido, id_torneo) VALUES
(@id_rm, @id_fcb, 2, 1, '2024-04-21 21:00:00', NULL),
(@id_lakers, @id_bulls, 108, 102, '2024-03-15 19:30:00', NULL),
(@id_fcb, @id_rm, 0, 4, '2024-01-14 20:00:00', NULL),
(@id_bulls, @id_lakers, 110, 115, '2024-02-20 20:00:00', NULL),
(@id_sel_vol_fem, @id_sel_vol_fem, 3, 0, '2024-05-10 18:00:00', NULL);

SET @id_res1 = LAST_INSERT_ID() - 4;
SET @id_res2 = LAST_INSERT_ID() - 3;
SET @id_res3 = LAST_INSERT_ID() - 2;
SET @id_res4 = LAST_INSERT_ID() - 1;
SET @id_res5 = LAST_INSERT_ID();

INSERT INTO torneos (id_torneo, nombre_torneo, id_deporte, fecha_inicio, fecha_fin) VALUES
(@id_res1, 'La Liga 23/24 - Clásico Vuelta', @id_futbol, '2023-08-10', '2024-05-26'),
(@id_res2, 'NBA Temporada Regular 23/24 - Partido Lakers vs Bulls', @id_baloncesto, '2023-10-24', '2024-04-14'),
(@id_res3, 'Supercopa España 2024 - Final', @id_futbol, '2024-01-10', '2024-01-14'),
(@id_res4, 'NBA Temporada Regular 23/24 - Partido Bulls vs Lakers', @id_baloncesto, '2023-10-24', '2024-04-14'),
(@id_res5, 'Liga Iberdrola Voleibol - Partido Clave', @id_voleibol, '2023-09-30', '2024-04-28');

UPDATE resultados_torneos SET id_torneo = @id_res1 WHERE id_resultado = @id_res1;
UPDATE resultados_torneos SET id_torneo = @id_res2 WHERE id_resultado = @id_res2;
UPDATE resultados_torneos SET id_torneo = @id_res3 WHERE id_resultado = @id_res3;
UPDATE resultados_torneos SET id_torneo = @id_res4 WHERE id_resultado = @id_res4;
UPDATE resultados_torneos SET id_torneo = @id_res5 WHERE id_resultado = @id_res5;

SELECT 'Datos de ejemplo insertados en todas las tablas.' AS resultado;

SELECT
    j.nombre_jugador,
    j.apellido_jugador,
    j.posicion,
    e.nombre_equipo,
    d.nombre_deporte
FROM jugadores j
JOIN equipos e ON j.id_equipo = e.id_equipo
JOIN deportes d ON e.id_deporte = d.id_deporte
WHERE e.nombre_equipo = 'Real Madrid CF';

SELECT
    t.nombre_torneo,
    d.nombre_deporte AS deporte_torneo,
    rt.fecha_partido,
    el.nombre_equipo AS equipo_local,
    rt.goles_local,
    ev.nombre_equipo AS equipo_visitante,
    rt.goles_visitante
FROM resultados_torneos rt
JOIN torneos t ON rt.id_torneo = t.id_torneo
JOIN equipos el ON rt.id_equipo_local = el.id_equipo
JOIN equipos ev ON rt.id_equipo_visitante = ev.id_equipo
JOIN deportes d ON t.id_deporte = d.id_deporte
WHERE t.nombre_torneo LIKE '%La Liga%';

SELECT
    d.nombre_deporte,
    COUNT(DISTINCT e.id_equipo) AS numero_equipos,
    COUNT(DISTINCT t.id_torneo) AS numero_torneos_con_resultados
FROM deportes d
LEFT JOIN equipos e ON d.id_deporte = e.id_deporte
LEFT JOIN torneos t ON d.id_deporte = t.id_deporte AND t.id_torneo IN (SELECT DISTINCT id_torneo FROM resultados_torneos)
GROUP BY d.nombre_deporte;

SELECT 'Consultas de ejemplo ejecutadas.' AS resultado;

UPDATE deportes
SET descripcion = 'Deporte de equipo jugado con un balón entre dos conjuntos de once jugadores, el más popular del mundo.'
WHERE nombre_deporte = 'Fútbol';
SET @id_futbol_mod = (SELECT id_deporte FROM deportes WHERE nombre_deporte = 'Fútbol');

UPDATE equipos
SET fecha_creacion = '1947-08-01'
WHERE nombre_equipo = 'Los Angeles Lakers';
SET @id_lakers_mod = (SELECT id_equipo FROM equipos WHERE nombre_equipo = 'Los Angeles Lakers');

UPDATE jugadores
SET posicion = 'Base-Escolta'
WHERE nombre_jugador = 'DeMar' AND apellido_jugador = 'DeRozan';
SET @id_derozan_mod = (SELECT id_jugador FROM jugadores WHERE nombre_jugador = 'DeMar' AND apellido_jugador = 'DeRozan');

UPDATE torneos
SET fecha_fin = '2024-05-30'
WHERE nombre_torneo = 'La Liga 23/24 - Clásico Vuelta';
SET @id_torneo_liga_mod = (SELECT id_torneo FROM torneos WHERE nombre_torneo = 'La Liga 23/24 - Clásico Vuelta');

UPDATE resultados_torneos
SET goles_local = 110, goles_visitante = 105
WHERE id_torneo = (SELECT id_torneo FROM torneos WHERE nombre_torneo = 'NBA Temporada Regular 23/24 - Partido Lakers vs Bulls')
  AND id_equipo_local = @id_lakers
  AND id_equipo_visitante = @id_bulls
LIMIT 1;

SELECT 'Datos modificados en cada tabla.' AS resultado;

INSERT INTO deportes (nombre_deporte, descripcion) VALUES ('Deporte Sacrificable', 'Para eliminar');
SET @id_deporte_elim = LAST_INSERT_ID();

INSERT INTO equipos (nombre_equipo, id_deporte, fecha_creacion) VALUES ('Equipo Sacrificable', @id_deporte_elim, '2000-01-01');
SET @id_equipo_elim = LAST_INSERT_ID();

INSERT INTO jugadores (nombre_jugador, apellido_jugador, id_equipo, fecha_nacimiento, posicion) VALUES ('Jugador', 'Sacrificable', @id_equipo_elim, '1990-01-01', 'Pívot');
SET @id_jugador_elim = LAST_INSERT_ID();

INSERT INTO resultados_torneos (id_equipo_local, id_equipo_visitante, goles_local, goles_visitante, fecha_partido, id_torneo) VALUES (@id_equipo_elim, @id_equipo_elim, 1, 0, '2023-01-01 12:00:00', NULL);
SET @id_resultado_elim = LAST_INSERT_ID();

INSERT INTO torneos (id_torneo, nombre_torneo, id_deporte, fecha_inicio, fecha_fin) VALUES (@id_resultado_elim, 'Torneo Sacrificable', @id_deporte_elim, '2023-01-01', '2023-01-02');
UPDATE resultados_torneos SET id_torneo = @id_resultado_elim WHERE id_resultado = @id_resultado_elim;

DELETE FROM jugadores WHERE id_jugador = @id_jugador_elim;
SELECT CONCAT('Jugador con id ', @id_jugador_elim, ' eliminado.') AS resultado_eliminacion;

DELETE FROM resultados_torneos WHERE id_resultado = @id_resultado_elim;
SELECT CONCAT('Resultado con id ', @id_resultado_elim, ' eliminado. Esto debería haber eliminado en cascada el torneo asociado.') AS resultado_eliminacion;

DELETE FROM equipos WHERE id_equipo = @id_equipo_elim;
SELECT CONCAT('Equipo con id ', @id_equipo_elim, ' eliminado. Esto debería haber eliminado en cascada jugadores y resultados asociados si no se hizo antes.') AS resultado_eliminacion;

DELETE FROM deportes WHERE id_deporte = @id_deporte_elim;
SELECT CONCAT('Deporte con id ', @id_deporte_elim, ' eliminado. Esto debería haber eliminado en cascada equipos asociados.') AS resultado_eliminacion;

SELECT 'Datos eliminados (o intentado eliminar con cascada) de cada tabla.' AS resultado;

SELECT 'Script para BD DEPORTES completado.' AS ESTADO_FINAL;
