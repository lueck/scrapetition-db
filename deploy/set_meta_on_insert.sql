-- Deploy set_meta_on_insert
-- requires: schema
-- requires: roles

-- This function can be reused by triggers that update meta data on
-- insert or update.

BEGIN;

CREATE OR REPLACE FUNCTION scrapetition.set_meta_on_insert()
    RETURNS TRIGGER AS $$
    BEGIN
    NEW.created_at = current_timestamp;
    NEW.created_by = coalesce(NEW.created_by, current_user);
    RETURN NEW;
    END;
    $$ language 'plpgsql';

COMMIT;
