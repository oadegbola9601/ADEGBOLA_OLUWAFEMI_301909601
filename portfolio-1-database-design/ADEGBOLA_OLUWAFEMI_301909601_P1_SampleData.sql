-- Fictional sample records for Retail ERP and POS Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."store" ("store_id", "store_name", "city") VALUES (1, 'North Market', 'Linden');
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "unit_price", "active") VALUES (2, 'SKU-001', 'Canvas Tote', 12.5, TRUE);
INSERT INTO portfolio."sale" ("sale_id", "store_id", "receipt_no", "sold_at", "status") VALUES (3, 1, 'R-100', '2026-11-07T10:15:00Z', 'completed');
INSERT INTO portfolio."sale_line" ("line_id", "sale_id", "product_id", "quantity", "unit_price") VALUES (4, 3, 2, 2, 12.5);
COMMIT;
