-- Exploratory Data Analysis

-- ---------------------------------------------------------------------Data Cleaning------------------------------------------------------------------------------------------

-- Standardize Date Format
ALTER TABLE `online retail analysis`.`products_online_sales`
ADD COLUMN InvoiceDateConverted DATE;

SET SQL_SAFE_UPDATES = 0;  -- Disable Safe Update Mode : It prevents updates that don't use a WHERE clause. This is a safety feature to prevent unintentional updates that could affect many rows.
-- SET SQL_SAFE_UPDATES = 1;

UPDATE `online retail analysis`.`products_online_sales`
SET InvoiceDateConverted = STR_TO_DATE(SUBSTRING_INDEX(InvoiceDate, ' ', 1), '%Y-%m-%d')
WHERE STR_TO_DATE(SUBSTRING_INDEX(InvoiceDate, ' ', 1), '%Y-%m-%d') IS NOT NULL;

ALTER TABLE `online retail analysis`.`products_online_sales`
DROP COLUMN InvoiceDate;

ALTER TABLE `online retail analysis`.`products_online_sales`
CHANGE InvoiceDateConverted InvoiceDate DATE;                             -- Similarly we will be doing this for additional_online_sales Table

-- Standardizing Country name
UPDATE `online retail analysis`.`products_online_sales`
SET Country = 'Ireland'
WHERE Country = 'EIRE';

DELETE FROM `online retail analysis`.`products_online_sales` WHERE Country = 'Unspecified';

-- -----------------------------------------------------------Most selled item-------------------------------------------------------------------------------------------------
SELECT Description, SUM(Quantity) AS TOTAL_SALE FROM `online retail analysis`.`products_online_sales` 
GROUP BY Description
order by total_sale desc;

-- ------------------------------------------------------Highest online sales by country----------------------------------------------------------------------------------------
SELECT Country, SUM(Quantity) AS TOTAL_SALE FROM `online retail analysis`.`products_online_sales` 
GROUP BY Country
order by total_sale desc;

-- -----------------------------------------------------------Most selled item in a region--------------------------------------------------------------------------------------
SELECT Country, Description, SUM(Quantity) AS total_quantity_bought FROM `online retail analysis`.`products_online_sales` 
GROUP BY Country, Description
having Country = 'USA'
order by total_quantity_bought desc;

-- ----------------------------------------------------------Maximum sales recorded by Country---------------------------------------------------------------------------------
SELECT Country, SUM(Quantity * UnitPrice) AS TOTAL_SALES FROM `online retail analysis`.`products_online_sales` 
GROUP BY Country
order by TOTAL_SALES desc;

-- -----------------------------------------------------------Customer with maximum purchased amount---------------------------------------------------------------------------
WITH cte AS (
    SELECT
        CustomerID,
        Description,
        (Quantity * UnitPrice) AS total_buy
    FROM `online retail analysis`.`products_online_sales`
    ORDER BY Description
)
SELECT
    CustomerID,
    SUM(total_buy) AS total_spent
FROM cte
GROUP BY CustomerID
ORDER BY total_spent desc;

SELECT max(InvoiceDate), min(InvoiceDate) FROM `online retail analysis`.`products_online_sales`;

SELECT DISTINCT Country FROM `online retail analysis`.`products_online_sales`;

-- -----------------------------------------------------------------------------Total Sales-------------------------------------------------------------------------------------
WITH total_sales AS (
    SELECT 
        prod.*, 
        ad.InvoiceNo AS add_InvoiceNo, 
        ad.CustomerID AS add_CustomerID, 
        ad.InvoiceDate AS add_InvoiceDate, 
        ad.Add_Qty, 
        ad.Add_fee,
        ((prod.Quantity * prod.UnitPrice) + ((ad.Add_Qty * prod.UnitPrice) + ad.Add_fee)) AS total_sales
    FROM 
        `online retail analysis`.products_online_sales prod
    LEFT JOIN  
        `online retail analysis`.additional_online_sales ad
    ON 
        prod.InvoiceNo = ad.InvoiceNo AND prod.CustomerID = ad.CustomerID
    UNION
    SELECT 
        prod.*, 
        ad.InvoiceNo AS add_InvoiceNo, 
        ad.CustomerID AS add_CustomerID, 
        ad.InvoiceDate AS add_InvoiceDate, 
        ad.Add_Qty, 
        ad.Add_fee,
        ((prod.Quantity * prod.UnitPrice) + ((ad.Add_Qty * prod.UnitPrice) + ad.Add_fee)) AS total_sales
    FROM 
        `online retail analysis`.products_online_sales prod
    RIGHT JOIN  
        `online retail analysis`.additional_online_sales ad
    ON 
        prod.InvoiceNo = ad.InvoiceNo AND prod.CustomerID = ad.CustomerID
)
SELECT 
    SUM(total_sales) AS total_sales_sum
FROM 
    total_sales;

-- TOP 10 Product categories
SELECT Product_Category, SUM(Quantity) AS quan
FROM `online retail analysis`.online_analysis_bi
GROUP BY Product_Category
ORDER BY quan DESC
LIMIT 10;
