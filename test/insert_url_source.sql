-- Start transaction and plan the tests
BEGIN;
SELECT plan(1);

-- Run the tests.
-- SELECT lives_ok('INSERT INTO url_source (source, target) VALUES 
--        (''http://www.feu.de/ksw'', ''http://www.feu.de/ksw\ndl'' )');

-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
