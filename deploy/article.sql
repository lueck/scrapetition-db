-- Deploy scrapetition-sql:article to pg
-- requires: url
-- requires: comments

BEGIN;

-- An article is a redactional item of a website, e.g. a news article
-- on a news website or an article for sale on a shopping site.
--
-- Note: Do not confuse the url referenced by canonical with the url
-- referenced by url_id. The canonical column refers to the url of the
-- article, while the url referenced by url_id is simple meta data of
-- the scraping process and may be some other url.
CREATE TABLE IF NOT EXISTS article (
       article_id SERIAL PRIMARY KEY,
       canonical INTEGER NOT NULL REFERENCES  url (url_id),
       domain TEXT,
       title TEXT,
       description TEXT,
       author TEXT,
       date TIMESTAMP,
       -- meta data
       url_id INTEGER NOT NULL REFERENCES  url (url_id),
       first_scraped TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper TEXT,
       CONSTRAINT article_unique UNIQUE (canonical));


-- Migrate data:

-- add urls that where not scraped, but are item urls
INSERT INTO url (url, first_scraped, last_scraped)
SELECT item, c.first_scraped, c.last_scraped
FROM comment AS c LEFT JOIN url ON (item = url)
WHERE url IS NULL
ON CONFLICT DO NOTHING;

INSERT INTO article (canonical, domain, url_id, first_scraped, last_scraped, scraper)
SELECT url.url_id, comment.domain, comment.url_id, comment.first_scraped, comment.last_scraped, comment.scraper
FROM comment LEFT JOIN url ON (url.url = comment.item)
-- GROUP BY url.url_id;
ON CONFLICT DO NOTHING;

ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS article_id INTEGER REFERENCES article (article_id);

CREATE OR REPLACE FUNCTION get_article_id_for_url(TEXT)
RETURNS INTEGER AS $$
	SELECT article_id FROM article
	LEFT JOIN url ON (canonical = url.url_id)
	-- FIXME: Vulnarable by sql injection? It does not work with quote_nullable($1)!
	WHERE url.url = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION get_article(INTEGER)
RETURNS TEXT AS $$
	SELECT url.url FROM article LEFT JOIN url ON (article.canonical = url.url_id)
	WHERE article_id = $1;
$$ LANGUAGE SQL;

UPDATE comment SET article_id = get_article_id_for_url(item);

DROP VIEW IF EXISTS comments;

ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS item;

COMMIT;
