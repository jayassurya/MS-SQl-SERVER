-- DAY 8 - SET 1: BANK FUNDS TRANSFER
-- Run in SSMS. This setup intentionally recreates the assignment database/tables.

USE master;
GO
IF DB_ID(N'Hexaware_Day8_Bank') IS NOT NULL
BEGIN
    ALTER DATABASE Hexaware_Day8_Bank SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hexaware_Day8_Bank;
END;
GO
CREATE DATABASE Hexaware_Day8_Bank;
GO
ALTER DATABASE Hexaware_Day8_Bank SET ALLOW_SNAPSHOT_ISOLATION ON;
GO
USE Hexaware_Day8_Bank;
GO

CREATE TABLE dbo.Accounts
(
    AccountID INT NOT NULL PRIMARY KEY,
    AccountHolder NVARCHAR(100) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL CHECK (Balance >= 0),
    AccountStatus VARCHAR(10) NOT NULL CHECK (AccountStatus IN ('Active','Inactive'))
);

CREATE TABLE dbo.TransactionHistory
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL REFERENCES dbo.Accounts(AccountID),
    TransactionType VARCHAR(10) NOT NULL CHECK (TransactionType IN ('Debit','Credit','Fee')),
    Amount DECIMAL(12,2) NOT NULL CHECK (Amount > 0),
    TransactionDate DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    Description NVARCHAR(200) NULL
);

INSERT INTO dbo.Accounts(AccountID, AccountHolder, Balance, AccountStatus)
VALUES
(1001, N'Arun Kumar', 10000, 'Active'),
(1002, N'Priya Sharma', 5000, 'Active'),
(1003, N'Rahul Raj', 8000, 'Active'),
(1004, N'Divya S', 3000, 'Inactive');

-- TASK 1: successful transfer with validation and TRY/CATCH.
DECLARE @FromAccount INT = 1001, @ToAccount INT = 1002, @Amount DECIMAL(12,2) = 1000;
BEGIN TRY
    BEGIN TRANSACTION;

    IF @Amount <= 0 THROW 50001, 'Transfer amount must be positive.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE AccountID=@FromAccount AND AccountStatus='Active')
        THROW 50002, 'Source account is missing or inactive.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Accounts WHERE AccountID=@ToAccount AND AccountStatus='Active')
        THROW 50003, 'Destination account is missing or inactive.', 1;
    IF (SELECT Balance FROM dbo.Accounts WITH (UPDLOCK, HOLDLOCK) WHERE AccountID=@FromAccount) < @Amount
        THROW 50004, 'Insufficient funds.', 1;

    UPDATE dbo.Accounts SET Balance = Balance - @Amount WHERE AccountID=@FromAccount;
    UPDATE dbo.Accounts SET Balance = Balance + @Amount WHERE AccountID=@ToAccount;

    INSERT dbo.TransactionHistory(AccountID, TransactionType, Amount, Description)
    VALUES
    (@FromAccount, 'Debit', @Amount, N'Transfer to account 1002'),
    (@ToAccount, 'Credit', @Amount, N'Transfer from account 1001');

    COMMIT TRANSACTION;
    PRINT 'Task 1: transfer committed successfully.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Task 1 failed: ', ERROR_MESSAGE());
END CATCH;
GO

-- TASK 2: deliberate failure after debit. The debit must be rolled back.
DECLARE @BeforeSource DECIMAL(12,2), @BeforeTarget DECIMAL(12,2);
SELECT @BeforeSource=Balance FROM dbo.Accounts WHERE AccountID=1001;
SELECT @BeforeTarget=Balance FROM dbo.Accounts WHERE AccountID=1002;

BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.Accounts SET Balance = Balance - 2000 WHERE AccountID=1001;
    THROW 50010, 'Intentional failure after debit to demonstrate rollback.', 1;
    UPDATE dbo.Accounts SET Balance = Balance + 2000 WHERE AccountID=1002;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Task 2 expected failure: ', ERROR_MESSAGE());
END CATCH;

SELECT 'Task 2 rollback evidence' AS Evidence,
       @BeforeSource AS SourceBefore, a.Balance AS SourceAfter,
       @BeforeTarget AS TargetBefore, b.Balance AS TargetAfter
FROM dbo.Accounts a
CROSS JOIN dbo.Accounts b
WHERE a.AccountID=1001 AND b.AccountID=1002;

-- TASK 3: savepoint removes only fee posting; transfer is retained.
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Accounts SET Balance=Balance-500 WHERE AccountID=1001 AND AccountStatus='Active';
    IF @@ROWCOUNT <> 1 THROW 50011, 'Source account unavailable.', 1;
    UPDATE dbo.Accounts SET Balance=Balance+500 WHERE AccountID=1002 AND AccountStatus='Active';
    IF @@ROWCOUNT <> 1 THROW 50012, 'Destination account unavailable.', 1;

    INSERT dbo.TransactionHistory(AccountID, TransactionType, Amount, Description)
    VALUES
    (1001, 'Debit', 500, N'Savepoint transfer to account 1002'),
    (1002, 'Credit', 500, N'Savepoint transfer from account 1001');

    SAVE TRANSACTION BeforeFee;
    INSERT dbo.TransactionHistory(AccountID, TransactionType, Amount, Description)
    VALUES (1001, 'Fee', 50, N'Test fee posting - rolled back to savepoint');

    ROLLBACK TRANSACTION BeforeFee;
    COMMIT TRANSACTION;
    PRINT 'Task 3: transfer retained; fee posting rolled back.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Task 3 failed: ', ERROR_MESSAGE());
END CATCH;
GO

SELECT AccountID, AccountHolder, Balance, AccountStatus
FROM dbo.Accounts ORDER BY AccountID;

SELECT TransactionID, AccountID, TransactionType, Amount, TransactionDate, Description
FROM dbo.TransactionHistory ORDER BY TransactionID;
GO
