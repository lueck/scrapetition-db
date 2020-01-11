-- Revert scrapetition-sql:user from pg

BEGIN;

DROP TABLE IF EXISTS "user";

COMMIT;
