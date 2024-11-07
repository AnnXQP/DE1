-- TERM PROJECT 1: Artificial Data from a Czech Bank
-- By Anna Pavlova, MS SDS
-- OPERATIONAL LAYER
	-- Loading the data using import/export from retational dataset repository 
CREATE SCHEMA cs; 
USE cs;
TABLE ACCOUNTS;
DESCRIBE ACCOUNTS; 
TABLE ACCOUNT_TRANSACTIONS;
TABLE ACCOUNT_TRANSACT_TYPES; 
TABLE ORGANIZATIONS;
TABLE PARTIES; 
TABLE PRODUCTS; 
TABLE target_churn; 

DESCRIBE ACCOUNT_TRANSACTIONS;  

-- ANALYTICS: Analytics Plan
-- Based on selected data it could think of analyzing transaction patterns by currency, transaction type, and product.
-- Conduct regional and demographic insights based on ZIP code and client details. 
-- In addition, to provide a calculation of transaction values and its categories: low, medium, high. It might be applicable for fraud detection, and risk reductions whent it comes to high value transfers. 

-- ANALYTICAL LAYER
CREATE TABLE account_analytics AS
SELECT *
FROM ACCOUNT_TRANSACTIONS
INNER JOIN ACCOUNTS
USING (ACC_KEY, ACCTP_KEY)
INNER JOIN PRODUCTS
USING (PROD_KEY);

TABLE account_analytics; 

CREATE TABLE parties_analytics AS
SELECT *
FROM PARTIES 
INNER JOIN ORGANIZATIONS  
USING (ORG_KEY); 

TABLE parties_analytics; 

SELECT *
FROM account_analytics t1
INNER JOIN ACCOUNT_TRANSACT_TYPES t2
ON t1.ACTRNTP_KEY = t2.ACTRNTP_KEY;

SELECT *
FROM account_analytics t1
INNER JOIN ACCOUNT_TYPES t2
ON t1.ACCTP_KEY = t2.ACCTP_KEY; 

DESCRIBE account_analytics; 
DESCRIBE parties_analytics; 

-- ETL USING STORED PROCEDURES 

DROP PROCEDURE IF EXISTS GetTotalTransactionAmountByCurrency;

DELIMITER $$

CREATE PROCEDURE GetTotalTransactionAmountByCurrency (
    IN currencyCode VARCHAR(255),
    OUT totalAmountCZK INT,
    OUT totalAmountFX INT
)
BEGIN
    SELECT 
        SUM(ACCTRN_AMOUNT_CZK),
        SUM(ACCTRN_AMOUNT_FX)
    INTO 
        totalAmountCZK,
        totalAmountFX
    FROM account_analytics
    WHERE CURR_ISO_CODE = currencyCode;
END$$

DELIMITER ;

CALL GetTotalTransactionAmountByCurrency('CZK', @totalAmountCZK, @totalAmountFX);
SELECT @totalAmountCZK, @totalAmountFX;

DROP PROCEDURE IF EXISTS GetTransactionsByProduct;

DELIMITER $$

CREATE PROCEDURE GetTransactionsByProduct (
    IN agendaName VARCHAR(255)
)
BEGIN
    SELECT *
    FROM account_analytics
    WHERE PROD_AGENDA_NAME = agendaName;
END$$

DELIMITER ;

CALL GetTransactionsByProduct('Produkt 88275');

DROP PROCEDURE IF EXISTS GetTransactionsByCashAndDebitCredit;

DELIMITER $$

CREATE PROCEDURE GetTransactionsByCashAndDebitCredit (
    IN cashType CHAR(1) -- "Y" for cash transactions, "N" for non-cash
)
BEGIN
    SELECT 
        ACCTRN_KEY,
        ACC_KEY,
        ACCTP_KEY,
        ACCTRN_ACCOUNTING_DATE,
        ACCTRN_AMOUNT_FX,
        CURR_ISO_CODE,
        ACCTRN_CASH_FLAG,
        CASE 
            WHEN ACCTRN_CASH_FLAG = 'N' THEN 
                CASE 
                    WHEN ACCTRN_CRDR_FLAG = 'D' THEN 'Debit'
                    WHEN ACCTRN_CRDR_FLAG = 'C' THEN 'Credit'
                    ELSE 'Unknown'
                END
            ELSE 'Cash Transaction'
        END AS Transaction_Type
    FROM account_analytics
    WHERE ACCTRN_CASH_FLAG = cashType;
