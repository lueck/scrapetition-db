-- Revert scrapetition-sql:domain from pg

BEGIN;

ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS domain TEXT;

UPDATE comment SET domain = get_domain(domain_id);

ALTER TABLE IF EXISTS comment
      ADD CONSTRAINT unique_comment_in_domain UNIQUE (id, domain);
ALTER TABLE IF EXISTS comment
      DROP CONSTRAINT IF EXISTS comment_unique_in_domain;
ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS domain_id;

DROP FUNCTION IF EXISTS get_domain(INTEGER);
DROP FUNCTION IF EXISTS get_domain_id_for_url_id(INTEGER);


DROP TABLE IF EXISTS domain;

COMMIT;
