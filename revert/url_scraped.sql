-- Revert scrapetition-sql:url_scraped from sqlite

BEGIN;

DROP VIEW IF EXISTS url_source;

DROP TABLE IF EXISTS url_scraped;

COMMIT;
