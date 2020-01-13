-- Verify adjust_privilege

BEGIN;

SELECT 'scrapetition.adjust_privilege'::regproc;

SELECT pg_catalog.has_function_privilege('scrapetitionuser', 'scrapetition.adjust_privilege()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitioneditor', 'scrapetition.adjust_privilege()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitionadmin', 'scrapetition.adjust_privilege()', 'EXECUTE');


ROLLBACK;
