-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 29, 2026 at 07:40 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `printing_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `service_type` varchar(50) NOT NULL,
  `document_type` varchar(50) NOT NULL,
  `page_count` int(11) NOT NULL,
  `color_type` varchar(20) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `order_status` varchar(20) DEFAULT 'Pending',
  `order_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `phone_number` varchar(20) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `payment_status` varchar(20) DEFAULT 'Unpaid'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `customer_name`, `service_type`, `document_type`, `page_count`, `color_type`, `total_price`, `order_status`, `order_date`, `phone_number`, `status`, `payment_status`) VALUES
(23, 'Alden', 'Xerox', 'ID', 3, 'Black & White', 6.00, 'Done', '2026-04-20 02:09:55', '', 'Pending', 'Unpaid'),
(31, 'Rose', 'Xerox', 'Receipt', 1, 'Black & White', 2.00, 'Printing', '2026-04-26 04:47:10', NULL, 'Pending', 'Unpaid'),
(33, 'Joseph', 'Scan', 'DFA', 4, 'Colored', 20.00, 'Done', '2026-04-29 03:04:05', NULL, 'Pending', 'Unpaid'),
(35, 'Gloria', 'Xerox', 'Senior ID', 3, 'Black & White', 6.00, 'Printing', '2026-04-29 04:12:04', NULL, 'Pending', 'Unpaid'),
(36, 'Beth', 'Print Text', 'Reflection', 7, 'Black & White', 21.00, 'Pending', '2026-04-29 04:26:31', NULL, 'Pending', 'Unpaid');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'rjotojot19', 'Rjotojot704');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
