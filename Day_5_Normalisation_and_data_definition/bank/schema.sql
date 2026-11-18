
-- SET 2: BANK BRANCH ACCOUNTS
-- Database creation

CREATE DATABASE BankBranchDB;
GO

USE BankBranchDB;
GO

-- 1. Customer table
CREATE TABLE Customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone VARCHAR(15) UNIQUE
);
GO

-- 2. Branch table
CREATE TABLE Branch (
    branch_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL
);
GO

-- 3. Relationship Manager table
CREATE TABLE RelationshipManager (
    manager_id INT IDENTITY(1,1) PRIMARY KEY,
    manager_name VARCHAR(100) NOT NULL,
    branch_id INT NOT NULL,
    FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id)
);
GO

-- 4. Account Type table
CREATE TABLE AccountType (
    account_type_id INT IDENTITY(1,1) PRIMARY KEY,
    account_type_name VARCHAR(30) NOT NULL UNIQUE
);
GO

-- 5. Bank Account table
CREATE TABLE BankAccount (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    account_type_id INT NOT NULL,
    branch_id INT NOT NULL,
    manager_id INT NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    opened_date DATE NOT NULL DEFAULT GETDATE(),

    CONSTRAINT CK_Savings_Balance
        CHECK (
            account_type_id <> 1
            OR balance >= 0
        ),

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    FOREIGN KEY (account_type_id)
        REFERENCES AccountType(account_type_id),

    FOREIGN KEY (branch_id)
        REFERENCES Branch(branch_id),

    FOREIGN KEY (manager_id)
        REFERENCES RelationshipManager(manager_id)
);
GO

-- 6. Account Transaction table
CREATE TABLE AccountTransaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_date DATETIME NOT NULL DEFAULT GETDATE(),
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    transaction_description VARCHAR(250),

    FOREIGN KEY (account_id)
        REFERENCES BankAccount(account_id)
        ON DELETE CASCADE
);
GO
