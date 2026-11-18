
USE RetailInventoryDB;
GO

-- ==========================================
-- 1. VERIFY ALL TABLES
-- ==========================================

PRINT '1. DATABASE TABLES';

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO


-- ==========================================
-- 2. VERIFY RECORD COUNTS
-- ==========================================

PRINT '2. TOTAL RECORDS IN EACH TABLE';

SELECT 'Supplier' AS TableName, COUNT(*) AS TotalRecords
FROM Supplier

UNION ALL

SELECT 'Category', COUNT(*)
FROM Category

UNION ALL

SELECT 'Warehouse', COUNT(*)
FROM Warehouse

UNION ALL

SELECT 'Product', COUNT(*)
FROM Product

UNION ALL

SELECT 'Inventory', COUNT(*)
FROM Inventory;
GO


-- ==========================================
-- 3. DISPLAY SUPPLIER DETAILS
-- ==========================================

PRINT '3. SUPPLIER DETAILS';

SELECT *
FROM Supplier
ORDER BY supplier_id;
GO


-- ==========================================
-- 4. DISPLAY PRODUCT DETAILS
-- ==========================================

PRINT '4. PRODUCT DETAILS';

SELECT
    P.sku,
    P.product_name,
    C.category_name,
    S.supplier_name,
    S.supplier_phone,
    P.product_status
FROM Product P
INNER JOIN Category C
ON P.category_id = C.category_id

INNER JOIN Supplier S
ON P.supplier_id = S.supplier_id

ORDER BY P.sku;
GO


-- ==========================================
-- 5. DISPLAY INVENTORY DETAILS
-- ==========================================

PRINT '5. INVENTORY DETAILS';

SELECT
    P.sku,
    P.product_name,
    W.warehouse_name,
    W.location,
    I.quantity,
    I.reorder_level
FROM Inventory I

INNER JOIN Product P
ON I.sku = P.sku

INNER JOIN Warehouse W
ON I.warehouse_id = W.warehouse_id

ORDER BY P.sku;
GO


-- ==========================================
-- 6. IDENTIFY PRODUCTS NEEDING REORDER
-- ==========================================

PRINT '6. PRODUCTS NEEDING REORDER';

SELECT
    P.sku,
    P.product_name,
    I.quantity,
    I.reorder_level
FROM Product P

INNER JOIN Inventory I
ON P.sku = I.sku

WHERE I.quantity <= I.reorder_level;
GO


-- ==========================================
-- 7. VERIFY FOREIGN KEY RELATIONSHIPS
-- ==========================================

PRINT '7. FOREIGN KEY CONSTRAINTS';

SELECT
    name AS ForeignKeyName,
    OBJECT_NAME(parent_object_id) AS TableName,
    OBJECT_NAME(referenced_object_id) AS ReferencedTable
FROM sys.foreign_keys
ORDER BY TableName;
GO


PRINT 'DATABASE VERIFICATION COMPLETED';
GO
