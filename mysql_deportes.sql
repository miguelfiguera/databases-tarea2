SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE DATABASE IF NOT EXISTS `deportes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `deportes`;

DROP TABLE IF EXISTS `deportes`;
CREATE TABLE `deportes` (
  `id_deporte` int(11) NOT NULL,
  `nombre_deporte` varchar(100) DEFAULT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `equipos`;
CREATE TABLE `equipos` (
  `id_equipo` int(11) NOT NULL,
  `nombre_equipo` varchar(100) DEFAULT NULL,
  `id_deporte` int(11) DEFAULT NULL,
  `fecha_creacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

DROP TABLE IF EXISTS `jugadores`;
CREATE TABLE `jugadores` (
  `id_jugador` int(11) NOT NULL,
  `nombre_jugador` varchar(100) DEFAULT NULL,
  `apellido_jugador` varchar(100) DEFAULT NULL,
  `id_equipo` int(11) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `posicion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

DROP TABLE IF EXISTS `torneos`;
CREATE TABLE `torneos` (
  `id_torneo` int(11) NOT NULL,
  `nombre_torneo` varchar(100) DEFAULT NULL,
  `id_deporte` int(11) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `deportes`
  ADD PRIMARY KEY (`id_deporte`);

ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id_equipo`),
  ADD KEY `fk_equipos_deporte` (`id_deporte`);

ALTER TABLE `jugadores`
  ADD PRIMARY KEY (`id_jugador`),
  ADD KEY `fk_jugadores_deporte` (`id_equipo`);

ALTER TABLE `resultados_torneos`
  ADD PRIMARY KEY (`id_resultado`),
  ADD KEY `fk_resultados_torneos` (`id_torneo`),
  ADD KEY `id_equipo_local` (`id_equipo_local`),
  ADD KEY `id_equipo_visitante` (`id_equipo_visitante`);

ALTER TABLE `torneos`
  ADD PRIMARY KEY (`id_torneo`);

