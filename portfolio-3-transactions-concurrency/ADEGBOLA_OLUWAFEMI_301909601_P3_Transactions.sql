-- This helper counter exists only in the temporary transaction exercise.
-- Original case columns and constraints are preserved. It is not part of the P1 design.
ALTER TABLE portfolio."sale" ADD COLUMN "p3_processed_count" integer NOT NULL DEFAULT 0;
ALTER TABLE portfolio."sale" ADD CONSTRAINT "p3_count_nonnegative" CHECK ("p3_processed_count" >= 0);

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."sale" SET "p3_processed_count" = "p3_processed_count" + 1 WHERE "sale_id" IS NOT DISTINCT FROM 3 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3;

BEGIN ISOLATION LEVEL READ COMMITTED;
UPDATE portfolio."sale" SET "p3_processed_count" = "p3_processed_count" + 10 WHERE "sale_id" IS NOT DISTINCT FROM 3 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A negative counter deliberately fails its CHECK. Keep psql open so ROLLBACK can run.
\set ON_ERROR_STOP off
\set VERBOSITY verbose
UPDATE portfolio."sale" SET "p3_processed_count" = -1 WHERE "sale_id" IS NOT DISTINCT FROM 3 RETURNING json_build_object('processed_count',"p3_processed_count");
-- A failed transaction rejects another statement until it is rolled back.
SELECT 1;
ROLLBACK;
\set ON_ERROR_STOP on
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3;
