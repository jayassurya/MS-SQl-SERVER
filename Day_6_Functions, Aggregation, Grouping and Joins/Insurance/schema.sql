
-- ==========================================
-- DAY 6 - SET 2
-- INSURANCE POLICY REPORTING
-- SQL SERVER 2025
-- ==========================================

CREATE DATABASE InsuranceReportingDB;
GO

USE InsuranceReportingDB;
GO

-- 1. CUSTOMERS
CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50)
);

-- 2. INSURANCE PRODUCTS
CREATE TABLE InsuranceProducts (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    coverage_type VARCHAR(50),
    description VARCHAR(255)
);

-- 3. INSURANCE AGENTS
CREATE TABLE Agents (
    agent_id INT IDENTITY(1,1) PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    region VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

-- 4. POLICIES
CREATE TABLE Policies (
    policy_id INT IDENTITY(1,1) PRIMARY KEY,
    policy_number VARCHAR(30) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    agent_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    annual_premium DECIMAL(12,2) NOT NULL,
    policy_status VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Policy_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    CONSTRAINT FK_Policy_Product
        FOREIGN KEY (product_id)
        REFERENCES InsuranceProducts(product_id),

    CONSTRAINT FK_Policy_Agent
        FOREIGN KEY (agent_id)
        REFERENCES Agents(agent_id),

    CONSTRAINT CK_Policy_Dates
        CHECK (end_date > start_date),

    CONSTRAINT CK_Annual_Premium
        CHECK (annual_premium >= 0),

    CONSTRAINT CK_Policy_Status
        CHECK (policy_status IN
        ('Active', 'Expired', 'Cancelled'))
);

-- 5. PREMIUM PAYMENTS
CREATE TABLE PremiumPayments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    policy_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30),

    CONSTRAINT FK_Payment_Policy
        FOREIGN KEY (policy_id)
        REFERENCES Policies(policy_id),

    CONSTRAINT CK_Payment_Amount
        CHECK (payment_amount >= 0),

    CONSTRAINT CK_Payment_Status
        CHECK (payment_status IN
        ('Paid', 'Pending', 'Failed'))
);

-- 6. CLAIMS
CREATE TABLE Claims (
    claim_id INT IDENTITY(1,1) PRIMARY KEY,
    policy_id INT NOT NULL,
    claim_date DATE NOT NULL,
    claim_amount DECIMAL(12,2) NOT NULL,
    approved_amount DECIMAL(12,2),
    claim_status VARCHAR(20) NOT NULL,
    settlement_date DATE,
    damage_category VARCHAR(50),

    CONSTRAINT FK_Claim_Policy
        FOREIGN KEY (policy_id)
        REFERENCES Policies(policy_id),

    CONSTRAINT CK_Claim_Amount
        CHECK (claim_amount >= 0),

    CONSTRAINT CK_Approved_Amount
        CHECK (approved_amount IS NULL
        OR approved_amount >= 0),

    CONSTRAINT CK_Claim_Status
        CHECK (claim_status IN
        ('Submitted', 'Under Review',
         'Approved', 'Rejected', 'Settled'))
);

-- ==========================================
-- VERIFY TABLE CREATION
-- ==========================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
