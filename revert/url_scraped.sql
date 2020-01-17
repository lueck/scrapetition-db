-- Revert scrapetition-sql:url_scraped from sqlite

BEGIN;

DROP VIEW IF EXISTS scrapetition.url_source;

DROP TABLE IF EXISTS scrapetition.url_scraped;

COMMIT;
