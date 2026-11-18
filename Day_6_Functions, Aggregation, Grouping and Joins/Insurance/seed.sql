
USE InsuranceReportingDB;
GO

-- ==========================================
-- 1. CUSTOMERS (10 RECORDS)
-- ==========================================

INSERT INTO Customers
(customer_name, date_of_birth, email, city)
VALUES
('Arun Kumar', '1995-04-12', 'arun@gmail.com', 'Chennai'),
('Priya Sharma', '1988-08-20', 'priya@gmail.com', 'Bangalore'),
('Rahul Verma', '1975-02-15', 'rahul@gmail.com', 'Hyderabad'),
('Sneha Raj', '1999-11-05', 'sneha@gmail.com', 'Chennai'),
('Karthik S', '1968-06-25', 'karthik@gmail.com', 'Coimbatore'),
('Divya Nair', '1992-09-10', 'divya@gmail.com', 'Kochi'),
('Vijay Anand', '1982-01-18', 'vijay@gmail.com', 'Chennai'),
('Meena Das', '1970-12-30', 'meena@gmail.com', 'Mumbai'),
('Sanjay Rao', '1990-03-08', 'sanjay@gmail.com', 'Hyderabad'),
('Anitha R', '2001-07-14', 'anitha@gmail.com', 'Bangalore');


-- ==========================================
-- 2. INSURANCE PRODUCTS (5 RECORDS)
-- ==========================================

INSERT INTO InsuranceProducts
(product_name, coverage_type, description)
VALUES
('Health Secure', 'Health', 'Individual health insurance'),
('Life Protect', 'Life', 'Term life insurance'),
('Motor Shield', 'Vehicle', 'Vehicle insurance'),
('Home Guard', 'Property', 'Home insurance'),
('Travel Safe', 'Travel', 'Domestic and international travel insurance');


-- ==========================================
-- 3. INSURANCE AGENTS (5 RECORDS)
-- ==========================================

INSERT INTO Agents
(agent_name, region, email)
VALUES
('Ramesh Kumar', 'Chennai', 'ramesh@insurance.com'),
('Priya Menon', 'Bangalore', 'priya.menon@insurance.com'),
('Suresh Babu', 'Hyderabad', 'suresh@insurance.com'),
('Divya Sharma', 'Mumbai', 'divya.sharma@insurance.com'),
('Kiran Raj', 'Kochi', 'kiran@insurance.com');


-- ==========================================
-- 4. POLICIES (15 RECORDS)
-- ==========================================

INSERT INTO Policies
(policy_number, customer_id, product_id, agent_id,
 start_date, end_date, annual_premium, policy_status)
VALUES
('POL1001', 1, 1, 1, '2025-12-01', '2026-11-25', 18000, 'Active'),
('POL1002', 1, 2, 1, '2026-01-10', '2027-01-10', 24000, 'Active'),
('POL1003', 2, 1, 2, '2026-02-01', '2026-12-01', 22000, 'Active'),
('POL1004', 2, 3, 2, '2025-06-15', '2026-11-30', 12000, 'Active'),
('POL1005', 3, 2, 3, '2024-10-01', '2026-10-01', 30000, 'Expired'),
('POL1006', 3, 4, 3, '2026-03-01', '2027-03-01', 15000, 'Active'),
('POL1007', 4, 5, 1, '2026-04-10', '2026-12-10', 8000, 'Active'),
('POL1008', 5, 1, 5, '2025-11-20', '2026-11-20', 25000, 'Active'),
('POL1009', 6, 3, 5, '2026-05-01', '2027-05-01', 14000, 'Active'),
('POL1010', 7, 2, 1, '2026-06-01', '2027-06-01', 28000, 'Active'),
('POL1011', 8, 4, 4, '2025-08-15', '2026-08-15', 16000, 'Expired'),
('POL1012', 9, 1, 3, '2026-07-01', '2027-07-01', 20000, 'Active'),
('POL1013', 10, 5, 2, '2026-08-01', '2026-12-15', 9000, 'Active'),
('POL1014', 4, 3, 4, '2026-09-01', '2027-09-01', 11000, 'Active'),
('POL1015', 7, 1, 1, '2026-10-01', '2027-10-01', 26000, 'Active');


-- ==========================================
-- 5. PREMIUM PAYMENTS (15 RECORDS)
-- ==========================================

INSERT INTO PremiumPayments
(policy_id, payment_date, payment_amount,
 payment_status, payment_method)
VALUES
(1, '2025-12-01', 18000, 'Paid', 'UPI'),
(2, '2026-01-10', 24000, 'Paid', 'Card'),
(3, '2026-02-01', 22000, 'Paid', 'UPI'),
(4, '2025-06-15', 12000, 'Paid', 'Net Banking'),
(5, '2024-10-01', 30000, 'Paid', 'Card'),
(6, '2026-03-01', 15000, 'Paid', 'UPI'),
(7, '2026-04-10', 8000, 'Paid', 'Card'),
(8, '2025-11-20', 25000, 'Paid', 'UPI'),
(9, '2026-05-01', 14000, 'Paid', 'Net Banking'),
(10, '2026-06-01', 28000, 'Paid', 'UPI'),
(11, '2025-08-15', 16000, 'Paid', 'Card'),
(12, '2026-07-01', 20000, 'Paid', 'UPI'),
(13, '2026-08-01', 9000, 'Pending', 'Card'),
(14, '2026-09-01', 11000, 'Paid', 'UPI'),
(15, '2026-10-01', 26000, 'Paid', 'Net Banking');


-- ==========================================
-- 6. CLAIMS (10 RECORDS)
-- ==========================================

INSERT INTO Claims
(policy_id, claim_date, claim_amount, approved_amount,
 claim_status, settlement_date, damage_category)
VALUES
(1, '2026-02-10', 50000, 40000, 'Settled', '2026-03-01', 'Medical'),
(2, '2026-04-15', 100000, 80000, 'Approved', NULL, 'Life'),
(3, '2026-05-20', 35000, 30000, 'Settled', '2026-06-05', 'Medical'),
(4, '2026-06-10', 25000, NULL, 'Under Review', NULL, 'Vehicle Damage'),
(5, '2025-01-12', 60000, 0, 'Rejected', NULL, 'Life'),
(6, '2026-07-05', 45000, 40000, 'Settled', '2026-07-25', 'Property Damage'),
(8, '2026-08-18', 20000, 18000, 'Settled', '2026-09-02', 'Medical'),
(9, '2026-09-12', 30000, NULL, 'Submitted', NULL, 'Vehicle Damage'),
(10, '2026-10-05', 75000, 60000, 'Approved', NULL, 'Life'),
(14, '2026-10-20', 15000, 12000, 'Settled', '2026-11-01', 'Vehicle Damage');


-- ==========================================
-- VERIFY RECORD COUNTS
-- ==========================================

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRecords FROM Customers
UNION ALL
SELECT 'InsuranceProducts', COUNT(*) FROM InsuranceProducts
UNION ALL
SELECT 'Agents', COUNT(*) FROM Agents
UNION ALL
SELECT 'Policies', COUNT(*) FROM Policies
UNION ALL
SELECT 'PremiumPayments', COUNT(*) FROM PremiumPayments
UNION ALL
SELECT 'Claims', COUNT(*) FROM Claims;
GO
