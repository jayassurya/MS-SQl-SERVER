
/* =========================================================
   HEXAWARE DAY 7 - SET 3
   RETAIL RETURNS AND REFUNDS
   Complete SQL Script
   ========================================================= */

-- 1. CREATE DATABASE
IF DB_ID('Hexaware_Day7_Retail') IS NULL
BEGIN
    CREATE DATABASE Hexaware_Day7_Retail;
END;
GO

USE Hexaware_Day7_Retail;
GO

-- 2. DROP EXISTING TABLES (FOR CLEAN RE-RUN)
DROP TABLE IF EXISTS Refunds;
DROP TABLE IF EXISTS Returns;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Stores;
GO

-- 3. CREATE TABLES

CREATE TABLE Stores (
    StoreID INT PRIMARY KEY,
    StoreName VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    StoreID INT,
    CustomerID INT,
    ProductID INT,
    QuantitySold INT,
    SaleDate DATE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    SaleID INT,
    StoreID INT,
    CustomerID INT,
    ProductID INT,
    EmployeeID INT,
    ReturnQuantity INT,
    ReturnDate DATE,
    ReturnReason VARCHAR(100),
    ReturnStatus VARCHAR(30),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Refunds (
    RefundID INT PRIMARY KEY,
    ReturnID INT,
    RefundAmount DECIMAL(10,2),
    RefundDate DATE,
    RefundStatus VARCHAR(30),
    FOREIGN KEY (ReturnID) REFERENCES Returns(ReturnID)
);
GO

-- 4. INSERT SAMPLE DATA

INSERT INTO Stores VALUES
(1, 'Chennai Central', 'Chennai', 'South'),
(2, 'Chennai North', 'Chennai', 'South'),
(3, 'Bangalore Store', 'Bangalore', 'South'),
(4, 'Mumbai Central', 'Mumbai', 'West'),
(5, 'Pune Store', 'Pune', 'West');

INSERT INTO Customers VALUES
(201, 'Arun Kumar', 'arun@gmail.com'),
(202, 'Priya Sharma', 'priya@gmail.com'),
(203, 'Rahul Raj', 'rahul@gmail.com'),
(204, 'Divya S', 'divya@gmail.com'),
(205, 'Karthik M', 'karthik@gmail.com'),
(206, 'Sneha R', 'sneha@gmail.com');

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Smartphone', 'Electronics', 25000),
(103, 'Headphones', 'Accessories', 3000),
(104, 'Monitor', 'Electronics', 12000),
(105, 'Keyboard', 'Accessories', 1500);

INSERT INTO Employees VALUES
(301, 'Ramesh', NULL),
(302, 'Suresh', 301),
(303, 'Meena', 301),
(304, 'Vijay', 301),
(305, 'Anitha', 302),
(306, 'Prakash', 302);

INSERT INTO Sales VALUES
(1, 1, 201, 101, 60, '2026-09-01'),
(2, 2, 202, 101, 40, '2026-09-02'),
(3, 1, 203, 101, 0,  '2026-09-03'),
(4, 3, 204, 102, 40, '2026-09-04'),
(5, 2, 205, 102, 40, '2026-09-05'),
(6, 1, 201, 103, 25, '2026-09-06'),
(7, 3, 206, 103, 25, '2026-09-07'),
(8, 4, 202, 104, 60, '2026-09-08'),
(9, 5, 203, 105, 20, '2026-09-09'),
(10, 5, 206, 105, 20, '2026-09-10'),
(11, 4, 204, 102, 0,  '2026-09-11'),
(12, 3, 205, 104, 0,  '2026-09-12');

-- Returns refer to the corresponding sales.
-- The sample quantities are chosen to demonstrate return-rate analysis.

INSERT INTO Returns VALUES
(1001, 1, 1, 201, 101, 302, 5, '2026-10-01', 'Damaged item', 'Approved'),
(1002, 2, 2, 202, 101, 303, 4, '2026-10-02', 'Defective item', 'Approved'),
(1003, 3, 1, 203, 101, 302, 6, '2026-10-03', 'Wrong product', 'Approved'),
(1004, 4, 3, 204, 102, 304, 2, '2026-10-04', 'Battery issue', 'Approved'),
(1005, 5, 2, 205, 102, 303, 2, '2026-10-05', 'Not satisfied', 'Approved'),
(1006, 6, 1, 201, 103, 302, 4, '2026-10-06', 'Sound issue', 'Approved'),
(1007, 7, 3, 206, 103, 304, 4, '2026-10-07', 'Damaged item', 'Approved'),
(1008, 8, 4, 202, 104, 305, 3, '2026-10-08', 'Display issue', 'Approved'),
(1009, 9, 5, 203, 105, 306, 3, '2026-10-09', 'Wrong item', 'Approved'),
(1010, 10, 5, 206, 105, 306, 3, '2026-10-10', 'Key issue', 'Approved');

INSERT INTO Refunds VALUES
(5001, 1001, 250.00, '2026-10-03', 'Completed'),
(5002, 1002, 300.00, '2026-10-04', 'Completed'),
(5003, 1004, 100.00, '2026-10-06', 'Completed'),
(5004, 1005, 150.00, '2026-10-07', 'Completed'),
(5005, 1007, 200.00, '2026-10-09', 'Completed'),
(5006, 1008, 350.00, '2026-10-10', 'Completed'),
(5007, 1009, 120.00, '2026-10-11', 'Completed'),
(5008, 1010, 180.00, '2026-10-12', 'Completed');
GO

/* =========================================================
   TASK 1 - TEN BUSINESS QUESTIONS / JOIN QUERIES
   ========================================================= */

-- Q1. Products with return rate above 10%
SELECT
    p.ProductID,
    p.ProductName,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    COALESCE(SUM(r.ReturnQuantity), 0) AS TotalUnitsReturned,
    CAST(
        COALESCE(SUM(r.ReturnQuantity), 0) * 100.0 /
        NULLIF(SUM(s.QuantitySold), 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage
FROM Products p
INNER JOIN Sales s
    ON p.ProductID = s.ProductID
LEFT JOIN Returns r
    ON s.SaleID = r.SaleID
GROUP BY p.ProductID, p.ProductName
HAVING
    COALESCE(SUM(r.ReturnQuantity), 0) * 100.0 /
    NULLIF(SUM(s.QuantitySold), 0) > 10;

-- Q2. Customers who have returns but no refund
SELECT DISTINCT
    c.CustomerID,
    c.CustomerName,
    r.ReturnID,
    r.ReturnReason
FROM Customers c
INNER JOIN Returns r
    ON c.CustomerID = r.CustomerID
LEFT JOIN Refunds rf
    ON r.ReturnID = rf.ReturnID
WHERE rf.RefundID IS NULL;

-- Q3. Stores with their total refund value, highest first
SELECT
    s.StoreID,
    s.StoreName,
    COALESCE(SUM(rf.RefundAmount), 0) AS TotalRefundValue
FROM Stores s
LEFT JOIN Returns r
    ON s.StoreID = r.StoreID
LEFT JOIN Refunds rf
    ON r.ReturnID = rf.ReturnID
GROUP BY s.StoreID, s.StoreName
ORDER BY TotalRefundValue DESC;

-- Q4. Employees and their managers (SELF JOIN)
SELECT
    e.EmployeeID,
    e.EmployeeName,
    m.EmployeeName AS ManagerName
FROM Employees e
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID;

-- Q5. Return details with customer, product and store
SELECT
    r.ReturnID,
    c.CustomerName,
    p.ProductName,
    s.StoreName,
    r.ReturnQuantity,
    r.ReturnReason,
    r.ReturnStatus
FROM Returns r
INNER JOIN Customers c
    ON r.CustomerID = c.CustomerID
INNER JOIN Products p
    ON r.ProductID = p.ProductID
INNER JOIN Stores s
    ON r.StoreID = s.StoreID;

-- Q6. Refund details with their return and customer
SELECT
    rf.RefundID,
    rf.RefundAmount,
    rf.RefundDate,
    rf.RefundStatus,
    r.ReturnID,
    c.CustomerName
FROM Refunds rf
INNER JOIN Returns r
    ON rf.ReturnID = r.ReturnID
INNER JOIN Customers c
    ON r.CustomerID = c.CustomerID;

-- Q7. Products that have never been returned
SELECT
    p.ProductID,
    p.ProductName
FROM Products p
LEFT JOIN Returns r
    ON p.ProductID = r.ProductID
WHERE r.ReturnID IS NULL;

-- Q8. Stores that have no returns
SELECT
    s.StoreID,
    s.StoreName
FROM Stores s
LEFT JOIN Returns r
    ON s.StoreID = r.StoreID
WHERE r.ReturnID IS NULL;

-- Q9. Number of returns handled by each employee
SELECT
    e.EmployeeID,
    e.EmployeeName,
    COUNT(r.ReturnID) AS TotalReturnsHandled
FROM Employees e
LEFT JOIN Returns r
    ON e.EmployeeID = r.EmployeeID
GROUP BY e.EmployeeID, e.EmployeeName
ORDER BY TotalReturnsHandled DESC;

-- Q10. All stores and their return/refund records
SELECT
    s.StoreName,
    r.ReturnID,
    rf.RefundID,
    rf.RefundAmount
FROM Stores s
FULL OUTER JOIN Returns r
    ON s.StoreID = r.StoreID
FULL OUTER JOIN Refunds rf
    ON r.ReturnID = rf.ReturnID;

/* =========================================================
   TASK 2 - IN, NOT IN, NULL PITFALL AND NOT EXISTS
   ========================================================= */

-- A. IN: Customers who have made at least one return
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Returns
);

-- B. NOT IN: Customers who have never made a return
SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Returns
);

-- C. Demonstration of the NULL problem with NOT IN
-- The subquery deliberately includes NULL.
-- This query returns no rows because NULL makes the
-- NOT IN comparison UNKNOWN for otherwise unmatched IDs.

SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID FROM Returns
    UNION ALL
    SELECT CAST(NULL AS INT)
);

