
USE RetailInventoryDB;
GO

-- 1. Supplier Table
CREATE TABLE Supplier (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_phone VARCHAR(15) NOT NULL UNIQUE
);

-- 2. Category Table
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Warehouse Table
CREATE TABLE Warehouse (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- 4. Product Table
CREATE TABLE Product (
    sku VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    product_status VARCHAR(20)
        NOT NULL DEFAULT 'Active',

    CONSTRAINT FK_Product_Category
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id),

    CONSTRAINT FK_Product_Supplier
        FOREIGN KEY (supplier_id)
        REFERENCES Supplier(supplier_id)
);

-- 5. Inventory Table
CREATE TABLE Inventory (
    sku VARCHAR(20) NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,

    CONSTRAINT PK_Inventory
        PRIMARY KEY (sku, warehouse_id),

    CONSTRAINT CK_Inventory_Quantity
        CHECK (quantity >= 0),

    CONSTRAINT CK_Inventory_Reorder
        CHECK (reorder_level >= 0),

    CONSTRAINT FK_Inventory_Product
        FOREIGN KEY (sku)
        REFERENCES Product(sku)
        ON DELETE CASCADE,

    CONSTRAINT FK_Inventory_Warehouse
        FOREIGN KEY (warehouse_id)
        REFERENCES Warehouse(warehouse_id)
);
GO


