-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: accounting2
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `beteshda`
--

DROP TABLE IF EXISTS `beteshda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beteshda` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `authorized` tinyint(1) NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `beteshda_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beteshda`
--

LOCK TABLES `beteshda` WRITE;
/*!40000 ALTER TABLE `beteshda` DISABLE KEYS */;
INSERT INTO `beteshda` VALUES (0,'Starting Amount','',2334,'2024-01-31',1,1,1),(2,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',513.21,'2024-02-06',1,1,1),(3,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-06',1,1,1),(4,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-06',1,1,1),(5,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-15',1,1,1),(6,'VMachines','Proxmox VMachines. CPU: 52.4 €, Disk: 242.08 €',-294.48,'2023-12-03',1,1,0),(7,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-04',1,1,1),(8,'VMachines','Proxmox VMachines. CPU: 0.0 €, Disk: 0.0 €',0,'2024-02-23',NULL,1,1),(9,'VMachines','Proxmox VMachines. CPU: 0.0 €, Disk: 0.0 €',0,'2024-02-23',0,1,1),(10,'prova','',10,'2024-03-07',0,1,0),(11,'prova2','',12,'2024-03-07',0,1,0),(12,'prova','',-10,'2024-03-07',0,1,0),(13,'prova2','',-12,'2024-03-07',0,1,0),(14,'df','df',-800,'2024-03-15',1,1,1);
/*!40000 ALTER TABLE `beteshda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credentials`
--

DROP TABLE IF EXISTS `credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credentials` (
  `device_id` int DEFAULT NULL,
  `service` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  `port` varchar(10) DEFAULT NULL,
  KEY `device_id` (`device_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `credentials_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `credentials_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credentials`
--

LOCK TABLES `credentials` WRITE;
/*!40000 ALTER TABLE `credentials` DISABLE KEYS */;
INSERT INTO `credentials` VALUES (1,'server','admin','perprotegir',1,'22'),(1,'nagios','marc','marc1234',1,'80'),(2,'TrueNAS','admin','perprotegir',1,'22'),(2,'WordPress','marc','marc1234',1,'22'),(7,'prova','marc','marc',1,'443'),(10,'admin','marc','perprotegir',1,'21'),(10,'admin2','prova','marc',1,'22');
/*!40000 ALTER TABLE `credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devices` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `devices_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devices`
--

LOCK TABLES `devices` WRITE;
/*!40000 ALTER TABLE `devices` DISABLE KEYS */;
INSERT INTO `devices` VALUES (1,'Server 1','10.23.0.80',1),(2,'Server 2','10.23.0.81',1),(7,'prova','10.23.0.82',1),(10,'ubuntu','10.23.0.83',1);
/*!40000 ALTER TABLE `devices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fixed_costs`
--

DROP TABLE IF EXISTS `fixed_costs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fixed_costs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fixed_costs`
--

LOCK TABLES `fixed_costs` WRITE;
/*!40000 ALTER TABLE `fixed_costs` DISABLE KEYS */;
INSERT INTO `fixed_costs` VALUES (1,'prova',11.00),(6,'prova3',10.56),(7,'prova2',24.00);
/*!40000 ALTER TABLE `fixed_costs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nom` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vlan` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (0,'general','',''),(1,'nokia','Nokia','23'),(23,'beteshda','Beteshda','22'),(25,'servitek','Servitek','24');
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'prova',1,'2024-02-16'),(2,'Prova',1,'2024-02-16'),(3,'Holaaa! :)',1,'2024-02-16'),(4,'a',1,'2024-02-16'),(5,'Hola',1,'2024-02-19'),(6,'Holaaaa',1,'2024-02-19'),(7,'zx',1,'2024-02-21'),(8,'asd',2,'2024-02-22');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nokia`
--

DROP TABLE IF EXISTS `nokia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nokia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double NOT NULL,
  `data` date NOT NULL,
  `userId` int DEFAULT NULL,
  `authorized` tinyint(1) NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `nokia_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nokia`
--

LOCK TABLES `nokia` WRITE;
/*!40000 ALTER TABLE `nokia` DISABLE KEYS */;
INSERT INTO `nokia` VALUES (0,'Starting Amount','asd',4000,'2023-11-14',1,1,1),(1,'LibreNMS','Instalació LibreNMS',300,'2023-12-22',1,1,1),(2,'Splunk','Instalació Splunk',200,'2023-12-22',1,1,1),(10,'prova','prova',200,'2023-11-26',1,1,1),(11,'prova','adsf',200,'2023-11-26',1,1,1),(12,'Prova actualització','prova',100,'2023-11-27',1,1,1),(13,'transacio 28','Transaction',400,'2023-11-28',1,1,1),(14,'Divendres','Divendres',50,'2023-11-30',1,1,1),(15,'December 5','December',250,'2023-12-05',1,1,1),(16,'December 11','December 11',380,'2023-12-11',1,1,1),(18,'prova','adsa',500,'2023-11-13',1,1,1),(19,'prova','dasf',50,'2023-11-14',1,1,1),(20,'prova','da',-100,'2023-12-27',1,1,1),(21,'add','dfa',200,'2023-12-27',1,1,1),(22,'add','fd',300,'2023-12-27',1,1,1),(23,'Reis','Reis',50,'2024-01-05',1,1,1),(24,'prova','prova',40,'2024-01-05',1,1,1),(25,'prova','prova',100,'2023-12-19',1,1,1),(26,'prova','ads',-100,'2023-12-19',1,1,1),(27,'Tablet','Tablet',200,'2024-01-05',1,1,1),(28,'a','adsf',-500,'2023-12-26',1,1,1),(29,'asdfasfd','asdf',23,'2024-01-06',1,1,1),(30,'asdfasfd','asdf',23,'2024-01-06',1,1,1),(32,'LibreNMS','asdf',500,'2024-01-09',1,1,1),(34,'sdaf','dsaf',-1000,'2023-12-12',1,1,1),(35,'prova user','prova',500,'2024-01-16',2,1,1),(36,'prova','fas',500,'2024-01-19',1,1,1),(37,'loading','loading test',-100,'2024-01-21',1,1,1),(38,'loading','loading ok',-100,'2024-01-21',1,1,1),(39,'prova','prova',50,'2024-01-21',1,1,1),(40,'prova','prova',500,'2024-01-22',7,1,1),(41,'prova','asdf',100,'2024-03-13',1,1,1),(42,'prova','prova',500,'2024-01-30',1,1,1),(43,'a','d',10,'2024-01-30',1,1,1),(44,'a','d',500,'2024-01-30',1,1,1),(45,'ad','d',-500,'2024-01-30',1,1,1),(46,'df','d',-500,'2024-01-30',1,1,1),(47,'adsfasf','dsaf',-500,'2024-01-30',1,1,1),(48,'asdf','asdf',32,'2024-01-30',1,1,1),(49,'psdf','asdf',12,'2024-01-30',1,1,1),(50,'dfg','dfg',22,'2024-01-30',1,1,1),(51,'fd','asdf',14,'2024-01-30',1,1,1),(52,'jk','u',55,'2024-01-30',1,1,1),(53,'sdf','d',-10,'2024-01-30',1,1,1),(54,'df','df',5,'2024-01-30',1,1,1),(55,'d','sd',11,'2024-01-30',1,1,1),(57,'asdf','jk',10,'2024-01-30',1,1,1),(60,'VMachines','Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €',-234.67,'2024-02-06',1,1,1),(62,'prova accept','sa',100,'2024-02-21',2,1,1),(63,'prova2','d',20,'2024-02-21',2,1,1),(65,'VMachines','Proxmox VMachines. CPU: 50.14 €, Disk: 255.3 €',-305.44,'2023-12-03',1,1,1),(67,'prova','l',-100,'2024-02-21',1,1,1),(68,'asdf','ds',13,'2024-02-21',1,1,1),(69,'asdf','asfd',13,'2024-02-21',1,1,1),(70,'VMachines','Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €',-234.67,'2024-02-04',1,1,1),(72,'adf','dds',26,'2024-02-23',1,1,1),(74,'VMachines','Proxmox VMachines. CPU: 0.0 €, Disk: 0.0 €',0,'2024-02-23',0,1,1),(77,'prova','',-10,'2024-03-07',0,1,1),(78,'prova2','',-12,'2024-03-07',0,1,1),(79,'sad','adsf',32,'2024-03-07',1,1,1),(80,'Prova','asdf',234,'2024-03-21',1,1,1);
/*!40000 ALTER TABLE `nokia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price`
--

DROP TABLE IF EXISTS `price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price` (
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price`
--

LOCK TABLES `price` WRITE;
/*!40000 ALTER TABLE `price` DISABLE KEYS */;
INSERT INTO `price` VALUES ('cpu',2),('disk',0.56),('firstCourse',4),('secondCourse',6);
/*!40000 ALTER TABLE `price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `description` varchar(250) DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  `data` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projects`
--

LOCK TABLES `projects` WRITE;
/*!40000 ALTER TABLE `projects` DISABLE KEYS */;
INSERT INTO `projects` VALUES (15,'prova2','23',1,'2024-01-17'),(16,'project 2','ddsf',1,'2024-02-23'),(17,'project 3','dsfa',1,'2024-02-23'),(18,'prova','adsf',1,'2024-03-06'),(19,'prova2','ad',1,'2024-03-07'),(21,'prova','asdf',1,'2024-03-20');
/*!40000 ALTER TABLE `projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recording`
--

DROP TABLE IF EXISTS `recording`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recording` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `project_id` int DEFAULT NULL,
  `start` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `recording_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `recording_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording`
--

LOCK TABLES `recording` WRITE;
/*!40000 ALTER TABLE `recording` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rights`
--

LOCK TABLES `rights` WRITE;
/*!40000 ALTER TABLE `rights` DISABLE KEYS */;
INSERT INTO `rights` VALUES (1,'Admin','Rights to manage the group, add/quit users, delete the group...'),(2,'Teacher','Rights to manage some global configurations');
/*!40000 ALTER TABLE `rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servitek`
--

DROP TABLE IF EXISTS `servitek`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servitek` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `authorized` tinyint(1) NOT NULL,
  `accepted` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `servitek_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servitek`
--

LOCK TABLES `servitek` WRITE;
/*!40000 ALTER TABLE `servitek` DISABLE KEYS */;
INSERT INTO `servitek` VALUES (0,'Starting Amount','',100000,'2024-02-07',1,1,1),(3,'VMachines','Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €',-425.71999999999997,'2024-02-15',1,1,1),(4,'VMachines','Proxmox VMachines. CPU: 48.42 €, Disk: 436.89 €',-485.31,'2023-12-03',1,1,0),(5,'VMachines','Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €',-425.71999999999997,'2024-02-04',1,1,1),(6,'VMachines','Proxmox VMachines. CPU: 0.0 €, Disk: 0.0 €',0,'2024-02-23',NULL,1,1),(7,'VMachines','Proxmox VMachines. CPU: 0.0 €, Disk: 0.0 €',0,'2024-02-23',0,1,1),(8,'prova','',10,'2024-03-07',0,1,0),(9,'prova2','',12,'2024-03-07',0,1,0),(10,'prova','',-10,'2024-03-07',0,1,0),(11,'prova2','',-12,'2024-03-07',0,1,0);
/*!40000 ALTER TABLE `servitek` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `key` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('chatId','719358840'),('alertChatId','719358840');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprints`
--

DROP TABLE IF EXISTS `sprints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sprints` (
  `name` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL,
  `end` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sprints`
--

LOCK TABLES `sprints` WRITE;
/*!40000 ALTER TABLE `sprints` DISABLE KEYS */;
INSERT INTO `sprints` VALUES ('Sprint 1','2023-09-11','2023-09-29'),('Sprint 2','2023-10-02','2023-10-20'),('Sprint 3','2023-10-23','2023-11-10'),('Sprint 4','2023-11-13','2023-12-01'),('Sprint 5','2023-12-04','2024-01-12'),('Sprint 6','2024-01-15','2024-02-01'),('Sprint 7','2024-02-05','2024-02-23'),('Sprint 8','2024-02-26','2024-03-15'),('Sprint 9','2024-03-18','2024-04-05'),('Sprint 10','2024-04-08','2024-04-26'),('Sprint 11','2024-04-29','2024-05-24');
/*!40000 ALTER TABLE `sprints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `course` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (0,'auto','a789d485a3d72acf6b12aaf3ba80da8ec40b6c4bb41bdeec87db3a7587443aae','Twt@IrmUB4zTfHUC3IYGlSJwZpSjY2Bi','auto',2),(1,'marc','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','tsu$&ZdM&pQca0PCPOFW4&tI6QxgNhlc','Marc',2),(2,'marc2','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','dvBt%2h$Qr7FK@YEb8F9iLrqCH1G6YlE','Marc2',2),(7,'espuga','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','TYZB#qowxS2AJyAVXZaXBDzff2Kye6fg','Espuga',2),(8,'espuga2','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','juyilIyrzOd6$ZO4yzxbVlBG78tjyt$9','espuga',2),(9,'espuga4','7dc6811fc4f2373e72a00adb5d69ebcac157849e40a662f2459cf1465dff6f37','pUD2l80S#TaIU3#dRYWso37qWM8RijC5','Espuga4',2),(10,'marc3','1ad27635e6ec9449eef2da946dcd808ff6ae5bea4516186ca2b9cad7c2504feb','KWfKVlyoFq%RWZOuyWlPIAcVxECqi&WB','marc3',2),(11,'marc4','fe11fe9cad28a9186c1e40a27b0ee420324e97f8fe0d0b989aaa4037104dfdbd','g$yoI5ESZm#YV1l7KjPOz6wApes#ErK7','marc4',2),(12,'marc5','e0d50ec8ac0401f8a66b1942f6b112069346326be9faa8fc47715eb808866359','olENnWcbuyeVGGaXKo@Lyc4wSN9wmtuR','marc5',2),(13,'marc6','6773493b7dd98d9f9fbe7427aa58f017e129aac036ff998aafb8c5239d1afb74','UwWjnnyIW%kSkJO6BTSEzBpDfcI%LFNk','marc6',2),(14,'marc7','74181cf8801a7bfb68402bcc7cc2b980d3ee22820e7ea5750b616139c41f3e10','S6s4ggfIh6QW57RTWM6VFDgbdzn$izWS','marc7',2),(15,'marc8','4df5db5cf629ec3724f33eed6d6373086b621d146492ec0c2962324e6a457853','jD2lY3g%H2cii6Q2cOUO$A&ywVe%#M5q','marc8',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_groups`
--

DROP TABLE IF EXISTS `users_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_groups` (
  `user_id` int DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `users_groups_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_groups`
--

LOCK TABLES `users_groups` WRITE;
/*!40000 ALTER TABLE `users_groups` DISABLE KEYS */;
INSERT INTO `users_groups` VALUES (2,1),(7,1),(7,23),(2,23),(8,23),(10,1),(11,1),(12,1),(13,1),(14,1),(2,25),(NULL,25),(NULL,25),(7,25),(10,25),(15,1);
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_projects`
--

DROP TABLE IF EXISTS `users_projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_projects` (
  `group_id` int NOT NULL,
  `user_id` int NOT NULL,
  `project_id` int NOT NULL,
  `hours` double DEFAULT NULL,
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `project_id` (`project_id`),
  CONSTRAINT `users_projects_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `users_projects_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_projects_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_projects`
--

LOCK TABLES `users_projects` WRITE;
/*!40000 ALTER TABLE `users_projects` DISABLE KEYS */;
INSERT INTO `users_projects` VALUES (1,2,15,1),(1,7,15,0),(1,10,15,0),(1,11,15,0),(1,12,15,0),(1,13,15,0),(1,14,15,0),(1,2,16,2),(1,7,16,4),(1,10,16,0),(1,11,16,0),(1,12,16,0),(1,13,16,0),(1,14,16,0),(1,15,16,0),(1,2,17,2.5),(1,7,17,1),(1,10,17,1),(1,11,17,0),(1,12,17,0),(1,13,17,0),(1,14,17,0),(1,15,17,0),(1,1,18,0),(1,2,18,3.916666666666667),(1,7,18,0.5333333333333333),(1,10,18,0),(1,11,18,0),(1,12,18,0),(1,13,18,0),(1,14,18,0),(1,15,18,0),(1,1,19,0.25),(1,2,19,1.25),(1,7,19,1),(1,10,19,0),(1,11,19,0),(1,12,19,0),(1,13,19,0),(1,14,19,0),(1,15,19,0),(1,2,21,1.0166666666666666),(1,7,21,0),(1,10,21,0),(1,11,21,0),(1,12,21,0),(1,13,21,0),(1,14,21,0),(1,15,21,0);
/*!40000 ALTER TABLE `users_projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_rights`
--

DROP TABLE IF EXISTS `users_rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_rights` (
  `user_id` int DEFAULT NULL,
  `group_id` int DEFAULT NULL,
  `right_id` int DEFAULT NULL,
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  KEY `right_id` (`right_id`),
  CONSTRAINT `users_rights_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_rights_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `users_rights_ibfk_3` FOREIGN KEY (`right_id`) REFERENCES `rights` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_rights`
--

LOCK TABLES `users_rights` WRITE;
/*!40000 ALTER TABLE `users_rights` DISABLE KEYS */;
INSERT INTO `users_rights` VALUES (1,0,2),(7,23,1),(2,23,1),(0,0,2),(1,1,1),(2,1,1);
/*!40000 ALTER TABLE `users_rights` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-21 15:00:39
