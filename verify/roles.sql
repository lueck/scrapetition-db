-- Verify arbroles

BEGIN;

-- this also verifies the existence of the three roles. 
SELECT has_schema_privilege('scraper', 'scrapetition', 'USAGE');
SELECT has_schema_privilege('scrapetitionuser', 'scrapetition', 'USAGE');
SELECT has_schema_privilege('scrapetitioneditor', 'scrapetition', 'USAGE');
SELECT has_schema_privilege('scrapetitionadmin', 'scrapetition', 'USAGE');

ROLLBACK;