END$$

DELIMITER ;
CALL GetTransactionsByCashAndDebitCredit('N');


DROP PROCEDURE IF EXISTS GetSenderCategoryByAmountFX;

DELIMITER $$

CREATE PROCEDURE GetSenderCategoryByAmountFX(
    IN pTransactionID BIGINT, 
    OUT pSenderCategory VARCHAR(20)
)
BEGIN
    DECLARE amountFX DECIMAL DEFAULT 0;
SELECT 
    ACCTRN_AMOUNT_FX
INTO amountFX FROM
    account_analytics
WHERE
    ACCTRN_KEY = pTransactionID;
    IF amountFX > -100000 THEN
        SET pSenderCategory = 'HIGH';
    ELSEIF amountFX > -50000 THEN
        SET pSenderCategory = 'MEDIUM';
    ELSE
        SET pSenderCategory = 'LOW';
    END IF;
END$$

DELIMITER ;

CALL GetSenderCategoryByAmountFX(5781198977, @pSenderCategory);
SELECT @pSenderCategory;         -- as an output we get 'HIGH': sender category based on transaction amount 

DROP PROCEDURE IF EXISTS GetClientCategoryByCzechZIP;

DELIMITER $$

CREATE PROCEDURE GetClientCategoryByCzechZIP(
    IN pClientID INT, 
    OUT pClientCategory VARCHAR(20)
)
BEGIN
    DECLARE zipCode INT DEFAULT 0;
    
    SELECT ZIP 
    INTO zipCode
    FROM parties_analytics
    WHERE PT_UNIFIED_KEY = pClientID;

    IF zipCode BETWEEN 10000 AND 19999 THEN   -- used publicly avaliable data to transform ZIPs to regions since cities couldn't tell much about clients segmentation. 
        SET pClientCategory = 'PRAGUE';
    ELSEIF zipCode BETWEEN 20000 AND 29999 THEN
        SET pClientCategory = 'CENTRAL_BOHEMIA';
    ELSEIF zipCode BETWEEN 30000 AND 39999 THEN
        SET pClientCategory = 'HRADEC_KRALOVE_AND_PARDUBICE';
    ELSEIF zipCode BETWEEN 40000 AND 49999 THEN
        SET pClientCategory = 'NORTH_BOHEMIA';
    ELSEIF zipCode BETWEEN 50000 AND 59999 THEN
        SET pClientCategory = 'EAST_BOHEMIA';
    ELSEIF zipCode BETWEEN 60000 AND 69999 THEN
        SET pClientCategory = 'SOUTH_MORAVIA';
    ELSEIF zipCode BETWEEN 70000 AND 79999 THEN
        SET pClientCategory = 'NORTH_MORAVIA';
    ELSEIF zipCode BETWEEN 80000 AND 89999 THEN
        SET pClientCategory = 'OSTRAVA_AND_SURROUNDINGS';
    ELSE
        SET pClientCategory = 'UNKNOWN_REGION';
    END IF;
END$$

DELIMITER ;

CALL GetClientCategoryByCzechZIP(2326500, @pClientCategory);
SELECT @pClientCategory;      -- Client is from Prague :) 

DROP PROCEDURE IF EXISTS GetClientsByAgeGenderAndRegion;

DELIMITER $$

