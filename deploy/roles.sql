-- Deploy roles
-- requires: schema

BEGIN;

DO
$$
BEGIN
    IF NOT EXISTS (
       SELECT from pg_catalog.pg_roles
       WHERE rolname = 'scraper')
       THEN
       -- As long as password is null, login is impossible.
       CREATE ROLE scraper NOINHERIT BYPASSRLS LOGIN PASSWORD NULL;
    END IF;
    IF NOT EXISTS (
       SELECT from pg_catalog.pg_roles
       WHERE rolname = 'scrapetitionuser')
       THEN
       CREATE ROLE scrapetitionuser NOLOGIN NOINHERIT;
    END IF;
    IF NOT EXISTS (
       SELECT from pg_catalog.pg_roles
       WHERE rolname = 'scrapetitioneditor')
       THEN
       CREATE ROLE scrapetitioneditor NOLOGIN NOINHERIT;
    END IF;
    IF NOT EXISTS (
       SELECT from pg_catalog.pg_roles
       WHERE rolname = 'scrapetitionadmin')
       THEN
       CREATE ROLE scrapetitionadmin NOLOGIN NOINHERIT CREATEROLE;
    END IF;
END
$$;

GRANT USAGE ON SCHEMA scrapetition
TO scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

COMMIT;
