-- -------------------------------------------------------------
-- TablePlus 6.4.8(608)
--
-- https://tableplus.com/
--
-- Database: yoon_teamcorperation_discovery_1
-- Generation Time: 2025-06-14 23:04:33.4610
-- -------------------------------------------------------------


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


INSERT INTO `dc_metas` (`id`, `metaKey`, `metaValue`) VALUES
(3, 'mappingPoints', '{\"timerPlus\":100,\"timerMinus\":100,\"upload\":2000,\"boxOpenGetEmpty\":2000,\"boxOpenGetWord\":4000,\"boxOpenUse\":1000,\"eniac\":20000,\"bingo\":1000}'),
(7, 'companyImage', 'companyImage-100.jpg'),
(8, 'map', 'map-17.jpg'),
(9, 'laptime', '480'),
(10, 'puzzleBoxCount', '48'),
(11, 'originalEniacWords', '여행의 또다른 즐거움 SK렌터카가 고객과 함께합니다'),
(12, 'randomEniacWords', '[0,0,\"또\",0,\"거\",\"K\",\"다\",\"께\",\"행\",0,0,0,\"터\",0,\"다\",0,0,0,0,\"과\",\"고\",0,\"즐\",0,\"렌\",0,\"여\",\"움\",\"가\",0,0,\"카\",0,\"의\",\"객\",0,\"함\",\"합\",0,0,0,0,0,\"S\",\"니\",0,\"른\"]'),
(13, 'lastBoxUrl', NULL),
(14, 'lastBoxState', '0'),
(15, 'adminPasswords', '{\"admin\":\"1234\",\"assist\":\"4321\"}'),
(16, 'eniacSuccessTeams', NULL),
(17, 'eniacState', '1'),
(18, 'tempBoxState', '1'),
(19, 'showPointNav', '0'),
(20, 'showPuzzleNav', '0');

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
(15, 0, 0, 0, 0, 0, 0);

INSERT INTO `dc_postInfos` (`post`, `mission`, `url`) VALUES
(1, '손가락프레임', 'https://drive.google.com/file/d/1uchDwHx7Tsxp4k5Z5Fte82h88tDBEsDD/view?usp=sharing'),
(2, '타임라인', 'https://drive.google.com/file/d/19j-AvFoP8fxTiIUCr9qsR_oHmL1NNNP3/view?usp=sharing'),
(3, '수식퍼즐', 'https://drive.google.com/open?id=12Ny3iKawhuBiIk1fgOKMnEjQcxIicjE7'),
(4, '팀크레인', 'https://drive.google.com/open?id=1s5i7dH-GIJxO4BBfcg6Wkl-1yTCkVGND'),
(5, '훈민정음', 'https://drive.google.com/file/d/1SQfEzKgwW_QnndB56qj5c9WCdEdFH-b3/view?usp=sharing');

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
(15, NULL, 0, 0);

INSERT INTO `dc_sessions` (`session_id`, `expires`, `data`) VALUES
('-EWEiWyt83eCZ9NSS8Y3BHRjbLzWo-Hj', 1749942207, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('1SC3FLPkQa5sGVbeZLxK8wA3NSfPBNH7', 1749942209, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('5FaI4-j_7COi5OKy9d0F4HmvBkIxTuow', 1749960553, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('6qgGzxO-01fHpNbU4l5QFYsluXmer-tj', 1749950116, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('82rwMRCRz1VCO3rH9tRgwrs0BgCKVnKE', 1749942212, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('8hEBVT7aPuS-oYtjFPZIYN8QOWkS92yq', 1749942206, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('b5TPJtjcilNFQZNOsmq60u1gdKvoyNPQ', 1749942210, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('bhrOGLcYe38TO34-wjEeDrXOjWF1ZwRw', 1749942207, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('G3bzYZeaejrSo1g7ctazGxwJC6T8L5oN', 1749942211, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('goiFj-urPGUHHPo2Q_yzmHZsK84RdV5X', 1749942210, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('grl92-aTGnwq6v-QDRIr7WZWq4m_ONdX', 1749942211, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('gw7u-vHnzYZURz0-iAwU5Oy0CESjICn-', 1749942209, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('HHhQrjvlueHy084aLXEDv1SoYp4HDcRm', 1749942208, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('HnuwlPBrjsECyuRgEAsUMZg-h7ZApL33', 1749950116, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('jBVYNfAHf8uDeSjJ3ccVHBiwmhJrZDxT', 1749951012, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('lDWDQ0CEibGzi8Oy9RVk9GUQayV8AKHU', 1749942210, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('LP4VuePPrXiE0f-FHbGhY_DA68g5soW_', 1749942211, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('mhM02yTHaqEGy7ntGbMvkDr5ARdEKSlJ', 1749942213, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('MzZu_MbmFbUVvDva58S-Fqpg1dXucaj1', 1749942212, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('nem9UrX_GdLxejPDWq768idzPTA2p0Hp', 1749942211, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('oM-6GDmbNJkr0Jw_CCR46tgekJxG0tFp', 1749942208, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('QDd7tUfZR1kka6yCd4Gbw-hYmFROEBFS', 1749942212, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('qy773ipIgchgw2AQASVVzhqUb5DPwcNQ', 1749942209, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('r3BBz28kiniwmrzrfZlp7G1Tnoct7vIz', 1749942208, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('rOmbvedRTqWnIgThsURwjxXKjjNTxGbK', 1749942209, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('S81KqYKwfVMtD9qiAwUABupgYrd7KdZh', 1749956437, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('UJLGumz4hunO3ozsmlFbHmJBr5vdma3g', 1749982089, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('viapBV1HbWbH_IP3YZU43hxdgK_MjXy4', 1749942207, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('VQJnuLBazL2l9mbyesR4y5MK3Ah8Zpyi', 1749942186, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('vvbPaa8T7B0FSogJAta7I0MeClWL5XHx', 1749942207, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('w-q59s06zVlFxxxSznPwwte-BoZkBty1', 1749942210, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('xvYVmxDVmZenJTOSfOB-2RDjLGGs76v0', 1749934990, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('yByHzAQAi33tXFM0VprG0enjJQBWO_O-', 1749942212, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}'),
('ZsOroJ5M3igHVBDKdsph4_zbQDKHLk4d', 1749942208, '{\"cookie\":{\"originalMaxAge\":null,\"expires\":null,\"httpOnly\":true,\"path\":\"/\"}}');

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
(15, 0);

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
(15, 0, 0, 0);

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
(15, NULL, NULL, 0, NULL);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


