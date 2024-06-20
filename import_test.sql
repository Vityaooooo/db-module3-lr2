-- Создание базы данных
CREATE DATABASE lr_2;
USE lr_2;

-- Создание таблицы Сектор
CREATE TABLE sector (
    id INT AUTO_INCREMENT PRIMARY KEY,
    coordinates VARCHAR(100),
    light_rotation DECIMAL(5, 2),
    foreign_object INT,
    star_object_count INT,
    unknown_object_count INT,
    specified_object_count INT,
    notes TEXT
);

-- Создание таблицы Объекты
CREATE TABLE objects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    accuracy DECIMAL(5, 2),
    quantity INT,
    time TIME,
    date DATE,
    notes TEXT
);

-- Создание таблицы ЕстественныеОбъекты
CREATE TABLE naturalobjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    galaxy VARCHAR(50),
    accuracy DECIMAL(5, 2),
    light_flux DECIMAL(10, 2),
    adjacent_objects TEXT,
    notes TEXT
);

-- Создание таблицы Положение
CREATE TABLE position (
    id INT AUTO_INCREMENT PRIMARY KEY,
    earth_position VARCHAR(100),
    sun_position VARCHAR(100),
    moon_position VARCHAR(100)
);

-- Создание таблицы Наблюдение
CREATE TABLE observation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sector_id INT,
    object_id INT,
    natural_object_id INT,
    position_id INT,
    FOREIGN KEY (sector_id) REFERENCES sector(id),
    FOREIGN KEY (object_id) REFERENCES objects(id),
    FOREIGN KEY (natural_object_id) REFERENCES naturalobjects(id),
    FOREIGN KEY (position_id) REFERENCES position(id)
);

-- Создание триггера
DELIMITER //

CREATE TRIGGER UpdateObjects
AFTER UPDATE ON objects
FOR EACH ROW
BEGIN
    DECLARE column_exists INT DEFAULT 0;
    
    SELECT COUNT(*) INTO column_exists
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'objects' AND COLUMN_NAME = 'date_update';

    IF column_exists = 0 THEN
        SET @alter_sql = 'ALTER TABLE objects ADD COLUMN date_update TIMESTAMP';
        PREPARE stmt FROM @alter_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;

    SET NEW.date_update = NOW();
END //

DELIMITER ;

-- Создание процедуры
DELIMITER //

CREATE PROCEDURE JoinTables(IN table1 VARCHAR(255), IN table2 VARCHAR(255))
BEGIN
    SET @sql = CONCAT('SELECT * FROM ', table1, ' t1 JOIN ', table2, ' t2 ON t1.id = t2.id');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


