
USE TelecomReportingDB;
GO

/* =========================================================
   SET 3 – TELECOM USAGE AND BILLING REPORTING
   ========================================================= */


/* QUERY 1: Total call minutes per plan
   Purpose: Find total call duration consumed under each plan.
*/

SELECT
    P.plan_name,
    COUNT(C.call_id) AS total_calls,
    ROUND(SUM(C.duration_minutes), 2) AS total_call_minutes
FROM Plans P
LEFT JOIN CallRecords C
    ON P.plan_id = C.plan_id
GROUP BY P.plan_id, P.plan_name
ORDER BY total_call_minutes DESC;


/* QUERY 2: Subscribers exceeding their data limit
   Purpose: Identify subscribers whose monthly data usage
   exceeds the limit of their subscribed plan.
*/

SELECT
    S.subscriber_name,
    S.phone_number,
    P.plan_name,
    D.usage_month,
    D.data_used_gb,
    P.data_limit_gb,
    ROUND(D.data_used_gb - P.data_limit_gb, 2)
        AS excess_data_gb
FROM DataUsage D
JOIN Subscribers S
    ON D.subscriber_id = S.subscriber_id
JOIN Plans P
    ON D.plan_id = P.plan_id
WHERE D.data_used_gb > P.data_limit_gb
ORDER BY D.data_used_gb DESC;


/* QUERY 3: Month-wise revenue
   Purpose: Calculate revenue collected from paid invoices
   for each month.
*/

SELECT
    FORMAT(invoice_date, 'yyyy-MM') AS revenue_month,
    COUNT(*) AS paid_invoice_count,
    SUM(invoice_amount) AS total_revenue
FROM Invoices
WHERE payment_status = 'Paid'
GROUP BY FORMAT(invoice_date, 'yyyy-MM')
ORDER BY revenue_month;


/* QUERY 4: Invoices overdue by more than 15 days
   Purpose: Find unpaid invoices whose due dates are
   more than 15 days before today's date.
   Also demonstrate CONCAT, RIGHT, FORMAT, DATEDIFF and CASE.
*/

SELECT
    I.invoice_id,
    CONCAT(
        'TEL-',
        RIGHT(I.invoice_number, 6)
    ) AS formatted_invoice_number,
    S.subscriber_name,
    I.invoice_amount,
    FORMAT(I.invoice_date, 'dd-MMM-yyyy') AS invoice_date,
    FORMAT(I.due_date, 'dd-MMM-yyyy') AS due_date,
    DATEDIFF(DAY, I.due_date, CAST(GETDATE() AS DATE))
        AS days_past_due,
    CASE
        WHEN I.payment_status = 'Paid'
            THEN 'Paid'
        WHEN DATEDIFF(DAY, I.due_date, CAST(GETDATE() AS DATE)) > 15
            THEN 'Overdue by more than 15 days'
        WHEN I.due_date < CAST(GETDATE() AS DATE)
            THEN 'Overdue'
        ELSE 'Not yet due'
    END AS due_date_status
FROM Invoices I
JOIN Subscribers S
    ON I.subscriber_id = S.subscriber_id
WHERE I.payment_status <> 'Paid'
  AND I.due_date < DATEADD(DAY, -15, CAST(GETDATE() AS DATE))
ORDER BY I.due_date;


/* QUERY 5: Subscribers with no usage
   Purpose: Identify subscribers who have neither call records
   nor data usage records.
*/

SELECT
    S.subscriber_id,
    S.subscriber_name,
    S.phone_number,
    S.circle
FROM Subscribers S
WHERE NOT EXISTS (
    SELECT 1
    FROM CallRecords C
    WHERE C.subscriber_id = S.subscriber_id
)
AND NOT EXISTS (
    SELECT 1
    FROM DataUsage D
    WHERE D.subscriber_id = S.subscriber_id
)
ORDER BY S.subscriber_id;


/* QUERY 6: Average Revenue Per User (ARPU) by circle
   Purpose: Calculate collected revenue per subscriber
   in each telecom circle.
*/

WITH CircleRevenue AS (
    SELECT
        S.circle,
        SUM(
            CASE
                WHEN I.payment_status = 'Paid'
                    THEN I.invoice_amount
                ELSE 0
            END
        ) AS total_revenue
    FROM Subscribers S
    LEFT JOIN Invoices I
        ON S.subscriber_id = I.subscriber_id
    GROUP BY S.circle
),
CircleSubscribers AS (
    SELECT
        circle,
        COUNT(*) AS total_subscribers
    FROM Subscribers
    GROUP BY circle
)
SELECT
    R.circle,
    R.total_revenue,
    C.total_subscribers,
    ROUND(
        CAST(R.total_revenue AS DECIMAL(12,2))
        / NULLIF(C.total_subscribers, 0),
        2
    ) AS ARPU
FROM CircleRevenue R
JOIN CircleSubscribers C
    ON R.circle = C.circle
ORDER BY ARPU DESC;


/* QUERY 7: Plan popularity
   Purpose: Count active subscribers using each plan.
*/

SELECT
    P.plan_name,
    COUNT(SP.subscriber_plan_id) AS active_subscribers
FROM Plans P
LEFT JOIN SubscriberPlans SP
    ON P.plan_id = SP.plan_id
    AND SP.plan_status = 'Active'
GROUP BY P.plan_id, P.plan_name
ORDER BY active_subscribers DESC, P.plan_name;


/* QUERY 8: Top 10 data consumers
   Purpose: Find subscribers with the highest total
   data consumption across recorded usage months.
*/

SELECT TOP 10
    S.subscriber_name,
    S.phone_number,
    S.circle,
    ROUND(SUM(D.data_used_gb), 2) AS total_data_used_gb
FROM Subscribers S
JOIN DataUsage D
    ON S.subscriber_id = D.subscriber_id
GROUP BY
    S.subscriber_id,
    S.subscriber_name,
    S.phone_number,
    S.circle
ORDER BY total_data_used_gb DESC;


/* =========================================================
   ADDITIONAL REQUIREMENT: DEMONSTRATE NULL BEHAVIOUR
   ========================================================= */

/* Compare COUNT(*), COUNT(column), SUM and AVG.
   LEFT JOIN preserves subscribers with no usage rows.
*/

SELECT
    S.subscriber_name,
    COUNT(*) AS joined_rows,
    COUNT(D.data_used_gb) AS usage_records,
    SUM(D.data_used_gb) AS total_data_gb,
    AVG(D.data_used_gb) AS average_data_gb
FROM Subscribers S
LEFT JOIN DataUsage D
    ON S.subscriber_id = D.subscriber_id
GROUP BY S.subscriber_id, S.subscriber_name
ORDER BY S.subscriber_id;


/* Overall NULL demonstration:
   SUM and AVG ignore NULL values.
   COUNT(*) counts all joined rows.
   COUNT(column) counts only non-NULL values.
*/

SELECT
    COUNT(*) AS total_joined_rows,
    COUNT(D.data_used_gb) AS non_null_usage_records,
    SUM(D.data_used_gb) AS total_data_usage,
    AVG(D.data_used_gb) AS average_data_usage
FROM Subscribers S
LEFT JOIN DataUsage D
    ON S.subscriber_id = D.subscriber_id;
GO
