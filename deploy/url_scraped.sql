-- Deploy scrapetition-sql:url_scraped to sqlite
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS url_scraped (
       source integer REFERENCES url(url_id),
       target	integer REFERENCES url(url_id),
       CONSTRAINT unique_source UNIQUE (source, target));

CREATE OR REPLACE VIEW url_source
       (source, source_url, target, target_url, first_seen, last_seen) AS
       SELECT source, s.url, target, t.url, s.first_seen, s.last_seen FROM
       url_scraped
       LEFT JOIN url AS s ON source=s.url_id
       LEFT JOIN url AS t ON target=t.url_id;


COMMIT;
