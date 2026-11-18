
USE RetailSalesDB;
GO

--------------------------------------------------
-- QUERY 1: TOP 5 PRODUCTS BY REVENUE
--------------------------------------------------

SELECT TOP 5
    P.product_name,
    SUM(OI.quantity * OI.unit_price) AS TotalRevenue
FROM Products P
INNER JOIN OrderItems OI
    ON P.product_id = OI.product_id
GROUP BY P.product_id, P.product_name
ORDER BY TotalRevenue DESC;
GO

--------------------------------------------------
-- QUERY 2: MONTH-WISE SALES
--------------------------------------------------

SELECT
    FORMAT(O.order_date, 'yyyy-MM') AS SalesMonth,
    ROUND(
        SUM(OI.quantity * OI.unit_price), 2
    ) AS MonthlyRevenue
FROM Orders O
INNER JOIN OrderItems OI
    ON O.order_id = OI.order_id
GROUP BY FORMAT(O.order_date, 'yyyy-MM')
ORDER BY SalesMonth;
GO

--------------------------------------------------
-- QUERY 3: CUSTOMERS WITH MORE THAN 3 ORDERS
-- Using HAVING
--------------------------------------------------

SELECT
    C.customer_name,
    COUNT(O.order_id) AS TotalOrders
FROM Customers C
INNER JOIN Orders O
    ON C.customer_id = O.customer_id
GROUP BY C.customer_id, C.customer_name
HAVING COUNT(O.order_id) > 3;
GO

--------------------------------------------------
-- QUERY 4: AVERAGE BASKET VALUE PER CITY
--------------------------------------------------

WITH OrderTotals AS (
    SELECT
        O.order_id,
        C.city,
        SUM(OI.quantity * OI.unit_price) AS OrderValue
    FROM Orders O
    INNER JOIN Customers C
        ON O.customer_id = C.customer_id
    INNER JOIN OrderItems OI
        ON O.order_id = OI.order_id
    GROUP BY O.order_id, C.city
)
SELECT
    city,
    ROUND(AVG(OrderValue), 2) AS AverageBasketValue
FROM OrderTotals
GROUP BY city
ORDER BY AverageBasketValue DESC;
GO

--------------------------------------------------
-- QUERY 5: ORDERS WITHOUT PAYMENT
-- Using LEFT JOIN
--------------------------------------------------

SELECT
    O.order_id,
    C.customer_name,
    O.order_date
FROM Orders O
INNER JOIN Customers C
    ON O.customer_id = C.customer_id
LEFT JOIN Payments P
    ON O.order_id = P.order_id
WHERE P.payment_id IS NULL;
GO

--------------------------------------------------
-- QUERY 6: CUSTOMERS WITH NO ORDERS
--------------------------------------------------

SELECT
    C.customer_id,
    C.customer_name,
    C.city
FROM Customers C
LEFT JOIN Orders O
    ON C.customer_id = O.customer_id
WHERE O.order_id IS NULL;
GO

--------------------------------------------------
-- QUERY 7: PRODUCT CATEGORY REVENUE SHARE
--------------------------------------------------

WITH CategorySales AS (
    SELECT
        C.category_name,
        SUM(OI.quantity * OI.unit_price) AS CategoryRevenue
    FROM Categories C
    INNER JOIN Products P
        ON C.category_id = P.category_id
    INNER JOIN OrderItems OI
        ON P.product_id = OI.product_id
    GROUP BY C.category_id, C.category_name
)
SELECT
    category_name,
    CategoryRevenue,
    ROUND(
        CategoryRevenue * 100.0 /
        SUM(CategoryRevenue) OVER (), 2
    ) AS RevenueSharePercentage
FROM CategorySales
ORDER BY CategoryRevenue DESC;
GO

--------------------------------------------------
-- QUERY 8: DAY WITH HIGHEST SALES
--------------------------------------------------

SELECT TOP 1
    O.order_date,
    SUM(OI.quantity * OI.unit_price) AS DailyRevenue
FROM Orders O
INNER JOIN OrderItems OI
    ON O.order_id = OI.order_id
GROUP BY O.order_date
ORDER BY DailyRevenue DESC;
GO

--------------------------------------------------
-- ADDITIONAL REQUIREMENT:
-- STRING, DATE AND MATHEMATICAL FUNCTIONS
--------------------------------------------------

SELECT
    UPPER(C.customer_name) AS CustomerName,
    CONCAT(C.customer_name, ' - ', C.city) AS CustomerDetails,
    O.order_date,
    DATEDIFF(DAY, O.order_date, GETDATE()) AS DaysSinceOrder,
    FORMAT(O.order_date, 'dd-MMM-yyyy') AS FormattedOrderDate,
    ROUND(
        SUM(OI.quantity * OI.unit_price), 2
    ) AS OrderTotal
FROM Customers C
INNER JOIN Orders O
    ON C.customer_id = O.customer_id
INNER JOIN OrderItems OI
    ON O.order_id = OI.order_id
GROUP BY
    C.customer_name,
    C.city,
    O.order_id,
    O.order_date;
GO

--------------------------------------------------
-- NULL BEHAVIOUR:
-- COUNT(*), COUNT(column), AVG(column)
--------------------------------------------------

SELECT
    COUNT(*) AS TotalOrders,
    COUNT(P.payment_id) AS OrdersWithPayment,
    COUNT(P.payment_amount) AS NonNullPaymentAmounts,
    AVG(P.payment_amount) AS AveragePaymentAmount
FROM Orders O
LEFT JOIN Payments P
    ON O.order_id = P.order_id;
GO

--------------------------------------------------
-- NULL BEHAVIOUR IN AVERAGE:
-- Compare payment averages
--------------------------------------------------

SELECT
    AVG(P.payment_amount) AS AverageOfExistingPayments,
    SUM(P.payment_amount) /
        CAST(COUNT(*) AS DECIMAL(10,2))
        AS AverageIncludingUnpaidOrdersAsZero
FROM Orders O
LEFT JOIN Payments P
    ON O.order_id = P.order_id;
GO
