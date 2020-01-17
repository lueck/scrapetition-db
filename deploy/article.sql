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
CREATE TABLE IF NOT EXISTS scrapetition.article (
       article_id SERIAL PRIMARY KEY,
       canonical INTEGER NOT NULL REFERENCES  scrapetition.url (url_id),
       domain TEXT,
       title TEXT,
       description TEXT,
       author TEXT,
       date TIMESTAMP,
       -- meta data
       url_id INTEGER NOT NULL REFERENCES  scrapetition.url (url_id),
       first_scraped TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       last_scraped  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
       scraper TEXT,
       CONSTRAINT article_unique UNIQUE (canonical));

GRANT SELECT, INSERT, UPDATE ON TABLE scrapetition.article
TO scraper;

GRANT SELECT, USAGE ON SEQUENCE scrapetition.article_article_id_seq
TO scraper;

COMMIT;
