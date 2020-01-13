-- Deploy scrapetition-sql:article_tag to pg
-- requires: schema
-- requires: role
-- requires: article
-- requires: set_meta_on_insert
-- requires: set_meta_on_update
-- requires: adjust_privilege


BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.article_tag (
       article_id INTEGER NOT NULL REFERENCES scrapetition.article (article_id),
       namespace TEXT NOT NULL,
       tag TEXT NOT NULL,
       text_value TEXT,
       numeric_value FLOAT,
       -- meta data for all types of tags
       created_at timestamp not null,
       created_by varchar not null,
       updated_at timestamp,
       updated_by varchar,
       gid varchar,
       privilege integer not null DEFAULT 436, -- o664
       FOREIGN KEY (namespace, tag) REFERENCES scrapetition.tag (namespace, tag),
       CONSTRAINT tag_unique_for_article UNIQUE (article_id, namespace, tag));


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE scrapetition.article_tag
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;


CREATE TRIGGER tag_set_meta_on_insert BEFORE INSERT ON scrapetition.article_tag
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_insert();

CREATE TRIGGER tag_set_meta_on_update BEFORE UPDATE ON scrapetition.article_tag
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_update();


CREATE TRIGGER adjust_privilege_on_insert BEFORE INSERT ON scrapetition.article_tag
       FOR EACH ROW EXECUTE PROCEDURE scrapetition.adjust_privilege(436);

CREATE TRIGGER adjust_privilege_on_update BEFORE UPDATE ON scrapetition.article_tag
       FOR EACH ROW EXECUTE PROCEDURE scrapetition.adjust_privilege(436);


ALTER TABLE scrapetition.article_tag ENABLE ROW LEVEL SECURITY;

-- Note: We do bitwise AND on the integer value of privilege and then
-- test if it equals the bitmask. privilege & 16 = 16 is the same as
-- privilege & (1<<4) = (1<<4), which may be more readable. For
-- performance reasons we replace (1<<4) with the count itself.

CREATE POLICY assert_well_formed ON scrapetition.article_tag
FOR INSERT TO scrapetitionuser
WITH CHECK (created_by = current_user);

CREATE POLICY assert_well_formed_null ON scrapetition.article_tag
FOR INSERT TO scrapetitionuser
WITH CHECK (created_by is null); -- if null, then is set to
				 -- current_user by trigger.

CREATE POLICY allow_insert_to_scrapetitioneditor ON scrapetition.article_tag
FOR INSERT TO scrapetitioneditor
WITH CHECK (true);


CREATE POLICY allow_select_to_creator ON scrapetition.article_tag
FOR SELECT TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_select_to_group_member ON scrapetition.article_tag
FOR SELECT TO scrapetitionuser
USING ((privilege & 16) = 16
        AND pg_has_role(gid, 'MEMBER'));

CREATE POLICY allow_select_to_others ON scrapetition.article_tag
FOR SELECT TO scrapetitionuser
USING (privilege & 2 = 2);

CREATE POLICY allow_select_to_scrapetitioneditor ON scrapetition.article_tag
FOR SELECT TO scrapetitioneditor
USING (true);


CREATE POLICY allow_update_to_creator ON scrapetition.article_tag
FOR UPDATE TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_update_to_group_member ON scrapetition.article_tag
FOR UPDATE TO scrapetitionuser
USING ((privilege & 16) = 16
        AND pg_has_role(gid, 'MEMBER'));

CREATE POLICY allow_update_to_others ON scrapetition.article_tag
FOR UPDATE TO scrapetitionuser
USING (privilege & 2 = 2);

CREATE POLICY allow_update_to_scrapetitioneditor ON scrapetition.article_tag
FOR UPDATE TO scrapetitioneditor
USING (true);

CREATE POLICY allow_delete_to_creator ON scrapetition.article_tag
FOR DELETE TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_delete_to_scrapetitioneditor ON scrapetition.article_tag
FOR DELETE TO scrapetitioneditor
USING (true);


COMMIT;
