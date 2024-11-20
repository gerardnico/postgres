# PGBackrest Backup Tool


## About
They use the term `cluster` that refers to [postgres cluster](postgres-cluster.md)

https://pgbackrest.org/ Wal manager
Used by [](postgres-ha.md#postgres-operator-crunchy-data-go)
Doc: https://access.crunchydata.com/documentation/crunchy-postgres-containers/5.3.1/examples/backup-restoration/pgbackrest/
User Guide: https://pgbackrest.org/user-guide.html

## Stanza

A [stanza](https://pgbackrest.org/user-guide.html#quickstart/setup-demo-cluster#quickstart/configure-stanza)
is the configuration for a PostgreSQL database cluster
that defines where it is located, how it will be backed up, archiving options, etc.

Stanza by server type:
* most db servers: one stanza (ie only one PostgreSQL database cluster)
* backup servers:  one stanza for every database cluster that needs to be backed up.

## Repo
The repository is where pgBackRest stores backups and archives WAL segments.
