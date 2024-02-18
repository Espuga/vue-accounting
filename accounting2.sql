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
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `beteshda_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beteshda`
--

LOCK TABLES `beteshda` WRITE;
/*!40000 ALTER TABLE `beteshda` DISABLE KEYS */;
INSERT INTO `beteshda` VALUES (0,'Starting Amount','',2334,'2024-01-31',1),(2,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',513.21,'2024-02-06',1),(3,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-06',1),(4,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-06',1),(5,'VMachines','Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €',-513.21,'2024-02-15',1);
/*!40000 ALTER TABLE `beteshda` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vlan` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
INSERT INTO `groups` VALUES (0,'general',''),(1,'nokia','23'),(23,'beteshda','22'),(25,'servitek','24');
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
  `message` varchar(500) DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'prova',1,'2024-02-16'),(2,'Prova',1,'2024-02-16'),(3,'Holaaa! :)',1,'2024-02-16'),(4,'a',1,'2024-02-16');
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
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double NOT NULL,
  `data` date NOT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `nokia_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nokia`
--

LOCK TABLES `nokia` WRITE;
/*!40000 ALTER TABLE `nokia` DISABLE KEYS */;
INSERT INTO `nokia` VALUES (0,'Starting Amount','asd',4000,'2023-11-14',1),(1,'LibreNMS','Instalació LibreNMS',300,'2023-12-22',1),(2,'Splunk','Instalació Splunk',200,'2023-12-22',1),(10,'prova','prova',200,'2023-11-26',1),(11,'prova','adsf',200,'2023-11-26',1),(12,'Prova actualització','prova',100,'2023-11-27',1),(13,'transacio 28','Transaction',400,'2023-11-28',1),(14,'Divendres','Divendres',50,'2023-11-30',1),(15,'December 5','December',250,'2023-12-05',1),(16,'December 11','December 11',380,'2023-12-11',1),(18,'prova','adsa',500,'2023-11-13',1),(19,'prova','dasf',50,'2023-11-14',1),(20,'prova','da',-100,'2023-12-27',1),(21,'add','dfa',200,'2023-12-27',1),(22,'add','fd',300,'2023-12-27',1),(23,'Reis','Reis',50,'2024-01-05',1),(24,'prova','prova',40,'2024-01-05',1),(25,'prova','prova',100,'2023-12-19',1),(26,'prova','ads',-100,'2023-12-19',1),(27,'Tablet','Tablet',200,'2024-01-05',1),(28,'a','adsf',-500,'2023-12-26',1),(29,'asdfasfd','asdf',23,'2024-01-06',1),(30,'asdfasfd','asdf',23,'2024-01-06',1),(32,'LibreNMS','asdf',500,'2024-01-09',1),(34,'sdaf','dsaf',-1000,'2023-12-12',1),(35,'prova user','prova',500,'2024-01-16',2),(36,'prova','fas',500,'2024-01-19',1),(37,'loading','loading test',-100,'2024-01-21',1),(38,'loading','loading ok',-100,'2024-01-21',1),(39,'prova','prova',50,'2024-01-21',1),(40,'prova','prova',500,'2024-01-22',7),(41,'prova','asdf',100,'2024-03-13',1),(42,'prova','prova',500,'2024-01-30',1),(43,'a','d',10,'2024-01-30',1),(44,'a','d',500,'2024-01-30',1),(45,'ad','d',-500,'2024-01-30',1),(46,'df','d',-500,'2024-01-30',1),(47,'adsfasf','dsaf',-500,'2024-01-30',1),(48,'asdf','asdf',32,'2024-01-30',1),(49,'psdf','asdf',12,'2024-01-30',1),(50,'dfg','dfg',22,'2024-01-30',1),(51,'fd','asdf',14,'2024-01-30',1),(52,'jk','u',55,'2024-01-30',1),(53,'sdf','d',-10,'2024-01-30',1),(54,'df','df',5,'2024-01-30',1),(55,'d','sd',11,'2024-01-30',1),(57,'asdf','jk',10,'2024-01-30',1),(60,'VMachines','Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €',-234.67,'2024-02-06',1),(61,'VMachines','Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €',-234.67,'2024-02-15',1);
/*!40000 ALTER TABLE `nokia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price`
--

DROP TABLE IF EXISTS `price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price` (
  `name` varchar(50) NOT NULL,
  `value` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price`
--

LOCK TABLES `price` WRITE;
/*!40000 ALTER TABLE `price` DISABLE KEYS */;
INSERT INTO `price` VALUES ('cpu',2),('disk',0.56);
/*!40000 ALTER TABLE `price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rights`
--

DROP TABLE IF EXISTS `rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rights` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `userId` (`userId`),
  CONSTRAINT `servitek_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servitek`
--

LOCK TABLES `servitek` WRITE;
/*!40000 ALTER TABLE `servitek` DISABLE KEYS */;
INSERT INTO `servitek` VALUES (0,'Starting Amount','',100000,'2024-02-07',1),(3,'VMachines','Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €',-425.71999999999997,'2024-02-15',1);
/*!40000 ALTER TABLE `servitek` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `key` varchar(50) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES ('chatId','719358840');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sprints`
--

DROP TABLE IF EXISTS `sprints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sprints` (
  `name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sprints`
--

LOCK TABLES `sprints` WRITE;
/*!40000 ALTER TABLE `sprints` DISABLE KEYS */;
INSERT INTO `sprints` VALUES ('Sprint 1','2023-09-11'),('Sprint 2','2023-10-02'),('Sprint 3','2023-10-23'),('Sprint 4','2023-11-13'),('Sprint 5','2023-12-04'),('Sprint 6','2024-01-15'),('Sprint 7','2024-02-05'),('Sprint 8','2024-02-26'),('Sprint 9','2024-04-01'),('Sprint 10','2024-04-22'),('Sprint 11','2024-05-13');
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
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'marc','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','tsu$&ZdM&pQca0PCPOFW4&tI6QxgNhlc','Marc'),(2,'marc2','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','dvBt%2h$Qr7FK@YEb8F9iLrqCH1G6YlE','Marc2'),(7,'espuga','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','TYZB#qowxS2AJyAVXZaXBDzff2Kye6fg','Espuga'),(8,'espuga2','9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a','juyilIyrzOd6$ZO4yzxbVlBG78tjyt$9','espuga'),(9,'espuga4','7dc6811fc4f2373e72a00adb5d69ebcac157849e40a662f2459cf1465dff6f37','pUD2l80S#TaIU3#dRYWso37qWM8RijC5','Espuga4');
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
INSERT INTO `users_groups` VALUES (2,1),(7,1),(7,23),(2,23);
/*!40000 ALTER TABLE `users_groups` ENABLE KEYS */;
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
INSERT INTO `users_rights` VALUES (1,0,2),(7,23,1),(2,1,1),(2,23,1);
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

-- Dump completed on 2024-02-16 16:14:11
