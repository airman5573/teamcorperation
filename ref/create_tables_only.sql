-- -------------------------------------------------------------
-- CREATE TABLES ONLY for teamcorperation_main
-- Run this first to create all table structures
-- -------------------------------------------------------------

-- Set session variables
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- Use the target database
USE `teamcorperation_main`;

-- Table: dc_metas
CREATE TABLE IF NOT EXISTS `dc_metas` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `metaKey` tinytext,
  `metaValue` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;

-- Table: dc_points
CREATE TABLE IF NOT EXISTS `dc_points` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `useable` int(11) DEFAULT '0',
  `timer` int(11) DEFAULT '0',
  `eniac` int(11) DEFAULT '0',
  `puzzle` int(11) DEFAULT '0',
  `temp` int(11) DEFAULT '0',
  `bingo` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Table: dc_postInfos
CREATE TABLE IF NOT EXISTS `dc_postInfos` (
  `post` int(11) unsigned NOT NULL,
  `mission` tinytext,
  `url` text,
  PRIMARY KEY (`post`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: dc_puzzles
CREATE TABLE IF NOT EXISTS `dc_puzzles` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `boxNumbers` text,
  `emptyBoxOpenCount` int(11) DEFAULT '0',
  `wordBoxOpenCount` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Table: dc_sessions
CREATE TABLE IF NOT EXISTS `dc_sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: dc_teamPasswords
CREATE TABLE IF NOT EXISTS `dc_teamPasswords` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `password` int(11) DEFAULT NULL,
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Table: dc_timers
CREATE TABLE IF NOT EXISTS `dc_timers` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `startTime` int(11) DEFAULT '0',
  `state` int(2) DEFAULT '0',
  `restTime` int(11) DEFAULT '0',
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Table: dc_uploads
CREATE TABLE IF NOT EXISTS `dc_uploads` (
  `team` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `files` text,
  `temp` text,
  `uploadTime` int(11) DEFAULT '0',
  `stackFiles` mediumtext,
  PRIMARY KEY (`team`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;

-- Table: dc_warehouse (from warehouse database)
CREATE TABLE IF NOT EXISTS `dc_warehouse` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mission` tinytext,
  `url` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4;

-- Restore session variables
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;