-- Deploy set_meta_on_update
-- requires: schema
-- requires: roles

BEGIN;

CREATE FUNCTION scrapetition.set_meta_on_update()
    RETURNS TRIGGER AS $$
    BEGIN
    NEW.updated_at = current_timestamp;
    NEW.updated_by = current_user;
    NEW.created_at = OLD.created_at;
    NEW.created_by = OLD.created_by;
    RETURN NEW;
    END;
    $$ language 'plpgsql';

COMMIT;
