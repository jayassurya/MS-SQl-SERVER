
USE Hexaware_Day7_Logistics;
GO

/* ============================================================
   DAY 7 - SET 1: LOGISTICS SHIPMENT ANALYSIS
   SQL Server 2025
   Tasks 1, 2, 3 and 4
   ============================================================ */


/* ============================================================
   TASK 1: TEN BUSINESS QUESTIONS USING JOINS
   ============================================================ */


/* Q1. Find shipments delayed by more than two days,
       including their carrier names.
       JOIN TYPE: INNER JOIN
*/

SELECT
    s.ShipmentID,
    c.CarrierName,
    s.ExpectedDeliveryDate,
    s.ActualDeliveryDate,
    DATEDIFF(DAY, s.ExpectedDeliveryDate,
             s.ActualDeliveryDate) AS DelayDays
FROM Shipments s
INNER JOIN Carriers c
    ON s.CarrierID = c.CarrierID
WHERE s.ActualDeliveryDate IS NOT NULL
  AND DATEDIFF(DAY, s.ExpectedDeliveryDate,
               s.ActualDeliveryDate) > 2
ORDER BY DelayDays DESC;


/* Q2. Find hubs that have no outbound shipments.
       JOIN TYPE: LEFT JOIN
*/

SELECT
    h.HubID,
    h.HubName,
    h.City
FROM Hubs h
LEFT JOIN Shipments s
    ON h.HubID = s.OriginHubID
WHERE s.ShipmentID IS NULL;


/* Q3. Display employees along with their supervisors.
       JOIN TYPE: SELF JOIN
*/

SELECT
    e.EmployeeID,
    e.EmployeeName,
    m.EmployeeName AS SupervisorName
FROM Employees e
LEFT JOIN Employees m
    ON e.SupervisorID = m.EmployeeID
ORDER BY e.EmployeeID;


/* Q4. Display complete shipment information:
       customer, carrier, origin hub and destination hub.
       JOIN TYPE: MULTIPLE INNER JOINS
*/

SELECT
    s.ShipmentID,
    cu.CustomerName,
    ca.CarrierName,
    oh.HubName AS OriginHub,
    dh.HubName AS DestinationHub,
    s.ShippingCost,
    s.ShipmentDate,
    s.ExpectedDeliveryDate,
    s.ActualDeliveryDate
FROM Shipments s
INNER JOIN Customers cu
    ON s.CustomerID = cu.CustomerID
INNER JOIN Carriers ca
    ON s.CarrierID = ca.CarrierID
INNER JOIN Hubs oh
    ON s.OriginHubID = oh.HubID
INNER JOIN Hubs dh
    ON s.DestinationHubID = dh.HubID
ORDER BY s.ShipmentID;


/* Q5. Count outbound shipments from each hub,
       including hubs with zero outbound shipments.
       JOIN TYPE: LEFT JOIN
*/

SELECT
    h.HubID,
    h.HubName,
    COUNT(s.ShipmentID) AS TotalOutboundShipments
FROM Hubs h
LEFT JOIN Shipments s
    ON h.HubID = s.OriginHubID
GROUP BY h.HubID, h.HubName
ORDER BY TotalOutboundShipments DESC;


/* Q6. Display all hubs and their outbound shipments.
       Include hubs without shipments.
       JOIN TYPE: FULL OUTER JOIN
*/

SELECT
    h.HubID,
    h.HubName,
    s.ShipmentID,
    s.ShippingCost
FROM Hubs h
FULL OUTER JOIN Shipments s
    ON h.HubID = s.OriginHubID
ORDER BY h.HubID, s.ShipmentID;


/* Q7. Find customers who have made more than one shipment.
       JOIN TYPE: INNER JOIN
*/

SELECT
    cu.CustomerID,
    cu.CustomerName,
    COUNT(s.ShipmentID) AS TotalShipments
FROM Customers cu
INNER JOIN Shipments s
    ON cu.CustomerID = s.CustomerID
