-- Revert scrapetition-sql:comments_insert_trigger from pg

BEGIN;

DROP TRIGGER IF EXISTS comments_insert ON scrapetition.comments;

DROP FUNCTION IF EXISTS scrapetition.comments_insert();

COMMIT;
