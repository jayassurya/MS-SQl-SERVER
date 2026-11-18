
-- DAY 6 - SET 1: RETAIL SALES REPORTING

CREATE DATABASE RetailSalesDB;
GO

USE RetailSalesDB;
GO

-- 1. Customers
CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50) NOT NULL
);
GO

-- 2. Categories
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);
GO

-- 3. Products
CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES Categories(category_id)
);
GO

-- 4. Orders
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id)
);
GO

-- 5. Order Items
CREATE TABLE OrderItems (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);
GO

-- 6. Payments
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_date DATE NOT NULL DEFAULT GETDATE(),
    payment_method VARCHAR(30) NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL
        CHECK (payment_amount >= 0),

    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);
GO

PRINT 'RetailSalesDB and all six tables created successfully!';
GO
