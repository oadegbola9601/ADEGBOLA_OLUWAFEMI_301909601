# Retail ERP and POS Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| sale_id | sale_line records (list) |
| --- | --- |
| 3 | [4] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| sale_line.line_id | sale_line.sale_id | sale_line.product_id | sale.sale_id | sale.store_id | sale.receipt_no | store.store_id | store.store_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 3 | 1 | R-100 | 1 | North Market |

Key: line_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## sale_line_example

| sale_line.line_id | sale_line.sale_id | sale_line.product_id | sale.sale_id | sale.store_id | sale.receipt_no | store.store_id | store.store_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 3 | 1 | R-100 | 1 | North Market |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## store

| store_id | store_name | city |
| --- | --- | --- |
| 1 | North Market | Linden |

## product

| product_id | sku | product_name | unit_price | active |
| --- | --- | --- | --- | --- |
| 2 | SKU-001 | Canvas Tote | 12.5 | true |

## sale

| sale_id | store_id | receipt_no | sold_at | status |
| --- | --- | --- | --- | --- |
| 3 | 1 | R-100 | 2026-11-07T10:15:00+00:00 | completed |

## sale_line

| line_id | sale_id | product_id | quantity | unit_price |
| --- | --- | --- | --- | --- |
| 4 | 3 | 2 | 2 | 12.5 |

## Dependencies

- store: (store_id) → store_name, city
- product: (product_id) → sku, product_name, unit_price, active
- sale: (sale_id) → store_id, receipt_no, sold_at, status
- sale_line: (line_id) → sale_id, product_id, quantity, unit_price

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
