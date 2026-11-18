
-- SET 3: HOSPITAL PATIENT RECORDS

CREATE DATABASE HospitalRecordsDB;
GO

USE HospitalRecordsDB;
GO

-- 1. Patient table
CREATE TABLE Patient (
    patient_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    address VARCHAR(200) NOT NULL,
    phone VARCHAR(15) UNIQUE
);
GO

-- 2. Department table
CREATE TABLE Department (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);
GO

-- 3. Doctor table
CREATE TABLE Doctor (
    doctor_id INT IDENTITY(1,1) PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id)
        REFERENCES Department(department_id)
);
GO

-- 4. Visit table
CREATE TABLE Visit (
    visit_id INT IDENTITY(1,1) PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(200) NOT NULL,
    prescription VARCHAR(300),
    visit_status VARCHAR(20) NOT NULL DEFAULT 'Open',

    CONSTRAINT CK_Visit_Date
        CHECK (visit_date <= CAST(GETDATE() AS DATE)),

    CONSTRAINT CK_Visit_Status
        CHECK (visit_status IN ('Open', 'Completed', 'Cancelled')),

    FOREIGN KEY (patient_id)
        REFERENCES Patient(patient_id),

    FOREIGN KEY (doctor_id)
        REFERENCES Doctor(doctor_id)
);
GO

-- 5. Billing table
CREATE TABLE Billing (
    billing_id INT IDENTITY(1,1) PRIMARY KEY,
    visit_id INT NOT NULL UNIQUE,
    bill_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT CK_Bill_Amount
        CHECK (bill_amount >= 0),

    FOREIGN KEY (visit_id)
        REFERENCES Visit(visit_id)
);
GO

PRINT 'Hospital database and tables created successfully!';
GO
