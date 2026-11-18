
CREATE DATABASE TelecomReportingDB;
GO

USE TelecomReportingDB;
GO

-- 1. Subscribers
CREATE TABLE Subscribers (
    subscriber_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    circle VARCHAR(50) NOT NULL,
    activation_date DATE NOT NULL,
    subscriber_status VARCHAR(20) NOT NULL
        CHECK (subscriber_status IN ('Active', 'Inactive'))
);

-- 2. Plans
CREATE TABLE Plans (
    plan_id INT IDENTITY(1,1) PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    monthly_fee DECIMAL(10,2) NOT NULL
        CHECK (monthly_fee >= 0),
    data_limit_gb DECIMAL(10,2) NOT NULL
        CHECK (data_limit_gb >= 0),
    validity_days INT NOT NULL
);

-- 3. Subscriber Plans
CREATE TABLE SubscriberPlans (
    subscriber_plan_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    plan_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    plan_status VARCHAR(20) NOT NULL
        CHECK (plan_status IN ('Active', 'Expired', 'Cancelled')),

    FOREIGN KEY (subscriber_id)
        REFERENCES Subscribers(subscriber_id),

    FOREIGN KEY (plan_id)
        REFERENCES Plans(plan_id)
);

-- 4. Call Records
CREATE TABLE CallRecords (
    call_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    plan_id INT NOT NULL,
    call_date DATETIME2 NOT NULL,
    duration_minutes DECIMAL(8,2) NOT NULL
        CHECK (duration_minutes >= 0),
    call_type VARCHAR(20) NOT NULL
        CHECK (call_type IN ('Local', 'STD', 'ISD')),

    FOREIGN KEY (subscriber_id)
        REFERENCES Subscribers(subscriber_id),

    FOREIGN KEY (plan_id)
        REFERENCES Plans(plan_id)
);

-- 5. Data Usage
CREATE TABLE DataUsage (
    usage_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    plan_id INT NOT NULL,
    usage_month DATE NOT NULL,
    data_used_gb DECIMAL(10,2) NOT NULL
        CHECK (data_used_gb >= 0),

    FOREIGN KEY (subscriber_id)
        REFERENCES Subscribers(subscriber_id),

    FOREIGN KEY (plan_id)
        REFERENCES Plans(plan_id)
);

-- 6. Invoices
CREATE TABLE Invoices (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    invoice_number VARCHAR(30) NOT NULL UNIQUE,
    invoice_date DATE NOT NULL,
    due_date DATE NOT NULL,
    invoice_amount DECIMAL(10,2) NOT NULL
        CHECK (invoice_amount >= 0),
    payment_status VARCHAR(20) NOT NULL
        CHECK (payment_status IN ('Paid', 'Pending', 'Overdue')),

    FOREIGN KEY (subscriber_id)
        REFERENCES Subscribers(subscriber_id),

    CHECK (due_date >= invoice_date)
);
GO

-- Verify table creation
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
