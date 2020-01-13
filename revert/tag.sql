-- Revert scrapetition-sql:tag from pg

BEGIN;

DROP POLICY IF EXISTS assert_well_formed ON scrapetition.tag;
DROP POLICY IF EXISTS assert_well_formed_null ON scrapetition.tag;
DROP POLICY IF EXISTS allow_insert_to_scrapetitioneditor ON scrapetition.tag;
DROP POLICY IF EXISTS allow_select_to_creator ON scrapetition.tag;
DROP POLICY IF EXISTS allow_select_to_group_member ON scrapetition.tag;
DROP POLICY IF EXISTS allow_select_to_others ON scrapetition.tag;
DROP POLICY IF EXISTS allow_select_to_scrapetitioneditor ON scrapetition.tag;
DROP POLICY IF EXISTS allow_update_to_creator ON scrapetition.tag;
DROP POLICY IF EXISTS allow_update_to_group_member ON scrapetition.tag;
DROP POLICY IF EXISTS allow_update_to_others ON scrapetition.tag;
DROP POLICY IF EXISTS allow_update_to_scrapetitioneditor ON scrapetition.tag;
DROP POLICY IF EXISTS allow_delete_to_creator ON scrapetition.tag;
DROP POLICY IF EXISTS allow_delete_to_scrapetitioneditor ON scrapetition.tag;

REVOKE ALL PRIVILEGES ON scrapetition.tag
FROM scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

-- REVOKE ALL PRIVILEGES ON scrapetition.tag_tag_id_seq
-- FROM scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

DROP TRIGGER tag_set_meta_on_update ON scrapetition.tag;

DROP TRIGGER tag_set_meta_on_insert ON scrapetition.tag;

DROP TRIGGER adjust_privilege_on_insert ON scrapetition.tag;

DROP TRIGGER adjust_privilege_on_update ON scrapetition.tag;

DROP FUNCTION scrapetition.evaluate_tag();

DROP TABLE IF EXISTS scrapetition.tag;

DROP TYPE IF EXISTS scrapetition.tag_type;

COMMIT;
