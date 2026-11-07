# Retail ERP and POS Management System — SQL queries

## 1. Show related sale, sale_line, product records (up to 20).

```sql
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
```

| sale_sale_id | sale_receipt_no | sale_line_line_id | sale_line_quantity | product_product_id | product_sku |
| --- | --- | --- | --- | --- | --- |
| 3 | R-100 | 4 | 2 | 2 | SKU-001 |

## 2. Find sale records where sold_at matches "2026-11-07T10:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."sale"
WHERE "sold_at" IS NOT DISTINCT FROM '2026-11-07T10:15:00Z'
ORDER BY "sale_id"
LIMIT 20;
```

| sale_id | store_id | receipt_no | sold_at | status |
| --- | --- | --- | --- | --- |
| 3 | 1 | R-100 | 2026-11-07T10:15:00+00:00 | completed |

## 3. Count sale records for each store_id (up to 20 groups).

```sql
SELECT "store_id", count(*) AS record_count
FROM portfolio."sale"
GROUP BY "store_id"
ORDER BY record_count DESC, "store_id" NULLS LAST
LIMIT 20;
```

| store_id | record_count |
| --- | --- |
| 1 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.419 | 2.419, 2.382, 2.561 | Sort → Seq Scan | 274 |
| After index | 0.283 | 0.278, 0.306, 0.283 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.419 ms to 0.283 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.392..2.395 rows=50 loops=1)
  Seq Scan on sale (actual time=0.014..2.354 rows=50 loops=1)
Planning Time: 0.331 ms
Execution Time: 2.419 ms
```

### Before index, run 2

```text
Sort (actual time=2.354..2.357 rows=50 loops=1)
  Seq Scan on sale (actual time=0.014..2.315 rows=50 loops=1)
Planning Time: 0.305 ms
Execution Time: 2.382 ms
```

### Before index, run 3

```text
Sort (actual time=2.533..2.536 rows=50 loops=1)
  Seq Scan on sale (actual time=0.014..2.495 rows=50 loops=1)
Planning Time: 0.312 ms
Execution Time: 2.561 ms
```

### After index, run 1

```text
Sort (actual time=0.225..0.227 rows=50 loops=1)
  Bitmap Heap Scan on sale (actual time=0.029..0.188 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=50 loops=1)
Planning Time: 0.543 ms
Execution Time: 0.278 ms
```

### After index, run 2

```text
Sort (actual time=0.252..0.255 rows=50 loops=1)
  Bitmap Heap Scan on sale (actual time=0.029..0.215 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=50 loops=1)
Planning Time: 0.509 ms
Execution Time: 0.306 ms
```

### After index, run 3

```text
Sort (actual time=0.229..0.232 rows=50 loops=1)
  Bitmap Heap Scan on sale (actual time=0.031..0.189 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.016 rows=50 loops=1)
Planning Time: 0.575 ms
Execution Time: 0.283 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run ADEGBOLA_OLUWAFEMI_301909601_P2_Queries.sql, then ADEGBOLA_OLUWAFEMI_301909601_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/ADEGBOLA_OLUWAFEMI_301909601_P2_QueryResults.png) · [Index comparison](screenshots/ADEGBOLA_OLUWAFEMI_301909601_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

