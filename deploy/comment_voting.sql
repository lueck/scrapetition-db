-- Deploy scrapetition-sql:comment_voting to pg
-- requires: user
-- requires: comments
-- requires: url

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.comment_voting (
       comment_voting_id SERIAL PRIMARY KEY,
       domain  TEXT NOT NULL,
       user_id INTEGER NOT NULL REFERENCES scrapetition."user" (user_id),
       comment_id INTEGER NOT NULL REFERENCES scrapetition.comment (comment_id),
       vote INTEGER,
       -- meta data
       url_id INTEGER NOT NULL REFERENCES scrapetition.url (url_id),
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper text,
       CONSTRAINT one_comment_voting_per_user UNIQUE (domain, user_id, comment_id));

GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition.comment_voting
TO scraper;

GRANT SELECT, USAGE ON SEQUENCE scrapetition.comment_voting_comment_voting_id_seq
TO scraper, scrapetitionadmin;

GRANT SELECT ON TABLE scrapetition.comment_voting
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON TABLE scrapetition.comment_voting
TO scrapetitionadmin;

COMMIT;
