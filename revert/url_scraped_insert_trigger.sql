-- Revert scrapetition-sql:url_scraped_insert_trigger from sqlite

BEGIN;

DROP TRIGGER IF EXISTS url_source_insert ON url_source;

DROP FUNCTION IF EXISTS url_source_insert();

COMMIT;
