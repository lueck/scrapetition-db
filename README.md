# A PostgreSQL Database for Scrapetition

This database schema for
[`scrapetition`](https://github.com/lueck/scrapetition) can be
deployed with [sqitch](https://sqitch.org/) from the root folder of
this repository:

	sqitch deploy

The default target is a database called `scrapetition_test` on
localhost. Another target can be specified with `sqitch`'s `-t`
option.

While the `deploy` command should work cleanly, the `revert` command
will print some notices from the change `schema` on. The schema name
`scrapetition` was introduced relatively late and every relation,
sequence, function etc. is moved into it in the change `schema`. But
it can not be moved back to `public`, so everything is dropped
instead. That causes the notices.

## Testing

There are unit tests defined for this database schema in the `test`
folder.  They are based on [pgTAP](https://pgtap.org/) and can be run
with [pg_prove](https://pgtap.org/pg_prove.html).  After installation,
`pgTAP` must be installed as an extension into the (`public`) schema.

	CREATE EXTENSION IF NOT EXISTS pgtap;

The tests can be run from the root folder of this repo:

	pg_prove -d scrapetition_test test/*.sql

