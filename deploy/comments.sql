-- Deploy scrapetition-sql:comments to sqlite
-- requires: url
-- requires: url_scraped

BEGIN;

CREATE TABLE IF NOT EXISTS comment (
       -- comment_id integer PRIMARY KEY AUTOINCREMENT,
       comment_id serial PRIMARY KEY,
       id     	   text NOT NULL,
       domain 	   text NOT NULL,
       text   	   text NOT NULL,
       title  	   text,
       "user"  	   text,
       name   	   text,
       date_informal text,
       date   	   timestamp,
       parent 	   text,
       thread 	   text,
       -- item	   text, 	-- The item this thread refers to.
       up_votes   integer,
       down_votes integer,
       url_id     integer NOT NULL,
       -- important, when deleted
       scrape_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper 	  text,
       CONSTRAINT unique_in_domain UNIQUE (id, domain),
       CONSTRAINT url_source FOREIGN KEY (url_id) REFERENCES url(url_id));

-- create a view on comments, where thread IDs are present
CREATE OR REPLACE VIEW comments
-- This is a view on comments with thread IDs propagated.
AS
WITH RECURSIVE
     dis (id,
     	  domain,
	  text,
	  title,
	  "user",
	  name,
	  date_informal,
	  date,
	  parent,
	  thread,
	  -- thread,
	  up_votes,
	  down_votes,
	  url,
	  scrape_date,
	  scraper,
	  height)
     AS (
     SELECT c.id, c.domain, c.text, c.title, c."user", c.name, c.date_informal, c.date,
     	    c.parent, c.id, c.up_votes, c.down_votes, url.url, c.scrape_date, c.scraper, 0
	    FROM comment AS c
	    LEFT JOIN url ON c.url_id = url.url_id
	    WHERE parent is NULL
     UNION
     SELECT c.id, c.domain, c.text,
     	    c.title, c.user, c.name, c.date_informal,
	    c.date, c.parent, dis.thread, c.up_votes,
	    c.down_votes, url.url, c.scrape_date,
	    c.scraper, dis.height+1
     FROM comment AS c, dis, url
     WHERE c.parent = dis.id AND c.url_id = url.url_id)
SELECT * FROM dis;


COMMIT;
