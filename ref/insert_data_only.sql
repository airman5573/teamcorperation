-- -------------------------------------------------------------
-- INSERT DATA ONLY for teamcorperation_main
-- Run this AFTER creating tables with create_tables_only.sql
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

-- Data for dc_metas
INSERT INTO `dc_metas` (`id`, `metaKey`, `metaValue`) VALUES
(3, 'mappingPoints', '{"timerPlus":100,"timerMinus":100,"upload":2000,"boxOpenGetEmpty":2000,"boxOpenGetWord":4000,"boxOpenUse":1000,"eniac":20000,"bingo":1000}'),
(7, 'companyImage', 'companyImage-100.jpg'),
(8, 'map', 'map-17.jpg'),
(9, 'laptime', '480'),
(10, 'puzzleBoxCount', '48'),
(11, 'originalEniacWords', '여행의 또다른 즐거움 SK렌터카가 고객과 함께합니다'),
(12, 'randomEniacWords', '[0,0,"또",0,"거","K","다","께","행",0,0,0,"터",0,"다",0,0,0,0,"과","고",0,"즐",0,"렌",0,"여","움","가",0,0,"카",0,"의","객",0,"함","합",0,0,0,0,0,"S","니",0,"른"]'),
(13, 'lastBoxUrl', NULL),
(14, 'lastBoxState', '0'),
(15, 'adminPasswords', '{"admin":"1234","assist":"4321"}'),
(16, 'eniacSuccessTeams', NULL),
(17, 'eniacState', '1'),
(18, 'tempBoxState', '1'),
(19, 'showPointNav', '0'),
(20, 'showPuzzleNav', '0')
ON DUPLICATE KEY UPDATE `metaValue` = VALUES(`metaValue`);

