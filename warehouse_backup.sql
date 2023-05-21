-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: warehouse
-- ------------------------------------------------------
-- Server version 5.7.24-0ubuntu0.16.04.1

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
-- Table structure for table `dc_warehouse`
--

DROP TABLE IF EXISTS `dc_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_warehouse` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mission` tinytext,
  `url` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_warehouse`
--

LOCK TABLES `dc_warehouse` WRITE;
/*!40000 ALTER TABLE `dc_warehouse` DISABLE KEYS */;
INSERT INTO `dc_warehouse` VALUES (57,'스텍스 4커플릴레이','https://drive.google.com/open?id=1KcyAwLpMHtsRYgNLQPq25bUD2bJzTiGF'),(58,'스텍스 개인릴레이','https://drive.google.com/open?id=1U5UpZBRq29Akn3CZxWw0a8ngQh3RX9QB'),(59,'파이프댄스 3단계릴레이','https://drive.google.com/open?id=19GtHuh4SBw-19FHmuLUAkFEBa0ra2JKb'),(60,'파이프댄스  2커플릴레이','https://drive.google.com/open?id=1RJjnkxJ0cTeAO3b-9UNFnX3hsRunCxfJ'),(61,'동원참치가시고기','https://drive.google.com/open?id=1kubRCmSzWwWW6Dg_XaPxix2GLacOcQkj'),(62,'수식퍼즐-블럭','https://drive.google.com/open?id=12Ny3iKawhuBiIk1fgOKMnEjQcxIicjE7'),(63,'래더볼','https://drive.google.com/open?id=1oRsAHuwcZ2GMnRPcD4v4fOiX0KbXyJfg'),(66,'행시','https://drive.google.com/open?id=1Im8FVcSwglTVJyRbu8y16zTCESncNX4I'),(67,'착시영상','https://drive.google.com/open?id=1YnM8saNcoN1NwdLm8zw3ZRAlIqv2gANN'),(72,'반지의제왕3단링','https://drive.google.com/open?id=1PCdgEtLn-I9p7WSkkJdPoW8oyAZB9FZr'),(73,'팀크레인','https://drive.google.com/open?id=1s5i7dH-GIJxO4BBfcg6Wkl-1yTCkVGND'),(75,'포인트라인','https://drive.google.com/open?id=1ATLUywDYn71juIlhoRW_u5PL0YdZ_zgx'),(76,'수식퍼즐-벨크로','https://drive.google.com/open?id=1oBOG0_O94T3UfxSU3CHl1Q3OrBlvcvus'),(77,'볼바운딩','https://drive.google.com/open?id=1IstSmvao24uosOtJxH1q6KQpT7qmXYNZ'),(78,'윈 도미노','https://drive.google.com/open?id=1fCZxTywtm5iHGbUOoJIPX8qZgA4qaWSO'),(79,'팀웍웨이브','https://drive.google.com/open?id=1VD5rE7M1-a7bU-vwlnnuAGNDfPZP3prX'),(80,'볼릴레이','https://drive.google.com/open?id=1ThATsfOEOLHXuObjgmwKWDoAthTFERG9'),(82,'4인제기차기','https://drive.google.com/file/d/1mkMW3vFz9E_4AOyyjKGVA1eO0RFFtlRb/view?usp=sharing'),(83,'5인 여행줄넘기','https://drive.google.com/file/d/1sg7zwSeAtUf30WbX2aMWsvL-ng1ZLg9f/view?usp=sharing'),(85,'타임라인','https://drive.google.com/file/d/1Ik42LEqnGxY-WuQl_mLVckDA2HnNk9Gs/view?usp=sharing'),(86,'문장만들기','https://drive.google.com/file/d/1jZID1K3K5hquCYRgxg5jg_ZDl44kDbiX/view?usp=sharing'),(87,'양궁','https://drive.google.com/file/d/13ygPN12Trxk2wF7mxp4hgE0Q7Gpv66rt/view?usp=share_link'),(88,'반지의제왕-180실내','https://drive.google.com/file/d/1NZtMtv4TcDg2poY_zMiOoLYwclK61u3r/view?usp=share_link'),(89,'반지의제왕-100실내','https://drive.google.com/file/d/1HPUCUQ_GpCIKxihTQxVr3FZnoztptudy/view?usp=share_link');
/*!40000 ALTER TABLE `dc_warehouse` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-21  4:48:10