-- D. Correct approach using NOT EXISTS
SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Returns r
    WHERE r.CustomerID = c.CustomerID
);

/* =========================================================
   TASK 3 - ANY AND ALL
   Compare each store's refunds with other stores
   in the same region.
   ========================================================= */

-- A. Stores whose refund total is greater than ANY
-- other store's refund total in the same region.

WITH StoreRefunds AS (
    SELECT
        s.StoreID,
        s.StoreName,
        s.Region,
        COALESCE(SUM(rf.RefundAmount), 0) AS TotalRefunds
    FROM Stores s
    LEFT JOIN Returns r
        ON s.StoreID = r.StoreID
    LEFT JOIN Refunds rf
        ON r.ReturnID = rf.ReturnID
    GROUP BY s.StoreID, s.StoreName, s.Region
)
SELECT
    sr.StoreID,
    sr.StoreName,
    sr.Region,
    sr.TotalRefunds
FROM StoreRefunds sr
WHERE sr.TotalRefunds > ANY (
    SELECT other.TotalRefunds
    FROM StoreRefunds other
    WHERE other.Region = sr.Region
      AND other.StoreID <> sr.StoreID
);

-- B. Stores whose refund total is greater than ALL
-- other store refund totals in the same region.

WITH StoreRefunds AS (
    SELECT
        s.StoreID,
        s.StoreName,
        s.Region,
        COALESCE(SUM(rf.RefundAmount), 0) AS TotalRefunds
    FROM Stores s
    LEFT JOIN Returns r
        ON s.StoreID = r.StoreID
    LEFT JOIN Refunds rf
        ON r.ReturnID = rf.ReturnID
    GROUP BY s.StoreID, s.StoreName, s.Region
)
SELECT
    sr.StoreID,
    sr.StoreName,
    sr.Region,
    sr.TotalRefunds
