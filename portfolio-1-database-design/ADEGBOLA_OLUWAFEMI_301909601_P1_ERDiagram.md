# Retail ERP and POS Management System — ER diagram

```mermaid
erDiagram
    direction LR
    store {
        bigint store_id PK
        text store_name
        text city
    }
    product {
        bigint product_id PK
        text sku UK
        text product_name
        numeric unit_price
        boolean active
    }
    sale {
        bigint sale_id PK
        bigint store_id FK
        text receipt_no
        timestamptz sold_at
        text status
    }
    sale_line {
        bigint line_id PK
        bigint sale_id FK
        bigint product_id FK
        integer quantity
        numeric unit_price
    }
    store ||--o{ sale : "store_id"
    sale ||--o{ sale_line : "sale_id"
    product ||--o{ sale_line : "product_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/ADEGBOLA_OLUWAFEMI_301909601_ERDiagram.png)
