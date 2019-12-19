-- Start transaction and plan the tests
BEGIN;
SELECT plan(6);
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


-- tests on view

SELECT lives_ok('INSERT INTO comments (id, domain, text, url)
       		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
		''http://e.feu.de/asdf'')');

SELECT throws_ok('INSERT INTO comments (id, domain, text, url)
       		VALUES (''cid-adsf'', ''example.com'', null,
		''http://e.feu.de/asdf'')',
		23502,
		'null value in column "text" violates not-null constraint');

SELECT throws_ok('INSERT INTO comments (id, domain, text, url)
       		VALUES (''cid-adsf'', ''example.com'', ''Hello'',
		null)',
		23502,
		'null value in column "url" violates not-null constraint');


-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
