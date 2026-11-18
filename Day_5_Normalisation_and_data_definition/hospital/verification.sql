
USE HospitalRecordsDB;
GO

--------------------------------------------------
-- 1. VIEW ALL PATIENTS
--------------------------------------------------

SELECT * FROM Patient;
GO

--------------------------------------------------
-- 2. VIEW ALL DOCTORS
--------------------------------------------------

SELECT * FROM Doctor;
GO

--------------------------------------------------
-- 3. VIEW ALL PATIENT VISITS
--------------------------------------------------

SELECT * FROM Visit;
GO

--------------------------------------------------
-- 4. PATIENTS VISITED IN AUGUST 2026
--------------------------------------------------

SELECT
    P.patient_name,
    V.visit_date,
    V.diagnosis,
    V.visit_status
FROM Patient P
INNER JOIN Visit V
    ON P.patient_id = V.patient_id
WHERE V.visit_date >= '2026-08-01'
AND V.visit_date < '2026-09-01';
GO

--------------------------------------------------
-- 5. DOCTORS BELONGING TO CARDIOLOGY
--------------------------------------------------

SELECT
    D.doctor_name,
    DP.department_name
FROM Doctor D
INNER JOIN Department DP
    ON D.department_id = DP.department_id
WHERE DP.department_name = 'Cardiology';
GO

--------------------------------------------------
-- 6. SEARCH DOCTORS USING LIKE
-- Doctor names starting with Dr. R
--------------------------------------------------

SELECT *
FROM Doctor
WHERE doctor_name LIKE 'Dr. R%';
GO

--------------------------------------------------
-- 7. SEARCH PATIENTS USING LIKE
-- Patient names containing 'a'
--------------------------------------------------

SELECT *
FROM Patient
WHERE patient_name LIKE '%a%';
GO

--------------------------------------------------
-- 8. VIEW PATIENT VISIT AND DOCTOR DETAILS
--------------------------------------------------

SELECT
    P.patient_name,
    D.doctor_name,
    DP.department_name,
    V.visit_date,
    V.diagnosis,
    V.visit_status
FROM Visit V
INNER JOIN Patient P
    ON V.patient_id = P.patient_id
INNER JOIN Doctor D
    ON V.doctor_id = D.doctor_id
INNER JOIN Department DP
    ON D.department_id = DP.department_id;
GO

--------------------------------------------------
-- 9. VIEW BILLING DETAILS
--------------------------------------------------

SELECT
    P.patient_name,
    V.visit_date,
    V.diagnosis,
    PB.bill_amount,
    PB.payment_status
FROM PatientBilling PB
INNER JOIN Visit V
    ON PB.visit_id = V.visit_id
INNER JOIN Patient P
    ON V.patient_id = P.patient_id;
GO

--------------------------------------------------
-- 10. FIND PENDING BILLS
--------------------------------------------------

SELECT *
FROM PatientBilling
WHERE payment_status = 'Pending';
GO

--------------------------------------------------
-- 11. COUNT VISITS BY DEPARTMENT
--------------------------------------------------

SELECT
    DP.department_name,
    COUNT(V.visit_id) AS TotalVisits
FROM Department DP
LEFT JOIN Doctor D
    ON DP.department_id = D.department_id
LEFT JOIN Visit V
    ON D.doctor_id = V.doctor_id
GROUP BY DP.department_name;
GO
