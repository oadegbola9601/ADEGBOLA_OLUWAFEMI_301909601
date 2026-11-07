# Retail ERP and POS Management System - database design

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

- Every product is identified by a unique SKU across the entire retail business.
- Each sales transaction must be linked to a valid store record.
- Receipt numbers cannot be duplicated within the same store. This ensures that no two transactions in a store share the same receipt number.
- Every sales line item must be associated with an existing sales transaction.
- Each sales line item must correspond to a valid product.
- Quantities recorded on sales line items must be greater than zero, while unit prices cannot be negative.

## Assumptions

- The dataset and benchmark values used in this project are artificially generated and do not contain any real customer, employee, payment, or transaction information.
- Each table uses a single-field primary key. Key values are assigned from a shared global numbering scheme, ensuring that identifiers remain unique across all tables.
- Product SKUs are unique throughout the retailer, whereas receipt numbers are unique only within an individual store.
- Sales line items can only reference sales transactions and products that already exist in the database. In addition, quantities must be positive and unit prices must be zero or greater.
- The normalization example is limited to the sale_line table and its relationships with the sale and product tables. Higher-level entities and relationships are intentionally excluded for simplicity and clarity.
