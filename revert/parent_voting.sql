-- Revert scrapetition-sql:parent_voting from pg

BEGIN;

ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS article_voting;

ALTER TABLE IF EXISTS comment
      DROP COLUMN IF EXISTS parent_voting;

COMMIT;
