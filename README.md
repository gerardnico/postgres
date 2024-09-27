# Postgres




## Run

### Docker

Make a copy of the [secxx.env](secxx.env.dist) file to `secret.env`

* To run with `pgdata` (/var/lib/postgresql/data) on the [disk](https://github.com/docker-library/docs/blob/master/postgres/README.md#where-to-store-data)

```bash
# on Cygwin
docker rm postgres
docker run --env-file secret.env --name postgres -d -p 5434:5432 -p 9187:9187 -v 'C:\temp\data':/data gerardnico/postgres:16.3-v1
```

Error?
```bash
docker logs postgres
```

## Dump

### How to perform a dump restore

A dump restore is performed via the [dbctl command](resources/dbctl/dbctl)

```bash
# List the available dump and select a snapshot
dbctl dump-ls
# perform a restore (the database is deleted!)
dbctl dump-restore snapshotId
# or for the latest one
dbctl dump-restore snapshotId
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

When creating the image. See [secxx](secxx.env.dist)

```ini
# See environment variables documentation \
# https://github.com/wal-g/wal-g/blob/master/docs/STORAGES.md
WALE_S3_PREFIX = s3://bucket-name/path/to/folder
AWS_ACCESS_KEY_ID = xxxx
AWS_SECRET_ACCESS_KEY = secret
AWS_ENDPOINT = s3-like-service:9000
WALG_COMPRESSION_METHOD = brotli
```

## dbctl

### Bash script

### Database procedure

You can't restore from the database as it expects a manual confirmation.

```sql
CALL public.dbctl('dump-ls');
```

## process

The process that are running in the container and their owner.

```bash
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 14:14 ?        00:00:00 /bin/bash /usr/local/bin/entrypoint.sh overmind start
root         7     1  0 14:14 ?        00:00:00 overmind start
root        14     7  0 14:14 ?        00:00:00 tmux -C -L overmind---yqiI2DgpEldIIe3MQsPrQ new -n postgres -s - -P -F %overmind-process #{pane_id} postgres #{pane_pi
root        20     1  0 14:14 ?        00:00:00 tmux -C -L overmind---yqiI2DgpEldIIe3MQsPrQ new -n postgres -s - -P -F %overmind-process #{pane_id} postgres #{pane_pi
root        21    20  0 14:14 pts/0    00:00:00 sh /tmp/overmind---yqiI2DgpEldIIe3MQsPrQ/postgres
root        23    20  0 14:14 pts/1    00:00:00 sh /tmp/overmind---yqiI2DgpEldIIe3MQsPrQ/postgres_exporter
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

```bash
overmind restart sql_exporter
```


## Dev

When developing,

* copy the [secxx.env](secxx.env.dist) to `secret.env`
* set your value
* and use the [rebuild.com](build.cmd) to rebuild the image.

## Overmind (Process manager)

```bash
OVERMIND_ENV='OVERMIND_CAN_DIE=sql_exporter,postgres_exporter OVERMIND_SHOW_TIMESTAMPS=1'
```

You can:

* Disable the port: [OVERMIND_NO_PORT](https://github.com/DarthSim/overmind?tab=readme-ov-file#disabling-port)
* Disable process to
  run: [OVERMIND_IGNORED_PROCESSES](https://github.com/DarthSim/overmind?tab=readme-ov-file#not-running-the-specified-processes)
* Scale the
  process: [OVERMIND_FORMATION](https://github.com/DarthSim/overmind?tab=readme-ov-file#scaling-processes-formation)
* Set processes to
  auto-restart : [OVERMIND_AUTO_RESTART](https://github.com/DarthSim/overmind?tab=readme-ov-file#auto-restarting-processes)
* Change the log color for each
  process: [OVERMIND_COLORS](https://github.com/DarthSim/overmind?tab=readme-ov-file#specifying-the-colors)
* Add timestamp: [OVERMIND_SHOW_TIMESTAMPS](https://github.com/DarthSim/overmind?tab=readme-ov-file#show-timestamps)




