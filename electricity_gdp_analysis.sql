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

--Calculate yearly averages for Access to electricity (% of population) from energy_data
SELECT
   AVG(`2000`) AS avg_2000,
   AVG(`2005`) AS avg_2005,
   AVG(`2010`) AS avg_2010,
   AVG(`2015`) AS avg_2015,
   AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'Access to electricity (% of population)';

--Calculate yearly averages for CO2 emissions (metric tons per capita) from energy_data
SELECT
   AVG(`2000`) AS avg_2000,
   AVG(`2005`) AS avg_2005,
   AVG(`2010`) AS avg_2010,
   AVG(`2015`) AS avg_2015,
   AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'CO2 emissions (metric tons per capita)';

--Calculate yearly averages for gross capital formation (% of GDP) from energy_data
SELECT
   AVG(`2000`) AS avg_2000,
   AVG(`2005`) AS avg_2005,
   AVG(`2010`) AS avg_2010,
   AVG(`2015`) AS avg_2015,
   AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'Gross capital formation (% of GDP)';

--Calculate yearly averages for CO2 emissions from electricity and heat production from energy_data
SELECT
   AVG(`2000`) AS avg_2000,
   AVG(`2005`) AS avg_2005,
   AVG(`2010`) AS avg_2010,
   AVG(`2015`) AS avg_2015,
   AVG(`2020`) AS avg_2020
FROM energy_data
WHERE `Series Name` = 'CO2 emissions from electricity and heat production, total (% of total fuel combustion)';

--Create filtered_data CTE to aggregate key indicators for 2000: electricity access, GDP, and CO2 emissions
WITH filtered_data AS (
    SELECT
        `Country Name`, -- The name of the country
        `Series Name`,  -- The name of the series (indicator)
        CASE
            -- Capture electricity access data for the year 2000
            WHEN `Series Name` = 'Access to electricity (% of population)' THEN `2000`
            ELSE NULL
        END AS ELEC_2000,  -- Electricity access for 2000
        CASE
            -- Capture GDP data for the year 2000
            WHEN `Series Name` = 'Gross capital formation (% of GDP)' THEN `2000`
            ELSE NULL
        END AS GDP_2000,  -- GDP for 2000
        CASE
            -- Capture CO2 emissions data for the year 2000
            WHEN `Series Name` = 'CO2 emissions (metric tons per capita)' THEN `2000`
            ELSE NULL
        END AS CO2_Emissions_2000 -- CO2 emissions for 2000
    FROM energy_data  -- Source table
    WHERE `Series Name` IN (
        -- Filter for relevant series of interest
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

--Extract CO2 emissions (metric tons per capita) for the year 2000 from energy_data.

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
