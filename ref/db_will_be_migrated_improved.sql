-- -------------------------------------------------------------
-- Improved Migration Script for teamcorperation_main Database
-- Database: teamcorperation_main
-- User: teamcorperation_db_user
-- Password: Thoumas138!
-- Generation Time: 2025-06-14
-- -------------------------------------------------------------

-- Set session variables for a clean import
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Use the target database
USE `teamcorperation_main`;

-- 1. Create dc_warehouse table if it doesn't exist
CREATE TABLE IF NOT EXISTS `dc_warehouse` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `mission` VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url` VARCHAR(512) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Disable checks for faster, safer import
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 2. Clear existing data to avoid duplicates (optional - remove if you want to keep existing data)
-- TRUNCATE TABLE `dc_warehouse`;

-- 3. Insert warehouse data (de-duplicated)
INSERT INTO `dc_warehouse` (`id`, `mission`, `url`) VALUES
(57, '스텍스 4커플릴레이', 'https://drive.google.com/open?id=1KcyAwLpMHtsRYgNLQPq25bUD2bJzTiGF'),
(58, '스텍스 개인릴레이', 'https://drive.google.com/open?id=1U5UpZBRq29Akn3CZxWw0a8ngQh3RX9QB'),
(59, '파이프댄스 3단계릴레이', 'https://drive.google.com/open?id=19GtHuh4SBw-19FHmuLUAkFEBa0ra2JKb'),
(60, '파이프댄스  2커플릴레이', 'https://drive.google.com/open?id=1RJjnkxJ0cTeAO3b-9UNFnX3hsRunCxfJ'),
(62, '수식퍼즐-블럭', 'https://drive.google.com/open?id=12Ny3iKawhuBiIk1fgOKMnEjQcxIicjE7'),
(63, '래더볼', 'https://drive.google.com/open?id=1oRsAHuwcZ2GMnRPcD4v4fOiX0KbXyJfg'),
(66, '행시', 'https://drive.google.com/open?id=1Im8FVcSwglTVJyRbu8y16zTCESncNX4I'),
(67, '착시영상', 'https://drive.google.com/open?id=1YnM8saNcoN1NwdLm8zw3ZRAlIqv2gANN'),
(72, '반지의제왕(야외)', 'https://drive.google.com/open?id=1PCdgEtLn-I9p7WSkkJdPoW8oyAZB9FZr'),
(73, '팀크레인', 'https://drive.google.com/open?id=1s5i7dH-GIJxO4BBfcg6Wkl-1yTCkVGND'),
(77, '볼바운딩', 'https://drive.google.com/open?id=1IstSmvao24uosOtJxH1q6KQpT7qmXYNZ'),
(78, '윈 도미노', 'https://drive.google.com/open?id=1fCZxTywtm5iHGbUOoJIPX8qZgA4qaWSO'),
(79, '팀웍웨이브', 'https://drive.google.com/open?id=1VD5rE7M1-a7bU-vwlnnuAGNDfPZP3prX'),
(80, '볼릴레이', 'https://drive.google.com/open?id=1ThATsfOEOLHXuObjgmwKWDoAthTFERG9'),
(82, '4인제기차기', 'https://drive.google.com/file/d/1mkMW3vFz9E_4AOyyjKGVA1eO0RFFtlRb/view?usp=sharing'),
(88, '반지의제왕(실내)', 'https://drive.google.com/file/d/1NZtMtv4TcDg2poY_zMiOoLYwclK61u3r/view?usp=share_link'),
(93, '훈민정음', 'https://drive.google.com/file/d/1SQfEzKgwW_QnndB56qj5c9WCdEdFH-b3/view?usp=sharing'),
(95, '수식퍼즐(실내)', 'https://drive.google.com/file/d/1cQCWKLYUaTdJvSXcgD0TkEd48jTHUIhm/view?usp=sharing'),
(97, '훈민정음(실내)', 'https://drive.google.com/file/d/1SYeXfm0_FjiYKaY2X-XlpYuCHo98jPlH/view?usp=sharing'),
(98, '팀크레인(실내)', 'https://drive.google.com/file/d/1QZzv2sHphn_8r2kHxY5gdf6DHx8YMgoh/view?usp=sharing'),
(99, '윈도미노(실내)', 'https://drive.google.com/file/d/1Fy0_HZ90zfvzfjtJsZZ2OGHP9Ec0xW2H/view?usp=sharing'),
(100, '본부미션(2P선-연결문제))', 'https://drive.google.com/file/d/1aPmrZ5LdS-KRXGXYYbpveyGaGPjBwjLS/view?usp=sharing'),
(NULL, '본부미션(손가락프레임)', 'https://drive.google.com/file/d/1uchDwHx7Tsxp4k5Z5Fte82h88tDBEsDD/view?usp=sharing'),
(NULL, '타임라인(내,외겸용)', 'https://drive.google.com/file/d/19j-AvFoP8fxTiIUCr9qsR_oHmL1NNNP3/view?usp=sharing')
ON DUPLICATE KEY UPDATE
  `mission` = VALUES(`mission`),
  `url` = VALUES(`url`);

-- 4. Update auto_increment value to continue from the highest ID
ALTER TABLE `dc_warehouse` AUTO_INCREMENT = 101;

-- Restore original session settings
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- 5. Additional notes for complete migration
-- You'll need to create other tables from the main database. 
-- Use this command to export all table structures from the source database:
-- mysqldump -u [old_user] -p --no-data yoon_teamcorperation_discovery_1 > schema_only.sql
-- Then import that schema into teamcorperation_main before running this data migration.