CREATE PROCEDURE GetClientsByAgeGenderAndRegion(
    IN ageCategory VARCHAR(20), -- 'YOUTH', 'ADULT', 'SENIOR', or 'LEGAL_ENTITY'
    IN gender CHAR(1)           -- 'M' for male, 'Z' for female, 'X' for legal entity
)
BEGIN
    SELECT 
        CASE
            WHEN ZIP BETWEEN 10000 AND 19999 THEN 'PRAGUE'
            WHEN ZIP BETWEEN 20000 AND 29999 THEN 'CENTRAL_BOHEMIA'
            WHEN ZIP BETWEEN 30000 AND 39999 THEN 'HRADEC_KRALOVE_AND_PARDUBICE'
            WHEN ZIP BETWEEN 40000 AND 49999 THEN 'NORTH_BOHEMIA'
            WHEN ZIP BETWEEN 50000 AND 59999 THEN 'EAST_BOHEMIA'
            WHEN ZIP BETWEEN 60000 AND 69999 THEN 'SOUTH_MORAVIA'
            WHEN ZIP BETWEEN 70000 AND 79999 THEN 'NORTH_MORAVIA'
            WHEN ZIP BETWEEN 80000 AND 89999 THEN 'OSTRAVA_AND_SURROUNDINGS'
            ELSE 'UNKNOWN_REGION'
        END AS Region,
        COUNT(*) AS ClientCount
    FROM parties_analytics
    WHERE 
      -- Legal entities with gender 'X' are treated separately
      ((gender = 'X' AND ageCategory = 'LEGAL_ENTITY' AND PTH_BIRTH_DATE = '1000-01-01')
      -- Personal age categories for gender 'M' and 'Z' only
      OR (gender != 'X' AND PSGEN_UNIFIED_ID = gender
          AND (
              (ageCategory = 'YOUTH' AND PTH_BIRTH_DATE != '1000-01-01' 
                  AND YEAR(CURDATE()) - YEAR(STR_TO_DATE(PTH_BIRTH_DATE, '%Y-%m-%d')) < 25)
              OR (ageCategory = 'ADULT' AND PTH_BIRTH_DATE != '1000-01-01' 
                  AND YEAR(CURDATE()) - YEAR(STR_TO_DATE(PTH_BIRTH_DATE, '%Y-%m-%d')) BETWEEN 25 AND 64)
              OR (ageCategory = 'SENIOR' AND PTH_BIRTH_DATE != '1000-01-01' 
                  AND YEAR(CURDATE()) - YEAR(STR_TO_DATE(PTH_BIRTH_DATE, '%Y-%m-%d')) >= 65)
              OR (ageCategory = 'UNKNOWN' AND PTH_BIRTH_DATE = '1000-01-01')
          )
      ))
    GROUP BY Region
    ORDER BY ClientCount DESC;
END$$

DELIMITER ;

CALL GetClientsByAgeGenderAndRegion('ADULT', 'Z');  -- there are two female adults in North Movara and Central Bohemia respectively. 

-- EVENT: ACCOUNT RELATED ANALYTICS 
DROP EVENT IF EXISTS GenerateTransactionEntries;

DELIMITER $$

CREATE EVENT IF NOT EXISTS GenerateTransactionEntries
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO account_analytics (
        PROD_KEY,
        ACC_KEY,
        ACCTP_KEY,
        ACCTRN_KEY,
        ACTRNTP_KEY,
        ACCTRN_ACCOUNTING_DATE,
        ACCTRN_AMOUNT_CZK,
        ACCTRN_AMOUNT_FX,
        CURR_ISO_CODE,
        ACCTRN_CRDR_FLAG,
        ACCTRN_CASH_FLAG,
        ACCTRN_INTEREST_FLAG,
        ACCTRN_TAX_FLAG,
        ACCTRN_FEE_FLAG,
        ACC_OTHER_ACCOUNT_KEY,
        ACCTP_OTHER_ACCOUNT_KEY,
        ORG_KEY,
        PT_UNIFIED_KEY,
        ACCH_OPEN_DATE,
        ACCH_CLOSE_DATE,
        PROD_AGENDA_CODE,
        PROD_AGENDA_NAME
    )
    VALUES 
    (
        FLOOR(RAND() * 1000),                    -- PROD_KEY
        FLOOR(RAND() * 1000),                    -- ACC_KEY
        FLOOR(RAND() * 100),                     -- ACCTP_KEY
        FLOOR(RAND() * 100000),                  -- ACCTRN_KEY
        FLOOR(RAND() * 100),                     -- ACTRNTP_KEY
        CURDATE(),                               -- ACCTRN_ACCOUNTING_DATE
      CASE 
            WHEN RAND() > 0.5 THEN -FLOOR(RAND() * 5000)                 -- If CZK, random amount in CZK
            ELSE -FLOOR(RAND() * 200 * 25.64)                            -- If EUR, convert EUR to CZK
        END,                                                             -- ACCTRN_AMOUNT_CZK
        CASE 
            WHEN RAND() > 0.5 THEN 0                                     -- No FX amount for CZK transactions
            ELSE -FLOOR(RAND() * 200)                                    -- Original EUR amount for EUR transactions
        END,                                                             -- ACCTRN_AMOUNT_FX
        CASE 
            WHEN RAND() > 0.5 THEN 'EUR' 
            ELSE 'CZK' 
        END,                                                    -- ACCTRN_AMOUNT_FX
        CASE 
            WHEN RAND() > 0.5 THEN 'EUR' 
            ELSE 'CZK' 
        END,                                                   -- CURR_ISO_CODE
        CASE 
            WHEN RAND() > 0.5 THEN 'D' 
            ELSE 'C' 
        END,                                                   -- ACCTRN_CRDR_FLAG (D for debit, C for credit)
        CASE 
            WHEN RAND() > 0.5 THEN 'Y' 
            ELSE 'N' 
        END,                                                   -- ACCTRN_CASH_FLAG
        CASE 
            WHEN RAND() > 0.5 THEN 'Y' 
            ELSE 'N' 
        END,                                                   -- ACCTRN_INTEREST_FLAG
        CASE 
            WHEN RAND() > 0.5 THEN 'Y' 
            ELSE 'N' 
        END,                                                   -- ACCTRN_TAX_FLAG
        CASE 
            WHEN RAND() > 0.5 THEN 'Y' 
            ELSE 'N' 
        END,                                                   -- ACCTRN_FEE_FLAG
        FLOOR(RAND() * 1000),                                  -- ACC_OTHER_ACCOUNT_KEY
        FLOOR(RAND() * 100),                                   -- ACCTP_OTHER_ACCOUNT_KEY
        FLOOR(RAND() * 1000),                                  -- ORG_KEY
        FLOOR(RAND() * 100000),                                -- PT_UNIFIED_KEY
        CURDATE(),                                             -- ACCH_OPEN_DATE
        DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY), -- ACCH_CLOSE_DATE
        '1S',                                                  -- PROD_AGENDA_CODE
        'Produkt 51757'                                        -- PROD_AGENDA_NAME
    );
