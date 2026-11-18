USE RetailInventoryDB;
GO

-- ==========================================
-- OPERATION 1: UPDATE SUPPLIER PHONE NUMBER
-- ==========================================

PRINT '1. SUPPLIER DETAILS BEFORE UPDATE';

SELECT *
FROM Supplier
WHERE supplier_id = 1;

-- Update supplier phone number
UPDATE Supplier
SET supplier_phone = '9123456780'
WHERE supplier_id = 1;

PRINT 'SUPPLIER DETAILS AFTER UPDATE';

SELECT *
FROM Supplier
WHERE supplier_id = 1;


-- ==========================================
-- OPERATION 2: MARK PRODUCT AS DISCONTINUED
-- ==========================================

PRINT '2. PRODUCT DETAILS BEFORE UPDATE';

SELECT *
FROM Product
WHERE sku = 'P110';

UPDATE Product
SET product_status = 'Discontinued'
WHERE sku = 'P110';

PRINT 'PRODUCT DETAILS AFTER UPDATE';

SELECT *
FROM Product
WHERE sku = 'P110';


-- ==========================================
-- OPERATION 3: DELETE DISCONTINUED PRODUCT
-- ==========================================

PRINT '3. PRODUCT AND INVENTORY BEFORE DELETE';

SELECT
    P.sku,
    P.product_name,
    P.product_status,
    I.warehouse_id,
    I.quantity
FROM Product P
LEFT JOIN Inventory I
    ON P.sku = I.sku
WHERE P.sku = 'P110';

-- Delete discontinued product
DELETE FROM Product
WHERE sku = 'P110'
AND product_status = 'Discontinued';

PRINT 'PRODUCT DETAILS AFTER DELETE';

SELECT *
FROM Product
WHERE sku = 'P110';


-- ==========================================
-- OPERATION 4: VERIFY CASCADE DELETE
-- ==========================================

PRINT '4. INVENTORY DETAILS AFTER DELETE';

SELECT *
FROM Inventory
WHERE sku = 'P110';

PRINT 'TASK 4 COMPLETED SUCCESSFULLY';
GO
