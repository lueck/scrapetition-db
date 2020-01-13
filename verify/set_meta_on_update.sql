-- Verify set_meta_on_update

BEGIN;

SELECT 'scrapetition.set_meta_on_update'::regproc;

SELECT pg_catalog.has_function_privilege('scrapetitionuser', 'scrapetition.set_meta_on_update()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitioneditor', 'scrapetition.set_meta_on_update()', 'EXECUTE');
SELECT pg_catalog.has_function_privilege('scrapetitionadmin', 'scrapetition.set_meta_on_update()', 'EXECUTE');

ROLLBACK;
