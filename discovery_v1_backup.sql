-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: discovery_v1
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
-- Table structure for table `dc_metas`
--

DROP TABLE IF EXISTS `dc_metas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_metas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `metaKey` tinytext,
  `metaValue` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_metas`
--

LOCK TABLES `dc_metas` WRITE;
/*!40000 ALTER TABLE `dc_metas` DISABLE KEYS */;
INSERT INTO `dc_metas` VALUES (3,'mappingPoints','{\"timerPlus\":100,\"timerMinus\":100,\"upload\":1000,\"boxOpenGetEmpty\":2000,\"boxOpenGetWord\":4000,\"boxOpenUse\":1000,\"eniac\":20000,\"bingo\":1000}'),(7,'companyImage','companyImage-66.jpg'),(8,'map','map-84.jpg'),(9,'laptime','480'),(10,'puzzleBoxCount','30'),(11,'originalEniacWords','우리는하나'),(12,'randomEniacWords','[\"는\",0,0,0,\"하\",0,0,0,\"우\",0,0,0,\"리\",0,0,0,0,\"나\",0,0,0,0,0,0,0,0,0,0,0]'),(13,'lastBoxUrl',NULL),(14,'lastBoxState','0'),(15,'adminPasswords','{\"admin\":\"0911\",\"assist\":\"0911\"}'),(16,'eniacSuccessTeams',NULL),(17,'eniacState','1'),(18,'tempBoxState','1');
/*!40000 ALTER TABLE `dc_metas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_points`
--

DROP TABLE IF EXISTS `dc_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_points` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `useable` int(11) DEFAULT '0',
  `timer` int(11) DEFAULT '0',
  `eniac` int(11) DEFAULT '0',
  `puzzle` int(11) DEFAULT '0',
  `temp` int(11) DEFAULT '0',
  `bingo` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_points`
--

LOCK TABLES `dc_points` WRITE;
/*!40000 ALTER TABLE `dc_points` DISABLE KEYS */;
INSERT INTO `dc_points` VALUES (1,1500,-91000,0,0,0,0),(2,2000,-91000,0,0,0,0),(3,2300,-91000,0,0,0,0),(4,1800,-91000,0,0,0,0),(5,0,0,0,0,0,0),(6,0,0,0,0,0,0),(7,0,0,0,0,0,0),(8,0,0,0,0,0,0),(9,0,0,0,0,0,0),(10,0,0,0,0,0,0),(11,0,0,0,0,0,0),(12,0,0,0,0,0,0),(13,0,0,0,0,0,0),(14,0,0,0,0,0,0),(15,0,0,0,0,0,0);
/*!40000 ALTER TABLE `dc_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_postInfos`
--

DROP TABLE IF EXISTS `dc_postInfos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_postInfos` (
  `post` int(11) unsigned NOT NULL,
  `mission` tinytext,
  `url` text,
  PRIMARY KEY (`post`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_postInfos`
--

LOCK TABLES `dc_postInfos` WRITE;
/*!40000 ALTER TABLE `dc_postInfos` DISABLE KEYS */;
INSERT INTO `dc_postInfos` VALUES (1,'스텍스','https://drive.google.com/open?id=1KcyAwLpMHtsRYgNLQPq25bUD2bJzTiGF'),(2,'파이프댄스','https://drive.google.com/open?id=19GtHuh4SBw-19FHmuLUAkFEBa0ra2JKb'),(3,'래더볼','https://drive.google.com/open?id=1oRsAHuwcZ2GMnRPcD4v4fOiX0KbXyJfg'),(4,'착시영상','https://drive.google.com/open?id=1YnM8saNcoN1NwdLm8zw3ZRAlIqv2gANN'),(5,'타임라인','https://drive.google.com/file/d/1Ik42LEqnGxY-WuQl_mLVckDA2HnNk9Gs/view?usp=sharing');
/*!40000 ALTER TABLE `dc_postInfos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_puzzles`
--

DROP TABLE IF EXISTS `dc_puzzles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_puzzles` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `boxNumbers` text,
  `emptyBoxOpenCount` int(11) DEFAULT '0',
  `wordBoxOpenCount` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_puzzles`
--

LOCK TABLES `dc_puzzles` WRITE;
/*!40000 ALTER TABLE `dc_puzzles` DISABLE KEYS */;
INSERT INTO `dc_puzzles` VALUES (1,NULL,0,0),(2,NULL,0,0),(3,NULL,0,0),(4,NULL,0,0),(5,NULL,0,0),(6,NULL,0,0),(7,NULL,0,0),(8,NULL,0,0),(9,NULL,0,0),(10,NULL,0,0),(11,NULL,0,0),(12,NULL,0,0),(13,NULL,0,0),(14,NULL,0,0),(15,NULL,0,0);
/*!40000 ALTER TABLE `dc_puzzles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_sessions`
--

DROP TABLE IF EXISTS `dc_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_sessions`
--

LOCK TABLES `dc_sessions` WRITE;
/*!40000 ALTER TABLE `dc_sessions` DISABLE KEYS */;
INSERT INTO `dc_sessions` VALUES ('-n7JDeJhxjQh1D5HkM8R0utdFjdLadQL',1677772577,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('-oob61vUvFwsNzsZ76wl-FOZ7LRLdOFR',1677774575,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('0ShKyht6q3wCy8373_3-VKneVmj2kjlT',1677775912,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('0_KIGGnuDadYmUSKaOBQebuI-Sc7XwpK',1677779567,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('13nJTAv_tk3AkLL4tiLE43-S7HABL1FR',1677740211,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('1XB0Wb8wMw0H9BB6XHAwHI-_iSXVVp6X',1677751097,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('2Gxj1WlL4W7Dqsbe7gRk-3alvo4dr-FR',1677767386,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('3xbvOM4bVcYiKBNBAN2nlMJyn5UZfoxE',1677751232,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('4nMhhIH23JAmqbZX_E-SsncIXq3p8hxF',1677779066,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('4qxPlp9qY3ZskaW9Z5kvl5w3K92EdOFD',1677763592,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('500g6CMqNYBWyRAqBc9Ig3HEbz1T-Api',1677742381,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('5jwVYc1a9Z2MGJZuqKJcgLSpYarrjavO',1677765099,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('6-oo9v_UXaYpK54JuAP7ViGTGN90hlr_',1677763520,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('6ahyo_ctsEpUdzpTEuTDusnmv7HqFP1K',1677755664,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('74VUVMBm0m6i_eoOPEez61CMDofQmQVJ',1677782488,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('7or-lzs3rZvco_FArc954UAMIe3FY6Ky',1677743996,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('7wpyAmB_3eUTcsiJXpbaamqPYVnIkznq',1677724350,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('89aENkMGiV7z5IHQHv0DHM34LuInUbaT',1677760406,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('8crbE-XmhHYdOzpEgOxIZZa11ohcMH-x',1677783280,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('9Popz6Slc8jL76iwmGqAx72TMzuGrP6Y',1677792454,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('9UsIWNg5Dthw1EuRXRTyw7D4PgPElXmY',1677725656,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('9gYyH22VkkndILYUAlXhJ5xsJ-vzHbBF',1677751231,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('9hUPg-DoZLbZ9URDgWmo-pCiBwqwDadI',1677790200,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('A6oDh91UOe-pXpSTDlzGVv6c2q91RtK-',1677733254,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Adn3yCwiYRd4LooCAwWKoUz7McI7JPn3',1677746762,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('BUjou9xCxoRItz4Cfu_OAGt3zG2KZ5M_',1677781796,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('BkDiQh3W-XBFT5E9CpKxYf00ElVRktru',1677795829,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('C9qmw5MrcTU5yk67F1xD4__xnVDs8Ni3',1677751234,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('D8eDfD0lsdeUkqGWwR3qabxTbIkkLOL6',1677790201,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('DAm5n95Du0G9hq7rUNUfI_Lkv5ggcPcR',1677734512,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('EWrINYG6f6vZrTa4IlYdQJnVlbS_z2t4',1677783318,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Ena-F_ZNa4r3j6dqlJtZOJY2JBJ0_S1k',1677724838,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('F0H5IWj3xt9vAUNjnMHft_b4z0cRvuER',1677756405,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('F0tdnJ2THKf_OEZCH_rjC9Sm7GF98umx',1677739077,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('G9kvJ6-6-e5k5HykXxj_owGo1ShcGIh3',1677724351,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('GiytQnPD6chSwlESfFVOjwz7M6fj1haU',1677791757,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('GmUubwqg4btrLJbaioVR3KwVO_peWiac',1677769966,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('GvDrHHgdCDyYCscmlaBnlKKVd9EvjUAn',1677738880,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('HI1cLuJZm-pcXu0cYzHegjboOOyItMDp',1677741163,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('HLRFdsgSBcmzeZPWNGMWZzO8O6B9NMO2',1677749199,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('HnpfHui-4sGBTfSeuabLozD2AZ2wl_7N',1677801370,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('J7sULd-ECYpq8Po9NsgATZG9tRhoFwLX',1677751238,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('JQg_pQWYtDtJ9MyBDD9tYMOZA44kQ9RM',1677755645,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('JXuklHYtTfCGFN3IbIMbnFNhWBq0PxyX',1677724351,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('JfiU5rVXTRB-75Q1mSu7u8ADMwteyq5t',1677758277,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Jonw8KYUbgu7Te9ymt0_RZ-TW2wBlKcm',1677727793,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('K4P9iAF2J70vltKwJodRqp2f6oSa1zT6',1677751231,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('L5Bu1qe0EnDMX5h9rb-_Kl-DjkDb0zOP',1677800873,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('LMQkBoDBY6PkfbtsLT3H-5eAaYUzkijT',1677761249,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('MSKeEo8Hu3u1yxSemhrPnMrbosxcBmWD',1677791911,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Mhj9BygsHnR3Xx9XZckNE8E6-aYFV6sU',1677796130,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('N4Q2DA2nDke0Ekk3TCD0pUx8UlDLvfcD',1677751234,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('NVxyVhKIKgo9lVXFRewCvl7LSHHK0mo8',1677808603,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('OnVPlYDNWWCS4u6hPdMllw1nyT_IA54i',1677753592,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('OxCq81U747H3U1aoi8jHxJpdOzBAlwZn',1677759969,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('RVL4YwL-CpEZR7rpGkVliY1uRgzcyaOm',1677781627,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('RXkLQusEus9OS6Yewy3xusax45yJ27O_',1677791756,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('SsCyndaKxUS7e-ikHod7ZctAfLQfF4BN',1677804006,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Ts095eFRmPj7JUfKQF5ktzvIaAYuuL6E',1677745654,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Txa5jWPzB8EkGhtqm85_F1Q-6-mSR7Ia',1677757593,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('UJY6aXQ2YnMd2KLtygIMjc3foBleLKZ-',1677792529,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('VdZxQiAJQtIpaWe1EBoJZsplolnNtWv_',1677752826,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('Wg_YWdFVqPksk-3_s2yJlNGUnW0Jt17q',1677751237,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('XWuy9i1vehJEsobHAYRa_Zan2cOJzCqr',1677740715,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('XuV4_ciHAvVYggHY-7GlRtrdQ_uYHlLF',1677766934,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('_2dwgrJsyq2ZrsYRF8lbnQc0uGh5LZPn',1677799614,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('_72Do6kMxznO0Sw-xLIRC9MWTTO1R8K7',1677751240,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('_GOoFpRGF2hOlEipONnwiaeGdFPAUpS9',1677775834,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('_LdCsHVVHWeONEuOK5N_8AV39NBYTrL9',1677758277,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('a5lBdEzyA-kxd7chEXHKCuhTKeAGEv9z',1677751233,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('amvMkGVZ3Z6wHkNeCRuCNbZpsOqbtSS1',1677775991,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('cCVW0nMjQc1e9lUYwm-yxpcsuOtZfb1U',1677724350,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('cxEv6tFlNX5Gj_m9zn85OwDpOt1zEtSf',1677751239,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('d7SumGzXy9dRgLGcpPHYbuDwyPNoyaCj',1677725289,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('edoYOqOgp4OV6e-YAEko6CklahdZq0C2',1677738573,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('efKZh4iBg6_QXzT__IL7xHyyFsixQsJz',1677731266,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('en9rkhYXMPv7LeIuWkktsPtOxT2OWFQd',1677795828,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('g7OotGQVn3XKNhMMakrmtgvxu2e8s1Yq',1677785239,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('gtW1FdgI6PcxpjgSmouhBigkhRaJsAdc',1677734510,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('h692yq0Y2D8WSATmeoCMu08alreX02UG',1677784129,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('hmOD8s0DPFlMBwiP29ygCYmAB7CIJMeH',1677742093,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('hroAelY5BT9Oq7FurUX14m1GaRlcYeKm',1677751237,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('iBT5CeoPDNFI2FaWIoFSZIkphO-xANL3',1677807198,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('jFR9P2a43dHfJnmzI4EBg9g8o8u_L73N',1677792455,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('m33Yt-4kh-vjaQnDCm6J8RF0BecgKqKP',1677807022,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('m6YkRmS5A14L1MwgoVW7UHmnAaXxSSg6',1677779079,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('mvcPUv4xMiaYIMjZdnqbbPh0EuPjWfHn',1677758278,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('mzcpmzAtIiXR9XrEP17nEE5CHQ_J4vor',1677734511,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('oIcftdyYk3I01_6-70I9Dxz__AgbczTC',1677735881,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('oOaJjbmDJspaIHbQXlUb44-ApOYwuLBA',1677783312,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('oRvD8BTyej7q75l_hUkI45QNqvTy1Pue',1677763131,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('p9uZdplCd1XV6RJM7Brp2Pg3vmO0YvBS',1677783315,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('pJsNvmE-lZ8RaqNCbD-7KH24N_qSWfdj',1677751236,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('paWQooTNNrXg7ZmXwxvfK0C-MB0XH91w',1677779852,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('qh7XsXwoW3m_cFhFb8q-MT3lPpWxqdJ-',1677732699,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('r6FuTHq3Nt4om8Mz3erpwpwmUMkxNsvx',1677770891,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('rQfT5RAsM2sINMfBUzG9lYjHGjp7wggm',1677783306,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('rrSJ2hsRXWjLcxaedpzz9gUVnBgk3ZLP',1677734060,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('sg_OdiPirnFEBuScp_StardeZi9Py2KO',1677756417,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('sqFpItFWstF5hEFVLTHpVjP4OshrJrhx',1677751097,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('tB4buf5XLZKMgqOsyLZguUk7OtCh0O6O',1677741934,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('uAqiO_PJOXJwQDoUQAolwfA_yULWQfLt',1677787906,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('uMwkAE2cWc0EEWsYwAxzocBUGULfZ7Wl',1677730119,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('vLLzMjJbLu2ZduKogZAkqUyHvPBN_wlI',1677795828,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('vmnibQ9T7QJwKckKCzzcfb38tU1LVlKv',1677753802,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('woe4Qbuov3WlD3mMC-of4CIyX82WTPJ2',1677758040,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('x40RTH3nvIrfxX7DmxN9Ur3qy6lUfyDs',1677778096,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('xomzd7uNZRSUjrWwLW2MhB268grQL_0D',1677779078,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('yBnujOmVgnP3ScmxiGDORrzu1B_L4ToW',1677747775,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('yGR6ojOZ_41mHWlQ_JNfwncKLJXZQJz0',1677796196,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('ygBfNEVExlent3vungVjJdinaVlV-JPs',1677747774,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('zUGYQ15LeQz35xqyzsTbD0ml0cTVMTI1',1677734914,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('zcBScrD6btHHif_w3YlwOAwCuRDxjagh',1677803297,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),('zuGwHCgzY7_-DfJp3vJNOSA6mNRjEvmq',1677724101,'{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}');
/*!40000 ALTER TABLE `dc_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_teamPasswords`
--

DROP TABLE IF EXISTS `dc_teamPasswords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_teamPasswords` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `password` int(11) DEFAULT NULL,
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_teamPasswords`
--

LOCK TABLES `dc_teamPasswords` WRITE;
/*!40000 ALTER TABLE `dc_teamPasswords` DISABLE KEYS */;
INSERT INTO `dc_teamPasswords` VALUES (1,1),(2,2),(3,3),(4,4),(5,0),(6,0),(7,0),(8,0),(9,0),(10,0),(11,0),(12,0),(13,0),(14,0),(15,0);
/*!40000 ALTER TABLE `dc_teamPasswords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_timers`
--

DROP TABLE IF EXISTS `dc_timers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_timers` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `startTime` int(11) DEFAULT '0',
  `state` int(2) DEFAULT '0',
  `restTime` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_timers`
--

LOCK TABLES `dc_timers` WRITE;
/*!40000 ALTER TABLE `dc_timers` DISABLE KEYS */;
INSERT INTO `dc_timers` VALUES (1,0,0,-27290),(2,0,0,-27293),(3,0,0,-27295),(4,0,0,-27296),(5,48430,1,0),(6,48430,1,0),(7,48430,1,0),(8,48430,1,0),(9,48430,1,0),(10,48430,1,0),(11,48430,1,0),(12,48430,1,0),(13,48430,1,0),(14,48430,1,0),(15,48430,1,0);
/*!40000 ALTER TABLE `dc_timers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dc_uploads`
--

DROP TABLE IF EXISTS `dc_uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dc_uploads` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `files` text,
  `temp` text,
  `uploadTime` int(11) DEFAULT '0',
  `stackFiles` mediumtext,
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dc_uploads`
--

LOCK TABLES `dc_uploads` WRITE;
/*!40000 ALTER TABLE `dc_uploads` DISABLE KEYS */;
INSERT INTO `dc_uploads` VALUES (1,NULL,NULL,0,NULL),(2,NULL,NULL,0,NULL),(3,NULL,NULL,0,NULL),(4,NULL,NULL,0,NULL),(5,NULL,NULL,0,NULL),(6,NULL,NULL,0,NULL),(7,NULL,NULL,0,NULL),(8,NULL,NULL,0,NULL),(9,NULL,NULL,0,NULL),(10,NULL,NULL,0,NULL),(11,NULL,NULL,0,NULL),(12,NULL,NULL,0,NULL),(13,NULL,NULL,0,NULL),(14,NULL,NULL,0,NULL),(15,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `dc_uploads` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-21  4:47:46
