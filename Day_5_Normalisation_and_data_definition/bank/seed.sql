
USE BankBranchDB;
GO

-- 1. Insert 10 customers
INSERT INTO Customer (customer_name, address, phone)
VALUES
('Arun Kumar', 'Anna Nagar, Chennai', '9000000001'),
('Priya Sharma', 'T Nagar, Chennai', '9000000002'),
('Rahul Verma', 'Adyar, Chennai', '9000000003'),
('Sneha Raj', 'Velachery, Chennai', '9000000004'),
('Karthik S', 'Tambaram, Chennai', '9000000005'),
('Divya Nair', 'Kochi, Kerala', '9000000006'),
('Vijay Anand', 'Bangalore, Karnataka', '9000000007'),
('Meena Das', 'Hyderabad, Telangana', '9000000008'),
('Sanjay Rao', 'Mumbai, Maharashtra', '9000000009'),
('Anitha R', 'Coimbatore, Tamil Nadu', '9000000010');
GO

-- 2. Insert 10 branches
INSERT INTO Branch (branch_name, branch_city)
VALUES
('Anna Nagar Branch', 'Chennai'),
('T Nagar Branch', 'Chennai'),
('Adyar Branch', 'Chennai'),
('Velachery Branch', 'Chennai'),
('Tambaram Branch', 'Chennai'),
('Kochi Main Branch', 'Kochi'),
('Bangalore Central', 'Bangalore'),
('Hyderabad Main Branch', 'Hyderabad'),
('Mumbai Central', 'Mumbai'),
('Coimbatore Branch', 'Coimbatore');
GO

-- 3. Insert 10 relationship managers
INSERT INTO RelationshipManager (manager_name, branch_id)
VALUES
('Ramesh Kumar', 1),
('Lakshmi Priya', 2),
('Suresh Babu', 3),
('Nithya Raj', 4),
('Gokul Das', 5),
('Anand Mohan', 6),
('Kavitha Rao', 7),
('Pradeep Sharma', 8),
('Divakar Singh', 9),
('Harini S', 10);
GO

-- 4. Insert 10 account types
-- Savings is inserted first, so its ID will be 1.
INSERT INTO AccountType (account_type_name)
VALUES
('Savings'),
('Current'),
('Salary'),
('Fixed Deposit'),
('Recurring Deposit'),
('Business'),
('Student'),
('Senior Citizen'),
('Joint'),
('NRI');
GO

-- 5. Insert 10 bank accounts
INSERT INTO BankAccount
(account_number, customer_id, account_type_id,
 branch_id, manager_id, balance, opened_date)
VALUES
('ACC10001', 1, 1, 1, 1, 45000.00, '2026-07-05'),
('ACC10002', 2, 2, 2, 2, 85000.00, '2026-08-12'),
('ACC10003', 3, 1, 3, 3, 12000.00, '2026-09-20'),
('ACC10004', 4, 3, 4, 4, 67000.00, '2026-07-25'),
('ACC10005', 5, 1, 5, 5, 30000.00, '2026-06-15'),
('ACC10006', 6, 4, 6, 6, 150000.00, '2026-08-01'),
('ACC10007', 7, 2, 7, 7, 95000.00, '2026-10-10'),
('ACC10008', 8, 1, 8, 8, 22000.00, '2026-09-10'),
('ACC10009', 9, 6, 9, 9, 200000.00, '2026-05-18'),
('ACC10010', 10, 1, 10, 10, 18000.00, '2026-07-30');
GO

-- 6. Insert 10 account transactions
INSERT INTO AccountTransaction
(account_id, transaction_type, amount, transaction_description)
VALUES
(1, 'Deposit', 5000.00, 'Monthly salary deposit'),
(2, 'Withdrawal', 2000.00, 'ATM cash withdrawal'),
(3, 'Deposit', 3000.00, 'Cash deposit'),
(4, 'Transfer', 4500.00, 'Online fund transfer'),
(5, 'Deposit', 6000.00, 'Monthly savings'),
(6, 'Withdrawal', 10000.00, 'Branch withdrawal'),
(7, 'Deposit', 8000.00, 'Business payment received'),
(8, 'Transfer', 1500.00, 'Utility bill payment'),
(9, 'Deposit', 12000.00, 'Business revenue'),
(10, 'Withdrawal', 2500.00, 'Personal expenses');
GO

PRINT 'Sample data inserted successfully!';
GO
