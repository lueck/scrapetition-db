-- Deploy scrapetition-sql:comments to pg
-- requires: url
-- requires: user

BEGIN;

CREATE TABLE IF NOT EXISTS scrapetition.comment (
       comment_id  serial PRIMARY KEY,
       id     	   text NOT NULL, -- the ID found on the website
       domain 	   text NOT NULL, -- the domain part of the url
       text   	   text NOT NULL, -- the textual body of the comment
       title  	   text,	  -- the title of the comment
       -- user_id may be NULL because sometimes there's none, but only a name
       user_id 	   integer REFERENCES scrapetition."user" (user_id),
       name   	   text,	-- the shown name of the user
       date_informal text,	-- an informal time, if present
       date   	   timestamp,	-- an timestamp, if any time is present
       parent 	   text,	-- the id parent comment 
       thread 	   text,	-- the id of the comment that started the thread
       article_id  integer REFERENCES scrapetition.article (article_id), -- A redactional item.
       up_votes    integer,	-- number of up votes
       down_votes  integer,	-- number of down votes
       article_voting integer,  -- voting of article (item), added in parent_voting
       parent_voting integer,   -- voting of parent comment, added in parent_voting
       -- meta data
       url_id      integer NOT NULL REFERENCES scrapetition.url (url_id), -- where found
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper 	  text,
       CONSTRAINT unique_comment_in_domain UNIQUE (id, domain));

GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition.comment
TO scraper;

GRANT SELECT, USAGE ON SEQUENCE scrapetition.comment_comment_id_seq
TO scraper, scrapetitionadmin;

GRANT SELECT ON TABLE scrapetition.comment
TO scrapetitionuser, scrapetitioneditor, scrapetitionadmin;

GRANT ALL PRIVILEGES ON TABLE scrapetition.comment
TO scrapetitionadmin;


COMMIT;
