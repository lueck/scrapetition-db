-- Revert scrapetition-sql:comment_voting from pg

BEGIN;

DROP TABLE IF EXISTS comment_voting;

COMMIT;
