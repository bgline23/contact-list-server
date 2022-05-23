DROP TABLE IF EXISTS User;
CREATE TABLE `User` (
  `id` char(36) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` char(32) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ;

DROP TABLE IF EXISTS Contact;
CREATE TABLE `Contact` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `email` varchar(50) NOT NULL,
  `home_number` varchar(12) NOT NULL,
  `cell_number` varchar(12) NOT NULL,
  `is_deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `fk_user_id_idx` (`user_id`),
  CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `User` (`id`)
) ;

DROP TABLE IF EXISTS Note;
CREATE TABLE `Note` (
  `id` char(36) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text,
  `date_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `contact_id` char(36) NOT NULL,
  `is_deleted` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `fk_contact_id_idx` (`contact_id`),
  CONSTRAINT `fk_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `Contact` (`id`) ON DELETE CASCADE
) ;
