
USE HospitalRecordsDB;
GO

--------------------------------------------------
-- 1. ADD insurance_id COLUMN TO PATIENT
--------------------------------------------------

ALTER TABLE Patient
ADD insurance_id VARCHAR(30) NULL;
GO

-- Verify the new column
SELECT * FROM Patient;
GO

--------------------------------------------------
-- 2. RENAME Billing TABLE TO PatientBilling
--------------------------------------------------

EXEC sp_rename 'Billing', 'PatientBilling';
GO

-- Verify renamed table
SELECT * FROM PatientBilling;
GO

--------------------------------------------------
-- 3. DROP A CONSTRAINT
--------------------------------------------------

-- First, identify the constraint name
SELECT
    name AS ConstraintName,
    type_desc
FROM sys.objects
WHERE parent_object_id = OBJECT_ID('PatientBilling')
AND type_desc = 'CHECK_CONSTRAINT';
GO

-- Drop the bill amount CHECK constraint
ALTER TABLE PatientBilling
DROP CONSTRAINT CK_Bill_Amount;
GO

-- Verify that the constraint was removed
SELECT
    name AS ConstraintName
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('PatientBilling');
GO

--------------------------------------------------
-- 4. UPDATE PATIENT DETAILS
--------------------------------------------------

SELECT * FROM Patient
WHERE patient_id = 1;

UPDATE Patient
SET address = 'Mylapore, Chennai'
WHERE patient_id = 1;

SELECT * FROM Patient
WHERE patient_id = 1;
GO

--------------------------------------------------
-- 5. UPDATE VISIT STATUS
--------------------------------------------------

SELECT * FROM Visit
WHERE visit_id = 4;

UPDATE Visit
SET visit_status = 'Completed'
WHERE visit_id = 4;

SELECT * FROM Visit
WHERE visit_id = 4;
GO

--------------------------------------------------
-- 6. INSERT A NEW PATIENT
--------------------------------------------------

INSERT INTO Patient
(patient_name, address, phone, insurance_id)
VALUES
('Ravi Kumar', 'Porur, Chennai', '9100000011', 'INS10011');
GO

SELECT * FROM Patient
WHERE phone = '9100000011';
GO

--------------------------------------------------
-- 7. DELETE A BILLING RECORD
--------------------------------------------------

SELECT * FROM PatientBilling
WHERE billing_id = 10;

DELETE FROM PatientBilling
WHERE billing_id = 10;

SELECT * FROM PatientBilling
WHERE billing_id = 10;
GO