FROM StoreRefunds sr
WHERE sr.TotalRefunds > ALL (
    SELECT other.TotalRefunds
    FROM StoreRefunds other
    WHERE other.Region = sr.Region
      AND other.StoreID <> sr.StoreID
);

/* =========================================================
   TASK 4 - TWO NESTED SUBQUERIES
   ========================================================= */

-- Nested Subquery 1:
-- Stores whose refund total is greater than the
-- average refund total of stores in the same region.

SELECT
    s.StoreID,
    s.StoreName,
    s.Region,
    (
        SELECT COALESCE(SUM(rf.RefundAmount), 0)
        FROM Returns r
        INNER JOIN Refunds rf
            ON r.ReturnID = rf.ReturnID
        WHERE r.StoreID = s.StoreID
    ) AS TotalRefunds
FROM Stores s
WHERE
    (
        SELECT COALESCE(SUM(rf.RefundAmount), 0)
        FROM Returns r
        INNER JOIN Refunds rf
            ON r.ReturnID = rf.ReturnID
        WHERE r.StoreID = s.StoreID
    ) >
    (
        SELECT AVG(RegionalTotals.TotalRefunds)
        FROM (
            SELECT
                st.StoreID,
                COALESCE(SUM(rf2.RefundAmount), 0) AS TotalRefunds
            FROM Stores st
            LEFT JOIN Returns r2
                ON st.StoreID = r2.StoreID
            LEFT JOIN Refunds rf2
                ON r2.ReturnID = rf2.ReturnID
            WHERE st.Region = s.Region
            GROUP BY st.StoreID
        ) AS RegionalTotals
    );

-- Nested Subquery 2:
-- Products whose returned quantity is greater than
-- the average returned quantity per product.

SELECT
    p.ProductID,
    p.ProductName,
    (
        SELECT COALESCE(SUM(r.ReturnQuantity), 0)
        FROM Returns r
        WHERE r.ProductID = p.ProductID
    ) AS TotalReturnedQuantity
FROM Products p
WHERE
    (
        SELECT COALESCE(SUM(r.ReturnQuantity), 0)
        FROM Returns r
        WHERE r.ProductID = p.ProductID
    ) >
    (
        SELECT AVG(ProductReturns.TotalReturned)
        FROM (
            SELECT
                p2.ProductID,
                COALESCE(SUM(r2.ReturnQuantity), 0) AS TotalReturned
            FROM Products p2
            LEFT JOIN Returns r2
                ON p2.ProductID = r2.ProductID
            GROUP BY p2.ProductID
        ) AS ProductReturns
    );

-- 5. FINAL VERIFICATION

SELECT 'Stores' AS TableName, COUNT(*) AS TotalRecords FROM Stores
UNION ALL
SELECT 'Customers', COUNT(*) FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Employees', COUNT(*) FROM Employees
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales
UNION ALL
SELECT 'Returns', COUNT(*) FROM Returns
UNION ALL
SELECT 'Refunds', COUNT(*) FROM Refunds;
GO
