
-- =====================================================
-- DAY 6 - SET 2: INSURANCE POLICY REPORTING
-- Database: InsuranceReportingDB
-- SQL Server 2025
-- =====================================================

USE InsuranceReportingDB;
GO


-- =====================================================
-- QUERY 1: POLICIES EXPIRING IN THE NEXT 30 DAYS
-- Functions: DATEADD, DATEDIFF, LEFT, RIGHT,
--            LEN, CONCAT, REPLICATE
-- =====================================================

SELECT
    P.policy_id,
    CONCAT(
        LEFT(P.policy_number, 3),
        REPLICATE('*', LEN(P.policy_number) - 6),
        RIGHT(P.policy_number, 3)
    ) AS masked_policy_number,
    C.customer_name,
    IP.product_name,
    P.end_date,
    DATEDIFF(DAY, CAST(GETDATE() AS DATE), P.end_date)
        AS days_until_expiry,
    DATEDIFF(DAY, P.start_date, CAST(GETDATE() AS DATE))
        AS policy_age_days
FROM Policies P
INNER JOIN Customers C
    ON P.customer_id = C.customer_id
INNER JOIN InsuranceProducts IP
    ON P.product_id = IP.product_id
WHERE
    P.policy_status = 'Active'
    AND P.end_date >= CAST(GETDATE() AS DATE)
    AND P.end_date <= DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
ORDER BY P.end_date ASC;
GO


-- =====================================================
-- QUERY 2: PREMIUM COLLECTED PER PRODUCT
-- Functions: SUM, GROUP BY, FORMAT, CONCAT, UPPER
-- =====================================================

SELECT
    IP.product_name,
    COUNT(DISTINCT P.policy_id) AS total_policies,
    SUM(PP.payment_amount) AS total_premium_collected,
    CONCAT(
        'INR ',
        FORMAT(SUM(PP.payment_amount), 'N2', 'en-IN')
    ) AS formatted_collection
FROM InsuranceProducts IP
INNER JOIN Policies P
    ON IP.product_id = P.product_id
INNER JOIN PremiumPayments PP
    ON P.policy_id = PP.policy_id
WHERE PP.payment_status = 'Paid'
GROUP BY IP.product_name
ORDER BY total_premium_collected DESC;
GO


-- =====================================================
-- QUERY 3: CUSTOMERS WITH MORE THAN ONE ACTIVE POLICY
-- Uses GROUP BY and HAVING
-- =====================================================

SELECT
    C.customer_id,
    UPPER(C.customer_name) AS customer_name,
    COUNT(P.policy_id) AS active_policy_count
FROM Customers C
INNER JOIN Policies P
    ON C.customer_id = P.customer_id
WHERE P.policy_status = 'Active'
GROUP BY
    C.customer_id,
    C.customer_name
HAVING COUNT(P.policy_id) > 1
ORDER BY active_policy_count DESC;
GO


-- =====================================================
-- QUERY 4: CLAIM RATIO PER INSURANCE PRODUCT
-- Claim ratio = Total claim amount / Premium collected
-- =====================================================

WITH PremiumCollected AS
(
    SELECT
        P.product_id,
        SUM(PP.payment_amount) AS total_premium
    FROM Policies P
    INNER JOIN PremiumPayments PP
        ON P.policy_id = PP.policy_id
    WHERE PP.payment_status = 'Paid'
    GROUP BY P.product_id
),
ProductClaims AS
(
    SELECT
        P.product_id,
        SUM(C.claim_amount) AS total_claim_amount,
        COUNT(C.claim_id) AS total_claims
    FROM Policies P
    INNER JOIN Claims C
        ON P.policy_id = C.policy_id
    GROUP BY P.product_id
)
SELECT
    IP.product_name,
    COALESCE(PC.total_premium, 0) AS premium_collected,
    COALESCE(CL.total_claim_amount, 0) AS total_claim_amount,
    COALESCE(CL.total_claims, 0) AS total_claims,
    ROUND(
        COALESCE(CL.total_claim_amount, 0) * 100.0 /
        NULLIF(PC.total_premium, 0),
        2
    ) AS claim_ratio_percentage
