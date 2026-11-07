-- Retail ERP and POS Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."store" (
  "store_id" bigint NOT NULL,
  "store_name" text NOT NULL,
  "city" text NOT NULL,
  CONSTRAINT "pk_store" PRIMARY KEY ("store_id")
);
CREATE TABLE portfolio."product" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "product_name" text NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_product" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_product_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."sale" (
  "sale_id" bigint NOT NULL,
  "store_id" bigint NOT NULL,
  "receipt_no" text NOT NULL,
  "sold_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_sale" PRIMARY KEY ("sale_id"),
  CONSTRAINT "uq_sale_0" UNIQUE ("store_id", "receipt_no")
);
CREATE TABLE portfolio."sale_line" (
  "line_id" bigint NOT NULL,
  "sale_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_sale_line" PRIMARY KEY ("line_id")
);
ALTER TABLE portfolio."sale" ADD CONSTRAINT "fk_sale_0" FOREIGN KEY ("store_id") REFERENCES portfolio."store" ("store_id");
ALTER TABLE portfolio."sale_line" ADD CONSTRAINT "fk_sale_line_0" FOREIGN KEY ("sale_id") REFERENCES portfolio."sale" ("sale_id");
ALTER TABLE portfolio."sale_line" ADD CONSTRAINT "fk_sale_line_1" FOREIGN KEY ("product_id") REFERENCES portfolio."product" ("product_id");
ALTER TABLE portfolio."sale_line" ADD CONSTRAINT "positive_line_values" CHECK (("quantity" > 0) AND ("unit_price" >= 0));
COMMIT;
