-- Revert scrapetition-sql:article_tag from pg

BEGIN;

DROP POLICY IF EXISTS assert_well_formed ON scrapetition.article_tag;
DROP POLICY IF EXISTS assert_well_formed_null ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_insert_to_scrapetitioneditor ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_select_to_creator ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_select_to_group_member ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_select_to_others ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_select_to_scrapetitioneditor ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_update_to_creator ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_update_to_group_member ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_update_to_others ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_update_to_scrapetitioneditor ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_delete_to_creator ON scrapetition.article_tag;
DROP POLICY IF EXISTS allow_delete_to_scrapetitioneditor ON scrapetition.article_tag;

REVOKE ALL PRIVILEGES ON scrapetition.article_tag
FROM scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

-- REVOKE ALL PRIVILEGES ON scrapetition.article_tag_tag_id_seq
-- FROM scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

DROP TRIGGER tag_set_meta_on_update ON scrapetition.article_tag;

DROP TRIGGER tag_set_meta_on_insert ON scrapetition.article_tag;

DROP TRIGGER adjust_privilege_on_insert ON scrapetition.article_tag;

DROP TRIGGER adjust_privilege_on_update ON scrapetition.article_tag;

DROP TABLE scrapetition.article_tag;

COMMIT;
