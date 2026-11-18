
-- ==========================================
-- HEXAWARE DAY 7
-- SET 1: LOGISTICS SHIPMENT ANALYSIS
-- DATABASE SETUP
-- ==========================================

CREATE DATABASE Hexaware_Day7_Logistics;
GO

USE Hexaware_Day7_Logistics;
GO

-- 1. HUBS TABLE
CREATE TABLE Hubs (
    HubID INT PRIMARY KEY,
    HubName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL
);

-- 2. CARRIERS TABLE
CREATE TABLE Carriers (
    CarrierID INT PRIMARY KEY,
    CarrierName VARCHAR(100) NOT NULL
);

-- 3. CUSTOMERS TABLE
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100)
);

-- 4. EMPLOYEES TABLE
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    SupervisorID INT NULL,
    FOREIGN KEY (SupervisorID)
        REFERENCES Employees(EmployeeID)
);

-- 5. SHIPMENTS TABLE
CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    CarrierID INT NOT NULL,
    OriginHubID INT NOT NULL,
    DestinationHubID INT NOT NULL,
    EmployeeID INT NULL,
    ShippingCost DECIMAL(10,2) NOT NULL,
    ShipmentDate DATE NOT NULL,
    ExpectedDeliveryDate DATE NOT NULL,
    ActualDeliveryDate DATE NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (CarrierID)
        REFERENCES Carriers(CarrierID),

    FOREIGN KEY (OriginHubID)
        REFERENCES Hubs(HubID),

    FOREIGN KEY (DestinationHubID)
        REFERENCES Hubs(HubID),

    FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

-- 6. DELIVERY EVENTS TABLE
CREATE TABLE DeliveryEvents (
    EventID INT PRIMARY KEY,
    ShipmentID INT NOT NULL,
    EventType VARCHAR(100) NOT NULL,
    EventLocation VARCHAR(100),
    EventTimestamp DATETIME2 NOT NULL,

    FOREIGN KEY (ShipmentID)
        REFERENCES Shipments(ShipmentID)
);

PRINT 'All six tables created successfully.';
