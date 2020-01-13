-- Test the trigger function, that asserts the wellformedness of tag
-- values.

-- Note: The following tests assert, that the trigger function works
-- as expected. In order to assert that it works on other tables we
-- only have to verify the existence of certain columns and of a
-- trigger. This can be done with sqitch's verify-scripts.

-- Start transaction and plan the tests
BEGIN;

SET search_path to scrapetition, public;

SELECT plan(23);
-- Run the tests.

CREATE TABLE IF NOT EXISTS test_tag (
       some_id INTEGER NOT NULL,
       namespace TEXT NOT NULL,
       tag TEXT NOT NULL,
       text_value TEXT,
       integer_value INTEGER,
       float_value FLOAT,
       FOREIGN KEY (namespace, tag) REFERENCES scrapetition.tag (namespace, tag),
       CONSTRAINT tag_unique_for_test UNIQUE (some_id, namespace, tag));

CREATE TRIGGER evaluate_tag_on_insert BEFORE INSERT ON test_tag
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.evaluate_tag();

SELECT lives_ok('INSERT INTO tag (namespace, tag, type, text_value_regex) VALUES
       		(''testing'', ''novalue'', ''none'', null),
		(''testing'', ''intvalue'', ''integer'', null),
		(''testing'', ''floatvalue'', ''float'', null),
		(''testing'', ''freetextvalue'', ''text'', ''.*''),
		(''testing'', ''atextvalue'', ''text'', ''aaa'')
		');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''novalue'', ''fail'')',
		 'P0001',
		 'Tag does not allow a value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''novalue'', 0)',
		 'P0001',
		 'Tag does not allow a value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, float_value) VALUES
       		 (1, ''testing'', ''novalue'', -1.0)',
		 'P0001',
		 'Tag does not allow a value');

SELECT lives_ok('INSERT INTO test_tag (some_id, namespace, tag) VALUES
       		(1, ''testing'', ''novalue'')');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag) VALUES
       		 (1, ''testing'', ''novalue'')',
		 '23505',
		 'duplicate key value violates unique constraint "tag_unique_for_test"');



SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, float_value) VALUES
       		 (1, ''testing'', ''intvalue'', -0.1)',
		 'P0001',
		 'Tag requires an integer value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''intvalue'', ''fail'')',
		 'P0001',
		 'Tag requires an integer value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''intvalue'', null)',
		 'P0001',
		 'Tag requires an integer value');

SELECT lives_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		(1, ''testing'', ''intvalue'', 1)');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''intvalue'', 1)',
		 '23505',
		 'duplicate key value violates unique constraint "tag_unique_for_test"');



SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''floatvalue'', -1)',
		 'P0001',
		 'Tag requires a float value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''floatvalue'', ''fail'')',
		 'P0001',
		 'Tag requires a float value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''floatvalue'', null)',
		 'P0001',
		 'Tag requires a float value');

SELECT lives_ok('INSERT INTO test_tag (some_id, namespace, tag, float_value) VALUES
       		(1, ''testing'', ''floatvalue'', 1.0)');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, float_value) VALUES
       		 (1, ''testing'', ''floatvalue'', 1.0)',
		 '23505',
		 'duplicate key value violates unique constraint "tag_unique_for_test"');



SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, float_value) VALUES
       		 (1, ''testing'', ''freetextvalue'', -0.1)',
		 'P0001',
		 'Tag requires a text value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''freetextvalue'', null)',
		 'P0001',
		 'Tag requires a text value');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, integer_value) VALUES
       		 (1, ''testing'', ''freetextvalue'', 0)',
		 'P0001',
		 'Tag requires a text value');

SELECT lives_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		(1, ''testing'', ''freetextvalue'', ''good'')');

SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''freetextvalue'', ''bad'')',
		 '23505',
		 'duplicate key value violates unique constraint "tag_unique_for_test"');



SELECT throws_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		 (1, ''testing'', ''atextvalue'', ''not good'')',
		 'P0001',
		 'Invalid tag content: Text value does not match regular expression');

SELECT lives_ok('INSERT INTO test_tag (some_id, namespace, tag, text_value) VALUES
       		(1, ''testing'', ''atextvalue'', ''Not baaad!'')');


-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;

