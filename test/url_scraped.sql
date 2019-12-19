-- Run tests on url, url_scraped, url_source and insert trigger

-- Start transaction and plan the tests
BEGIN;
SELECT plan(9);

-- Tests on url and url_scraped
SELECT lives_ok('INSERT INTO url (url) VALUES (''http://e.feu.de/'')');
SELECT lives_ok('INSERT INTO url (url) VALUES (''http://www.feu.de/ksw'')');

SELECT lives_ok('INSERT INTO url_scraped (source, target) VALUES
       			((SELECT url_id FROM url WHERE url = ''http://e.feu.de/'')
			,(SELECT url_id FROM url WHERE url = ''http://www.feu.de/ksw''))');

SELECT is(count(*), 1::bigint) FROM url_source
       WHERE source_url = 'http://e.feu.de/'
       AND target_url = 'http://www.feu.de/ksw';

SELECT throws_ok('INSERT INTO url_scraped (source, target) VALUES
       			 ((SELECT url_id FROM url WHERE url = ''http://e.feu.de/'')
			 ,(SELECT url_id FROM url WHERE url = ''http://www.feu.de/ksw''))',
	         23505,
		 'duplicate key value violates unique constraint "unique_source"');


-- Tests on view and insert trigger

SELECT lives_ok('INSERT INTO url_source (source_url, target_url) VALUES
       			(''http://e.feu.de/'', ''http://www.feu.de/ksw/institut'')');

SELECT is(count(*), 1::bigint) FROM url_source
       WHERE source_url = 'http://e.feu.de/'
       AND target_url = 'http://www.feu.de/ksw/institut';

SELECT lives_ok('INSERT INTO url_source (source_url, target_url) VALUES
       			(''http://e.feu.de/'', ''http://www.feu.de/ksw/institut'')');

SELECT is(count(*), 1::bigint) FROM url_source
       WHERE source_url = 'http://e.feu.de/'
       AND target_url = 'http://www.feu.de/ksw/institut';

-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
