DELIMITER $$


DROP PROCEDURE IF EXISTS CreateUser;
DROP PROCEDURE IF EXISTS GetAuthenticatedUser;

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
    IF CHAR_LENGTH(TRIM(name)) < 2 OR name REGEXP '[0-9]'
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