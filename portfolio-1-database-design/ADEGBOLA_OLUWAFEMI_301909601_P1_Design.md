# Retail ERP and POS Management System — database design

My case study records store, product, sale, sale_line.

## Users

- Cashiers recording point-of-sale transactions
- Store managers reviewing sales
- Retail analysts comparing product and store performance

## Main operations

- Record a sale and its lines atomically, then commit if all referenced rows and checks are valid; roll back the transaction if a line is invalid.
- Filter sales by sold_at and status, joining store to label results.
- Join sale lines to products and sales to produce receipt details.
- Aggregate line revenue by store and product using quantity multiplied by unit_price.
- Separate benchmark plan: generate 50000 synthetic sale rows, run the same sold_at date-range filter without an index and with a B-tree index, compare result correctness and measured query plans; do not assume a performance outcome.

## Entities

| Entity | Information stored |
| --- | --- |
| store | Retail store locations. |
| product | Retail products and their current selling prices. |
| sale | A store receipt header with its sale time and status. |
| sale_line | A product and quantity recorded on a sale receipt. |

## store

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| store_id | BIGINT | PK | Yes |
| store_name | TEXT |  | Yes |
| city | TEXT |  | Yes |


## product

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| product_name | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## sale

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| sale_id | BIGINT | PK | Yes |
| store_id | BIGINT | FK | Yes |
| receipt_no | TEXT |  | Yes |
| sold_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- store_id → store.store_id
- Unique key: (store_id, receipt_no).

## sale_line

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| line_id | BIGINT | PK | Yes |
| sale_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
- sale_id → sale.sale_id
- product_id → product.product_id

## Relationships and business rules

- Each product SKU is unique across the retailer.
- Every sale references an existing store.
- A receipt number may occur only once within a store; simultaneous duplicate receipt attempts are rejected by this constraint.
- Every sale line references an existing sale.
- Every sale line references an existing product.
- Each sale line has quantity greater than zero and a nonnegative unit price.

## Assumptions

- All records and benchmark inputs are synthetic; no real customer, employee, payment, or sales data is used.
- Each entity has a single-column primary key, and ID values are allocated from one global namespace so keys are globally unique across these tables.
- A receipt number is unique within a store, while a product SKU is unique across the retailer.
- Sale lines refer to existing sales and products; line quantity must be positive and unit price nonnegative.
- The normalization example focuses only on sale_line and its sale and product references; it does not repeat ancestor roles in that example.

