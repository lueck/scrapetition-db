-- Deploy scrapetition-sql:url to pg

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.url (
       url_id	serial PRIMARY KEY,
       url	text   NOT NULL,
       -- time when first/last visited this url:
       first_seen timestamp,
       last_seen  timestamp,
       -- time when first/last found this url on a scraped page:
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       CONSTRAINT url_unique UNIQUE (url));


GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition.url
TO scraper;

GRANT SELECT, USAGE ON SEQUENCE scrapetition.url_url_id_seq
TO scraper, scrapetitionadmin;

GRANT SELECT ON TABLE scrapetition.url
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON TABLE scrapetition.url
TO scrapetitionadmin;

COMMIT;
