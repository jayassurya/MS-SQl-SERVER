-- DAY 8 - SET 3: RETAIL INVENTORY RESERVATION
-- Run in SSMS. This setup intentionally recreates the assignment database/tables.

USE master;
GO
IF DB_ID(N'Hexaware_Day8_Retail') IS NOT NULL
BEGIN
    ALTER DATABASE Hexaware_Day8_Retail SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hexaware_Day8_Retail;
END;
GO
CREATE DATABASE Hexaware_Day8_Retail;
GO
USE Hexaware_Day8_Retail;
GO

CREATE TABLE dbo.Categories
(
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE dbo.Products
(
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL REFERENCES dbo.Categories(CategoryID),
    Stock INT NOT NULL CHECK (Stock >= 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0)
);
CREATE TABLE dbo.Orders
(
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    OrderDate DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    OrderStatus VARCHAR(15) NOT NULL CHECK (OrderStatus IN ('Placed','Cancelled'))
);
CREATE TABLE dbo.OrderLines
(
    OrderLineID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL REFERENCES dbo.Orders(OrderID),
    ProductID INT NOT NULL REFERENCES dbo.Products(ProductID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0)
);
CREATE TABLE dbo.Sales
(
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL REFERENCES dbo.Products(ProductID),
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0)
);

INSERT dbo.Categories VALUES (1,N'Electronics'),(2,N'Accessories'),(3,N'Home');
INSERT dbo.Products VALUES
(101,N'Laptop',1,20,55000),(102,N'Monitor',1,35,12000),(103,N'Keyboard',2,8,1500),
(104,N'Mouse',2,60,700),(105,N'Desk Lamp',3,12,1800),(106,N'Chair',3,30,4500);

INSERT dbo.Sales(ProductID,SaleDate,Quantity,UnitPrice) VALUES
(101,'2026-09-05',2,55000),(101,'2026-10-10',3,55000),(101,'2026-11-02',1,55000),
(102,'2026-09-07',4,12000),(102,'2026-10-12',2,12000),(102,'2026-11-05',5,12000),
(103,'2026-09-09',5,1500),(103,'2026-10-15',8,1500),(103,'2026-11-08',4,1500),
(104,'2026-09-11',10,700),(104,'2026-10-17',7,700),(104,'2026-11-10',9,700),
(105,'2026-09-13',3,1800),(105,'2026-10-19',4,1800),(105,'2026-11-12',2,1800),
(106,'2026-09-15',1,4500),(106,'2026-10-21',2,4500),(106,'2026-11-14',3,4500);

-- TASK 1: reserve stock and create order + order lines atomically.
DECLARE @Customer NVARCHAR(100)=N'Kavya', @ProductID INT=101, @Qty INT=2,
        @OrderID INT, @Price DECIMAL(10,2);
BEGIN TRY
    BEGIN TRANSACTION;

    SELECT @Price=UnitPrice FROM dbo.Products WITH (UPDLOCK, HOLDLOCK)
    WHERE ProductID=@ProductID AND Stock >= @Qty;
    IF @Price IS NULL THROW 52001, 'Insufficient stock or invalid product.', 1;

    UPDATE dbo.Products SET Stock=Stock-@Qty
    WHERE ProductID=@ProductID AND Stock >= @Qty;
    IF @@ROWCOUNT <> 1 THROW 52002, 'Stock reservation failed.', 1;

    INSERT dbo.Orders(CustomerName,OrderStatus) VALUES(@Customer,'Placed');
    SET @OrderID=SCOPE_IDENTITY();

    INSERT dbo.OrderLines(OrderID,ProductID,Quantity,UnitPrice)
    VALUES(@OrderID,@ProductID,@Qty,@Price);

    COMMIT TRANSACTION;
    PRINT 'Order placed and stock reserved.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Order failed: ',ERROR_MESSAGE());
END CATCH;
GO

-- Rollback proof: product 103 has only 8 units. Requesting 100 must fail.
DECLARE @StockBefore INT, @StockAfter INT;
SELECT @StockBefore=Stock FROM dbo.Products WHERE ProductID=103;
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE dbo.Products SET Stock=Stock-100
    WHERE ProductID=103 AND Stock>=100;
    IF @@ROWCOUNT <> 1 THROW 52010, 'Intentional insufficient-stock failure.', 1;
    INSERT dbo.Orders(CustomerName,OrderStatus) VALUES(N'Test rollback','Placed');
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    PRINT CONCAT('Expected rollback: ',ERROR_MESSAGE());
END CATCH;
SELECT @StockAfter=Stock FROM dbo.Products WHERE ProductID=103;
SELECT 'Rollback evidence' AS Evidence, @StockBefore AS StockBefore, @StockAfter AS StockAfter;

-- TASK 2: correlated subquery - stock below average in the same category.
SELECT p.ProductID, p.ProductName, c.CategoryName, p.Stock
FROM dbo.Products p
JOIN dbo.Categories c ON c.CategoryID=p.CategoryID
WHERE p.Stock <
(
    SELECT AVG(CAST(p2.Stock AS DECIMAL(10,2)))
    FROM dbo.Products p2
    WHERE p2.CategoryID=p.CategoryID
);
GO
