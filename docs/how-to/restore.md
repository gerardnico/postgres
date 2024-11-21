## How to restore

A dump restore is performed via the [pg-x command](../bin-generated/pg-x.md)

## How to restore a database from a snapshot dump


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

## How to restore a database from a local dump

```bash
# From the host, copy a dump into the container or mount a volume
docker cp /tmp/db-dump/dumpfile-db-combo.sql.gz postgres:/tmp
# From the container, perform a restore
docker exec -ti postgres bash
dbctl backup restore /tmp/dumpfile-db-combo.sql.gz
```

### How to perform a dump backup

A dump backup is performed via the [ctl command](bin/dbctl)

```bash
dbctl dump-backup
# prune the repo
dbctl dump-prune
```