-- Revert scrapetition-sql:comments from sqlite

BEGIN;

DROP TABLE IF EXISTS scrapetition.comment;

COMMIT;
