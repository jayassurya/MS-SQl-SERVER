
USE TelecomReportingDB;
GO

-- 1. Subscribers
INSERT INTO Subscribers
(subscriber_name, phone_number, circle, activation_date, subscriber_status)
VALUES
('Arun Kumar',   '9876500001', 'Chennai',    '2025-01-10', 'Active'),
('Priya Sharma', '9876500002', 'Bangalore',  '2025-02-15', 'Active'),
('Rahul Verma',  '9876500003', 'Hyderabad',  '2025-03-20', 'Active'),
('Sneha Raj',    '9876500004', 'Chennai',    '2025-04-05', 'Active'),
('Karthik S',    '9876500005', 'Coimbatore', '2025-05-12', 'Active'),
('Divya Nair',   '9876500006', 'Kochi',      '2025-06-18', 'Active'),
('Vijay Anand',  '9876500007', 'Chennai',    '2025-07-22', 'Active'),
('Meena Das',    '9876500008', 'Mumbai',     '2025-08-30', 'Active'),
('Sanjay Rao',   '9876500009', 'Hyderabad',  '2025-09-14', 'Active'),
('Anitha R',     '9876500010', 'Bangalore',  '2025-10-01', 'Active');

-- 2. Plans
INSERT INTO Plans
(plan_name, monthly_fee, data_limit_gb, validity_days)
VALUES
('Basic 2GB',       199,  2, 28),
('Smart 5GB',       299,  5, 28),
('Premium 10GB',    499, 10, 28),
('Unlimited 20GB',  699, 20, 28),
('Student 3GB',     249,  3, 28);

-- 3. Subscriber Plans
INSERT INTO SubscriberPlans
(subscriber_id, plan_id, start_date, end_date, plan_status)
VALUES
(1, 3, '2026-01-01', NULL, 'Active'),
(2, 2, '2026-01-05', NULL, 'Active'),
(3, 4, '2026-02-01', NULL, 'Active'),
(4, 1, '2026-02-10', NULL, 'Active'),
(5, 5, '2026-03-01', NULL, 'Active'),
(6, 3, '2026-03-15', NULL, 'Active'),
(7, 4, '2026-04-01', NULL, 'Active'),
(8, 2, '2026-04-15', NULL, 'Active'),
(9, 1, '2026-05-01', NULL, 'Active'),
(10, 5, '2026-05-15', NULL, 'Active'),
(1, 2, '2025-06-01', '2025-12-31', 'Expired'),
(3, 3, '2025-07-01', '2026-01-31', 'Expired');

-- 4. Call Records
INSERT INTO CallRecords
(subscriber_id, plan_id, call_date, duration_minutes, call_type)
VALUES
(1, 3, '2026-10-01 09:15:00', 25, 'Local'),
(1, 3, '2026-10-03 11:30:00', 40, 'STD'),
(1, 3, '2026-10-05 15:45:00', 35, 'Local'),
(2, 2, '2026-10-02 10:00:00', 20, 'Local'),
(2, 2, '2026-10-06 12:15:00', 30, 'STD'),
(2, 2, '2026-10-10 17:00:00', 45, 'Local'),
(3, 4, '2026-10-01 08:30:00', 60, 'STD'),
(3, 4, '2026-10-04 14:00:00', 55, 'Local'),
(3, 4, '2026-10-08 19:00:00', 70, 'ISD'),
(4, 1, '2026-10-03 09:00:00', 15, 'Local'),
(4, 1, '2026-10-07 13:30:00', 20, 'Local'),
(5, 5, '2026-10-05 10:15:00', 35, 'STD'),
(5, 5, '2026-10-09 16:45:00', 25, 'Local'),
(6, 3, '2026-10-02 11:00:00', 50, 'Local'),
(6, 3, '2026-10-06 18:30:00', 45, 'STD'),
(7, 4, '2026-10-04 08:00:00', 80, 'STD'),
(7, 4, '2026-10-08 20:00:00', 65, 'Local'),
(8, 2, '2026-10-05 12:00:00', 30, 'Local'),
(8, 2, '2026-10-09 15:00:00', 40, 'STD'),
(1, 3, '2026-11-01 09:00:00', 30, 'Local'),
(2, 2, '2026-11-03 10:00:00', 25, 'STD'),
(3, 4, '2026-11-05 12:00:00', 90, 'ISD'),
(4, 1, '2026-11-07 14:00:00', 10, 'Local'),
(6, 3, '2026-11-09 16:00:00', 55, 'STD'),
(7, 4, '2026-11-11 18:00:00', 75, 'Local');

