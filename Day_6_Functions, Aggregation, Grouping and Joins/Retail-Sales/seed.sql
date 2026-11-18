
USE RetailSalesDB;
GO

--------------------------------------------------
-- 1. CUSTOMERS
--------------------------------------------------

INSERT INTO Customers (customer_name, email, city)
VALUES
('Arun Kumar', 'arun@gmail.com', 'Chennai'),
('Priya Sharma', 'priya@gmail.com', 'Bangalore'),
('Rahul Verma', 'rahul@gmail.com', 'Chennai'),
('Sneha Raj', 'sneha@gmail.com', 'Hyderabad'),
('Karthik S', 'karthik@gmail.com', 'Bangalore'),
('Divya Nair', 'divya@gmail.com', 'Kochi'),
('Vijay Anand', 'vijay@gmail.com', 'Chennai'),
('Meena Das', 'meena@gmail.com', 'Mumbai'),
('Sanjay Rao', 'sanjay@gmail.com', 'Hyderabad'),
('Anitha R', 'anitha@gmail.com', 'Coimbatore');
GO

--------------------------------------------------
-- 2. CATEGORIES
--------------------------------------------------

INSERT INTO Categories (category_name)
VALUES
('Electronics'),
('Mobiles'),
('Laptops'),
('Accessories'),
('Furniture'),
('Clothing'),
('Footwear'),
('Home Appliances'),
('Books'),
('Sports');
GO

--------------------------------------------------
-- 3. PRODUCTS
--------------------------------------------------

INSERT INTO Products (product_name, category_id)
VALUES
('Wireless Mouse', 4),
('Smartphone X', 2),
('Laptop Pro', 3),
('Bluetooth Headphones', 1),
('Office Chair', 5),
('Cotton T-Shirt', 6),
('Running Shoes', 7),
('Smart Television', 8),
('Database Book', 9),
('Football', 10);
GO

--------------------------------------------------
-- 4. ORDERS
--------------------------------------------------

INSERT INTO Orders (customer_id, order_date)
VALUES
(1, '2026-07-05'),
(1, '2026-07-15'),
(1, '2026-08-10'),
(1, '2026-09-20'),
(2, '2026-07-08'),
(2, '2026-08-18'),
(3, '2026-08-05'),
(3, '2026-09-12'),
(4, '2026-09-15'),
(4, '2026-10-03'),
(5, '2026-10-10'),
(6, '2026-10-15'),
(7, '2026-11-01'),
(8, '2026-11-05'),
(9, '2026-11-10');
GO

--------------------------------------------------
-- 5. ORDER ITEMS
--------------------------------------------------

INSERT INTO OrderItems
(order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 500),
(1, 4, 1, 1500),

(2, 2, 1, 25000),
(2, 1, 1, 500),

(3, 3, 1, 65000),
(3, 4, 2, 1500),

(4, 2, 2, 25000),
(4, 7, 1, 3000),

(5, 5, 1, 8000),
(5, 6, 2, 700),

(6, 3, 1, 65000),
(6, 1, 2, 500),

(7, 4, 3, 1500),
(7, 9, 2, 600),

(8, 2, 1, 25000),
(8, 10, 2, 900),

(9, 8, 1, 40000),
(9, 4, 1, 1500),

(10, 7, 2, 3000),
(10, 6, 3, 700),

(11, 3, 1, 65000),
(11, 1, 3, 500),

(12, 5, 2, 8000),
(12, 9, 1, 600),

(13, 2, 1, 25000),
(13, 4, 2, 1500),

(14, 8, 1, 40000),
(14, 10, 1, 900),

(15, 3, 1, 65000),
(15, 7, 1, 3000);
GO

--------------------------------------------------
-- 6. PAYMENTS
--------------------------------------------------

INSERT INTO Payments
(order_id, payment_date, payment_method, payment_amount)
VALUES
(1, '2026-07-05', 'UPI', 2500),
(2, '2026-07-15', 'Card', 25500),
(3, '2026-08-10', 'UPI', 68000),
(5, '2026-07-08', 'Cash', 9400),
(6, '2026-08-18', 'Card', 66000),
(7, '2026-08-05', 'UPI', 5700),
(8, '2026-09-12', 'UPI', 26800),
(9, '2026-09-15', 'Card', 41500),
(10, '2026-10-03', 'Cash', 8100),
(11, '2026-10-10', 'UPI', 68000),
(13, '2026-11-01', 'Card', 28000),
(15, '2026-11-10', 'UPI', 68000);
GO

PRINT 'Retail sales sample data inserted successfully!';
GO
