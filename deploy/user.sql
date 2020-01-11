-- Deploy scrapetition-sql:user to pg
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS "user" (
       user_id SERIAL PRIMARY KEY,
       "user" TEXT NOT NULL,
       domain TEXT NOT NULL,
       name   TEXT,
       url_id INTEGER NOT NULL REFERENCES url(url_id),
       first_scraped TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper TEXT,
       CONSTRAINT unique_user_in_domain UNIQUE ("user", domain));

COMMIT;
