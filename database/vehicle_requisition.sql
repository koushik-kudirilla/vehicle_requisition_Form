-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               8.0.42 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for vehicle_requisition
CREATE DATABASE IF NOT EXISTS `vehicle_requisition` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `vehicle_requisition`;

-- Dumping structure for table vehicle_requisition.employee
CREATE TABLE IF NOT EXISTS `employee` (
  `StaffNo` varchar(20) NOT NULL,
  `NameOfEmployee` varchar(100) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `Designation_Grade` varchar(100) DEFAULT NULL,
  `Department` varchar(100) DEFAULT NULL,
  `ManagerStaffNo` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`StaffNo`),
  KEY `fk_parent_staff` (`ManagerStaffNo`),
  CONSTRAINT `fk_parent_staff` FOREIGN KEY (`ManagerStaffNo`) REFERENCES `employee` (`StaffNo`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table vehicle_requisition.employee: ~6 rows (approximately)
INSERT INTO `employee` (`StaffNo`, `NameOfEmployee`, `password`, `Designation_Grade`, `Department`, `ManagerStaffNo`) VALUES
	('S001', 'Koushik', '1234', 'user', 'R&D', 'S003'),
	('S002', 'chanikya', '1234', 'user', 'DTG', 'S003'),
	('S003', 'pavan', '1234', 'admin', 'R&D', 'S004'),
	('S004', 'Ramesh Kumar', '1234', 'Senior Admin', 'R&D', NULL),
	('S005', 'santhosh', '1234', 'user', 'DTG', 'S003'),
	('S006', 'kumar', '1234', 'user', 'DTG', 'S003');

-- Dumping structure for table vehicle_requisition.vehicle_entry_requests
CREATE TABLE IF NOT EXISTS `vehicle_entry_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_name` varchar(100) NOT NULL,
  `staff_no` varchar(50) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `vehicle_no` varchar(50) NOT NULL,
  `vehicle_type` enum('2-Wheeler','4-Wheeler') NOT NULL,
  `validity_from` date NOT NULL,
  `validity_to` date NOT NULL,
  `justification` text NOT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'Pending',
  `admin_approved_by` varchar(20) DEFAULT NULL,
  `admin_approved_at` datetime DEFAULT NULL,
  `senior_admin_approved_by` varchar(20) DEFAULT NULL,
  `senior_admin_approved_at` datetime DEFAULT NULL,
  `rejection_reason` text,
  `editstatus` varchar(20) DEFAULT 'None',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_staff_no` (`staff_no`),
  CONSTRAINT `fk_staff_no` FOREIGN KEY (`staff_no`) REFERENCES `employee` (`StaffNo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table vehicle_requisition.vehicle_entry_requests: ~3 rows (approximately)
INSERT INTO `vehicle_entry_requests` (`id`, `employee_name`, `staff_no`, `designation`, `department`, `vehicle_no`, `vehicle_type`, `validity_from`, `validity_to`, `justification`, `submitted_at`, `status`, `admin_approved_by`, `admin_approved_at`, `senior_admin_approved_by`, `senior_admin_approved_at`, `rejection_reason`, `editstatus`) VALUES
	(1, 'chanikya', 'S002', 'user', 'DTG', 'ap311432', '2-Wheeler', '2025-05-07', '2026-05-07', 'purpose', '2025-05-07 04:17:02', 'Final Approved', 'S003', '2025-05-07 09:49:02', 'S004', '2025-05-07 09:49:30', NULL, 'None'),
	(2, 'Koushik', 'S001', 'user', 'R&D', 'ap311432', '2-Wheeler', '2025-05-07', '2026-05-07', 'ddd', '2025-05-07 05:03:13', 'Final Approved', 'S003', '2025-05-07 10:33:44', 'S004', '2025-05-07 10:34:34', NULL, 'None'),
	(19, 'santhosh', 'S005', 'user', 'DTG', 'ap311432', '2-Wheeler', '2025-05-09', '2025-05-10', 'cxzcxz', '2025-05-09 06:05:40', 'Admin Approved', 'S003', '2025-05-09 11:36:13', NULL, NULL, NULL, 'Approved');

-- Dumping structure for table vehicle_requisition.vehicle_log_sheet
CREATE TABLE IF NOT EXISTS `vehicle_log_sheet` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(20) NOT NULL,
  `driver_name` varchar(100) NOT NULL,
  `log_date` timestamp NULL DEFAULT (now()),
  `entry_no` int NOT NULL,
  `start_time` time DEFAULT NULL,
  `close_time` time DEFAULT NULL,
  `places_visited` varchar(255) DEFAULT NULL,
  `meter_start` int DEFAULT NULL,
  `meter_close` int DEFAULT NULL,
  `km` int DEFAULT NULL,
  `purpose` text,
  `fuel` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_trip` (`vehicle_no`,`log_date`,`entry_no`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table vehicle_requisition.vehicle_log_sheet: ~6 rows (approximately)
INSERT INTO `vehicle_log_sheet` (`id`, `vehicle_no`, `driver_name`, `log_date`, `entry_no`, `start_time`, `close_time`, `places_visited`, `meter_start`, `meter_close`, `km`, `purpose`, `fuel`) VALUES
	(1, 'ap311432', 'Koushik', '2025-05-11 18:30:00', 1, '09:14:00', '12:15:00', 'gajuwaka', 10, 11, 3, 'emergency work', 'petrol'),
	(2, 'ap311432', 'Koushik', '2025-05-11 18:30:00', 2, '09:21:00', '10:21:00', 'DFD', 3, 4, 2, 'cxc', 'nv'),
	(3, 'ap311432', 'Koushik', '2025-05-11 18:30:00', 3, '09:21:00', '11:21:00', 'DFD', 2, 3, 2, 'xcx', 'zx'),
	(4, 'ap311432', 'chanikya', '2025-06-09 18:30:00', 1, '15:22:00', '15:22:00', 'scc', 3, 4, 1, 'hjnj', 'jhj'),
	(5, 'ap311432', 'chanikya', '2025-06-13 18:30:00', 1, '21:16:00', '21:17:00', 'DFD', 1, 4, 3, 'zcxcxcx', '5.0'),
	(6, 'ap311432', 'chanikya', '2025-06-13 18:30:00', 2, '21:20:00', '21:20:00', 'DFD', 1, 4, 3, 'dd', '5');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
