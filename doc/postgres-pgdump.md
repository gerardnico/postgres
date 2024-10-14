# Postgres PgDump/PgRestore

## About

https://www.postgresql.org/docs/15/backup.html

## Type
### Plain (in PSQL format)

The whole database in a PSQL file.

Example:

* Backup

```bash
pg_dump dbname | gzip  > $PGDATA/dump/dumpfile.sql.gz
```

* Restore

```bash
dropdb dbname
createdb dbname
gunzip < $PGDATA/dump/dumpfile.sql.gz | psql --set ON_ERROR_STOP=on --single-transaction dbname
# run analyze (to update the stats)
```

where:

* `ON_ERROR_STOP` - stop on error
* `single-transaction` will commit only at the end (to avoid a partially restored dump)

You can also [split](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP-LARGE)

### Custom

Same as gzip with the advantage that tables can be restored selectively `pg_dump` and `pg_restore`

[example](https://www.postgresql.org/docs/15/app-pgrestore.html#APP-PGRESTORE-EXAMPLES)
[ref](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP-LARGE)

Example:
* Dump

```bash
# in -Fc, F means format, c means custom
pg_dump -Fc dbname > filename.dump
```

* Restore in the same database

```bash
# dropdb dbname
pg_restore -d dbname filename.dump
```

* Restore in another database

```bash
# the database is created from template0 not template1, to ensure it is initially empty.
createdb -T template0 newdb
# -C is not used to connect directly to the database to be restored into.
pg_restore -d newdb db.dump
```

## Custom Format to PLSql

The custom binary postgres export data. It can be converted to plain text using pg_restore as follows
```bash
pg_restore data.dump -f plain.sql
```


## In parallel (big database)

```bash
pg_dump -j parralelNum -F d -f out.dir dbname
```

```bash
pg_restore -j
```


## Pgdump and Restic Stdin

https://www.postgresql.org/docs/current/app-pgdump.html
```bash
tar -c whatever/ | gzip --rsyncable > file.tar.gz
```

```bash
bash -c 'pg_dumpall --clean -U$POSTGRES_USER' \
    | gzip --rsyncable \
    | restic backup \
    --host "myapp-prod-db" \
    --stdin --stdin-filename \
    postgres.sql.gz
```

As client with pg_dump
https://github.com/ixc/restic-pg-dump-docker/blob/master/Dockerfile

