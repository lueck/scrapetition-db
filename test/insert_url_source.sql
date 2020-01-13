-- url_source is a view. In this test, we verify, that the insert
-- trigger works.

-- Start transaction and plan the tests
BEGIN;

SET search_path TO scrapetition, public;

SELECT plan(4);

-- Run the tests.

SELECT lives_ok('INSERT INTO url_source (source_url, target_url) VALUES 
        	(''http://www.feu.de/ksw'', ''http://www.feu.de/ksw\ndl'' )');

SELECT is(count(*), 1::bigint) FROM url_source
WHERE source_url = 'http://www.feu.de/ksw'
AND target_url = 'http://www.feu.de/ksw\ndl';

SELECT lives_ok('INSERT INTO url_source (source_url, target_url) VALUES 
        	(''http://www.feu.de/ksw'', ''http://www.feu.de/ksw\ndl'' )');

SELECT is(count(*), 1::bigint) FROM url_source
WHERE source_url = 'http://www.feu.de/ksw'
AND target_url = 'http://www.feu.de/ksw\ndl';


-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
