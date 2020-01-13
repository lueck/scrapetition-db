-- Start transaction and plan the tests
BEGIN;

SET search_path TO scrapetition, public;

SELECT plan(1);

-- Run the tests.
SELECT XXX

-- Finish the tests and clean up.
SELECT finish();
ROLLBACK;
