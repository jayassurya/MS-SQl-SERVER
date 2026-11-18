
USE BankBranchDB;
GO

--------------------------------------------------
-- 1. VIEW ALL BANK ACCOUNTS
--------------------------------------------------

SELECT * FROM BankAccount;
GO

--------------------------------------------------
-- 2. RETRIEVE ACCOUNTS WITH BALANCE ABOVE 50000
--------------------------------------------------

SELECT *
FROM BankAccount
WHERE balance > 50000;
GO

--------------------------------------------------
-- 3. USING AND
-- Accounts with balance above 30000
-- AND belonging to branch 1
--------------------------------------------------

SELECT *
FROM BankAccount
WHERE balance > 30000
AND branch_id = 1;
GO

--------------------------------------------------
-- 4. USING OR
-- Accounts belonging to branch 1 OR branch 2
--------------------------------------------------

SELECT *
FROM BankAccount
WHERE branch_id = 1
OR branch_id = 2;
GO

--------------------------------------------------
-- 5. USING IN
-- Accounts belonging to selected account types
--------------------------------------------------

SELECT *
FROM BankAccount
WHERE account_type_id IN (1, 2, 3);
GO

--------------------------------------------------
-- 6. USING BETWEEN
-- Accounts with balance between 20000 and 100000
--------------------------------------------------

SELECT *
FROM BankAccount
WHERE balance BETWEEN 20000 AND 100000;
GO

--------------------------------------------------
-- 7. LAST QUARTER ACCOUNTS
-- Opened in the previous calendar quarter,
-- with balance above 30000
--------------------------------------------------

DECLARE @Today DATE = CAST(GETDATE() AS DATE);

DECLARE @CurrentQuarterStart DATE =
    DATEFROMPARTS(
        YEAR(@Today),
        ((DATEPART(QUARTER, @Today) - 1) * 3) + 1,
        1
    );

DECLARE @LastQuarterStart DATE =
    DATEADD(QUARTER, -1, @CurrentQuarterStart);

SELECT
    account_number,
    customer_id,
    balance,
    opened_date
FROM BankAccount
WHERE opened_date >= @LastQuarterStart
AND opened_date < @CurrentQuarterStart
AND balance > 30000;
GO

--------------------------------------------------
-- 8. JOIN ACCOUNT WITH CUSTOMER DETAILS
--------------------------------------------------

SELECT
    BA.account_number,
    C.customer_name,
    C.address,
    BA.balance,
    BA.opened_date
FROM BankAccount BA
INNER JOIN Customer C
    ON BA.customer_id = C.customer_id;
GO

--------------------------------------------------
-- 9. JOIN ACCOUNT WITH BRANCH AND MANAGER
--------------------------------------------------

SELECT
    BA.account_number,
    B.branch_name,
    RM.manager_name,
    BA.balance
FROM BankAccount BA
INNER JOIN Branch B
    ON BA.branch_id = B.branch_id
INNER JOIN RelationshipManager RM
    ON BA.manager_id = RM.manager_id;
GO

--------------------------------------------------
-- 10. COUNT ACCOUNTS BY ACCOUNT TYPE
--------------------------------------------------

SELECT
    AT.account_type_name,
    COUNT(BA.account_id) AS TotalAccounts
FROM AccountType AT
LEFT JOIN BankAccount BA
    ON AT.account_type_id = BA.account_type_id
GROUP BY AT.account_type_name;
GO

--------------------------------------------------
-- 11. VIEW TRANSACTION HISTORY
--------------------------------------------------

SELECT
    BA.account_number,
    T.transaction_type,
    T.amount,
    T.transaction_date,
    T.transaction_description
FROM AccountTransaction T
INNER JOIN BankAccount BA
    ON T.account_id = BA.account_id
ORDER BY T.transaction_date DESC;
GO
