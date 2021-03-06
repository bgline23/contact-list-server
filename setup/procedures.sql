DELIMITER $$

 DROP PROCEDURE IF EXISTS CreateContact;

 CREATE PROCEDURE CreateContact
(

  IN `id` char(36) ,
  IN `user_id` char(36) ,
  IN `first_name` varchar(100) ,
  IN `surname` varchar(100) ,
  IN `middle_name` varchar(100) ,
  IN `email` varchar(50) ,
  IN `home_number` varchar(12) ,
  IN `cell_number` varchar(12) 

)
BEGIN
	IF first_name NOT REGEXP '[:alpha:]' 
		OR middle_name NOT REGEXP '[:alpha:]'
			OR surname NOT REGEXP '[:alpha:]'
    THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name cannot contain a number';
    END IF;
    
    INSERT INTO `epicentre`.`Contact`
	(`id`,
	`user_id`,
	`first_name`,
	`surname`,
	`middle_name`,
	`email`,
	`home_number`,
	`cell_number`)
	VALUES
	(	id,
		user_id,
		first_name,
		surname,
		middle_name,
		email,
		home_number,
		cell_number
	);
END $$


-- **************************************

DROP PROCEDURE IF EXISTS GetContactList;

CREATE PROCEDURE GetContactList(
    IN user_id CHAR(36),
    IN page_offset INT,
    IN page_size INT
)
BEGIN	
	SELECT 		first_name, 
				surname,
				home_number, 
				cell_number 
    FROM 		Contact
    WHERE 		is_deleted = 0
    ORDER BY 	first_name ASC
    LIMIT 		page_offset, page_size;
END$$

-- **************************************

DROP PROCEDURE IF EXISTS CreateUser;

CREATE PROCEDURE CreateUser
(
    IN `name`         VARCHAR(50),
    IN email        VARCHAR(40),
    IN username     VARCHAR(50),
    IN password     CHAR(32)
)
BEGIN

--  Verify user does not exist
    IF EXISTS (SELECT id FROM User u WHERE u.email = email) 
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email address already exists';
    END IF;

    IF EXISTS (SELECT username FROM User u WHERE u.username = username) 
    THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username already exists';
    END IF;

--  Verify fields are valid
    IF name REGEXP '[0-9]'
    THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name cannot contain a number';
    END IF;

      IF CHAR_LENGTH(TRIM(email)) < 6  THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Provide a valid email address';
    END IF;

    IF username REGEXP '[^0-9a-zA-Z]' THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username can only be letters followed by numbers';
    END IF; 

     IF CHAR_LENGTH(TRIM(username)) < 6  THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username must be 6 characters or more';
    END IF;

    IF CHAR_LENGTH(TRIM(password)) < 6  THEN
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password must be 6 characters or more';
    END IF;

    SET @generate_username =  CASE TRIM(username) WHEN '' THEN CONCAT(name,cast(rand() * 10000 as signed)) ELSE username END ;
    

    INSERT INTO User 
    (
        id,
        `name`,
        email,
        username,
        password     
    )
    VALUES
    (
        uuid(),
        name,
        email,
        username,
        password      
    );
    
    SELECT      u.id,
                u.name,
                u.email,
                u.username
    FROM        User u
    WHERE       u.id = LAST_INSERT_ID();
END $$

-- **************************************

DROP PROCEDURE IF EXISTS CreateNote;

CREATE  PROCEDURE CreateNote(
	id char(36),
	contact_id char(36) ,
	title varchar(200) ,
	description text
)
BEGIN
	IF EXISTS (SELECT id
				FROM Contact c
                WHERE c.id = contact_id AND c.is_deleted = 0)
	THEN
		INSERT INTO Note
		(
			id,
			contact_id,
			title,
			description
		)
		VALUES
		(
			id,
			contact_id,
			title,
			description		
		);
    END IF;
END$$


-- **************************************

DROP PROCEDURE IF EXISTS GetAuthenticatedUser;

CREATE PROCEDURE GetAuthenticatedUser(IN username VARCHAR(100), IN password CHAR(32))
BEGIN
    SELECT  u.id,
            u.name,
            u.email,
            u.username
    FROM    User u
    WHERE   (u.username = username OR u.email = username)
    AND     u.password = password;
END $$

-- **************************************



DELIMITER ;