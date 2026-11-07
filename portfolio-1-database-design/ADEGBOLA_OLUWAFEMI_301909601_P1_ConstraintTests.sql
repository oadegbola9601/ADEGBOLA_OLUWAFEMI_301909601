-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. store pk test. Expected: pk_store, SQLSTATE 23505.
INSERT INTO portfolio."store" ("store_id", "store_name", "city")
VALUES (1, 'South Market', 'Arbor');

-- 2. store not null test. Expected: city, SQLSTATE 23502.
INSERT INTO portfolio."store" ("store_id", "store_name", "city")
VALUES (100, 'West Market', NULL);

-- 3. product pk test. Expected: pk_product, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "unit_price", "active")
VALUES (2, 'SKU-002', 'Wool Scarf', 20, TRUE);

-- 4. product unique test. Expected: uq_product_0, SQLSTATE 23505.
INSERT INTO portfolio."product" ("product_id", "sku", "product_name", "unit_price", "active")
VALUES (101, 'SKU-001', 'Wool Scarf', 20, TRUE);

-- 5. sale pk test. Expected: pk_sale, SQLSTATE 23505.
INSERT INTO portfolio."sale" ("sale_id", "store_id", "receipt_no", "sold_at", "status")
VALUES (3, 1, 'R-101', '2026-11-07T11:00:00+00:00', 'completed');

-- 6. sale unique test. Expected: uq_sale_0, SQLSTATE 23505.
INSERT INTO portfolio."sale" ("sale_id", "store_id", "receipt_no", "sold_at", "status")
VALUES (102, 1, 'R-100', '2026-11-07T11:05:00Z', 'completed');

-- 7. sale fk test. Expected: fk_sale_0, SQLSTATE 23503.
INSERT INTO portfolio."sale" ("sale_id", "store_id", "receipt_no", "sold_at", "status")
VALUES (103, 999, 'R-102', '2026-11-07T11:10:00Z', 'completed');

-- 8. sale line pk test. Expected: pk_sale_line, SQLSTATE 23505.
INSERT INTO portfolio."sale_line" ("line_id", "sale_id", "product_id", "quantity", "unit_price")
VALUES (4, 3, 2, 1, 10);

-- 9. sale line sale fk test. Expected: fk_sale_line_0, SQLSTATE 23503.
INSERT INTO portfolio."sale_line" ("line_id", "sale_id", "product_id", "quantity", "unit_price")
VALUES (104, 999, 2, 1, 10);

-- 10. sale line product fk test. Expected: fk_sale_line_1, SQLSTATE 23503.
INSERT INTO portfolio."sale_line" ("line_id", "sale_id", "product_id", "quantity", "unit_price")
VALUES (105, 3, 998, 1, 10);

-- 11. sale line check test. Expected: positive_line_values, SQLSTATE 23514.
INSERT INTO portfolio."sale_line" ("line_id", "sale_id", "product_id", "quantity", "unit_price")
VALUES (106, 3, 2, 0, 10);
