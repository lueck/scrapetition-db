-- Revert scrapetition-sql:comments_insert_trigger from pg

BEGIN;

DROP TRIGGER IF EXISTS comments_insert ON comments;

DROP FUNCTION IF EXISTS comments_insert();

COMMIT;
