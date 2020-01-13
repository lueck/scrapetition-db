-- Start transaction and plan the tests
BEGIN;

SET search_path TO scrapetition, public;

SELECT plan(10);

-- Setup.
CREATE TABLE IF NOT EXISTS tmeta_data (
	a_number integer not null,
	-- these cols may be copied:
	created_at timestamp not null DEFAULT current_timestamp,
	created_by varchar not null,
	updated_at timestamp null,
	updated_by varchar null,
	gid varchar null,
	privilege integer not null DEFAULT 492
	--
	);

SELECT lives_ok('
CREATE TRIGGER tmeta_data_set_meta_on_insert BEFORE INSERT ON tmeta_data
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_insert()');

SELECT lives_ok('
CREATE TRIGGER tmeta_data_set_meta_on_upate BEFORE UPDATE ON tmeta_data
    FOR EACH ROW EXECUTE PROCEDURE scrapetition.set_meta_on_update()');

-- Run the tests.
INSERT INTO tmeta_data (a_number) VALUES (1);
SELECT is(created_by, current_user::varchar) FROM tmeta_data WHERE a_number = 1;
-- SELECT is(gid, current_user) FROM tmeta_data WHERE a_number = 1;
SELECT isnt(created_at, null) FROM tmeta_data WHERE a_number = 1;
SELECT is(updated_by, null) FROM tmeta_data WHERE a_number = 1;
SELECT is(updated_at, null) FROM tmeta_data WHERE a_number = 1;

SELECT lives_ok('UPDATE tmeta_data SET (created_by) = (''someone else'') WHERE a_number=1');
SELECT isnt(updated_by, null) FROM tmeta_data WHERE a_number = 1;
SELECT isnt(updated_at, null) FROM tmeta_data WHERE a_number = 1;
SELECT is(created_by, current_user::varchar) FROM tmeta_data WHERE a_number = 1;


-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
