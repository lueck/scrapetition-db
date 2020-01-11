-- Deploy scrapetition-sql:parent_voting to pg
-- requires: comments

BEGIN;

ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS article_voting INTEGER;

ALTER TABLE IF EXISTS comment
      ADD COLUMN IF NOT EXISTS parent_voting INTEGER;

COMMIT;