-- Data for dc_points
INSERT INTO `dc_points` (`team`, `useable`, `timer`, `eniac`, `puzzle`, `temp`, `bingo`) VALUES
(1, 1800, 0, 0, 0, 0, 0),
(2, 1200, 0, 0, 0, 0, 0),
(3, 2100, 0, 0, 0, 0, 0),
(4, 1830, 0, 0, 0, 0, 0),
(5, 0, 0, 0, 0, 0, 0),
(6, 0, 0, 0, 0, 0, 0),
(7, 0, 0, 0, 0, 0, 0),
(8, 0, 0, 0, 0, 0, 0),
(9, 0, 0, 0, 0, 0, 0),
(10, 0, 0, 0, 0, 0, 0),
(11, 0, 0, 0, 0, 0, 0),
(12, 0, 0, 0, 0, 0, 0),
(13, 0, 0, 0, 0, 0, 0),
(14, 0, 0, 0, 0, 0, 0),
(15, 0, 0, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE 
  `useable` = VALUES(`useable`),
  `timer` = VALUES(`timer`),
  `eniac` = VALUES(`eniac`),
  `puzzle` = VALUES(`puzzle`),
  `temp` = VALUES(`temp`),
  `bingo` = VALUES(`bingo`);

-- Data for dc_postInfos
INSERT INTO `dc_postInfos` (`post`, `mission`, `url`) VALUES
(1, '손가락프레임', 'https://drive.google.com/file/d/1uchDwHx7Tsxp4k5Z5Fte82h88tDBEsDD/view?usp=sharing'),
(2, '타임라인', 'https://drive.google.com/file/d/19j-AvFoP8fxTiIUCr9qsR_oHmL1NNNP3/view?usp=sharing'),
(3, '수식퍼즐', 'https://drive.google.com/open?id=12Ny3iKawhuBiIk1fgOKMnEjQcxIicjE7'),
(4, '팀크레인', 'https://drive.google.com/open?id=1s5i7dH-GIJxO4BBfcg6Wkl-1yTCkVGND'),
(5, '훈민정음', 'https://drive.google.com/file/d/1SQfEzKgwW_QnndB56qj5c9WCdEdFH-b3/view?usp=sharing')
ON DUPLICATE KEY UPDATE 
  `mission` = VALUES(`mission`),
  `url` = VALUES(`url`);

-- Data for dc_puzzles
INSERT INTO `dc_puzzles` (`team`, `boxNumbers`, `emptyBoxOpenCount`, `wordBoxOpenCount`) VALUES
(1, NULL, 0, 0),
(2, NULL, 0, 0),
(3, NULL, 0, 0),
(4, NULL, 0, 0),
(5, NULL, 0, 0),
(6, NULL, 0, 0),
(7, NULL, 0, 0),
(8, NULL, 0, 0),
(9, NULL, 0, 0),
(10, NULL, 0, 0),
(11, NULL, 0, 0),
(12, NULL, 0, 0),
(13, NULL, 0, 0),
(14, NULL, 0, 0),
(15, NULL, 0, 0)
ON DUPLICATE KEY UPDATE 
  `boxNumbers` = VALUES(`boxNumbers`),
  `emptyBoxOpenCount` = VALUES(`emptyBoxOpenCount`),
  `wordBoxOpenCount` = VALUES(`wordBoxOpenCount`);

-- Data for dc_teamPasswords
INSERT INTO `dc_teamPasswords` (`team`, `password`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 0),
(6, 0),
(7, 0),
(8, 0),
(9, 0),
(10, 0),
(11, 0),
(12, 0),
(13, 0),
(14, 0),
(15, 0)
ON DUPLICATE KEY UPDATE `password` = VALUES(`password`);

-- Data for dc_timers
INSERT INTO `dc_timers` (`team`, `startTime`, `state`, `restTime`) VALUES
(1, 0, 0, 0),
(2, 0, 0, 0),
(3, 0, 0, 0),
(4, 0, 0, 0),
(5, 0, 0, 0),
(6, 0, 0, 0),
(7, 0, 0, 0),
(8, 0, 0, 0),
(9, 0, 0, 0),
(10, 0, 0, 0),
(11, 0, 0, 0),
(12, 0, 0, 0),
(13, 0, 0, 0),
(14, 0, 0, 0),
(15, 0, 0, 0)
ON DUPLICATE KEY UPDATE 
  `startTime` = VALUES(`startTime`),
  `state` = VALUES(`state`),
  `restTime` = VALUES(`restTime`);

-- Data for dc_uploads
INSERT INTO `dc_uploads` (`team`, `files`, `temp`, `uploadTime`, `stackFiles`) VALUES
(1, NULL, NULL, 0, NULL),
(2, NULL, NULL, 0, NULL),
(3, NULL, NULL, 0, NULL),
(4, NULL, NULL, 0, NULL),
(5, NULL, NULL, 0, NULL),
(6, NULL, NULL, 0, NULL),
(7, NULL, NULL, 0, NULL),
(8, NULL, NULL, 0, NULL),
(9, NULL, NULL, 0, NULL),
(10, NULL, NULL, 0, NULL),
(11, NULL, NULL, 0, NULL),
(12, NULL, NULL, 0, NULL),
(13, NULL, NULL, 0, NULL),
(14, NULL, NULL, 0, NULL),
(15, NULL, NULL, 0, NULL)
ON DUPLICATE KEY UPDATE 
  `files` = VALUES(`files`),
  `temp` = VALUES(`temp`),
  `uploadTime` = VALUES(`uploadTime`),
  `stackFiles` = VALUES(`stackFiles`);

-- Data for dc_warehouse (de-duplicated)
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
(100, '본부미션(2P선-연결문제))', 'https://drive.google.com/file/d/1aPmrZ5LdS-KRXGXYYbpveyGaGPjBwjLS/view?usp=sharing')
ON DUPLICATE KEY UPDATE 
  `mission` = VALUES(`mission`),
  `url` = VALUES(`url`);

-- Insert records with NULL IDs (will auto-increment)
INSERT INTO `dc_warehouse` (`mission`, `url`) VALUES
('본부미션(손가락프레임)', 'https://drive.google.com/file/d/1uchDwHx7Tsxp4k5Z5Fte82h88tDBEsDD/view?usp=sharing'),
('타임라인(내,외겸용)', 'https://drive.google.com/file/d/19j-AvFoP8fxTiIUCr9qsR_oHmL1NNNP3/view?usp=sharing');

-- Restore session variables
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;