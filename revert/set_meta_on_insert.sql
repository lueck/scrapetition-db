-- Revert set_meta_on_insert

BEGIN;

DROP FUNCTION scrapetition.set_meta_on_insert();

COMMIT;
