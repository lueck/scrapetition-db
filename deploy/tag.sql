-- Deploy scrapetition-sql:tag to pg

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.tag (
       tag TEXT NOT NULL,
       namespace TEXT NOT NULL DEFAULT CURRENT_USER,
       description TEXT,
       text_value_regex TEXT DEFAULT '.*',
       -- meta data for all types of tags
       created_at timestamp not null,
       created_by varchar not null,
       updated_at timestamp,
       updated_by varchar,
       gid varchar,
       privilege integer not null DEFAULT 436, -- o664
       CONSTRAINT tag_unique_for_user PRIMARY KEY (tag, namespace));


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE scrapetition.tag
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;


CREATE TRIGGER tag_set_meta_on_insert BEFORE INSERT ON scrapetition.tag
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_insert();

CREATE TRIGGER tag_set_meta_on_update BEFORE UPDATE ON scrapetition.tag
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_update();


CREATE TRIGGER adjust_privilege_on_insert BEFORE INSERT ON scrapetition.tag
       FOR EACH ROW EXECUTE PROCEDURE scrapetition.adjust_privilege(436);

CREATE TRIGGER adjust_privilege_on_update BEFORE UPDATE ON scrapetition.tag
       FOR EACH ROW EXECUTE PROCEDURE scrapetition.adjust_privilege(436);


ALTER TABLE scrapetition.tag ENABLE ROW LEVEL SECURITY;

-- Note: We do bitwise AND on the integer value of privilege and then
-- test if it equals the bitmask. privilege & 16 = 16 is the same as
-- privilege & (1<<4) = (1<<4), which may be more readable. For
-- performance reasons we replace (1<<4) with the count itself.

CREATE POLICY assert_well_formed ON scrapetition.tag
FOR INSERT TO scrapetitionuser
WITH CHECK (created_by = current_user);

CREATE POLICY assert_well_formed_null ON scrapetition.tag
FOR INSERT TO scrapetitionuser
WITH CHECK (created_by is null); -- if null, then is set to
				 -- current_user by trigger.

CREATE POLICY allow_insert_to_scrapetitioneditor ON scrapetition.tag
FOR INSERT TO scrapetitioneditor
WITH CHECK (true);


CREATE POLICY allow_select_to_creator ON scrapetition.tag
FOR SELECT TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_select_to_group_member ON scrapetition.tag
FOR SELECT TO scrapetitionuser
USING ((privilege & 16) = 16
        AND pg_has_role(gid, 'MEMBER'));

CREATE POLICY allow_select_to_others ON scrapetition.tag
FOR SELECT TO scrapetitionuser
USING (privilege & 2 = 2);

CREATE POLICY allow_select_to_scrapetitioneditor ON scrapetition.tag
FOR SELECT TO scrapetitioneditor
USING (true);


CREATE POLICY allow_update_to_creator ON scrapetition.tag
FOR UPDATE TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_update_to_group_member ON scrapetition.tag
FOR UPDATE TO scrapetitionuser
USING ((privilege & 16) = 16
        AND pg_has_role(gid, 'MEMBER'));

CREATE POLICY allow_update_to_others ON scrapetition.tag
FOR UPDATE TO scrapetitionuser
USING (privilege & 2 = 2);

CREATE POLICY allow_update_to_scrapetitioneditor ON scrapetition.tag
FOR UPDATE TO scrapetitioneditor
USING (true);

CREATE POLICY allow_delete_to_creator ON scrapetition.tag
FOR DELETE TO scrapetitionuser
USING (created_by = current_user);

CREATE POLICY allow_delete_to_scrapetitioneditor ON scrapetition.tag
FOR DELETE TO scrapetitioneditor
USING (true);


COMMIT;
