-- Revert scrapetition-sql:schema from pg

BEGIN;

-- -- move existing elements into the new schema.
-- DO
-- $$
-- DECLARE
--     row record;
-- BEGIN
--     -- move tables into the schema
--     FOR row in SELECT tablename FROM pg_tables WHERE schemaname = 'scrapetion'
--     LOOP
--         EXECUTE 'ALTER TABLE scrapetition.' || quote_ident(row.tablename) || ' SET SCHEMA public;';
--     END LOOP;
--     -- move sequences into the schema    
--     -- FOR row IN SELECT sequence_name FROM information_schema.sequences
--     -- WHERE sequence_schema = 'scrapetition'
--     -- LOOP
--     --     EXECUTE 'ALTER SEQUENCE scrapetition.' || quote_ident(row.sequence_name) || ' SET SCHEMA public;';
--     -- END LOOP;
--     ALTER SEQUENCE scrapetition.article_article_id_seq OWNER TO public;
--     ALTER SEQUENCE scrapetition.article_article_id_seq SET SCHEMA public;
--     ALTER SEQUENCE scrapetition.comment_comment_id_seq SET SCHEMA public;
--     ALTER SEQUENCE scrapetition.comment_voting_comment_voting_id_seq SET SCHEMA public;
--     ALTER SEQUENCE scrapetition.url_url_id_seq SET SCHEMA public;
--     ALTER SEQUENCE scrapetition.user_user_id_seq SET SCHEMA public;
--     -- move functions
--     ALTER FUNCTION scrapetition.get_article_id_for_url(TEXT) SET SCHEMA public;
--     ALTER FUNCTION scrapetition.get_article(INTEGER) SET SCHEMA public;
--     --ALTER FUNCTION scrapetition.comments_insert(TEXT) SET SCHEMA public;
--     ALTER FUNCTION scrapetition.url_source_insert() SET SCHEMA public;
-- END;
-- $$;


DROP SCHEMA IF EXISTS scrapetition CASCADE;


COMMIT;
