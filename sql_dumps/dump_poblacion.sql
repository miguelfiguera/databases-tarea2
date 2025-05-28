-- MySQL dump 10.13  Distrib 5.7.42, for Linux (x86_64)
--
-- Host: localhost    Database: poblacion
-- ------------------------------------------------------
-- Server version	5.7.42-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `densidad_poblacion`
--

DROP TABLE IF EXISTS `densidad_poblacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `densidad_poblacion` (
  `id_densidad` int(11) NOT NULL AUTO_INCREMENT,
  `id_municipio_fk` int(11) NOT NULL,
  `anio` smallint(4) NOT NULL,
  `poblacion` int(11) NOT NULL,
  `densidad_km2` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id_densidad`),
  KEY `id_municipio_fk` (`id_municipio_fk`),
  KEY `anio` (`anio`),
  CONSTRAINT `densidad_poblacion_ibfk_1` FOREIGN KEY (`id_municipio_fk`) REFERENCES `municipios` (`id_Municipio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `densidad_poblacion`
--

LOCK TABLES `densidad_poblacion` WRITE;
/*!40000 ALTER TABLE `densidad_poblacion` DISABLE KEYS */;
INSERT INTO `densidad_poblacion` VALUES (1,1,2023,1500000,9288.00),(2,2,2023,3849000,3200.50),(3,3,2023,2794000,4334.40);
/*!40000 ALTER TABLE `densidad_poblacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dirigentes`
--

DROP TABLE IF EXISTS `dirigentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dirigentes` (
  `id_dirigente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(200) NOT NULL,
  `cargo` enum('Presidente','Gobernador','Alcalde') NOT NULL,
  `id_pais_fk` int(11) NOT NULL,
  `id_estado_fk` int(11) DEFAULT NULL,
  `id_municipio_fk` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_dirigente`),
  KEY `id_pais_fk` (`id_pais_fk`),
  KEY `id_estado_fk` (`id_estado_fk`),
  KEY `id_municipio_fk` (`id_municipio_fk`),
  CONSTRAINT `dirigentes_ibfk_1` FOREIGN KEY (`id_pais_fk`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dirigentes_ibfk_2` FOREIGN KEY (`id_estado_fk`) REFERENCES `estados` (`id_estado`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `dirigentes_ibfk_3` FOREIGN KEY (`id_municipio_fk`) REFERENCES `municipios` (`id_Municipio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dirigentes`
--

LOCK TABLES `dirigentes` WRITE;
/*!40000 ALTER TABLE `dirigentes` DISABLE KEYS */;
INSERT INTO `dirigentes` VALUES (1,'Andrés M. López Obrador','Presidente',1,NULL,NULL),(2,'Joe Biden','Presidente',2,NULL,NULL),(3,'Enrique Alfaro Ramírez','Gobernador',1,1,NULL),(4,'Gavin Newsom','Gobernador',2,2,NULL);
/*!40000 ALTER TABLE `dirigentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados`
--

DROP TABLE IF EXISTS `estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estados` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(100) NOT NULL,
  `id_pais_fk` int(11) NOT NULL,
  PRIMARY KEY (`id_estado`),
  KEY `id_pais_fk` (`id_pais_fk`),
  CONSTRAINT `estados_ibfk_1` FOREIGN KEY (`id_pais_fk`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados`
--

LOCK TABLES `estados` WRITE;
/*!40000 ALTER TABLE `estados` DISABLE KEYS */;
INSERT INTO `estados` VALUES (1,'Jalisco MX',1),(2,'California',2),(3,'Ontario',3);
/*!40000 ALTER TABLE `estados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `municipios` (
  `id_Municipio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_municipio` varchar(100) NOT NULL,
  `id_estado_fk` int(11) NOT NULL,
  PRIMARY KEY (`id_Municipio`),
  KEY `id_estado_fk` (`id_estado_fk`),
  CONSTRAINT `municipios_ibfk_1` FOREIGN KEY (`id_estado_fk`) REFERENCES `estados` (`id_estado`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (1,'Guadalajara Centro',1),(2,'Los Angeles',2),(3,'Toronto',3);
/*!40000 ALTER TABLE `municipios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paises`
--

DROP TABLE IF EXISTS `paises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paises` (
  `id_pais` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_pais` varchar(100) NOT NULL,
  `codigo_iso` varchar(3) NOT NULL,
  PRIMARY KEY (`id_pais`),
  UNIQUE KEY `codigo_iso` (`codigo_iso`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paises`
--

LOCK TABLES `paises` WRITE;
/*!40000 ALTER TABLE `paises` DISABLE KEYS */;
INSERT INTO `paises` VALUES (1,'México','MX'),(2,'Estados Unidos','USA'),(3,'Canadá','CAN');
/*!40000 ALTER TABLE `paises` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-28 12:24:16
