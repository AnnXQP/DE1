-- MySQL dump 10.13  Distrib 8.0.38, for macos14 (arm64)
--
-- Host: db.relational-data.org    Database: cs
-- ------------------------------------------------------
-- Server version	8.0.31-google

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `ORGANIZATIONS`
--

DROP TABLE IF EXISTS `ORGANIZATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ORGANIZATIONS` (
  `ORG_KEY` int NOT NULL,
  `ORGH_UNIFIED_ID` varchar(255) DEFAULT NULL,
  `CITY` varchar(255) DEFAULT NULL,
  `ZIP` int DEFAULT NULL,
  PRIMARY KEY (`ORG_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ORGANIZATIONS`
--

LOCK TABLES `ORGANIZATIONS` WRITE;
/*!40000 ALTER TABLE `ORGANIZATIONS` DISABLE KEYS */;
INSERT INTO `ORGANIZATIONS` VALUES (-2,'HR0_69999999','Onen svět - okres Klatovy',33901),(703,'HR0_50000333','Hořovice',26801),(710,'HR0_50000324','Kladno',27201),(720,'HR0_50000321','Hostivice',25301),(748,'HR0_50000399','Neratovice',27711),(749,'HR0_50000398','Mělník',27601),(755,'HR0_50000957','Praha 1',11000),(760,'HR0_50000383','Mladá Boleslav',29301),(775,'HR0_50000425','Dobříš',26301),(788,'HR0_50000456','Zliv',37344),(801,'HR0_50000471','Velešín',38232),(803,'HR0_50000749','Jindřichův Hradec',37701),(807,'HR0_50000530','Kardašova Řečice',37821),(817,'HR0_50000750','Onen svět - okres Klatovy',33901),(847,'HR0_50000499','Blatná',38801),(852,'HR0_50000518','Bechyně',39165),(858,'HR0_50000585','Plzeň',30100),(861,'HR0_50000608','Plzeň',32600),(878,'HR0_50000006','Domažlice',34401),(884,'HR0_50000753','Cheb',35002),(888,'HR0_50000552','Karlovy Vary',36001),(905,'HR0_50000755','Rokycany',33701),(921,'HR0_50000802','Ústí nad Labem',40001),(948,'HR0_50000656','Liberec',46001),(962,'HR0_50000816','Štětí',41108),(963,'HR0_50001603','Libochovice',41117),(984,'HR0_50000817','Teplice',41501),(992,'HR0_50000833','Hradec Králové',50003),(993,'HR0_50000846','Hradec Králové',50002),(1002,'HR0_50000923','Havlíčkův Brod',58001),(1005,'HR0_50000925','Světlá nad Sázavou',58291),(1011,'HR0_50000936','Hlinsko v Čechách',53901),(1029,'HR0_50000879','Broumov',55001),(1038,'HR0_50000909','Pardubice',53002),(1069,'HR0_50000681','Jablonec nad Jizerou',51243),(1074,'HR0_50001116','Moravská Třebová',57101),(1075,'HR0_50001117','Polička',57201),(1088,'HR0_50001121','Ústí nad Orlicí',56201),(1098,'HR0_50001139','Onen svět - okres Klatovy',33901),(1099,'HR0_50001145','Onen svět - okres Klatovy',33901),(1129,'HR0_50001395','Onen svět - okres Klatovy',33901),(1131,'HR0_50001397','Onen svět - okres Klatovy',33901),(1149,'HR0_50001225','Onen svět - okres Klatovy',33901),(1174,'HR0_50001041','Praha 6',16000),(1175,'HR0_50001042','Praha 6',16000),(1239,'HR0_50001287','Ostrava',70200),(1250,'HR0_50001515','Ostrava',70800),(1254,'HR0_50001519','Ostrava',70030),(1261,'HR0_50001423','Třinec',73961),(1269,'HR0_50001408','Havířov',73601),(1285,'HR0_50001444','Rožnov pod Radhoštěm',75661),(1289,'HR0_50001448','Odry',74235),(1294,'HR0_50001359','Olomouc',77900),(1310,'HR0_50001372','Opava',74601),(1312,'HR0_50001488','Bruntál',79201),(1315,'HR0_50001491','Krnov',79401),(2591,'HR0_50001491','Krnov',79401),(2792,'EX0_000351','Onen svět - okres Klatovy',33901),(3375,'HR0_50000324','Kladno',27201),(3417,'HR0_50000363','Říčany',25101),(3471,'HR0_50000585','Plzeň',30100),(3480,'HR0_50000006','Domažlice',34401),(3521,'HR0_50000530','Kardašova Řečice',37821),(3571,'HR0_50000802','Ústí nad Labem',40001),(3591,'HR0_50000628','Děčín',40502),(3767,'HR0_50001041','Praha 6',16000),(3788,'HR0_50001139','Onen svět - okres Klatovy',33901),(3795,'HR0_50001117','Polička',57201),(3798,'HR0_50001395','Onen svět - okres Klatovy',33901),(3874,'HR0_50001397','Onen svět - okres Klatovy',33901),(6381,'HR0_50000006','Domažlice',34401),(6527,'HR0_50000321','Hostivice',25301),(6530,'HR0_50000324','Kladno',27201),(6538,'HR0_50000333','Hořovice',26801),(6563,'HR0_50000383','Mladá Boleslav',29301),(6570,'HR0_50000398','Mělník',27601),(6571,'HR0_50000399','Neratovice',27711),(6613,'HR0_50000471','Velešín',38232),(6627,'HR0_50000499','Blatná',38801),(6637,'HR0_50000518','Bechyně',39165),(6647,'HR0_50000530','Kardašova Řečice',37821),(6659,'HR0_50000552','Karlovy Vary',36001),(6677,'HR0_50000585','Plzeň',30100),(6694,'HR0_50000608','Plzeň',32600),(6721,'HR0_50000656','Liberec',46001),(6737,'HR0_50000681','Jablonec nad Jizerou',51243),(6769,'HR0_50000749','Jindřichův Hradec',37701),(6770,'HR0_50000750','Onen svět - okres Klatovy',33901),(6771,'HR0_50000753','Cheb',35002),(6773,'HR0_50000755','Rokycany',33701),(6802,'HR0_50000802','Ústí nad Labem',40001),(6811,'HR0_50000816','Štětí',41108),(6812,'HR0_50000817','Teplice',41501),(6821,'HR0_50000833','Hradec Králové',50003),(6829,'HR0_50000846','Hradec Králové',50002),(6848,'HR0_50000879','Broumov',55001),(6871,'HR0_50000909','Pardubice',53002),(6880,'HR0_50000923','Havlíčkův Brod',58001),(6882,'HR0_50000925','Světlá nad Sázavou',58291),(6893,'HR0_50000936','Hlinsko v Čechách',53901),(6903,'HR0_50000957','Praha 1',11000),(6935,'HR0_50001014','Praha 4',14000),(6950,'HR0_50001041','Praha 6',16000),(6951,'HR0_50001042','Praha 6',16000),(6966,'HR0_50001070','Praha 8',18200),(6993,'HR0_50001116','Moravská Třebová',57101),(6994,'HR0_50001117','Polička',57201),(6998,'HR0_50001121','Ústí nad Orlicí',56201),(7007,'HR0_50001139','Onen svět - okres Klatovy',33901),(7008,'HR0_50001145','Onen svět - okres Klatovy',33901),(7064,'HR0_50001225','Onen svět - okres Klatovy',33901),(7098,'HR0_50001287','Ostrava',70200),(7134,'HR0_50001359','Olomouc',77900),(7135,'HR0_50001372','Opava',74601),(7141,'HR0_50001395','Onen svět - okres Klatovy',33901),(7143,'HR0_50001397','Onen svět - okres Klatovy',33901),(7154,'HR0_50001408','Havířov',73601),(7168,'HR0_50001423','Třinec',73961),(7182,'HR0_50001444','Rožnov pod Radhoštěm',75661),(7186,'HR0_50001448','Odry',74235),(7223,'HR0_50001488','Bruntál',79201),(7226,'HR0_50001491','Krnov',79401),(7250,'HR0_50001515','Ostrava',70800),(7254,'HR0_50001519','Ostrava',70030),(7270,'HR0_50001603','Libochovice',41117),(7440,'HR0_60000014','Onen svět - okres Klatovy',33901),(10645,'EX0_000099','Onen svět - okres Klatovy',33901),(10735,'EX0_000333','Onen svět - okres Klatovy',33901),(322051,'EX0_000099','Onen svět - okres Klatovy',33901),(322105,'EX0_000333','Onen svět - okres Klatovy',33901),(338105,'HR0_50001017','Praha 4',14700),(338160,'HR0_50001070','Praha 8',18200),(342236,'HR0_50003554','Onen svět - okres Klatovy',33901),(397859,'EX0_000363','Onen svět - okres Klatovy',33901),(397880,'EX0_000363','Onen svět - okres Klatovy',33901),(426587,'HR0_50004147','Děčín',40502),(426802,'HR0_50004147','Děčín',40502);
/*!40000 ALTER TABLE `ORGANIZATIONS` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-06 15:10:41