-- 5. Data Usage
INSERT INTO DataUsage
(subscriber_id, plan_id, usage_month, data_used_gb)
VALUES
(1, 3, '2026-10-01', 12.50),
(1, 3, '2026-11-01',  8.20),
(2, 2, '2026-10-01',  6.80),
(2, 2, '2026-11-01',  4.20),
(3, 4, '2026-10-01', 25.60),
(3, 4, '2026-11-01', 18.50),
(4, 1, '2026-10-01',  3.40),
(4, 1, '2026-11-01',  1.80),
(5, 5, '2026-10-01',  2.50),
(5, 5, '2026-11-01',  4.10),
(6, 3, '2026-10-01',  9.50),
(6, 3, '2026-11-01', 11.20),
(7, 4, '2026-10-01', 22.30),
(7, 4, '2026-11-01', 28.70),
(8, 2, '2026-10-01',  4.50),
(8, 2, '2026-11-01',  5.80);

-- Subscribers 9 and 10 intentionally have no usage rows.

-- 6. Invoices
INSERT INTO Invoices
(subscriber_id, invoice_number, invoice_date, due_date, invoice_amount, payment_status)
VALUES
(1, 'INV202610001', '2026-10-01', '2026-10-15', 499, 'Paid'),
(2, 'INV202610002', '2026-10-02', '2026-10-16', 299, 'Paid'),
(3, 'INV202610003', '2026-10-03', '2026-10-17', 699, 'Overdue'),
(4, 'INV202610004', '2026-10-04', '2026-10-18', 199, 'Paid'),
(5, 'INV202610005', '2026-10-05', '2026-10-19', 249, 'Pending'),
(6, 'INV202610006', '2026-10-06', '2026-10-20', 499, 'Paid'),
(7, 'INV202610007', '2026-10-07', '2026-10-21', 699, 'Overdue'),
(8, 'INV202610008', '2026-10-08', '2026-10-22', 299, 'Paid'),
(1, 'INV202611001', '2026-11-01', '2026-11-15', 499, 'Paid'),
(2, 'INV202611002', '2026-11-02', '2026-11-16', 299, 'Pending'),
(3, 'INV202611003', '2026-11-03', '2026-11-17', 699, 'Overdue'),
(4, 'INV202611004', '2026-11-04', '2026-11-18', 199, 'Paid'),
(6, 'INV202611005', '2026-11-05', '2026-11-19', 499, 'Paid'),
(7, 'INV202611006', '2026-11-06', '2026-11-20', 699, 'Pending'),
(8, 'INV202611007', '2026-11-07', '2026-11-21', 299, 'Paid');

GO

-- Verify inserted records
SELECT 'Subscribers' AS TableName, COUNT(*) AS TotalRecords FROM Subscribers
UNION ALL
SELECT 'Plans', COUNT(*) FROM Plans
UNION ALL
SELECT 'SubscriberPlans', COUNT(*) FROM SubscriberPlans
UNION ALL
SELECT 'CallRecords', COUNT(*) FROM CallRecords
UNION ALL
SELECT 'DataUsage', COUNT(*) FROM DataUsage
UNION ALL
SELECT 'Invoices', COUNT(*) FROM Invoices;
GO
