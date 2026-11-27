-- DAY 8 - SET 1: MONTHLY STATEMENT USING CTE, ROW_NUMBER AND LAG
-- Run transfer.sql first. This report uses the bank database created there.

USE Hexaware_Day8_Bank;
GO

;WITH OpeningBalances AS
(
    SELECT AccountID,
           CASE AccountID
             WHEN 1001 THEN CAST(10000.00 AS DECIMAL(12,2))
             WHEN 1002 THEN CAST(5000.00 AS DECIMAL(12,2))
             WHEN 1003 THEN CAST(8000.00 AS DECIMAL(12,2))
             WHEN 1004 THEN CAST(3000.00 AS DECIMAL(12,2))
           END AS OpeningBalance
    FROM dbo.Accounts
),
Ledger AS
(
    SELECT th.TransactionID, th.AccountID, th.TransactionType,
           th.Amount, th.TransactionDate, th.Description,
           CASE WHEN th.TransactionType='Credit' THEN th.Amount
                ELSE -th.Amount END AS SignedAmount
    FROM dbo.TransactionHistory th
),
Balances AS
(
    SELECT l.*,
           ob.OpeningBalance
           + SUM(l.SignedAmount) OVER
             (PARTITION BY l.AccountID ORDER BY l.TransactionDate, l.TransactionID
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS BalanceAfter
    FROM Ledger l
    JOIN OpeningBalances ob ON ob.AccountID=l.AccountID
),
MonthlyRows AS
(
    SELECT *,
           ROW_NUMBER() OVER
             (PARTITION BY AccountID ORDER BY TransactionDate, TransactionID) AS RowNumInStatement,
           LAG(BalanceAfter) OVER
             (PARTITION BY AccountID ORDER BY TransactionDate, TransactionID) AS PreviousBalance
    FROM Balances
    WHERE TransactionDate >= DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
      AND TransactionDate < DATEADD(MONTH, 1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
)
SELECT AccountID, RowNumInStatement, TransactionID, TransactionDate,
       TransactionType, Amount,
       COALESCE(PreviousBalance,
                BalanceAfter - CASE WHEN TransactionType='Credit' THEN Amount ELSE -Amount END)
           AS BalanceBefore,
       BalanceAfter, Description
FROM MonthlyRows
ORDER BY AccountID, TransactionDate, TransactionID;
GO