ALTER TABLE `deportes`
  MODIFY `id_deporte` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `equipos`
  MODIFY `id_equipo` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `jugadores`
  MODIFY `id_jugador` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `resultados_torneos`
  MODIFY `id_resultado` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `torneos`
  MODIFY `id_torneo` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `equipos`
  ADD CONSTRAINT `fk_equipos_deporte` FOREIGN KEY (`id_deporte`) REFERENCES `deportes` (`id_deporte`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `jugadores`
  ADD CONSTRAINT `fk_jugadores_deporte` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `resultados_torneos`
  ADD CONSTRAINT `fk_resultados_torneos` FOREIGN KEY (`id_torneo`) REFERENCES `torneos` (`id_torneo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resultados_torneos_ibfk_1` FOREIGN KEY (`id_equipo_local`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resultados_torneos_ibfk_2` FOREIGN KEY (`id_equipo_visitante`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `torneos`
  ADD CONSTRAINT `fk_torneos_deporte` FOREIGN KEY (`id_torneo`) REFERENCES `resultados_torneos` (`id_resultado`) ON DELETE CASCADE ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `deportes` (`id_deporte`, `nombre_deporte`, `descripcion`) VALUES
(1, 'Fútbol', 'Deporte de equipo jugado con un balón entre dos conjuntos de once jugadores.'),
(2, 'Baloncesto', 'Deporte de equipo jugado entre dos conjuntos de cinco jugadores cada uno.'),
(3, 'Tenis', 'Deporte de raqueta practicado entre dos jugadores o dos parejas.'),
(4, 'Voleibol', 'Deporte donde dos equipos se enfrentan sobre un terreno de juego liso separados por una red central.'),
(5, 'Atletismo', 'Conjunto de prácticas deportivas que comprende pruebas de velocidad, saltos y lanzamientos.');

INSERT INTO `equipos` (`id_equipo`, `nombre_equipo`, `id_deporte`, `fecha_creacion`) VALUES
(1, 'Real Madrid CF', 1, '1902-03-06'),
(2, 'FC Barcelona', 1, '1899-11-29'),
(3, 'Los Angeles Lakers', 2, '1947-01-01'),
(4, 'Golden State Warriors', 2, '1946-01-01'),
(5, 'Equipo Voley A', 4, '2020-05-10'),
(6, 'Equipo Voley B', 4, '2021-06-01');

INSERT INTO `torneos` (`id_torneo`, `nombre_torneo`, `id_deporte`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 'La Liga 2023-2024', 1, '2023-08-11', '2024-05-26'),
(2, 'Copa del Rey 2024', 1, '2023-10-31', '2024-04-06'),
(3, 'NBA Season 2023-2024', 2, '2023-10-24', '2024-06-23'),
(4, 'Roland Garros 2024', 3, '2024-05-26', '2024-06-09'),
(5, 'Mundial de Voleibol Femenino 2024', 4, '2024-09-01', '2024-09-30');

INSERT INTO `resultados_torneos` (`id_resultado`, `id_torneo`, `id_equipo_local`, `id_equipo_visitante`, `goles_local`, `goles_visitante`, `fecha_partido`) VALUES
(1, 1, 1, 2, 2, 1, '2024-01-10 20:00:00'),
(2, 2, 2, 1, 3, 1, '2024-02-15 19:30:00'),
(3, 3, 3, 4, 102, 100, '2024-03-01 21:00:00'),
(4, 4, NULL, NULL, 3, 2, '2024-06-08 15:00:00'),
(5, 5, 5, 6, 3, 1, '2024-09-10 18:00:00');

INSERT INTO `jugadores` (`id_jugador`, `nombre_jugador`, `apellido_jugador`, `id_equipo`, `fecha_nacimiento`, `posicion`) VALUES
(1, 'Vinicius', 'Junior', 1, '2000-07-12', 'Delantero'),
(2, 'Lamine', 'Yamal', 2, '2007-07-13', 'Delantero'),
(3, 'LeBron', 'James', 3, '1984-12-30', 'Alero'),
(4, 'Stephen', 'Curry', 4, '1988-03-14', 'Base'),
(5, 'Ana', 'Perez', 5, '1999-01-15', 'Central');

SET FOREIGN_KEY_CHECKS=1;

SELECT * FROM `deportes` LIMIT 1;
SELECT * FROM `equipos` LIMIT 1;
SELECT * FROM `torneos` LIMIT 1;
SELECT * FROM `resultados_torneos` LIMIT 1;
SELECT * FROM `jugadores` LIMIT 1;

SELECT `id_deporte`, `nombre_deporte`, `descripcion` FROM `deportes` LIMIT 1;
SELECT `id_equipo`, `nombre_equipo`, `id_deporte`, `fecha_creacion` FROM `equipos` LIMIT 1;
SELECT `id_torneo`, `nombre_torneo`, `id_deporte`, `fecha_inicio`, `fecha_fin` FROM `torneos` LIMIT 1;
SELECT `id_resultado`, `id_torneo`, `id_equipo_local`, `id_equipo_visitante`, `goles_local`, `goles_visitante` FROM `resultados_torneos` LIMIT 1;
SELECT `id_jugador`, `nombre_jugador`, `apellido_jugador`, `id_equipo`, `posicion` FROM `jugadores` LIMIT 1;

UPDATE `deportes` SET `descripcion` = 'Deporte de equipo con 11 jugadores por lado, objetivo marcar goles.' WHERE `id_deporte` = 1;
UPDATE `equipos` SET `nombre_equipo` = 'Real Madrid Club de Fútbol' WHERE `id_equipo` = 1;
UPDATE `torneos` SET `nombre_torneo` = 'La Liga Santander 2023-2024' WHERE `id_torneo` = 1;
UPDATE `resultados_torneos` SET `goles_local` = 3, `goles_visitante` = 0 WHERE `id_resultado` = 1;
UPDATE `jugadores` SET `posicion` = 'Extremo Izquierdo' WHERE `id_jugador` = 1;

SET FOREIGN_KEY_CHECKS=0;

DELETE FROM `resultados_torneos` WHERE `id_resultado` = 5;
DELETE FROM `torneos` WHERE `id_torneo` = 5;
DELETE FROM `jugadores` WHERE `id_jugador` = 5;
DELETE FROM `equipos` WHERE `id_equipo` = 5;
DELETE FROM `deportes` WHERE `id_deporte` = 5;

SET FOREIGN_KEY_CHECKS=1;

COMMIT;