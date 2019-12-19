-- Revert scrapetition-sql:url from sqlite

BEGIN;

DROP TABLE IF EXISTS url;

COMMIT;
