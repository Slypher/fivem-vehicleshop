/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE DATABASE IF NOT EXISTS `es_extended` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `es_extended`;

CREATE TABLE IF NOT EXISTS `vehicle_shop` (
  `label` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `stock` tinyint(4) NOT NULL,
  `price` float NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40000 ALTER TABLE `vehicle_shop` DISABLE KEYS */;
INSERT INTO `vehicle_shop` (`label`, `name`, `stock`, `price`) VALUES
	('Alpha', 'alpha', 4, 80000),
	('Carbonizzare', 'carbonizzare', 4, 300000),
	('Dominator 7', 'dominator7', 2, 150000),
	('Elegy', 'elegy', 0, 100000),
	('Fugitive', 'fugitive', 3, 30000),
	('Tailgater 2', 'tailgater2', 2, 250000);
/*!40000 ALTER TABLE `vehicle_shop` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
