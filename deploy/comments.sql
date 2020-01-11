-- Deploy scrapetition-sql:comments to pg
-- requires: url
-- requires: user

BEGIN;

CREATE TABLE IF NOT EXISTS comment (
       comment_id  serial PRIMARY KEY,
       id     	   text NOT NULL, -- the ID found on the website
       domain 	   text NOT NULL, -- the domain part of the url
       text   	   text NOT NULL, -- the textual body of the comment
       title  	   text,	  -- the title of the comment
       -- user_id may be NULL because sometimes there's none, but only a name
       user_id 	   integer REFERENCES "user" (user_id),
       name   	   text,	-- the shown name of the user
       date_informal text,	-- an informal time, if present
       date   	   timestamp,	-- an timestamp, if any time is present
       parent 	   text,	-- the id parent comment 
       thread 	   text,	-- the id of the comment that started the thread
       item	   text, 	-- The item this thread refers
				-- to. E.g. a redactional item. Note:
				-- This will be replaced by article_id in article.
       up_votes    integer,	-- number of up votes
       down_votes  integer,	-- number of down votes
       -- article_voting integer,  -- voting of article (item), added in parent_voting
       -- parent_voting integer,   -- voting of parent comment, added in parent_voting
       -- meta data
       url_id      integer NOT NULL REFERENCES url (url_id), -- where found
       first_scraped timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper 	  text,
       CONSTRAINT unique_comment_in_domain UNIQUE (id, domain));

-- create a view on comments, where thread IDs are present
CREATE OR REPLACE VIEW comments
-- This is a view on comments with thread IDs propagated.
AS
WITH RECURSIVE
     dis (comment_id,
     	  id,
     	  domain,
	  text,
	  title,
	  user_id,
	  name,
	  date_informal,
	  date,
	  parent,
	  thread,
	  -- thread,
	  item,
	  up_votes,
	  down_votes,
	  url_id,
	  first_scraped,
	  last_scraped,
	  scraper,
	  height)
     AS (
     SELECT c.comment_id, c.id, c.domain, c.text, c.title,
     	    user_id, c.name, c.date_informal, c.date,
     	    c.parent, c.id,
	    c.item, c.up_votes, c.down_votes,
	    c.url_id, c.first_scraped, c.last_scraped, c.scraper,
	    0
	    FROM comment AS c
	    WHERE parent is NULL OR parent = id
     UNION
     SELECT c.comment_id, c.id, c.domain, c.text, c.title,
     	    c.user_id, c.name, c.date_informal, c.date,
	    c.parent, dis.thread,
	    c.item, c.up_votes, c.down_votes,
	    c.url_id, c.first_scraped, c.last_scraped, c.scraper,
	    dis.height+1
     FROM comment AS c, dis
     WHERE c.parent = dis.id AND c.domain = dis.domain)
SELECT * FROM dis;
-- LEFT JOIN url ON (dis.url_id = url.url_id)
-- LEFT JOIN "user" USING (user_id);


COMMIT;