GROUP BY cu.CustomerID, cu.CustomerName
HAVING COUNT(s.ShipmentID) > 1
ORDER BY TotalShipments DESC;


/* Q8. Display shipment details with their delivery events.
       JOIN TYPE: INNER JOIN
*/

SELECT
    s.ShipmentID,
    de.EventID,
    de.EventType,
    de.EventLocation,
    de.EventTimestamp
FROM Shipments s
INNER JOIN DeliveryEvents de
    ON s.ShipmentID = de.ShipmentID
ORDER BY s.ShipmentID, de.EventTimestamp;


/* Q9. Find shipments that do not have any delivery events.
       JOIN TYPE: LEFT JOIN
*/

SELECT
    s.ShipmentID,
    s.CustomerID,
    s.CarrierID,
    s.ShipmentDate
FROM Shipments s
LEFT JOIN DeliveryEvents de
    ON s.ShipmentID = de.ShipmentID
WHERE de.EventID IS NULL;


/* Q10. Display shipment count and average shipping cost
        for every carrier, including carriers with no shipments.
        JOIN TYPE: LEFT JOIN
*/

SELECT
    c.CarrierID,
    c.CarrierName,
    COUNT(s.ShipmentID) AS TotalShipments,
    AVG(s.ShippingCost) AS AverageShippingCost
FROM Carriers c
LEFT JOIN Shipments s
    ON c.CarrierID = s.CarrierID
GROUP BY c.CarrierID, c.CarrierName
ORDER BY TotalShipments DESC;


/* ============================================================
   TASK 2: SUBQUERIES - IN, EXISTS, ANY AND ALL
   ============================================================ */


/* Q1. Find customers who have shipped to every hub.
       OPERATOR: IN
*/

SELECT
    CustomerID,
    CustomerName
FROM Customers
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Shipments
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT DestinationHubID) =
           (SELECT COUNT(*) FROM Hubs)
);


/* Q2. Find customers who have shipped to every hub.
       OPERATOR: EXISTS
       Uses double NOT EXISTS to check every hub.
*/

SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Hubs h
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Shipments s
        WHERE s.CustomerID = c.CustomerID
          AND s.DestinationHubID = h.HubID
    )
);


/* Q3. Find carriers whose average delivery delay
       is above the overall average delivery delay.
       OPERATOR: ANY
*/

SELECT
    c.CarrierID,
    c.CarrierName,
    AVG(CAST(
        DATEDIFF(DAY, s.ExpectedDeliveryDate,
                 s.ActualDeliveryDate) AS DECIMAL(10,2)
    )) AS AverageDelayDays
FROM Carriers c
INNER JOIN Shipments s
    ON c.CarrierID = s.CarrierID
WHERE s.ActualDeliveryDate IS NOT NULL
GROUP BY c.CarrierID, c.CarrierName
HAVING AVG(CAST(
    DATEDIFF(DAY, s.ExpectedDeliveryDate,
             s.ActualDeliveryDate) AS DECIMAL(10,2)
))
>
ANY
(
    SELECT AVG(CAST(
        DATEDIFF(DAY, ExpectedDeliveryDate,
                 ActualDeliveryDate) AS DECIMAL(10,2)
    ))
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);


/* Q4. Find carriers whose average delivery delay
       is above the overall average delivery delay.
       OPERATOR: ALL
*/

SELECT
    c.CarrierID,
    c.CarrierName,
    AVG(CAST(
        DATEDIFF(DAY, s.ExpectedDeliveryDate,
                 s.ActualDeliveryDate) AS DECIMAL(10,2)
    )) AS AverageDelayDays
FROM Carriers c
INNER JOIN Shipments s
    ON c.CarrierID = s.CarrierID
WHERE s.ActualDeliveryDate IS NOT NULL
GROUP BY c.CarrierID, c.CarrierName
HAVING AVG(CAST(
    DATEDIFF(DAY, s.ExpectedDeliveryDate,
             s.ActualDeliveryDate) AS DECIMAL(10,2)
))
>
ALL
(
    SELECT AVG(CAST(
        DATEDIFF(DAY, ExpectedDeliveryDate,
                 ActualDeliveryDate) AS DECIMAL(10,2)
    ))
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
);


