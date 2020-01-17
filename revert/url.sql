-- Revert scrapetition-sql:url from sqlite

BEGIN;

DROP TABLE IF EXISTS scrapetition.url;

COMMIT;
