-- Revert adjust_privilege

BEGIN;

DROP FUNCTION scrapetition.adjust_privilege();

COMMIT;
