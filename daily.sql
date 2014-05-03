-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2014-05-03 16:10:53
-- 服务器版本: 5.6.14
-- PHP 版本: 5.4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `faceair_zhihu`
--

-- --------------------------------------------------------

--
-- 表的结构 `daily`
--

CREATE TABLE IF NOT EXISTS `daily` (
  `title` varchar(50) NOT NULL,
  `share_url` varchar(100) NOT NULL,
  `id` varchar(50) NOT NULL,
  `body` text NOT NULL,
  `date` varchar(50) NOT NULL,
  `image` varchar(100) NOT NULL,
  `image_source` varchar(50) NOT NULL,
  `date_index` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
