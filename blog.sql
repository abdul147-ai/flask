-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 07, 2025 at 03:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blog`
--

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `sno` int(11) NOT NULL,
  `name` text NOT NULL,
  `phone_num` varchar(13) NOT NULL,
  `msg` text NOT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`sno`, `name`, `phone_num`, `msg`, `date`, `email`) VALUES
(1, 'first post', '1234567890', 'first post', '2025-09-02 11:49:44', 'firstpost@gmail.com'),
(6, 'Ayan Shaikh', '09876543210', 'flask application', '2025-09-02 12:39:18', 'ayan@gmail.com'),
(8, 'Abdul Aziz', '09876543210', 'Test flask', '2025-09-03 10:27:05', 'abdul@gmail.com'),
(13, 'Abdul', '09876543210', 'check flask', '2025-09-16 10:11:34', 'abdul@gmail.com'),
(15, 'Abdul', '09876543210', ' send mail', '2025-09-25 18:55:24', 'abdul@gmail.com'),
(16, 'Abdul', '09876543210', 'send mail', '2025-09-26 11:18:37', 'abdul@gmail.com'),
(17, 'Abdul', '09876543210', 'send mail', '2025-09-26 11:18:43', 'abdul@gmail.com'),
(18, 'Shaikh Abdul', '09876543210', 'web application', '2025-09-27 11:03:06', 'abdul@gmail.com'),
(19, 'Shaikh Abdul', '09876543210', 'web application', '2025-09-27 11:03:49', 'abdul@gmail.com'),
(20, 'Shaikh Abdul', '09876543210', 'without mail', '2025-09-27 11:05:13', 'abdul@gmail.com'),
(21, 'Shaikh Abdul', '09876543210', 'by removing email block', '2025-09-27 11:11:14', 'abdul@gmail.com'),
(22, 'Abdul ', '09876543210', 'Adding post in flask', '2025-10-04 10:28:41', 'abdul@gmail.com'),
(23, 'Abdul ', '09876543210', 'Adding post in flask', '2025-10-04 10:42:59', 'abdul@gmail.com'),
(24, 'Abdul ', '09876543210', 'hello', '2025-10-07 10:24:46', 'abdul@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `sno` int(11) NOT NULL,
  `title` text NOT NULL,
  `tagline` text NOT NULL,
  `slug` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `img_file` varchar(20) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`sno`, `title`, `tagline`, `slug`, `content`, `img_file`, `date`) VALUES
(1, 'Learn about Flask (Python)', 'This is first post edited', 'first-post', 'Flask is a lightweight and powerful web framework for Python. It’s often called a \"micro-framework\" because it provides the essentials for web development without unnecessary complexity. Unlike Django, which comes with built-in features like authentication and an admin panel, Flask keeps things minimal and lets us add only what we need.', 'post-bg.jpg', '2025-10-04 12:10:10'),
(2, ' Jinja template', 'coolest post ever', 'second-post', 'A Jinja template is simply a text file. Jinja can generate any text-based format (HTML, XML, CSV, LaTeX, etc.). A Jinja template doesn’t need to have a specific extension: .html, .xml, or any other extension is just fine.\r\n\r\nA template contains variables and/or expressions, which get replaced with values when a template is rendered; and tags, which control the logic of the template. The template syntax is heavily inspired by Django and Python.', 'about-bg.jpg', '2025-10-01 15:29:02'),
(3, 'Microframework', 'Flask is considered a \"micro\" web framework ', 'third-post', 'Flask is considered a \"micro\" web framework because it is lightweight and simple to use, with minimal dependencies. It doesn\'t come with the full set of tools that more extensive frameworks like Django provide, giving developers more control and flexibility over the application structure.', 'about-bg.jpg', '2025-10-04 18:01:20'),
(4, 'Routing:', 'Flask’s routing system is extremely simple and intuitive', 'tagline4', 'lask’s routing system is extremely simple and intuitive. You define routes with decorators that map URLs to Python functions. This makes it very easy to set up and control the flow of your application.', 'about-bg.jpg', '2025-10-04 18:01:31'),
(5, 'No ORM by Default', 'Flask does not come with ORM', 'fifth-post', 'Unlike Django, Flask does not come with a built-in Object-Relational Mapping (ORM) tool like Django’s ORM. Instead, it lets developers choose their ORM, such as SQLAlchemy or simply use raw SQL.', 'about-bg.jpg', '2025-10-04 19:45:28'),
(6, 'RESTful API Support', 'Flask is popular for building RESTful APIs', 'six-post', 'Flask is popular for building RESTful APIs. Its simplicity and flexibility make it a great choice for building APIs and many developers use it for creating microservices and backends for single-page applications.', 'img.png', '2025-10-07 16:12:11');

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

CREATE TABLE `team` (
  `sno` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `position` varchar(50) NOT NULL,
  `bio` varchar(120) NOT NULL,
  `img_file` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `team`
--

INSERT INTO `team` (`sno`, `name`, `position`, `bio`, `img_file`, `email`, `date`) VALUES
(1, 'Abdul Aziz', 'Python Developer', 'Django , Flask ', 'abdul.jpeg', 'abdul@gmail.com', '2025-10-07 15:43:59'),
(2, 'Shaikh Umair', 'Digital marketing', 'Social medial handling\r\nSEO, meta adds', 'staff.png', 'umair@gmail.com', '2025-10-07 18:18:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`sno`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`sno`);

--
-- Indexes for table `team`
--
ALTER TABLE `team`
  ADD PRIMARY KEY (`sno`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `sno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `sno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `team`
--
ALTER TABLE `team`
  MODIFY `sno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
