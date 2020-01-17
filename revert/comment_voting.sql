-- Revert scrapetition-sql:comment_voting from pg

BEGIN;

DROP TABLE IF EXISTS scrapetition.comment_voting;

COMMIT;
