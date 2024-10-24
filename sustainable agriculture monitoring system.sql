-- Step 1: Create the database for the Sustainable Agriculture Monitoring System
-- This command creates a new database to store all relevant agricultural data
CREATE DATABASE SustainableAgricultureDB;

-- Step 2: Switch to the newly created database
-- This ensures all subsequent commands are executed in this specific database
USE SustainableAgricultureDB;

-- Step 3: Create a table for farmers' details
-- This table will store each farmer’s information, like their ID, name, and contact details
CREATE TABLE Farmers (
    farmer_id INT PRIMARY KEY AUTO_INCREMENT,  -- A unique identifier for each farmer
    name VARCHAR(100),                         -- Farmer's full name
    contact_info VARCHAR(100)                  -- Farmer's contact details (phone or email)
);

-- Step 4: Create a table for farm details
-- This table stores information about each farm, including its size, location, and soil type
CREATE TABLE Farms (
    farm_id INT PRIMARY KEY AUTO_INCREMENT,    -- A unique identifier for each farm
    farmer_id INT,                             -- Links each farm to a specific farmer
    location VARCHAR(100),                     -- Location of the farm (city, village)
    size_acres FLOAT,                          -- Size of the farm in acres
    soil_type VARCHAR(50),                     -- Type of soil (e.g., clay, loam, sandy)
    FOREIGN KEY (farmer_id) REFERENCES Farmers(farmer_id)  -- Foreign key linking farm to farmer
);

-- Step 5: Create a table for crops
-- This table stores information about the crops grown on each farm, including crop name, planting, and harvest dates
CREATE TABLE Crops (
    crop_id INT PRIMARY KEY AUTO_INCREMENT,    -- Unique identifier for each crop
    farm_id INT,                               -- Links the crop to a specific farm
    crop_name VARCHAR(50),                     -- Name of the crop (e.g., wheat, rice)
    planting_date DATE,                        -- The date the crop was planted
    harvest_date DATE,                         -- The expected harvest date for the crop
    yield_per_acre FLOAT,                      -- Crop yield per acre (in tons or kg)
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking the crop to a farm
);

-- Step 6: Create a table for irrigation methods
-- This table stores details about the irrigation methods used on farms and the amount of water consumed
CREATE TABLE IrrigationMethods (
    irrigation_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each irrigation method entry
    farm_id INT,                                  -- Links irrigation method to a specific farm
    method VARCHAR(50),                           -- Type of irrigation method (e.g., drip, flood)
    water_consumption_liters FLOAT,               -- Amount of water used for irrigation (in liters)
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking irrigation method to farm
);

-- Step 7: Create a table for pesticide usage
-- This table stores data about pesticide usage on each farm
CREATE TABLE Pesticides (
    pesticide_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each pesticide entry
    farm_id INT,                                 -- Links the pesticide usage to a specific farm
    pesticide_name VARCHAR(50),                  -- Name of the pesticide used
    amount_used_kg FLOAT,                        -- Amount of pesticide used (in kilograms)
    application_date DATE,                       -- The date the pesticide was applied
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking pesticide usage to farm
);

-- Step 8: Create a table for fertilizer usage
-- This table stores data about fertilizers used on farms
CREATE TABLE Fertilizers (
    fertilizer_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each fertilizer entry
    farm_id INT,                                  -- Links fertilizer usage to a specific farm
    fertilizer_name VARCHAR(50),                  -- Name of the fertilizer used
    amount_used_kg FLOAT,                         -- Amount of fertilizer used (in kilograms)
    application_date DATE,                        -- The date the fertilizer was applied
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking fertilizer usage to farm
);

-- Step 9: Create a table for water usage
-- This table stores data about water consumption on farms, which is useful for tracking resource use
CREATE TABLE WaterUsage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each water usage entry
    farm_id INT,                              -- Links water usage to a specific farm
    water_consumed_liters FLOAT,              -- Amount of water used (in liters)
    usage_date DATE,                          -- The date the water was used
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking water usage to farm
);

-- Step 10: Create a table for energy usage
-- This table stores information about the energy consumed by farm machinery and operations
CREATE TABLE EnergyUsage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each energy usage entry
    farm_id INT,                              -- Links energy usage to a specific farm
    energy_consumed_kwh FLOAT,                -- Amount of energy used (in kilowatt-hours)
    usage_date DATE,                          -- The date the energy was consumed
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking energy usage to farm
);

-- Step 11: Create a table for carbon emissions
-- This table tracks carbon emissions from farms, helping monitor their environmental impact
CREATE TABLE CarbonEmissions (
    emission_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique identifier for each carbon emission entry
    farm_id INT,                                -- Links carbon emissions to a specific farm
    emission_source VARCHAR(100),               -- The source of the emissions (e.g., machinery, transportation)
    emissions_kg FLOAT,                         -- The amount of carbon emissions (in kilograms)
    emission_date DATE,                         -- The date the emissions were recorded
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking emissions to farm
);

-- Step 12: Create a table for alerts (optional)
-- This table stores alerts or warnings when resource usage exceeds certain thresholds (e.g., water overuse)
CREATE TABLE Alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,  -- Unique identifier for each alert
    farm_id INT,                              -- Links the alert to a specific farm
    alert_message VARCHAR(255),               -- The message describing the alert
    alert_date DATE DEFAULT CURRENT_DATE,     -- The date the alert was generated
    FOREIGN KEY (farm_id) REFERENCES Farms(farm_id)  -- Foreign key linking alert to farm
);

-- Step 13: Create a trigger to generate alerts for excessive water usage
-- This trigger automatically creates an alert if water consumption on a farm exceeds 100,000 liters in one usage
CREATE TRIGGER check_water_usage
AFTER INSERT ON WaterUsage
FOR EACH ROW
WHEN (NEW.water_consumed_liters > 100000)
BEGIN
    INSERT INTO Alerts (farm_id, alert_message)
    VALUES (NEW.farm_id, 'High water usage detected');
END;