/* Verification: calculate overall average delivery delay. */

SELECT
    AVG(CAST(
        DATEDIFF(DAY, ExpectedDeliveryDate,
                 ActualDeliveryDate) AS DECIMAL(10,2)
    )) AS OverallAverageDelayDays
FROM Shipments
WHERE ActualDeliveryDate IS NOT NULL;


/* ============================================================
   TASK 3: REWRITE TWO SUBQUERIES AS JOINS
   ============================================================ */


/* Q1. JOIN REWRITE:
       Find customers who have shipped to every hub.

       Uses CROSS JOIN and LEFT JOIN instead of IN/NOT EXISTS.
*/

SELECT
    c.CustomerID,
    c.CustomerName
FROM Customers c
CROSS JOIN Hubs required_hubs
LEFT JOIN Shipments s
    ON s.CustomerID = c.CustomerID
   AND s.DestinationHubID = required_hubs.HubID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT s.DestinationHubID) =
       COUNT(DISTINCT required_hubs.HubID);


/* Q2. JOIN REWRITE:
       Find carriers whose average delay is above
       the overall average delay.

       Uses CTEs and CROSS JOIN instead of ANY/ALL.
*/

WITH OverallAverage AS
(
    SELECT
        AVG(CAST(
            DATEDIFF(DAY, ExpectedDeliveryDate,
                     ActualDeliveryDate) AS DECIMAL(10,2)
        )) AS OverallDelay
    FROM Shipments
    WHERE ActualDeliveryDate IS NOT NULL
),
CarrierAverage AS
(
    SELECT
        c.CarrierID,
        c.CarrierName,
        AVG(CAST(
            DATEDIFF(DAY, s.ExpectedDeliveryDate,
                     s.ActualDeliveryDate) AS DECIMAL(10,2)
        )) AS AverageDelay
    FROM Carriers c
    INNER JOIN Shipments s
        ON c.CarrierID = s.CarrierID
    WHERE s.ActualDeliveryDate IS NOT NULL
    GROUP BY c.CarrierID, c.CarrierName
)
SELECT
    ca.CarrierID,
    ca.CarrierName,
    ca.AverageDelay,
    oa.OverallDelay
FROM CarrierAverage ca
CROSS JOIN OverallAverage oa
WHERE ca.AverageDelay > oa.OverallDelay;


/* Comparison:
   - JOINs are useful when information from multiple tables
     must be displayed together.
   - IN is useful for checking whether a value belongs
     to a result set.
   - EXISTS is useful for checking whether matching rows exist.
   - JOIN-based rewrites can be easier to inspect when
     several related columns are needed.
   - EXISTS can be more readable for pure existence checks.
   - Actual performance depends on indexes, data volume
     and the SQL Server query optimizer.
*/


/* ============================================================
   TASK 4: NESTED SUBQUERY
   Find the second-highest shipping cost per origin hub.

   The inner subquery finds the highest shipping cost.
   The outer subquery finds the maximum cost below that value.
   This returns the second-highest DISTINCT cost per hub.
   ============================================================ */

SELECT
    h.HubID,
    h.HubName,
    (
        SELECT MAX(s1.ShippingCost)
        FROM Shipments s1
        WHERE s1.OriginHubID = h.HubID
          AND s1.ShippingCost <
          (
              SELECT MAX(s2.ShippingCost)
              FROM Shipments s2
              WHERE s2.OriginHubID = h.HubID
          )
    ) AS SecondHighestShippingCost
FROM Hubs h
WHERE EXISTS
(
    SELECT 1
    FROM Shipments s
    WHERE s.OriginHubID = h.HubID
      AND s.ShippingCost <
      (
          SELECT MAX(s2.ShippingCost)
          FROM Shipments s2
          WHERE s2.OriginHubID = h.HubID
      )
)
ORDER BY h.HubID;


/* ============================================================
   END OF DAY 7 - SET 1 SQL REPORTS
   ============================================================ */
