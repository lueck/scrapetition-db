-- Verify set_meta_on_insert

BEGIN;

-- functions are stored on pg_proc system table.
SELECT 'scrapetition.set_meta_on_insert'::regproc;

SELECT pg_catalog.has_function_privilege('scrapetitionuser', 'scrapetition.set_meta_on_insert()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitioneditor', 'scrapetition.set_meta_on_insert()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitionadmin', 'scrapetition.set_meta_on_insert()', 'EXECUTE');

ROLLBACK;
