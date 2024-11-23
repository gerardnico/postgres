# Wal-g

## About
`wal-g` as a tool for making encrypted, compressed PostgreSQL backups (full and incremental)
and push/fetch them to/from remote storages without saving it on your filesystem.

You can use wal-g as a tool for making encrypted, compressed PostgreSQL backups (full and incremental)
and push/fetch them to/from remote storages without saving it on your filesystem.

Physical backups for all projects running on Fly using WAL-G.
https://github.com/wal-g/wal-g

Database changes are continuously streamed to S3.
When there is a host or volume corruption, we restore the project to a new Fly host using the latest data in S3.
https://supabase.com/blog/postgres-on-fly-by-supabase
https://news.ycombinator.com/item?id=38915421

https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md
https://github.com/sorintlab/stolon/blob/master/doc/pitr_wal-g.md
https://github.com/avestura/walg-docker/blob/master/Dockerfile

Docker:
https://github.com/fly-apps/postgres-flex (HA setup using repmgr - primary and a standby server)
https://github.com/fly-apps/postgres-ha (HA setup using solon - old as stated [here](https://fly.io/docs/postgres/advanced-guides/high-availability-and-global-replication/))

https://github.com/MikeTangoEcho/postgres-walg
https://github.com/stephane-klein/playground-postgresql-walg/

```bash
docker run --env-file [your env file] postgres-walg sh /root/dump.sh
```



## Env

```ini
# See environment variables documentation \
# https://github.com/wal-g/wal-g/blob/master/docs/STORAGES.md
AWS_ACCESS_KEY_ID=xxxx
AWS_SECRET_ACCESS_KEY=secret
AWS_ENDPOINT=s3-like-service:9000
WALG_COMPRESSION_METHOD=brotli
```

### Dump Location

Location of the dump (ie base backup and wal files)
```bash
WALE_S3_PREFIX=s3://bucket-name/path/to/folder
WALG_S3_PREFIX=s3://bucket-name/path
WALG_S3_PREFIX=s3://postgres-dev/dev-name
```

## Backup Scenario

