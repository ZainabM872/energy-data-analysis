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

SELECT COUNT(*) FROM energy_data;

--check for null values
SELECT COUNT(*) AS NULL_Country_Name FROM energy_data WHERE `Country Name` IS NULL;

--specific yr:
SELECT `2000` FROM energy_data WHERE `2000` IS NOT NULL;

DESCRIBE energy_data 

SELECT 
    AVG(`2000`) AS avg_2000,
    AVG(`2005`) AS avg_2005,
    AVG(`2010`) AS avg_2010,
    AVG(`2015`) AS avg_2015,
    AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'Access to electricity (% of population)';

SELECT 
    AVG(`2000`) AS avg_2000,
    AVG(`2005`) AS avg_2005,
    AVG(`2010`) AS avg_2010,
    AVG(`2015`) AS avg_2015,
    AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'CO2 emissions (metric tons per capita)';

SELECT 
    AVG(`2000`) AS avg_2000,
    AVG(`2005`) AS avg_2005,
    AVG(`2010`) AS avg_2010,
    AVG(`2015`) AS avg_2015,
    AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'Gross capital formation (% of GDP)';

SELECT 
    AVG(`2000`) AS avg_2000,
    AVG(`2005`) AS avg_2005,
    AVG(`2010`) AS avg_2010,
    AVG(`2015`) AS avg_2015,
    AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'CO2 emissions from electricity and heat production, total (% of total fuel combustion)';

WITH filtered_data AS (
    SELECT 
        `Country Name`,
        `Series Name`,
        CASE
            WHEN `Series Name` = 'Access to electricity (% of population)' THEN `2000`
            ELSE NULL
        END AS ELEC_2000,
        CASE 
            WHEN `Series Name` = 'Gross capital formation (% of GDP)' THEN `2000`
            ELSE NULL
        END AS GDP_2000,
        CASE 
            WHEN `Series Name` = 'CO2 emissions (metric tons per capita)' THEN `2000`
            ELSE NULL
        END AS CO2_Emissions_2000
    FROM energy_data
    WHERE `Series Name` IN (
        'Access to electricity (% of population)', 
        'CO2 emissions (metric tons per capita)', 
        'Gross capital formation (% of GDP)'
    )
)
-- returns the max value for electricity, gdp, and co2 emissions for each country
SELECT 
    `Country Name`,
    MAX(ELEC_2000) AS MAXELEC_2000,
    MAX(GDP_2000) AS MAXGDP_2000,
    MAX(CO2_Emissions_2000) AS MAXCO2_2000
FROM 
    filtered_data
GROUP BY 
    `Country Name`;

SELECT 
    `Country Name`,
    `2000` AS Year,
    CASE WHEN `Series Name` = 'CO2 emissions (metric tons per capita)' THEN `2000` END AS CO2_Emissions
FROM energy_data
WHERE `Series Name` = 'CO2 emissions (metric tons per capita)';


--electricitty access data
CREATE VIEW electricity_access_data AS
SELECT 
    `Country Name`,
    `2000` AS Year_2000,
    `2005` AS Year_2005,
    `2010` AS Year_2010,
    `2015` AS Year_2015,
    `2020` AS Year_2020
FROM 
    energy_data
WHERE 
    `Series Name` = 'Access to electricity (% of population)';
SELECT * FROM electricity_access_data;

--gdp data
CREATE VIEW gdp_data AS
SELECT 
    `Country Name`,
    `2000` AS Year_2000,
    `2005` AS Year_2005,
    `2010` AS Year_2010,
    `2015` AS Year_2015,
    `2020` AS Year_2020
FROM 
    energy_data
WHERE 
    `Series Name` = 'Gross capital formation (% of GDP)';

--c02 data
CREATE VIEW co2_data AS
SELECT 
    `Country Name`,
    `2000` AS Year_2000,
    `2005` AS Year_2005,
    `2010` AS Year_2010,
    `2015` AS Year_2015,
    `2020` AS Year_2020
FROM 
    energy_data
WHERE 
    `Series Name` = 'CO2 emissions (metric tons per capita)';


--Effect on Economic Growth: Analyze whether countries that improved electricity access significantly saw more substantial GDP growth compared to those that didn’t.
CREATE VIEW electricity_gdp_analysis AS
SELECT 
    e.`Country Name`,
    e.`Year_2000`,
    e.`Year_2020` AS `Electricity_Access_2020`,
    (e.`Year_2020` - e.`Year_2000`) AS `Electricity_Access_Improvement`,
    g.`Year_2000` AS `GDP_2000`,
    g.`Year_2020` AS `GDP_2020`,
    (g.`Year_2020` - g.`Year_2000`) AS `GDP_Growth`
FROM 
    electricity_access_data e
JOIN 
    gdp_data g ON e.`Country Name` = g.`Country Name`;

SELECT * FROM electricity_gdp_analysis

SELECT 
    CASE 
        WHEN `Electricity_Access_Improvement` > 20 THEN 'Significant Improvement'
        WHEN `Electricity_Access_Improvement` BETWEEN 0 AND 20 THEN 'Moderate Improvement'
        ELSE 'No Improvement'
    END AS Improvement_Category,
    AVG(`GDP_Growth`) AS Average_GDP_Growth
FROM 
    electricity_gdp_analysis
GROUP BY 
    Improvement_Category;

CREATE VIEW combined_trends AS
SELECT 
    e.`Country Name`,
    e.`Year_2000` AS Electricity_Access_2000,
    e.`Year_2005` AS Electricity_Access_2005,
    e.`Year_2010` AS Electricity_Access_2010,
    e.`Year_2015` AS Electricity_Access_2015,
    e.`Year_2020` AS Electricity_Access_2020,
    g.`Year_2000` AS GDP_2000,
    g.`Year_2005` AS GDP_2005,
    g.`Year_2010` AS GDP_2010,
    g.`Year_2015` AS GDP_2015,
    g.`Year_2020` AS GDP_2020,
    c.`Year_2000` AS CO2_2000,
    c.`Year_2005` AS CO2_2005,
    c.`Year_2010` AS CO2_2010,
    c.`Year_2015` AS CO2_2015,
    c.`Year_2020` AS CO2_2020
FROM 
    electricity_access_data e
JOIN 
    gdp_data g ON e.`Country Name` = g.`Country Name`
JOIN 
    co2_data c ON e.`Country Name` = c.`Country Name`;
SELECT * FROM combined_trends;

SELECT 
    `Country Name`,
    (Electricity_Access_2020 - Electricity_Access_2000) / Electricity_Access_2000 * 100 AS Electricity_Access_Change,
    (GDP_2020 - GDP_2000) / GDP_2000 * 100 AS GDP_Change,
    (CO2_2020 - CO2_2000) / CO2_2000 * 100 AS CO2_Change
FROM 
    combined_trends;

