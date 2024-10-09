# Postgres



## Run

### Docker

Set your value in the [.env](.env) file

* To run with `pgdata` at `/data` on the [disk](https://github.com/docker-library/docs/blob/master/postgres/README.md#where-to-store-data)

```bash
docker rm postgres
docker run \
  --name postgres \
  --env-file .env \
  --user 1000:1000 \
  --group-add postgres \
  -d \
  -p 5432:5432 \
  -v $PWD/mount:/data \
  gerardnico/postgres:16.3-latest
```

Error?
```bash
docker logs postgres
```

## Dump

### How to restore a database from a snapshot dump  

A dump restore is performed via the [dbctl command](resources/dbctl/dbctl)

```bash
# Start bash in the container before using dbctl
docker exec -ti postgres bash
# List the available dump and select a snapshot
dbctl backup ls
# Perform a restore
dbctl backup restore snapshotId
# or for the latest one
dbctl backup restore latest
```

### How to restore a database from a local dump

```bash
# From the host, copy a dump into the container or mount a volume
docker cp /tmp/db-dump/dumpfile-db-combo.sql.gz postgres:/tmp
# From the container, perform a restore
docker exec -ti postgres bash
dbctl backup restore /tmp/dumpfile-db-combo.sql.gz
```

### How to perform a dump backup

A dump backup is performed via the [ctl command](resources/dbctl/dbctl)

```bash
dbctl dump-backup
# prune the repo
dbctl dump-prune
```

## How to perform a full backup

The backup location is set via:

```
WALG_S3_PREFIX=s3://bucket-name/path
WALG_S3_PREFIX=s3://postgres-dev/dev-name
```

In the container:
```
wal-g backup-push $PGDATA
```



## Diagnostic

Log is on at `$PGDATA/log`

## Env

When creating the image. See [.env](.env)

```ini
# See environment variables documentation \
# https://github.com/wal-g/wal-g/blob/master/docs/STORAGES.md
WALE_S3_PREFIX=s3://bucket-name/path/to/folder
AWS_ACCESS_KEY_ID=xxxx
AWS_SECRET_ACCESS_KEY=secret
AWS_ENDPOINT=s3-like-service:9000
WALG_COMPRESSION_METHOD=brotli
```

All [libpq environments variable](https://www.postgresql.org/docs/current/libpq-envars.html) may be applied
for client app.

## dbctl

### Bash script

### Database procedure

You can't restore from the database as it expects a manual confirmation.

```sql
-- noinspection SqlResolve
CALL public.dbctl('dump-ls');
```

## process

The process that are running in the container and their owner.

```bash
UID        PID  PPID  C STIME TTY          TIME CMD
root        25    21  0 14:14 pts/0    00:00:00 /bin/bash /usr/local/bin/postgres-entrypoint.sh postgres -c config_file=/etc/postgresql/postgresql.conf
root        27    23  0 14:14 pts/1    00:00:00 postgres_exporter --log.level=warn
postgres    48    25  0 14:14 pts/0    00:00:00 postgres -c config_file=/etc/postgresql/postgresql.conf
postgres    69    48  0 14:14 ?        00:00:00 postgres: logger
postgres    70    48  0 14:14 ?        00:00:00 postgres: checkpointer
postgres    71    48  0 14:14 ?        00:00:00 postgres: background writer
postgres    73    48  0 14:14 ?        00:00:00 postgres: walwriter
postgres    74    48  0 14:14 ?        00:00:00 postgres: autovacuum launcher
postgres    75    48  0 14:14 ?        00:00:00 postgres: archiver
postgres    76    48  0 14:14 ?        00:00:00 postgres: pg_cron launcher
postgres    77    48  0 14:14 ?        00:00:00 postgres: logical replication launcher
postgres    78    48  0 14:14 ?        00:00:00 postgres: eraldy eraldy 172.17.0.1(47582) idle
root        95     0  0 14:16 pts/2    00:00:00 bash
root       323    95  0 14:20 pts/2    00:00:00 ps -ef
```


Memory:
```bash
8.72656 MB postgres: background writer
8.58203 MB postgres: autovacuum launcher
8.41406 MB postgres: logical replication launcher
8.05469 MB postgres: archiver failed on
6.19141 MB postgres: logger
39.082 MB postgres -c config_file=/etc/postgresql/postgresql.conf -c
3.57812 MB /bin/bash /usr/local/bin/postgres-ctl postgres -c
31.3359 MB /usr/bin/python3 /usr/bin/supervisord -c /supervisord.conf
18.8984 MB postgres: checkpointer
14.5 MB postgres: walwriter
14.4492 MB postgres: pg_cron launcher
0.921875 MB /bin/sh
0.882812 MB /usr/bin/tail -f /var/log/postgres/postgres.log
Total: 101.2MiB
```

## Database: Postgres

After initialization, a database cluster will contain a database named postgres,
which is meant as a default database for use by utilities, users and third party applications.
The database server itself does not require the postgres database to exist,
but many external utility programs assume it exists.
https://www.postgresql.org/docs/9.1/creating-cluster.html

## Schema restoration

We don't use SQL restoration for schema
because with cascade, drops all objects that depend on the schema.
And this object may be external.

There is no guarantee that the results of a specific-schema dump
can be successfully restored into a clean database.

Why? Because the dump (pg_dump) will not dump any other database dependent objects
than the selected schema(s).

## Dump Format

* dir: one data file by tables. It will upload only the table changed
* sql: a sql file
* archive: one custom archive format

## Wal-g

## Restic

### Subset Data Check

With [rolling data check](https://restic.readthedocs.io/en/v0.13.1/045_working_with_repos.html#checking-integrity-and-consistency).

You can set the t value in `--read-data-subset=n/t` with the `DBCTL_CHECK_SUBSET` env

```env
DBCTL_CHECK_SUBSET=5
```

### Forget Policy

[Forget Policy](https://restic.readthedocs.io/en/v0.13.1/060_forget.html?highlight=forget#removing-snapshots-according-to-a-policy)

```
DBCTL_FORGET_POLICY=--keep-hourly 5 --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 3
```

### Support - Restic Repo not found

Be sure to path the good password in the environment variable ie `RESTIC_PASSWORD`.

```bash
postgres          | Restic Repo not found - Restic init at s3:host/bucket-name
postgres          | Fatal: create key in repository at s3:host/bucket-name failed: repository master key and config already initialized
```
## Postgres Exporter

The Postgres exporter is `optional` and will not kill the container if shutdown.

http://localhost:9187/metrics

`POSTGRES_EXPORTER_FLAGS` env
by default: `--log.level=warn`

`POSTGRES_EXPORTER_ENV` env
by default: `DATA_SOURCE_NAME='sslmode=disable' PG_EXPORTER_DISABLE_SETTINGS_METRICS=true`

User and host are mandatory
[Data Source Name Doc](https://pkg.go.dev/github.com/lib/pq#hdr-Connection_String_Parameters)

## Sql Exporter

The SQL exporter is `optional`

`SQL_EXPORTER_FLAGS`

[](https://github.com/free/sql_exporter/blob/master/README.md#data-source-names)

Change the config files at: `/data/sql_exporter`




## How to Develop (dscript)

See [dev doc](doc/dev.md)

## Kubernetes

"docker-ensure-initdb.sh" as a Kubernetes "init container" 
to ensure the provided database directory is initialized; see also "startup probes" for an alternative solution
(no-op if database is already initialized)
[Ref](https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-ensure-initdb.sh)

