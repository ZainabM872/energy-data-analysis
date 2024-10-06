USE test;
DROP DATABASE test;
CREATE DATABASE test;

CREATE TABLE energy_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    `Country Name` VARCHAR(100),
    `Country Code` VARCHAR(10),
    `Series Name` VARCHAR(100),
    `Series Code` VARCHAR(10),
    `2000` DECIMAL(15, 2),
    `2001` DECIMAL(15, 2),
    `2002` DECIMAL(15, 2),
    `2003` DECIMAL(15, 2),
    `2004` DECIMAL(15, 2),
    `2005` DECIMAL(15, 2),
    `2006` DECIMAL(15, 2),
    `2007` DECIMAL(15, 2),
    `2008` DECIMAL(15, 2),
    `2009` DECIMAL(15, 2),
    `2010` DECIMAL(15, 2),
    `2011` DECIMAL(15, 2),
    `2012` DECIMAL(15, 2),
    `2013` DECIMAL(15, 2),
    `2014` DECIMAL(15, 2),
    `2015` DECIMAL(15, 2),
    `2016` DECIMAL(15, 2),
    `2017` DECIMAL(15, 2),
    `2018` DECIMAL(15, 2),
    `2019` DECIMAL(15, 2),
    `2020` DECIMAL(15, 2)
);

SELECT COUNT(*) FROM energy_data; --Query to count total records in energy_data

--check for null values
SELECT COUNT(*) AS NULL_Country_Name FROM energy_data WHERE `Country Name` IS NULL;

--Retrieve specific year data from energy_data
SELECT `2000` FROM energy_data WHERE `2000` IS NOT NULL;

DESCRIBE energy_data 
