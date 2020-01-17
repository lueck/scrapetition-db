-- Deploy scrapetition-sql:user to pg
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition."user" (
       user_id SERIAL PRIMARY KEY,
       "user" TEXT NOT NULL,
       domain TEXT NOT NULL,
       name   TEXT,
       url_id INTEGER NOT NULL REFERENCES scrapetition.url(url_id),
       first_scraped TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper TEXT,
       CONSTRAINT unique_user_in_domain UNIQUE ("user", domain));

GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition."user"
TO scraper;

GRANT SELECT, USAGE ON SEQUENCE scrapetition.user_user_id_seq
TO scraper, scrapetitionadmin;

GRANT SELECT ON TABLE scrapetition."user"
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON TABLE scrapetition."user"
TO scrapetitionadmin;

COMMIT;