END$$

DELIMITER ;
SET GLOBAL event_scheduler = ON;

-- TRIGGER 

DELIMITER $$
DROP TRIGGER IF EXISTS FlagHighTransactionForApproval$$

-- Create the trigger to set approval_status based on transaction amount
CREATE TRIGGER FlagHighTransactionForApproval
BEFORE INSERT ON account_analytics
FOR EACH ROW
BEGIN
    -- Check if the transaction amount qualifies as "HIGH" and requires approval
    IF NEW.ACCTRN_AMOUNT_CZK > -10000 OR NEW.ACCTRN_AMOUNT_FX > -10000 THEN
        SET NEW.approval_status = 'Needs Approval';
    ELSE
        SET NEW.approval_status = 'Approved';
    END IF;
END$$

DELIMITER ;

-- ACTIVATE TRIGGER 
INSERT INTO account_analytics (
    PROD_KEY, ACC_KEY, ACCTP_KEY, ACCTRN_KEY, ACTRNTP_KEY, 
    ACCTRN_ACCOUNTING_DATE, ACCTRN_AMOUNT_CZK, ACCTRN_AMOUNT_FX, 
    CURR_ISO_CODE, ACCTRN_CRDR_FLAG, ACCTRN_CASH_FLAG, 
    ACCTRN_INTEREST_FLAG, ACCTRN_TAX_FLAG, ACCTRN_FEE_FLAG, 
    ACC_OTHER_ACCOUNT_KEY, ACCTP_OTHER_ACCOUNT_KEY, 
    ORG_KEY, PT_UNIFIED_KEY, 
    ACCH_OPEN_DATE, ACCH_CLOSE_DATE, PROD_AGENDA_CODE, PROD_AGENDA_NAME
) 
VALUES 
(
    101,                    -- PROD_KEY
    1001,                   -- ACC_KEY
    201,                    -- ACCTP_KEY
    500001,                 -- ACCTRN_KEY
    301,                    -- ACTRNTP_KEY
    CURDATE(),              -- ACCTRN_ACCOUNTING_DATE (sets today's date)
    -12000,                  -- ACCTRN_AMOUNT_CZK
    -473.29,                      -- ACCTRN_AMOUNT_FX
    'CZK',                  -- CURR_ISO_CODE
    'D',                    -- ACCTRN_CRDR_FLAG (D for debit)
    'Y',                    -- ACCTRN_CASH_FLAG
    'N',                    -- ACCTRN_INTEREST_FLAG
    'N',                    -- ACCTRN_TAX_FLAG
    'N',                    -- ACCTRN_FEE_FLAG
    1102,                   -- ACC_OTHER_ACCOUNT_KEY
    211,                    -- ACCTP_OTHER_ACCOUNT_KEY
    501,                    -- ORG_KEY
    200001,                 -- PT_UNIFIED_KEY
    CURDATE(),              -- ACCH_OPEN_DATE
    DATE_ADD(CURDATE(), INTERVAL 1 YEAR), -- ACCH_CLOSE_DATE (1 year from today)
    '1S',                -- PROD_AGENDA_CODE
    'Produkt 51757'      -- PROD_AGENDA_NAME
);

SELECT * FROM account_analytics
WHERE approval_status = 'Needs Approval'ORDER BY ACCTRN_ACCOUNTING_DATE;

-- DATA MARTS VIEW 

DROP VIEW IF EXISTS High_Value_Transactions;
CREATE VIEW `High_Value_Transactions` AS
SELECT * FROM account_analytics
WHERE ACCTRN_AMOUNT_CZK > -10000 OR ACCTRN_AMOUNT_FX > -10000;
SELECT * FROM High_Value_Transactions;

DROP VIEW IF EXISTS Currency;
CREATE VIEW `Currency` AS
SELECT * FROM account_analytics WHERE CURR_ISO_CODE = 'CZK';
SELECT * FROM Currency ORDER BY ACCTRN_AMOUNT_CZK;

-- EVENT 2: PARTIES ANALYTICS 

DROP EVENT IF EXISTS GenerateClientDataEntries;

DELIMITER $$

CREATE EVENT GenerateClientDataEntries
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
    INSERT INTO parties_analytics (
        ORG_KEY,
        PT_UNIFIED_KEY,
        PTH_BIRTH_DATE,
        PTH_CLIENT_FROM_DATE,
        PTH_CLIENT_FROM_DATE_ALT,
        PTTP_UNIFIED_ID,
        PSGEN_UNIFIED_ID,
        ORGH_UNIFIED_ID,
        CITY,
        ZIP
    )
    VALUES 
    (
        FLOOR(RAND() * 1000),                            -- ORG_KEY
        FLOOR(RAND() * 100000),                          -- PT_UNIFIED_KEY
        DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND() * 365 * 100) DAY), '%Y-%m-%d'), -- Random birth date within the last 100 years
        DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND() * 365 * 20) DAY), '%Y-%m-%d'),  -- Client start date within the last 20 years
        DATE_FORMAT(DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND() * 365 * 20) DAY), '%Y-%m-%d'),  -- Alternative client start date within the last 20 years
        CASE WHEN RAND() < 0.5 THEN 'P' ELSE 'F' END,           -- PTTP_UNIFIED_ID (randomized unique ID prefix)
        CASE 
            WHEN RAND() > 0.5 THEN 'M'                   -- PSGEN_UNIFIED_ID: 'M' for male, 'Z' for female
            ELSE 'Z'
        END,
        CONCAT(
			CASE WHEN RAND() < 0.5 THEN 'EX0_' ELSE 'HR0_' END,
			FLOOR(RAND() * 10000)),           -- ORGH_UNIFIED_ID (randomized org unique ID prefix)
        CASE 
            WHEN RAND() < 0.25 THEN 'Prague'
            WHEN RAND() < 0.5 THEN 'Brno'
            WHEN RAND() < 0.75 THEN 'Ostrava'
            ELSE 'Plzeň'
        END,                                             -- CITY
        CASE 
            WHEN RAND() < 0.25 THEN FLOOR(10000 + RAND() * 10000)   -- ZIP for Prague (10000-19999)
            WHEN RAND() < 0.5 THEN FLOOR(60000 + RAND() * 10000)     -- ZIP for Brno (60000-69999)
            WHEN RAND() < 0.75 THEN FLOOR(70000 + RAND() * 10000)  -- ZIP for Ostrava (70000-79999)
            ELSE FLOOR(30000 + RAND() * 10000)                      -- ZIP for Plzeň (30000-39999)
        END                                              -- ZIP (dependent on city)
    );
$$

DELIMITER ;

SET GLOBAL event_scheduler = ON;
TABLE parties_analytics; 

-- DATA MART

DROP VIEW IF EXISTS Prague;
CREATE VIEW Prague AS
SELECT * FROM parties_analytics 
WHERE ZIP BETWEEN 10000 AND 19999;
SELECT * FROM Prague;

DROP VIEW IF EXISTS Klatovy;
CREATE VIEW Klatovy AS
SELECT * FROM parties_analytics 
WHERE ZIP BETWEEN 30000 AND 39999;
SELECT * FROM Klatovy;









