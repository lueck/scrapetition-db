-- Start transaction and plan the tests
BEGIN;

SET search_path TO scrapetition, public;

SELECT plan(4);
-- Run the tests.

SELECT lives_ok('INSERT INTO url (url) VALUES (''http://e.feu.de/'')');


SELECT lives_ok('INSERT INTO comment (id, domain, text, url_id)
       		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
		(SELECT url_id FROM url WHERE url = ''http://e.feu.de/''))');

SELECT throws_ok('INSERT INTO comment (id, domain, text, url_id)
       		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
		(SELECT url_id FROM url WHERE url = ''http://e.feu.de/asdf''))',
		23502,
		'null value in column "url_id" violates not-null constraint');

SELECT throws_ok('INSERT INTO comment (id, domain, text, url_id)
       		VALUES (''cid-adsf'', ''example.com'', ''World'',
		(SELECT url_id FROM url WHERE url = ''http://e.feu.de/''))',
		23505,
		'duplicate key value violates unique constraint "unique_comment_in_domain"');


-- -- tests on view
-- migration: The view does not exist any more!

-- SELECT lives_ok('INSERT INTO comments (id, domain, text, url)
--        		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
-- 		''http://e.feu.de/asdf'')');

-- SELECT lives_ok('INSERT INTO comments (id, domain, text, url)
--        		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
-- 		''http://e.feu.de/asdf'')');

-- SELECT throws_ok('INSERT INTO comments (id, domain, text, url)
--        		VALUES (''cid-adsf'', ''example.com'', null,
-- 		''http://e.feu.de/asdf'')',
-- 		23502,
-- 		'null value in column "text" violates not-null constraint');

-- SELECT throws_ok('INSERT INTO comments (id, domain, text, url)
--        		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
-- 		null)',
-- 		23502,
-- 		'null value in column "url" violates not-null constraint');


-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
