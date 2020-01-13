-- Verify scrapetition-sql:schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('scrapetition', 'usage');

ROLLBACK;