[](https://github.com/stephane-klein/playground-postgresql-walg/blob/master/README.md)


### Connect

* Go into the container

```bash
docker exec -it postgres bash
# or
dbash
# git bash
winpty docker exec -it postgres bash
```

* SQL Client: localhost: 5432


### Monitoring

Check Stats archiver Information

```bash
echo "select * from pg_stat_archiver;" | psql -x -U $POSTGRES_USER $POSTGRES_DB -a -q -f -
```

[pg_stat_archiver](https://www.postgresql.org/docs/current/monitoring-stats.html#MONITORING-PG-STAT-ARCHIVER-VIEW)
```
-[ RECORD 1 ]------+-----------------------------------------
archived_count     | 4    # Number of WAL files that have been successfully archived
last_archived_wal  | 000000010000000000000003.00000028.backup # Name of the WAL file most recently successfully archived
last_archived_time | 2020-04-01 22:12:52.273572+00
failed_count       | 0    # Number of failed attempts for archiving WAL files
last_failed_wal    |      # Name of the WAL file of the most recent failed archival operation
last_failed_time   |      # Time of the most recent failed archival operation
stats_reset        | 2020-04-01 22:12:19.392116+00
```

* switch a wal manually
```sql
SELECT pg_switch_wal()
```

```
SHOW archive_mode;
SHOW archive_command;
```

### Generate Data

```bash
pgbench -U $PGUSER -i -s 2 -n
pgbench -i -s 2 -n
```

### wal-g backup-list

```bash
INFO : 2024/05/25 09:03:52.466361 List backups from storages: [default]
backup_name                   modified             wal_file_name            storage_name
base_000000010000000000000003 2024-05-25T08:49:00Z 000000010000000000000003 default
base_000000010000000000000006 2024-05-25T08:51:59Z 000000010000000000000006 default
base_000000010000000000000008 2024-05-25T08:52:15Z 000000010000000000000008 default
base_000000010000000000000016 2024-05-25T09:02:40Z 000000010000000000000016 default
```

### wal-g wal-show

wal-g wal-show

```
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
| TLI | PARENT TLI | SWITCHPOINT LSN | START SEGMENT            | END SEGMENT              | SEGMENT RANGE | SEGMENTS COUNT | STATUS | BACKUPS COUNT |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
|   1 |          0 |             0/0 | 000000010000000000000001 | 000000010000000000000014 |            20 |             20 | OK     |             3 |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
```

after a full backup

```
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
| TLI | PARENT TLI | SWITCHPOINT LSN | START SEGMENT            | END SEGMENT              | SEGMENT RANGE | SEGMENTS COUNT | STATUS | BACKUPS COUNT |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
|   1 |          0 |             0/0 | 000000010000000000000001 | 000000010000000000000016 |            22 |             22 | OK     |             4 |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
```

### Restore /recover

It will restore to the latest (no `PITR` for now)

```bash
# in a existing container
docker exec postgres bash -c 'touch $PGDATA/recovery.signal'
# before a run
docker run --rm postgres2 sh -c 'wal-g backup-fetch $PGDATA LATEST; touch $PGDATA/recovery.signal'
# fly
fly machine exec [machine-id] bash -c 'touch $PGDATA/recovery.signal'
```


### Restore check

* The time stamp of the last transaction replayed during recovery

```sql
select * from pg_last_xact_replay_timestamp ();
```

+---------------------------------+
|pg_last_xact_replay_timestamp |
+---------------------------------+
|2024-05-26 17:11:06.105773 +00:00|
+---------------------------------+

More [Recovery function](https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-RECOVERY-CONTROL)


## Concepts

### wal deletion

Postgres recycles wal files, so you should see the number of files
remaining pretty much the same, but the file names should change
during the time.


### Delta-Backup

with `WALG_DELTA_MAX_STEPS` to a number greater than 0

deltas and base backup
[](https://github.com/wal-g/wal-g/issues/187#issuecomment-469770129)

Deltas is a whole new story.
Delta-backup is a backup which can be applied to base backup.
But much faster than WAL, because it is parallel and squashes multiple page writes into one.

## Commands

### Verify Integrity / timeline (wal-verify)

https://github.com/wal-g/wal-g/blob/a2c015d8d22289877f548c3ee2a9cbed5695ce33/docs/PostgreSQL.md#wal-verify

```bash
wal-g backup-list
wal-g wal-show
wal-g wal-verify integrity timeline
```

### Switch a WAL

```sql
SELECT pg_switch_wal()
```

### Make base backup (backup-push)

In the container:
```bash
wal-g backup-push $PGDATA
```
will create a base backup at the [dump location](#dump-location)

### List the base backup dump (backup-list)

To list the backups
```bash
wal-g backup-list
```

### Delete the older than 5 days backup

```bash
wal-g delete retain Full 5 --confirm
```

### Push Wal (wal-push)

```bash
export WALG_PREVENT_WAL_OVERWRITE=1; wal-g wal-push $PGDATA/pg_wal/00000003000000000000000B
```

## Benchmark

```bash
# base backup
wal-g backup-push /var/lib/postgresql/10/main/
# https://www.postgresql.org/docs/current/pgbench.html
pgbench -U $PGUSER -i -s $SCALE -n
# 1600 MB
pgbench -i -s 1000 userdb
```

https://github.com/wal-g/wal-g/blob/master/benchmarks/reverse-delta-unpack/reverse-delta-unpack-26-03-2020.md
https://github.com/wal-g/wal-g/blob/master/benchmarks

## Exporter

The [prometheus exporter](postgres-exporter.md) have the following metrics :

* total wal segments: total wal segments on remote storage
* continuous wal segments: total wal segments without gap starting from last uploaded
* valid base backup: total base backup starting from last uploaded without wal segments gap
* missing wal segments: Missing wal segment on remote storage between base backups
* missing wal segments at end: Missing wal segment near the master position, should not go higher than 1. Replication
  lag for remote storage

[Ref](https://github.com/wal-g/wal-g/issues/323#issuecomment-595663310)