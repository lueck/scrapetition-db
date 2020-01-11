-- Revert scrapetition-sql:article from pg

BEGIN;

ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS item TEXT;

UPDATE comment SET item = quote_nullable(get_article(article_id));

ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS article_id;

DROP FUNCTION IF EXISTS get_article(INTEGER);
DROP FUNCTION IF EXISTS get_article_id_for_url(TEXT);


DROP TABLE IF EXISTS article;

COMMIT;
