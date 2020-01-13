-- Verify scrapetition-sql:user_tag on pg

BEGIN;

-- assert that columns used by triggers are present.
SELECT (namespace, tag, text_value, integer_value, float_value,
        created_at, created_by, updated_at, updated_by,
	gid, privilege)
FROM scrapetition.user_tag WHERE TRUE;


SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'evaluate_tag_on_insert';

SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'evaluate_tag_on_update';


SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'tag_set_meta_on_insert';

SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'tag_set_meta_on_update';

SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'adjust_privilege_on_insert';

SELECT 1/count(tgname) FROM pg_trigger t
       WHERE NOT tgisinternal
       AND tgrelid = 'scrapetition.user_tag'::regclass
       AND tgname = 'adjust_privilege_on_update';



ROLLBACK;
