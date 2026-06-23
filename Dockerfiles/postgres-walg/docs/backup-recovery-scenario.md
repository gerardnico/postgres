# Backup and recovery Scenario

Adaptation of [](https://github.com/stephane-klein/playground-postgresql-walg/tree/master)

## Steps

### Set the env

See the [docker-compose.yml](../docker-compose.yml) for the environment.

#### Wal-g

For Wal-g, you can set configuration via:

* an env
* or a [configuration file](https://github.com/wal-g/wal-g/tree/master/docs#configuration)

See this [script](../resources/walg-runtime-env.sh) for an example on how to set env.

Check the `official documentation` for the full list

* [Common Walg](https://github.com/wal-g/wal-g/tree/master/docs#configuration)
* [Specific Postgres](https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#configuration)

### Start a container database

```bash
# -d is mandatory so that it runs in the background (ie detach)
./docker-compose up -d
```

### Check the logs

```bash
./docker-compose logs -f
```

### Get a shell

```bash
./docker-compose exec postgres-walg bash
```

### Verify the wal configuration

```bash
psql --expanded --echo-all --quiet  -t -c 'show archive_mode; show wal_level; show archive_timeout; show archive_command; show restore_command'
```

```txt
archive_mode | on
wal_level | replica
archive_timeout | 1min
archive_command | wal-g wal-push %p
restore_command | wal-g wal-fetch %f %p
```

### List the wal-g backup

```bash
wal-g backup-list
```

```txt
INFO: 2026/06/23 07:42:30.556022 List backups from storages: [default]
INFO: 2026/06/23 07:42:30.996708 No backups found
```

### Make a base backup

A base backup is a full file system backup of the `PGDATA` directory.

(It should be performed regularly so that in case of restoration, only a couple of Wal files
are needed)

```bash
wal-g backup-push -f $PGDATA
```

Note that `-f PGDATA` is mandatory as `wal-g` is not `PGDATA` aware.

Output:

```txt
INFO: 2026/06/23 08:02:44.905477 Backup will be pushed to storage: default
INFO: 2026/06/23 08:02:44.913004 Doing full backup.
INFO: 2026/06/23 08:02:44.916880 Calling pg_start_backup()
INFO: 2026/06/23 08:02:44.970974 Initializing the PG alive checker (interval=1m0s)...
INFO: 2026/06/23 08:02:44.971740 Starting a new tar bundle
INFO: 2026/06/23 08:02:44.971783 Walking ...
INFO: 2026/06/23 08:02:44.971975 Starting part 1 ...
INFO: 2026/06/23 08:02:45.472180 Packing ...
INFO: 2026/06/23 08:02:45.474065 Finished writing part 1.
INFO: 2026/06/23 08:02:46.855973 Starting part 2 ...
INFO: 2026/06/23 08:02:46.856070 /global/pg_control
INFO: 2026/06/23 08:02:46.856734 Finished writing part 2.
INFO: 2026/06/23 08:02:46.856769 Calling pg_stop_backup()
INFO: 2026/06/23 08:02:46.871495 Starting part 3 ...
INFO: 2026/06/23 08:02:46.871649 backup_label
INFO: 2026/06/23 08:02:46.871695 tablespace_map
INFO: 2026/06/23 08:02:46.881374 Finished writing part 3.
INFO: 2026/06/23 08:02:47.081918 Querying pg_database
INFO: 2026/06/23 08:02:47.716180 Wrote backup with name base_000000010000000000000004 to storage default
```

List

```bash
wal-g backup-list
```

```txt
backup_name                   modified             wal_file_name            storage_name
base_000000010000000000000004 2026-06-23T08:02:49Z 000000010000000000000004 default
```

### Generate and insert data

Use `pgbench` to fill it

```bash
pgbench -i -s 2 -n
```

```txt
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
creating primary keys...
done in 0.29 s (drop tables 0.00 s, create tables 0.03 s, client-side generate 0.20 s, primary keys 0.06 s).
```

### Check that data are present

```bash
psql -xqtc 'select count(*) from pgbench_accounts'
```

```txt
count | 200000
```

### Verify the wal archiver runs after wal switch

```bash
psql -xqtc 'select * from pg_stat_archiver';
```

```txt
-[ RECORD 1 ]------+------------------------------
archived_count     | 9
last_archived_wal  | 000000010000000000000007
last_archived_time | 2026-06-23 10:33:06.906488+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2026-06-23 07:59:21.120989+00
```

If it has not occurs because of the delay, the switch occurs at every [archive_timeout](#verify-the-wal-configuration),
(60s in the image), you can switch it manually
with [pg_switch_wal](https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-BACKUP-TABLE)

```sql
SELECT pg_switch_wal()
```

### Verify the Wal is in the cloud (wal-show)

[wal-show](https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#wal-show)
show information about the WAL storage folder.

* if there are no gaps (missing segments) in the range, final status is OK
* if there are some missing segments found, final status is LOST_SEGMENTS

```bash
wal-g wal-show
```

```txt
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
| TLI | PARENT TLI | SWITCHPOINT LSN | START SEGMENT            | END SEGMENT              | SEGMENT RANGE | SEGMENTS COUNT | STATUS | BACKUPS COUNT |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
|   1 |          0 |             0/0 | 000000010000000000000001 | 00000001000000000000000A |            10 |             10 | OK     |             2 |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
```

* `TLI` is the `timeline id`
* `PARENT_TLI` is the previous `timeline id`
* `000000010000000000000001` is a WAL file name where
  * `00000001` is the `timeline id`
  * `0000000000000001` is the `logical sequence number (LSN)`

### Check the cloud file system

With [st (storage tool](https://github.com/wal-g/wal-g/blob/master/docs/StorageTools.md),
you can do file system operation.

For instance, the `ls` command list the backup objects:

```bash
wal-g st ls
```

```txt
type size last modified                 name
dir  0    0001-01-01 00:00:00 +0000 UTC basebackups_005/
dir  0    0001-01-01 00:00:00 +0000 UTC wal_005/
```

### Verify WAL-G can perform a PITR (wal-verify)

[wal-verify integrity](https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#integrity)
Ensure that there is a consistent WAL segment history for the cluster so WAL-G can perform a PITR for the backup.

```bash
wal-g wal-verify integrity
```

```txt
INFO: 2026/06/23 10:55:46.003280 Current WAL segment: 00000001000000000000000B
INFO: 2026/06/23 10:55:46.501115 Building check runner: integrity
INFO: 2026/06/23 10:55:47.616975 Detected earliest available backup: base_000000010000000000000004
INFO: 2026/06/23 10:55:47.617043 Running the check: integrity
[wal-verify] integrity check status: OK
[wal-verify] integrity check details:
+-----+--------------------------+--------------------------+----------------+--------+
| TLI | START                    | END                      | SEGMENTS COUNT | STATUS |
+-----+--------------------------+--------------------------+----------------+--------+
|   1 | 000000010000000000000004 | 00000001000000000000000A |              7 |  FOUND |
+-----+--------------------------+--------------------------+----------------+--------+
```

where:

* `TLI` is the `timeline id`

### Verify the timeline (wal-verify timeline)

Whenever an archive recovery completes, a new timeline is created to identify
the series of WAL records generated after a recovery.

[wal-g wal-verify integrity](https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#timeline)
check if the current cluster timeline is greater than or equal to any of the storage WAL segments timelines.

```bash
wal-g wal-verify timeline
```

```txt
INFO: 2026/06/23 10:59:50.442061 Current WAL segment: 00000001000000000000000B
INFO: 2026/06/23 10:59:50.877518 Building check runner: integrity
INFO: 2026/06/23 10:59:51.987373 Detected earliest available backup: base_000000010000000000000004
INFO: 2026/06/23 10:59:51.987421 Running the check: integrity
[wal-verify] integrity check status: OK
[wal-verify] integrity check details:
+-----+--------------------------+--------------------------+----------------+--------+
| TLI | START                    | END                      | SEGMENTS COUNT | STATUS |
+-----+--------------------------+--------------------------+----------------+--------+
|   1 | 000000010000000000000004 | 00000001000000000000000A |              7 |  FOUND |
+-----+--------------------------+--------------------------+----------------+--------+
```

### Simulate a crash disk

Exit the container, stop it and delete the directory

```bash
exit
./docker-compose down
# start only a shell
./docker-compose run --rm --entrypoint bash postgres-walg
# Env set in the image: MOUNTED_DIR=/var/lib/postgresql
rm -rf "$MOUNTED_DIR/18"
```

### Restore a base backup (backup-fetch) and starts in recovery mode

* [backup-fetch](https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#backup-fetch)

```bash
ls $PGDATA # should not exist
# PG_DATA="$MOUNT_DIR/18/docker" - WAL-G create it
wal-g backup-fetch $PGDATA LATEST
# or a specific one
# wal-g backup-fetch $PGDATA base_00000001000000000000002A
```
```txt
INFO: 2026/06/23 13:23:53.616233 Selecting the latest backup...
INFO: 2026/06/23 13:23:53.616686 Backup to fetch will be searched in storages: [default]
INFO: 2026/06/23 13:23:54.035365 LATEST backup is: 'base_000000010000000000000006'
INFO: 2026/06/23 13:23:57.766643 Finished extraction of part_001.tar.br
INFO: 2026/06/23 13:23:58.082476 Finished extraction of pg_control.tar.br
INFO: 2026/06/23 13:23:58.084480 Finished extraction of backup_label.tar.br
INFO: 2026/06/23 13:23:58.084522
Backup extraction complete.
```
* Signal the recovery (ie the WAL files present in `$PGDATA/pg_wal` should be ingested into the actual data)

```bash
touch $PGDATA/recovery.signal
```

* Set the recovery configuration - target and action

```bash
cat > $PGDATA/postgresql.auto.conf <<EOF
# already set, for example purpose
restore_command = 'wal-g wal-fetch "%f" "%p"'
# optional:
# recovery_target_time = '2026-06-20 14:35:00+02' # ie until a certain time - default to last one
# recovery_target_action = 'promote' # ie start the db
EOF
```

* Exit and start the container.

```bash
exit
./docker-compose up
```

### Verify the recovery

#### Check the recovery log

Note as the recovery process asks for Wal file until an error occurs, the error below in the log is normal.
Postgres had asked it, and it does not exist (ie end of archive)

```bash
ERROR: 2026/06/23 12:21:36.049327 Archive '00000001000000000000000C' does not exist.
```

> [!TIP] If you don't see any docker log, you may have the conf `logging_collector = on`, the log is in $PGDATA/log and not as docker log
> ```bash
> tail -n 200 $PGDATA/log/postgresql-*.log
> ```

Example of output:
```txt
==> /var/lib/postgresql/18/docker/log/postgresql-2026-06-23_122130.log <==
2026-06-23 12:21:30.685 UTC [1] LOG:  starting PostgreSQL 18.4 (Debian 18.4-1.pgdg12+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 12.2.0-14+deb12u1) 12.2.0, 64-bit
2026-06-23 12:21:30.686 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2026-06-23 12:21:30.686 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2026-06-23 12:21:30.691 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2026-06-23 12:21:30.699 UTC [20] LOG:  database system was interrupted; last known up at 2026-06-23 08:05:09 UTC
2026-06-23 12:21:30.699 UTC [20] LOG:  creating missing WAL directory "pg_wal/archive_status"
2026-06-23 12:21:30.700 UTC [20] LOG:  creating missing WAL directory "pg_wal/summaries"
ERROR: 2026/06/23 12:21:32.371111 Archive '00000002.history' does not exist.
2026-06-23 12:21:32.376 UTC [20] LOG:  starting backup recovery with redo LSN 0/6000028, checkpoint LSN 0/6000080, on timeline ID 1
2026-06-23 12:21:32.677 UTC [60] FATAL:  the database system is starting up
2026-06-23 12:21:33.287 UTC [20] LOG:  restored log file "000000010000000000000006" from archive
2026-06-23 12:21:33.296 UTC [20] LOG:  starting archive recovery
2026-06-23 12:21:33.305 UTC [20] LOG:  redo starts at 0/6000028
2026-06-23 12:21:34.040 UTC [20] LOG:  restored log file "000000010000000000000007" from archive
2026-06-23 12:21:34.454 UTC [20] LOG:  restored log file "000000010000000000000008" from archive
2026-06-23 12:21:34.476 UTC [20] LOG:  completed backup recovery with redo LSN 0/6000028 and end LSN 0/6000158
2026-06-23 12:21:34.476 UTC [20] LOG:  consistent recovery state reached at 0/6000158
2026-06-23 12:21:34.476 UTC [1] LOG:  database system is ready to accept read-only connections
2026-06-23 12:21:34.652 UTC [20] LOG:  restored log file "000000010000000000000009" from archive
2026-06-23 12:21:34.742 UTC [20] LOG:  restored log file "00000001000000000000000A" from archive
2026-06-23 12:21:34.789 UTC [20] LOG:  restored log file "00000001000000000000000B" from archive
ERROR: 2026/06/23 12:21:36.049327 Archive '00000001000000000000000C' does not exist.
ERROR: 2026/06/23 12:21:37.107258 Archive '00000001000000000000000C' does not exist.
2026-06-23 12:21:37.111 UTC [20] LOG:  redo done at 0/B000110 system usage: CPU: user: 0.02 s, system: 0.10 s, elapsed: 3.80 s
2026-06-23 12:21:37.111 UTC [20] LOG:  last completed transaction was at log time 2026-06-23 10:45:18.260173+00
2026-06-23 12:21:37.192 UTC [1] LOG:  untracked child process (PID 267) exited with exit code 0
2026-06-23 12:21:37.610 UTC [20] LOG:  restored log file "00000001000000000000000B" from archive
ERROR: 2026/06/23 12:21:38.652718 Archive '00000002.history' does not exist.
2026-06-23 12:21:38.656 UTC [20] LOG:  selected new timeline ID: 2
ERROR: 2026/06/23 12:21:39.730510 Archive '00000001.history' does not exist.
2026-06-23 12:21:39.741 UTC [20] LOG:  archive recovery complete
2026-06-23 12:21:39.744 UTC [18] LOG:  checkpoint starting: end-of-recovery immediate wait
2026-06-23 12:21:39.846 UTC [18] LOG:  checkpoint complete: wrote 3887 buffers (23.7%), wrote 3 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=0.044 s, sync=0.045 s, total=0.105 s; sync files=49, longest=0.005 s, average=0.001 s; distance=98304 kB, estimate=98304 kB; lsn=0/C000028, redo lsn=0/C000028
2026-06-23 12:21:39.853 UTC [1] LOG:  database system is ready to accept connections
```

#### Check the control file

If the recovery is successful, the database should start
The Database cluster state should say in production after successful recovery

```bash
pg_controldata $PGDATA
```

```
Database cluster state:               in production
Latest checkpoint location:           0/E000060
Time of latest checkpoint:            Tue 23 Jun 2026 12:27:01 PM UTC
```

#### Check the new timeline

After a PITR recovery, a new timeline is created (`TLI2`)
(ie the `.history` file in `pg_wal/`)

```bash
./docker-compose exec postgres-walg bash
# then
ls $PGDATA/pg_wal/*.history
# contain the recovery history
cat $PGDATA/pg_wal/00000002.history
# wal
wal-g wal-show
```

```txt
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
| TLI | PARENT TLI | SWITCHPOINT LSN | START SEGMENT            | END SEGMENT              | SEGMENT RANGE | SEGMENTS COUNT | STATUS | BACKUPS COUNT |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
|   1 |          0 |             0/0 | 000000010000000000000001 | 00000001000000000000000B |            11 |             11 | OK     |             2 |
|   2 |          1 |       0/C000000 | 00000002000000000000000C | 00000002000000000000000C |             1 |              1 | OK     |             0 |
+-----+------------+-----------------+--------------------------+--------------------------+---------------+----------------+--------+---------------+
```

* Timeline 1: 11 WAL segments (000...001 → 000...00B), 2 backups — the original primary
* Timeline 2:  1 WAL segments (000...00C → 000...00C), 0 backups — the promoted recovery

#### Where is the recovery ? control function

You can follow the recovery with
the [Recovery control function](https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-RECOVERY-CONTROL)

```bash
# f if recovery is done otherwise t for true
psql -c 'select * from pg_is_in_recovery();'
# null if recovery is done otherwise the timestamp of the last transaction replayed
psql -c 'select * from pg_last_xact_replay_timestamp();'
```

### Clean up

```bash
./docker-compose down
sudo rm -rf ../../mount
```
