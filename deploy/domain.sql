-- Deploy scrapetition-sql:domain to pg
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS domain (
       domain_id SERIAL PRIMARY KEY,
       domain 	 TEXT NOT NULL UNIQUE);

INSERT INTO domain (domain)
SELECT substring(url from '(?:.*://)?([^/]*)') AS domain FROM url GROUP BY domain;




ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS domain_id INTEGER REFERENCES domain (domain_id);

CREATE OR REPLACE FUNCTION get_domain_id_for_url_id(INTEGER)
RETURNS INTEGER AS $$
	SELECT domain_id FROM domain WHERE domain = substring((SELECT url FROM url WHERE url_id = $1) from '(?:.*://)?([^/]*)')
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_domain(INTEGER)
RETURNS TEXT AS $$
	SELECT domain FROM domain WHERE domain_id = $1;
$$ LANGUAGE SQL;


UPDATE comment SET domain_id = get_domain_id_for_url_id(url_id);

DROP VIEW IF EXISTS comments;

ALTER TABLE IF EXISTS comment
      ADD CONSTRAINT comment_unique_in_domain UNIQUE (id, domain_id);
ALTER TABLE IF EXISTS comment
      DROP CONSTRAINT IF EXISTS unique_comment_in_domain;
ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS domain;





COMMIT;
