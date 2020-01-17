-- Revert scrapetition-sql:schema from pg

BEGIN;


DROP SCHEMA IF EXISTS scrapetition;


COMMIT;
