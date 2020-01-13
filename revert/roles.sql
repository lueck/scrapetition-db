-- Revert arbroles

BEGIN;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA scrapetition
FROM scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA scrapetition
FROM scraper;

REVOKE USAGE ON SCHEMA scrapetition
FROM scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

DROP ROLE IF EXISTS scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

COMMIT;
