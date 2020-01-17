-- Deploy scrapetition-sql:schema to pg

BEGIN;

CREATE SCHEMA IF NOT EXISTS scrapetition;

-- -- move existing elements into the new schema.
-- DO
-- $$
-- DECLARE
--     row record;
-- BEGIN
--     -- move tables into the schema
--     FOR row in SELECT tablename FROM pg_tables WHERE schemaname = 'public'
--     LOOP
--         EXECUTE 'ALTER TABLE public.' || quote_ident(row.tablename) || ' SET SCHEMA scrapetition;';
--     END LOOP;
--     -- move views into the schema
--     FOR row in SELECT viewname FROM pg_views WHERE schemaname = 'public'
--     LOOP
--         EXECUTE 'ALTER VIEW public.' || quote_ident(row.viewname) || ' SET SCHEMA scrapetition;';
--     END LOOP;
--     -- move sequences into the schema
--     FOR row IN SELECT sequence_name FROM information_schema.sequences
--     WHERE sequence_schema = 'public'
--     LOOP
--         EXECUTE 'ALTER SEQUENCE public.' || quote_ident(row.sequence_name) || ' SET SCHEMA scrapetition;';
--     END LOOP;
--     -- move functions
--     ALTER FUNCTION public.get_article_id_for_url(TEXT) SET SCHEMA scrapetition;
--     ALTER FUNCTION public.get_article(INTEGER) SET SCHEMA scrapetition;
--     --ALTER FUNCTION public.comments_insert(TEXT) SET SCHEMA scrapetition;
--     ALTER FUNCTION public.url_source_insert() SET SCHEMA scrapetition;
-- END;
-- $$;


COMMIT;
