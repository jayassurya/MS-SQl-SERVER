
USE BankBranchDB;
GO

-- Create an isolated test table
IF OBJECT_ID('DeletionTest', 'U') IS NOT NULL
    DROP TABLE DeletionTest;
GO

CREATE TABLE DeletionTest (
    test_id INT IDENTITY(1,1) PRIMARY KEY,
    test_name VARCHAR(50)
);
GO

-- Insert initial records
INSERT INTO DeletionTest (test_name)
VALUES ('Record A'), ('Record B'), ('Record C');
GO

-- Check initial records and identity values
SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- TEST 1: DELETE
--------------------------------------------------

-- DELETE removes rows but does not reset identity.
DELETE FROM DeletionTest
WHERE test_id = 3;

SELECT * FROM DeletionTest;
GO

-- Next inserted ID should be 4
INSERT INTO DeletionTest (test_name)
VALUES ('After Delete');

SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- TEST 2: TRUNCATE
--------------------------------------------------

-- TRUNCATE removes all rows and resets identity.
TRUNCATE TABLE DeletionTest;

SELECT * FROM DeletionTest;
GO

-- Next inserted ID should be 1
INSERT INTO DeletionTest (test_name)
VALUES ('After Truncate');

SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- TEST 3: ROLLBACK DELETE
--------------------------------------------------

INSERT INTO DeletionTest (test_name)
VALUES ('Rollback Delete A'), ('Rollback Delete B');

BEGIN TRANSACTION;

DELETE FROM DeletionTest;

SELECT * FROM DeletionTest;
-- Table is temporarily empty.

ROLLBACK TRANSACTION;

-- Original rows are restored
SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- TEST 4: ROLLBACK TRUNCATE
--------------------------------------------------

BEGIN TRANSACTION;

TRUNCATE TABLE DeletionTest;

SELECT * FROM DeletionTest;
-- Table is temporarily empty.

ROLLBACK TRANSACTION;

-- Rows are restored
SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- TEST 5: ROLLBACK DROP
--------------------------------------------------

BEGIN TRANSACTION;

DROP TABLE DeletionTest;

-- The table is temporarily dropped.

ROLLBACK TRANSACTION;

-- The table and its data are restored
SELECT * FROM DeletionTest;
GO

--------------------------------------------------
-- FINAL IDENTITY CHECK
--------------------------------------------------

SELECT
    IDENT_CURRENT('DeletionTest') AS CurrentIdentityValue;

GO
