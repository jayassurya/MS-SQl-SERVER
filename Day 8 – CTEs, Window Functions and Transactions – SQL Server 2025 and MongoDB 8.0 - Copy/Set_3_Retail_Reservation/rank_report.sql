-- DAY 8 - SET 3: PRODUCT SALES RANKING AND MONTH-ON-MONTH CHANGE
-- Run reservation.sql first.

USE Hexaware_Day8_Retail;
GO

-- Aggregate monthly sales per product, then rank products within each category.
;WITH MonthlySales AS
(
    SELECT p.ProductID, p.ProductName, p.CategoryID,
           DATEFROMPARTS(YEAR(s.SaleDate),MONTH(s.SaleDate),1) AS SalesMonth,
           SUM(s.Quantity) AS UnitsSold,
           SUM(s.Quantity*s.UnitPrice) AS Revenue
    FROM dbo.Sales s
    JOIN dbo.Products p ON p.ProductID=s.ProductID
    GROUP BY p.ProductID,p.ProductName,p.CategoryID,
             DATEFROMPARTS(YEAR(s.SaleDate),MONTH(s.SaleDate),1)
),
ProductTotals AS
(
    SELECT ProductID, ProductName, CategoryID,
           SUM(UnitsSold) AS TotalUnitsSold,
           SUM(Revenue) AS TotalRevenue
    FROM MonthlySales
    GROUP BY ProductID,ProductName,CategoryID
),
RankedProducts AS
(
    SELECT pt.*, c.CategoryName,
           ROW_NUMBER() OVER
             (PARTITION BY pt.CategoryID ORDER BY pt.TotalUnitsSold DESC, pt.ProductID) AS CategoryRank
    FROM ProductTotals pt
    JOIN dbo.Categories c ON c.CategoryID=pt.CategoryID
)
SELECT CategoryName, ProductID, ProductName, TotalUnitsSold, TotalRevenue, CategoryRank
FROM RankedProducts
WHERE CategoryRank <= 3
ORDER BY CategoryName, CategoryRank;
GO

-- LEAD/LAG: monthly sales change for each product.
;WITH MonthlySales AS
(
    SELECT p.ProductID, p.ProductName,
           DATEFROMPARTS(YEAR(s.SaleDate),MONTH(s.SaleDate),1) AS SalesMonth,
           SUM(s.Quantity*s.UnitPrice) AS MonthlyRevenue
    FROM dbo.Sales s
    JOIN dbo.Products p ON p.ProductID=s.ProductID
    GROUP BY p.ProductID,p.ProductName,
             DATEFROMPARTS(YEAR(s.SaleDate),MONTH(s.SaleDate),1)
),
MonthComparison AS
(
    SELECT ProductID,ProductName,SalesMonth,MonthlyRevenue,
           LAG(MonthlyRevenue) OVER(PARTITION BY ProductID ORDER BY SalesMonth) AS PreviousMonthRevenue,
           LEAD(MonthlyRevenue) OVER(PARTITION BY ProductID ORDER BY SalesMonth) AS NextMonthRevenue
    FROM MonthlySales
)
SELECT ProductID,ProductName,SalesMonth,MonthlyRevenue,
       PreviousMonthRevenue,
       MonthlyRevenue-PreviousMonthRevenue AS ChangeFromPreviousMonth,
       NextMonthRevenue
FROM MonthComparison
ORDER BY ProductID,SalesMonth;
GO
