-- Revert scrapetition-sql:comments from sqlite

BEGIN;

DROP VIEW IF EXISTS comments;

DROP TABLE IF EXISTS comment;

COMMIT;
