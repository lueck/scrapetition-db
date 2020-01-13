-- Revert set_meta_on_update

BEGIN;

DROP FUNCTION scrapetition.set_meta_on_update();

COMMIT;
