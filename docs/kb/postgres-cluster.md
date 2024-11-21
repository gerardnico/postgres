# Postgres Cluster

## About
A cluster is a [single Postgres Instance](https://www.postgresql.org/docs/current/creating-cluster.html)
serving  multiple [database](postgres-database.md)

## Creation

Creating a database cluster consists of :
* creating the directories in which the database data will live, 
* generating the shared catalog tables (tables that belong to the whole cluster rather than to any particular database), 
* creating the `template1`
* creating the [postgres databases](postgres-database.md#postgres)
* initializes the database cluster's default locale and character set encoding (--lc-collate, --lc-ctype and --locale options)

### InitDb
[InitDb](https://www.postgresql.org/docs/14/app-initdb.html) creates a cluster (not a db)

Os Privileges:
* The `database user account/cluster owner` is the OS user that runs the server process.
* Group access: The `--allow-group-access` option allows any user in the same group as the cluster owner to read files in the cluster. 
  * This is useful for performing backups as a non-privileged user.
    
Install:
* if not root, 
  * create an empty data directory as root,
  * use chown to assign ownership of that directory to the database user account, 
  * su to become the database user to run initdb (`initdb` must be run as the user that will own the server process,
  because the server needs to have access to the files and directories that initdb creates.)

### pg_createcluster from Pg Common
`pg_createcluster` is a wrapper for initdb

* [pg_createcluster](https://manpages.ubuntu.com/manpages/trusty/man8/pg_createcluster.8.html)

Example Usage:
https://pgbackrest.org/user-guide.html#quickstart/setup-demo-cluster

from:
* https://salsa.debian.org/postgresql/postgresql-common
* https://github.com/credativ/postgresql-common


## Postgres Daemon

https://www.postgresql.org/docs/current/app-postgres.html

## Maintenance, debug, release: Single User Mode

https://www.postgresql.org/docs/current/app-postgres.html

## Ref

https://www.postgresql.org/docs/14/app-initdb.html