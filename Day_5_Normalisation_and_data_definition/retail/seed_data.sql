
USE RetailInventoryDB;
GO

-- TEST 1: Duplicate primary key
BEGIN TRY
    INSERT INTO Product
    (sku, product_name, category_id, supplier_id)
    VALUES ('P101', 'Duplicate Laptop', 1, 1);
END TRY
BEGIN CATCH
    SELECT 'TEST 1 - DUPLICATE KEY' AS TestName,
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

-- TEST 2: Missing parent record
BEGIN TRY
    INSERT INTO Product
    (sku, product_name, category_id, supplier_id)
    VALUES ('P999', 'Unknown Category Product', 999, 1);
END TRY
BEGIN CATCH
    SELECT 'TEST 2 - MISSING PARENT' AS TestName,
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

-- TEST 3: Negative quantity
BEGIN TRY
    INSERT INTO Inventory
    (sku, warehouse_id, quantity, reorder_level)
    VALUES ('P101', 2, -10, 5);
END TRY
BEGIN CATCH
    SELECT 'TEST 3 - NEGATIVE QUANTITY' AS TestName,
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO

-- TEST 4: NULL in mandatory column
BEGIN TRY
    INSERT INTO Supplier
    (supplier_id, supplier_name, supplier_phone)
    VALUES (11, NULL, '9876500011');
END TRY
BEGIN CATCH
    SELECT 'TEST 4 - NULL VALUE' AS TestName,
           ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
