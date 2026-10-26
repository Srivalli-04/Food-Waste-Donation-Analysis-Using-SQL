-- Food Waste & Donation Analysis Using MySQL--
-- Creating database--

CREATE DATABASE food_waste_donation_practice;
USE food_waste_donation_practice;

-- Creating tables--

CREATE TABLE food_providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100),
    provider_type VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50)
);
DESCRIBE food_providers;

CREATE TABLE food_inventory (
    food_id INT PRIMARY KEY,
    provider_id INT NOT NULL,
    food_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    unit VARCHAR(20),
    received_date DATE,
    expiry_date DATE,
    FOREIGN KEY (provider_id)
        REFERENCES food_providers(provider_id)
);
DESCRIBE food_inventory;

CREATE TABLE food_waste (
    waste_id INT PRIMARY KEY,
    food_id INT NOT NULL,
    waste_quantity INT,
    waste_date DATE,
    waste_reason VARCHAR(100),
    FOREIGN KEY (food_id)
        REFERENCES food_inventory(food_id)
);
DESCRIBE food_waste;

CREATE TABLE donation_centers (
    center_id INT PRIMARY KEY,
    center_name VARCHAR(100),
    city VARCHAR(50),
    center_type VARCHAR(50)
);
DESCRIBE donation_centers;

CREATE TABLE food_donations (
    donation_id INT PRIMARY KEY,
    food_id INT NOT NULL,
    center_id INT NOT NULL,
    donation_quantity INT,
    donation_date DATE,
    donation_status VARCHAR(30),
    FOREIGN KEY (food_id)
        REFERENCES food_inventory(food_id),
    FOREIGN KEY (center_id)
        REFERENCES donation_centers(center_id)
);
DESCRIBE food_donations;

SHOW TABLES;

-- Checking number of records--
SELECT COUNT(*) FROM food_providers;
SELECT COUNT(*) FROM food_inventory;
SELECT COUNT(*) FROM food_waste;
SELECT COUNT(*) FROM donation_centers;
SELECT COUNT(*) FROM food_donations;

-- Queries--

SELECT * FROM food_providers;
SELECT * FROM food_inventory;
SELECT * FROM food_waste;
SELECT * FROM donation_centers;
SELECT * FROM food_donations;

-- SQL Analysis Queries--

-- Who are the food providers, and how many providers are there in each city?--
SELECT city, COUNT(*) AS total_providers
FROM food_providers
GROUP BY city
ORDER BY total_providers DESC;
-- Business insight: Identify which cities have the largest provider networks and which cities have fewer providers.--

-- What types of food providers are represented in the network?--
SELECT
    provider_type,
    COUNT(*) AS provider_count,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM food_providers),
        2
    ) AS percentage_of_providers
FROM food_providers
GROUP BY provider_type
ORDER BY provider_count DESC;
-- Business insight: Identify which provider types dominate the network and which are underrepresented.--

-- Which food providers contribute the largest recorded inventory quantities?--
SELECT
    fp.provider_name,
    fp.provider_type,
    fp.city,
    SUM(fi.quantity) AS total_inventory_quantity
FROM food_providers fp
JOIN food_inventory fi
    ON fp.provider_id = fi.provider_id
GROUP BY
    fp.provider_id,
    fp.provider_name,
    fp.provider_type,
    fp.city
ORDER BY total_inventory_quantity DESC;

-- Which types of food providers are present in our dataset, and how many providers belong to each type?--
SELECT * FROM food_providers;
SELECT provider_type, COUNT(*) AS providers_type FROM food_providers GROUP BY provider_type ORDER BY providers_type DESC;



-- What food categories are available, and how much total food quantity is available in each category?--
SELECT * FROM food_inventory;
SELECT category, SUM(quantity) AS total_quantity
FROM food_inventory
GROUP BY category
ORDER BY total_quantity DESC;
-- Business insight: Identify categories with the highest recorded quantities and categories with fewer inventory records.--

-- Which food items have the highest recorded quantities?--
SELECT
    food_name,
    category,
    quantity,
    unit,
    expiry_date
FROM food_inventory
ORDER BY quantity DESC
LIMIT 10;
-- Business insight: Identify the ten inventory records with the largest quantities.--

-- Which inventory items have passed their expiry dates?--
SELECT
    food_name,
    category,
    quantity,
    unit,
    expiry_date,
    DATEDIFF(CURDATE(), expiry_date) AS days_since_expiry
FROM food_inventory
WHERE expiry_date < CURDATE()
ORDER BY days_since_expiry DESC;
-- Business insight: Identify records that require an inventory review because their expiry dates have passed.--


