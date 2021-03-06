-- Deploy adjust_privilege
-- requires: schema
-- requires:  roles

-- Adjust privilege integer by ORing bitwise. You can provide a
-- constant bitmask to adjust privileges always granted by security
-- policies for RLS, e.g. 484 = rwxr__r__ if select is globally
-- allowed and rwx is allowed to the owner.

BEGIN;

CREATE FUNCTION scrapetition.adjust_privilege()
       RETURNS TRIGGER AS $$
       BEGIN
       NEW.privilege = coalesce(NEW.privilege | coalesce(TG_ARGV[0]::integer, 0),
       		       		OLD.privilege,
				TG_ARGV[0]::integer,
				448);
       RETURN NEW;
       END;
       $$ language 'plpgsql';

COMMIT;
