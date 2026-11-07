-- Show related sale, sale_line, product records (up to 20).
SELECT t0."sale_id" AS "sale_sale_id",
       t0."receipt_no" AS "sale_receipt_no",
       t1."line_id" AS "sale_line_line_id",
       t1."quantity" AS "sale_line_quantity",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."sale" t0
JOIN portfolio."sale_line" t1 ON t1."sale_id" = t0."sale_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
ORDER BY t0."sale_id", t1."line_id", t2."product_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."sale_id" AS "sale_sale_id",
       t0."receipt_no" AS "sale_receipt_no",
       t1."line_id" AS "sale_line_line_id",
       t1."quantity" AS "sale_line_quantity",
       t2."product_id" AS "product_product_id",
       t2."sku" AS "product_sku"
FROM portfolio."sale" t0
JOIN portfolio."sale_line" t1 ON t1."sale_id" = t0."sale_id"
JOIN portfolio."product" t2 ON t1."product_id" = t2."product_id"
ORDER BY t0."sale_id", t1."line_id", t2."product_id"
LIMIT 20;

-- Find sale records where sold_at matches "2026-11-07T10:15:00Z" (up to 20).
SELECT * FROM portfolio."sale"
WHERE "sold_at" IS NOT DISTINCT FROM '2026-11-07T10:15:00Z'
ORDER BY "sale_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."sale"
WHERE "sold_at" IS NOT DISTINCT FROM '2026-11-07T10:15:00Z'
ORDER BY "sale_id"
LIMIT 20;

-- Count sale records for each store_id (up to 20 groups).
SELECT "store_id", count(*) AS record_count
FROM portfolio."sale"
GROUP BY "store_id"
ORDER BY record_count DESC, "store_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "store_id", count(*) AS record_count
FROM portfolio."sale"
GROUP BY "store_id"
ORDER BY record_count DESC, "store_id" NULLS LAST
LIMIT 20;
