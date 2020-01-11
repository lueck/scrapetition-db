-- Deploy scrapetition-sql:comment_voting to pg
-- requires: user
-- requires: comments
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS comment_voting (
       comment_voting_id SERIAL PRIMARY KEY,
       domain  TEXT NOT NULL,
       user_id INTEGER NOT NULL REFERENCES "user" (user_id),
       comment_id INTEGER NOT NULL REFERENCES comment (comment_id),
       vote INTEGER,
       -- meta data
       url_id INTEGER NOT NULL REFERENCES url (url_id),
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper text,
       CONSTRAINT one_comment_voting_per_user UNIQUE (domain, user_id, comment_id));

COMMIT;