FROM InsuranceProducts IP
LEFT JOIN PremiumCollected PC
    ON IP.product_id = PC.product_id
LEFT JOIN ProductClaims CL
    ON IP.product_id = CL.product_id
ORDER BY claim_ratio_percentage DESC;
GO


-- =====================================================
-- QUERY 5: POLICIES WITHOUT CLAIMS
-- Uses LEFT JOIN
-- =====================================================

SELECT
    P.policy_id,
    P.policy_number,
    C.customer_name,
    IP.product_name,
    P.policy_status,
    P.annual_premium
FROM Policies P
INNER JOIN Customers C
    ON P.customer_id = C.customer_id
INNER JOIN InsuranceProducts IP
    ON P.product_id = IP.product_id
LEFT JOIN Claims CL
    ON P.policy_id = CL.policy_id
WHERE CL.claim_id IS NULL
ORDER BY P.policy_id;
GO


-- =====================================================
-- QUERY 6: AVERAGE PREMIUM BY CUSTOMER AGE BAND
-- Functions: DATEDIFF, DATEADD, CASE, AVG
-- =====================================================

WITH CustomerAge AS
(
    SELECT
        C.customer_id,
        C.customer_name,
        P.annual_premium,
        DATEDIFF(
            YEAR,
            C.date_of_birth,
            CAST(GETDATE() AS DATE)
        )
        -
        CASE
            WHEN DATEADD(
                YEAR,
                DATEDIFF(
                    YEAR,
                    C.date_of_birth,
                    CAST(GETDATE() AS DATE)
                ),
                C.date_of_birth
            ) > CAST(GETDATE() AS DATE)
            THEN 1
            ELSE 0
        END AS customer_age
    FROM Customers C
    INNER JOIN Policies P
        ON C.customer_id = P.customer_id
),
AgeBands AS
(
    SELECT
        customer_id,
        annual_premium,
        CASE
            WHEN customer_age BETWEEN 18 AND 30
                THEN '18-30'
            WHEN customer_age BETWEEN 31 AND 45
                THEN '31-45'
            WHEN customer_age BETWEEN 46 AND 60
                THEN '46-60'
            ELSE 'Above 60'
        END AS age_band
    FROM CustomerAge
)
SELECT
    age_band,
    COUNT(*) AS total_policies,
    ROUND(AVG(annual_premium), 2) AS average_annual_premium
FROM AgeBands
GROUP BY age_band
ORDER BY age_band;
GO


-- =====================================================
-- QUERY 7: MONTHLY NEW POLICIES
-- Uses FORMAT, COUNT, GROUP BY
-- =====================================================

SELECT
    FORMAT(start_date, 'yyyy-MM') AS policy_month,
    COUNT(policy_id) AS new_policies,
    SUM(annual_premium) AS total_annual_premium
FROM Policies
GROUP BY FORMAT(start_date, 'yyyy-MM')
ORDER BY policy_month;
GO


-- =====================================================
-- QUERY 8: TOP 5 AGENTS BY PREMIUM
-- Uses TOP, SUM, GROUP BY, UPPER
-- =====================================================

SELECT TOP 5
    A.agent_id,
    UPPER(A.agent_name) AS agent_name,
    A.region,
    COUNT(P.policy_id) AS policies_sold,
    SUM(P.annual_premium) AS total_annual_premium
FROM Agents A
INNER JOIN Policies P
    ON A.agent_id = P.agent_id
GROUP BY
    A.agent_id,
    A.agent_name,
    A.region
ORDER BY total_annual_premium DESC;
GO


-- =====================================================
-- ADDITIONAL DEMONSTRATION: WHERE VS HAVING
-- =====================================================

-- WHERE filters individual rows before grouping.
SELECT
    policy_status,
    COUNT(*) AS total_policies
FROM Policies
WHERE policy_status = 'Active'
GROUP BY policy_status;


-- HAVING filters grouped results after aggregation.
SELECT
    agent_id,
    COUNT(*) AS total_policies
FROM Policies
GROUP BY agent_id
HAVING COUNT(*) > 2;
GO
