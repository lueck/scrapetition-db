-- Revert arbroles

BEGIN;

REVOKE USAGE ON SCHEMA scrapetition
FROM scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

-- We do not drop these users, because for different databases,
-- e.g. scrapetition and scrapetition_test, they are the same.

-- DROP ROLE IF EXISTS scraper, scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

COMMIT;
