# Postgres Backup and restore



## File system

Don't as the database needs to be shutdown.

## Pgdump

See [](postgres-pgdump.md)

## Continuous Archiving and Point-in-Time Recovery (PITR/Wal)

[PITR/Wal](postgres-wal.md)


## Backup Script from Postgres

With `pg_cron` and `python`

Note: Only superusers can create functions in untrusted languages such as `plpython3u`.
https://www.postgresql.org/docs/current/plpython.html

```
CREATE EXTENSION plpythonu;
```

```sql
CREATE
OR REPLACE FUNCTION backup(command text)
RETURNS text AS $$
import subprocess
result = subprocess.run("backup.sh", shell=True, capture_output=True, text=True)
return result.stdout + result.stderr
$$ LANGUAGE plpythonu;
```

```sql
SELECT exec_shell('ls -la');
```


## Image Snapshot

Fly.io performs daily storage-based snapshots of each of your provisioned volumes.
These snapshots can be used to restore your dataset into a new Postgres application.

## Tools

### wal-g

[](postgres-wal-g.md)



### PgBackRest

[pbackrest](postgres-pgbackrest.md)
