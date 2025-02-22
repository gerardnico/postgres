# PGBackrest Backup Tool


## About
They use the term `cluster` that refers to [postgres cluster](postgres-cluster.md)

https://pgbackrest.org/ Wal manager
Used by [](postgres-ha.md#postgres-operator-crunchy-data-go)
Doc: https://access.crunchydata.com/documentation/crunchy-postgres-containers/5.3.1/examples/backup-restoration/pgbackrest/
User Guide: https://pgbackrest.org/user-guide.html

## Features 

pgbackrest is newer and better solution than barman, it saves and manages WALs that relate to the main backup and keeps all nice and tidy.

You can also restore a single database from full backup if you need that.

Pgbackrest can restore a single database if pg version is 14 or newer iirc. 

But it will still backup the whole cluster for sure.


## Stanza

A [stanza](https://pgbackrest.org/user-guide.html#quickstart/setup-demo-cluster#quickstart/configure-stanza)
is the configuration for a PostgreSQL database cluster
that defines where it is located, how it will be backed up, archiving options, etc.

Stanza by server type:
* most db servers: one stanza (ie only one PostgreSQL database cluster)
* backup servers:  one stanza for every database cluster that needs to be backed up.

## Repo
The repository is where pgBackRest stores backups and archives WAL segments.