-- What percentage of recorded donations have been delivered?-- 
SELECT
    COUNT(*) AS total_donations,
    SUM(CASE
        WHEN donation_status = 'Delivered' THEN 1
        ELSE 0
    END) AS delivered_donations,
    ROUND(
        100.0 * SUM(CASE
            WHEN donation_status = 'Delivered' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS success_rate_percentage
FROM food_donations;
-- Business insight: Measure the share of donation records that have reached the Delivered status.--


-- Which donation centres receive the largest total recorded donation quantities?--
SELECT
    dc.center_name,
    dc.city,
    SUM(fd.donation_quantity) AS total_donated_quantity,
    COUNT(fd.donation_id) AS donation_count
FROM donation_centers dc
JOIN food_donations fd
    ON dc.center_id = fd.center_id
GROUP BY
    dc.center_id,
    dc.center_name,
    dc.city
ORDER BY total_donated_quantity DESC;
-- Business insight: Identify centres associated with the largest recorded donation quantities and compare those quantities with donation counts.--

-- How many donations are delivered, pending, or cancelled?--
SELECT
    donation_status,
    COUNT(*) AS donation_count,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM food_donations),
        2
    ) AS percentage_of_donations
FROM food_donations
GROUP BY donation_status
ORDER BY donation_count DESC;

-- Which reasons account for the largest recorded food waste quantities?--
SELECT
    waste_reason,
    SUM(waste_quantity) AS total_waste_quantity,
    COUNT(*) AS waste_records
FROM food_waste
GROUP BY waste_reason
ORDER BY total_waste_quantity DESC;
-- Business insight: Identify the waste reasons associated with the largest quantities and compare them with the number of waste records.--

-- Which food categories contribute the most to recorded food waste?--
SELECT
    fi.category,
    SUM(fw.waste_quantity) AS total_waste_quantity,
    COUNT(fw.waste_id) AS waste_records
FROM food_waste fw
JOIN food_inventory fi
    ON fw.food_id = fi.food_id
GROUP BY fi.category
ORDER BY total_waste_quantity DESC;
-- Business insight: Identify food categories associated with the largest recorded waste quantities.--

-- Which food items have recorded quantities in both donation and waste records?--
SELECT
    fi.food_name,
    fi.category,
    COALESCE(d.donated_quantity, 0) AS donated_quantity,
    COALESCE(w.wasted_quantity, 0) AS wasted_quantity
FROM food_inventory fi
LEFT JOIN (
    SELECT
        food_id,
        SUM(donation_quantity) AS donated_quantity
    FROM food_donations
    GROUP BY food_id
) d
    ON fi.food_id = d.food_id
LEFT JOIN (
    SELECT
        food_id,
        SUM(waste_quantity) AS wasted_quantity
    FROM food_waste
    GROUP BY food_id
) w
    ON fi.food_id = w.food_id
WHERE d.donated_quantity IS NOT NULL
  AND w.wasted_quantity IS NOT NULL
ORDER BY wasted_quantity DESC;
-- Business insight: Identify food items that have both donation and waste records, then compare the associated quantities.--


-- Which inventory items have a large recorded quantity and are approaching expiry?--
CREATE VIEW food_inventory_waste_view AS
SELECT
    fi.food_id,
    fi.food_name,
    fi.category,
    fi.quantity AS inventory_quantity,
    fi.unit,
    COALESCE(SUM(fw.waste_quantity), 0) AS total_waste_quantity
FROM food_inventory fi
LEFT JOIN food_waste fw
    ON fi.food_id = fw.food_id
GROUP BY
    fi.food_id,
    fi.food_name,
    fi.category,
    fi.quantity,
    fi.unit;
    
SELECT *
FROM food_inventory_waste_view
ORDER BY total_waste_quantity DESC;

SELECT
    food_name,
    category,
    inventory_quantity,
    total_waste_quantity,
    ROUND(
        (total_waste_quantity / inventory_quantity) * 100,
        2
    ) AS waste_percentage
FROM food_inventory_waste_view
WHERE total_waste_quantity > 0
ORDER BY waste_percentage DESC;


-- Which providers have the highest recorded waste quantities?-
SELECT
    fp.provider_name,
    fp.provider_type,
    SUM(fw.waste_quantity) AS total_waste_quantity,
    COUNT(fw.waste_id) AS waste_records
FROM food_providers fp
JOIN food_inventory fi
    ON fp.provider_id = fi.provider_id
JOIN food_waste fw
    ON fi.food_id = fw.food_id
GROUP BY
    fp.provider_id,
    fp.provider_name,
    fp.provider_type
ORDER BY total_waste_quantity DESC;

-- Which providers have inventory records that need the most urgent review?--
SELECT
    food_name,
    category,
    quantity,
    unit,
    expiry_date,
    CASE
        WHEN expiry_date < CURDATE()
            THEN 'Expired - Immediate Review'
        WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY)
            THEN 'High Priority'
        WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)
            THEN 'Medium Priority'
        ELSE 'Lower Priority'
    END AS review_priority
