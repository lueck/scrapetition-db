-- Deploy scrapetition-sql:url_scraped to sqlite
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.url_scraped (
       source integer REFERENCES scrapetition.url(url_id),
       target	integer REFERENCES scrapetition.url(url_id),
       CONSTRAINT unique_source UNIQUE (source, target));

CREATE OR REPLACE VIEW scrapetition.url_source
       (source, source_url, target, target_url, first_seen, last_seen) AS
       SELECT source, s.url, target, t.url, s.first_seen, s.last_seen FROM
       scrapetition.url_scraped
       LEFT JOIN scrapetition.url AS s ON source=s.url_id
       LEFT JOIN scrapetition.url AS t ON target=t.url_id;


GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition.url_scraped
TO scraper;

GRANT SELECT ON TABLE scrapetition.url_scraped
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON TABLE scrapetition.url_scraped
TO scrapetitionadmin;

COMMIT;
