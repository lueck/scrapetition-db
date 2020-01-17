-- Revert scrapetition-sql:article from pg

BEGIN;

DROP TABLE IF EXISTS scrapetition.article;

COMMIT;
