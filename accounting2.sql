-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 06-02-2024 a las 20:05:54
-- Versión del servidor: 10.4.25-MariaDB
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `accounting2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `beteshda`
--

CREATE TABLE `beteshda` (
  `id` int(11) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `beteshda`
--

INSERT INTO `beteshda` (`id`, `title`, `description`, `amount`, `data`, `userId`) VALUES
(0, 'Starting Amount', '', 2334, '2024-01-31', 1),
(2, 'VMachines', 'Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €', 513.21, '2024-02-06', 1),
(3, 'VMachines', 'Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €', -513.21, '2024-02-06', 1),
(4, 'VMachines', 'Proxmox VMachines. CPU: 281.36 €, Disk: 231.85 €', -513.21, '2024-02-06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `groups`
--

CREATE TABLE `groups` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `vlan` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `groups`
--

INSERT INTO `groups` (`id`, `name`, `admin_id`, `vlan`) VALUES
(0, 'general', 1, ''),
(1, 'nokia', 1, '23'),
(23, 'beteshda', 1, '22'),
(24, 'servitek', 1, '24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nokia`
--

CREATE TABLE `nokia` (
  `id` int(11) NOT NULL,
  `title` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` double NOT NULL,
  `data` date NOT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `nokia`
--

INSERT INTO `nokia` (`id`, `title`, `description`, `amount`, `data`, `userId`) VALUES
(0, 'prova', 'asd', 4000, '2023-11-14', 1),
(1, 'LibreNMS', 'Instalació LibreNMS', 300, '2023-12-22', 1),
(2, 'Splunk', 'Instalació Splunk', 200, '2023-12-22', 1),
(10, 'prova', 'prova', 200, '2023-11-26', 1),
(11, 'prova', 'adsf', 200, '2023-11-26', 1),
(12, 'Prova actualització', 'prova', 100, '2023-11-27', 1),
(13, 'transacio 28', 'Transaction', 400, '2023-11-28', 1),
(14, 'Divendres', 'Divendres', 50, '2023-11-30', 1),
(15, 'December 5', 'December', 250, '2023-12-05', 1),
(16, 'December 11', 'December 11', 380, '2023-12-11', 1),
(17, 'Prova', 'Prova', 200, '2023-11-13', 1),
(18, 'prova', 'adsa', 200, '2023-11-13', 1),
(19, 'prova', 'dasf', 50, '2023-11-14', 1),
(20, 'prova', 'da', -100, '2023-12-27', 1),
(21, 'add', 'dfa', 200, '2023-12-27', 1),
(22, 'add', 'fd', 300, '2023-12-27', 1),
(23, 'Reis', 'Reis', 50, '2024-01-05', 1),
(24, 'prova', 'prova', 40, '2024-01-05', 1),
(25, 'prova', 'prova', 100, '2023-12-19', 1),
(26, 'prova', 'ads', -100, '2023-12-19', 1),
(27, 'Tablet', 'Tablet', 200, '2024-01-05', 1),
(28, 'a', 'adsf', -500, '2023-12-26', 1),
(29, 'asdfasfd', 'asdf', 23, '2024-01-06', 1),
(30, 'asdfasfd', 'asdf', 23, '2024-01-06', 1),
(31, 'prova', 'uob', 500, '2024-01-08', 1),
(32, 'LibreNMS', 'asdf', 500, '2024-01-09', 1),
(34, 'sdaf', 'dsaf', -2000, '2023-12-12', 1),
(35, 'prova user', 'prova', 500, '2024-01-16', 2),
(36, 'prova', 'fas', 500, '2024-01-19', 1),
(37, 'loading', 'loading test', -100, '2024-01-21', 1),
(38, 'loading', 'loading ok', -100, '2024-01-21', 1),
(39, 'prova', 'prova', 50, '2024-01-21', 1),
(40, 'prova', 'prova', 500, '2024-01-22', 7),
(41, 'prova', 'asdf', 100, '2024-03-13', 1),
(42, 'prova', 'prova', 500, '2024-01-30', 1),
(43, 'a', 'd', 10, '2024-01-30', 1),
(44, 'a', 'd', 500, '2024-01-30', 1),
(45, 'ad', 'd', -500, '2024-01-30', 1),
(46, 'df', 'd', -500, '2024-01-30', 1),
(47, 'adsfasf', 'dsaf', -500, '2024-01-30', 1),
(48, 'asdf', 'asdf', 32, '2024-01-30', 1),
(49, 'psdf', 'asdf', 12, '2024-01-30', 1),
(50, 'dfg', 'dfg', 22, '2024-01-30', 1),
(51, 'fd', 'asdf', 14, '2024-01-30', 1),
(52, 'jk', 'u', 55, '2024-01-30', 1),
(53, 'sdf', 'd', -10, '2024-01-30', 1),
(54, 'df', 'df', 5, '2024-01-30', 1),
(55, 'd', 'sd', 11, '2024-01-30', 1),
(56, 'sadf', 'asdfasdf', 234, '2023-10-17', 1),
(57, 'asdf', 'jk', 10, '2024-01-30', 1),
(58, 'VMachines', 'Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €', 234.67, '2024-02-06', 1),
(59, 'VMachines', 'Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €', -234.67, '2024-02-06', 1),
(60, 'VMachines', 'Proxmox VMachines. CPU: 29.82 €, Disk: 204.85 €', -234.67, '2024-02-06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `price`
--

CREATE TABLE `price` (
  `name` varchar(50) NOT NULL,
  `value` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `price`
--

INSERT INTO `price` (`name`, `value`) VALUES
('cpu', 2.2),
('disk', 0.56);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rights`
--

CREATE TABLE `rights` (
  `id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `rights`
--

INSERT INTO `rights` (`id`, `name`, `description`) VALUES
(1, 'Admin', 'Rights to manage the group, add/quit users, delete the group...'),
(2, 'Teacher', 'Rights to manage some global configurations');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servitek`
--

CREATE TABLE `servitek` (
  `id` int(11) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `data` date DEFAULT NULL,
  `userId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `servitek`
--

INSERT INTO `servitek` (`id`, `title`, `description`, `amount`, `data`, `userId`) VALUES
(0, 'Starting Amount', '', 1000, '2024-02-05', 1),
(2, 'VMachines', 'Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €', 425.71999999999997, '2024-02-06', 1),
(3, 'VMachines', 'Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €', -425.71999999999997, '2024-02-06', 1),
(4, 'VMachines', 'Proxmox VMachines. CPU: 39.44 €, Disk: 386.28 €', -425.71999999999997, '2024-02-06', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sprints`
--

CREATE TABLE `sprints` (
  `name` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sprints`
--

INSERT INTO `sprints` (`name`, `data`) VALUES
('Sprint 1', '2023-09-11'),
('Sprint 2', '2023-10-02'),
('Sprint 3', '2023-10-23'),
('Sprint 4', '2023-11-13'),
('Sprint 5', '2023-12-04'),
('Sprint 6', '2024-01-15'),
('Sprint 7', '2024-02-05'),
('Sprint 8', '2024-02-26'),
('Sprint 9', '2024-04-01'),
('Sprint 10', '2024-04-22'),
('Sprint 11', '2024-05-13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `token`, `name`) VALUES
(1, 'marc', '9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a', 'tsu$&ZdM&pQca0PCPOFW4&tI6QxgNhlc', 'Marc'),
(2, 'marc2', '9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a', 'dvBt%2h$Qr7FK@YEb8F9iLrqCH1G6YlE', 'Marc2'),
(7, 'espuga', '9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a', 'TYZB#qowxS2AJyAVXZaXBDzff2Kye6fg', 'Espuga'),
(8, 'espuga2', '9900fed43c64a98a4ef899417e37a10db29b8cb9a4449cc2d34c14607fce7f7a', 'juyilIyrzOd6$ZO4yzxbVlBG78tjyt$9', 'espuga'),
(9, 'espuga4', '7dc6811fc4f2373e72a00adb5d69ebcac157849e40a662f2459cf1465dff6f37', 'pUD2l80S#TaIU3#dRYWso37qWM8RijC5', 'Espuga4');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_groups`
--

CREATE TABLE `users_groups` (
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users_groups`
--

INSERT INTO `users_groups` (`user_id`, `group_id`) VALUES
(1, 1),
(2, 1),
(7, 1),
(1, 23),
(NULL, 23),
(1, 24),
(NULL, 24);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_rights`
--

CREATE TABLE `users_rights` (
  `user_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `right_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users_rights`
--

INSERT INTO `users_rights` (`user_id`, `group_id`, `right_id`) VALUES
(1, 1, 1),
(1, 0, 2),
(1, 23, 1),
(1, 24, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `beteshda`
--
ALTER TABLE `beteshda`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indices de la tabla `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indices de la tabla `nokia`
--
ALTER TABLE `nokia`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indices de la tabla `rights`
--
ALTER TABLE `rights`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `servitek`
--
ALTER TABLE `servitek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users_groups`
--
ALTER TABLE `users_groups`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `group_id` (`group_id`);

--
-- Indices de la tabla `users_rights`
--
ALTER TABLE `users_rights`
  ADD KEY `user_id` (`user_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `right_id` (`right_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `beteshda`
--
ALTER TABLE `beteshda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `nokia`
--
ALTER TABLE `nokia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT de la tabla `rights`
--
ALTER TABLE `rights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `servitek`
--
ALTER TABLE `servitek`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `beteshda`
--
ALTER TABLE `beteshda`
  ADD CONSTRAINT `beteshda_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `nokia`
--
ALTER TABLE `nokia`
  ADD CONSTRAINT `nokia_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `servitek`
--
ALTER TABLE `servitek`
  ADD CONSTRAINT `servitek_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `users_groups`
--
ALTER TABLE `users_groups`
  ADD CONSTRAINT `users_groups_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `users_groups_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`);

--
-- Filtros para la tabla `users_rights`
--
ALTER TABLE `users_rights`
  ADD CONSTRAINT `users_rights_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `users_rights_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `users_rights_ibfk_3` FOREIGN KEY (`right_id`) REFERENCES `rights` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
