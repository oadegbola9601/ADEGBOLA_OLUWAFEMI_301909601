-- Use two psql terminals connected to the same exercise database.
-- Follow the numbered order across Session A and Session B.

-- 2. Session B: also read 1 before A writes.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3;

-- 4. Session B: write its stale value. The final count is 2, so one increment is lost.
UPDATE portfolio."sale" SET "p3_processed_count" = 2 WHERE "sale_id" IS NOT DISTINCT FROM 3 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3;

-- 7. Session B: request the same row lock. This statement waits.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3 FOR UPDATE;

-- 9. Session B: its SELECT now returns 2. Apply the second increment and commit.
UPDATE portfolio."sale" SET "p3_processed_count" = 3 WHERE "sale_id" IS NOT DISTINCT FROM 3 RETURNING json_build_object('processed_count',"p3_processed_count");
COMMIT;
SELECT "sale_id", "p3_processed_count" FROM portfolio."sale" WHERE "sale_id" IS NOT DISTINCT FROM 3;
