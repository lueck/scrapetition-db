-- Deploy scrapetition-sql:url to sqlite

BEGIN;

CREATE TABLE IF NOT EXISTS url (
       url_id	serial PRIMARY KEY,
       url	text   NOT NULL,
       -- time when first/last visited this url:
       first_seen timestamp,
       last_seen  timestamp,
       -- time when first/last found this url on a scraped page:
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       CONSTRAINT url_unique UNIQUE (url));

COMMIT;
