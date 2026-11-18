
USE HospitalRecordsDB;
GO

-- 1. Insert 10 patients
INSERT INTO Patient (patient_name, address, phone)
VALUES
('Arun Kumar', 'Anna Nagar, Chennai', '9100000001'),
('Priya Sharma', 'T Nagar, Chennai', '9100000002'),
('Rahul Verma', 'Adyar, Chennai', '9100000003'),
('Sneha Raj', 'Velachery, Chennai', '9100000004'),
('Karthik S', 'Tambaram, Chennai', '9100000005'),
('Divya Nair', 'Kochi, Kerala', '9100000006'),
('Vijay Anand', 'Bangalore, Karnataka', '9100000007'),
('Meena Das', 'Hyderabad, Telangana', '9100000008'),
('Sanjay Rao', 'Mumbai, Maharashtra', '9100000009'),
('Anitha R', 'Coimbatore, Tamil Nadu', '9100000010');
GO

-- 2. Insert 10 departments
INSERT INTO Department (department_name)
VALUES
('Cardiology'),
('Neurology'),
('Orthopedics'),
('Dermatology'),
('Pediatrics'),
('ENT'),
('General Medicine'),
('Ophthalmology'),
('Oncology'),
('Dental');
GO

-- 3. Insert 10 doctors
INSERT INTO Doctor (doctor_name, department_id)
VALUES
('Dr. Rajesh Kumar', 1),
('Dr. Meera Sharma', 2),
('Dr. Suresh Babu', 3),
('Dr. Nithya Raj', 4),
('Dr. Gokul Das', 5),
('Dr. Anand Mohan', 6),
('Dr. Kavitha Rao', 7),
('Dr. Pradeep Singh', 8),
('Dr. Divakar Rao', 9),
('Dr. Harini S', 10);
GO

-- 4. Insert 10 patient visits
INSERT INTO Visit
(patient_id, doctor_id, visit_date, diagnosis, prescription, visit_status)
VALUES
(1, 1, '2026-07-05', 'High Blood Pressure', 'BP medication', 'Completed'),
(2, 2, '2026-07-12', 'Migraine', 'Pain relief medication', 'Completed'),
(3, 3, '2026-08-03', 'Knee Pain', 'Physiotherapy', 'Completed'),
(4, 4, '2026-08-15', 'Skin Allergy', 'Antihistamine', 'Open'),
(5, 5, '2026-09-02', 'Fever', 'Fever medication', 'Completed'),
(6, 6, '2026-09-10', 'Ear Infection', 'Prescribed ear drops', 'Open'),
(7, 7, '2026-10-05', 'Diabetes', 'Blood sugar monitoring', 'Completed'),
(8, 8, '2026-10-12', 'Eye Infection', 'Eye drops', 'Open'),
(9, 9, '2026-11-01', 'Anemia', 'Follow-up tests', 'Open'),
(10, 10, '2026-11-05', 'Tooth Pain', 'Dental consultation', 'Completed');
GO

-- 5. Insert 10 billing records
INSERT INTO Billing
(visit_id, bill_amount, payment_status)
VALUES
(1, 1500.00, 'Paid'),
(2, 2000.00, 'Paid'),
(3, 3500.00, 'Paid'),
(4, 1200.00, 'Pending'),
(5, 800.00, 'Paid'),
(6, 1800.00, 'Pending'),
(7, 2500.00, 'Paid'),
(8, 1600.00, 'Pending'),
(9, 3000.00, 'Pending'),
(10, 1000.00, 'Paid');
GO

PRINT 'Hospital sample data inserted successfully!';
GO