FROM food_inventory
ORDER BY
    CASE
        WHEN expiry_date < CURDATE() THEN 1
        WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 7 DAY) THEN 2
        WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 3
        ELSE 4
    END,
    expiry_date ASC;
    -- Business insight: Produce a prioritised list of inventory records for review based on expiry dates.--
    
    
# Which food items have both been donated and wasted?
SELECT
    fi.food_name,
    fi.category,
    d.donated_quantity,
    w.wasted_quantity
FROM food_inventory fi
JOIN (
    SELECT food_id, SUM(donation_quantity) AS donated_quantity
    FROM food_donations
    GROUP BY food_id
) d ON fi.food_id = d.food_id
JOIN (
    SELECT food_id, SUM(waste_quantity) AS wasted_quantity
    FROM food_waste
    GROUP BY food_id
) w ON fi.food_id = w.food_id
ORDER BY w.wasted_quantity DESC;

-- This analysis helps identify food items that have both donation and waste records, 
-- allowing the organisation to investigate whether donation timing or distribution planning could be improved.

#Which providers are associated with the highest food waste?
SELECT
    fp.provider_name,
    fp.provider_type,
    SUM(fw.waste_quantity) AS total_waste_quantity,
    COUNT(fw.waste_id) AS waste_records
FROM food_providers fp
JOIN food_inventory fi
    ON fp.provider_id = fi.provider_id
JOIN food_waste fw
    ON fi.food_id = fw.food_id
GROUP BY
    fp.provider_id,
    fp.provider_name,
    fp.provider_type
ORDER BY total_waste_quantity DESC;

#Which months have the highest donation activity?
SELECT
    DATE_FORMAT(donation_date, '%Y-%m') AS donation_month,
    COUNT(*) AS total_donations,
    SUM(donation_quantity) AS total_donated_quantity
FROM food_donations
GROUP BY DATE_FORMAT(donation_date, '%Y-%m')
ORDER BY donation_month;
-- This analysis helps identify months with higher or lower donation activity. 
-- organisation can use these trends to plan food collection, staffing, and distribution.

#Which donation centres have the most cancelled donations?
SELECT
    dc.center_name,
    dc.city,
    COUNT(fd.donation_id) AS cancelled_donations
FROM donation_centers dc
JOIN food_donations fd
    ON dc.center_id = fd.center_id
WHERE fd.donation_status = 'Cancelled'
GROUP BY
    dc.center_id,
    dc.center_name,
    dc.city
ORDER BY cancelled_donations DESC;
-- This analysis helps identify centres that may need investigation into cancellation reasons, coordination, or delivery scheduling.--

#Which food categories have the highest donation demand?
SELECT
    fi.category,
    SUM(fd.donation_quantity) AS total_donated_quantity,
    COUNT(fd.donation_id) AS total_donation_records
FROM food_inventory fi
JOIN food_donations fd
    ON fi.food_id = fd.food_id
WHERE fd.donation_status = 'Delivered'
GROUP BY fi.category
ORDER BY total_donated_quantity DESC;


SHOW FULL TABLES
FROM food_waste_donation_practice;

SELECT 'food_providers' AS table_name, COUNT(*) AS total_records
FROM food_providers

UNION ALL

SELECT 'food_inventory', COUNT(*)
FROM food_inventory

UNION ALL

SELECT 'food_waste', COUNT(*)
FROM food_waste

UNION ALL

SELECT 'donation_centers', COUNT(*)
FROM donation_centers

UNION ALL

SELECT 'food_donations', COUNT(*)
FROM food_donations;

#Which donation centres have the highest and lowest donation delivery success rates?
SELECT
    dc.center_name,
    COUNT(fd.donation_id) AS total_donations,
    SUM(
        CASE
            WHEN fd.donation_status = 'Delivered' THEN 1
            ELSE 0
        END
    ) AS delivered_donations,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN fd.donation_status = 'Delivered' THEN 1
                ELSE 0
            END
        ) / COUNT(fd.donation_id),
        2
    ) AS delivery_success_percentage
FROM donation_centers dc
JOIN food_donations fd
    ON dc.center_id = fd.center_id
GROUP BY
    dc.center_id,
    dc.center_name
ORDER BY delivery_success_percentage DESC;

#Which centres have the highest delivery success rates.
#Which centres may need improvements in donation coordination.
#Whether some centres have a higher proportion of pending or cancelled donations.

#Which months have the highest recorded food waste quantities?
SELECT
    DATE_FORMAT(waste_date, '%Y-%m') AS waste_month,
    COUNT(*) AS waste_records,
    SUM(waste_quantity) AS total_waste_quantity
FROM food_waste
GROUP BY DATE_FORMAT(waste_date, '%Y-%m')
ORDER BY waste_month;


