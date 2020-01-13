-- Deploy roles
-- requires: schema

BEGIN;

-- As long as password is null, login is impossible.
CREATE ROLE scraper NOINHERIT BYPASSRLS LOGIN PASSWORD NULL;

CREATE ROLE scrapetitionuser NOLOGIN NOINHERIT;
CREATE ROLE scrapetitioneditor NOLOGIN NOINHERIT;
CREATE ROLE scrapetitionadmin NOLOGIN NOINHERIT CREATEROLE;

GRANT USAGE ON SCHEMA scrapetition
TO scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;


GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA scrapetition
TO scraper;

GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA scrapetition
TO scraper;


GRANT SELECT ON ALL TABLES IN SCHEMA scrapetition
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA scrapetition
TO scrapetitionadmin;

COMMIT;
