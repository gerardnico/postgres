# Postgres Backup and restore



## File system

Don't as the database needs to be shutdown.

## cncf physical backup wal

https://cloudnative-pg.io/documentation/1.24/backup/

## Kubernetes logical backup (dump/restore)

how to take a logical backup of the app database in the cluster-example Postgres cluster, from the cluster-example-1 pod in custom format, which is the most versatile way to take logical backups in PostgreSQL.

kubectl exec cluster-example-1 -c postgres \
  -- pg_dump -Fc -d app > app.dump
  
kubectl exec -i new-cluster-example-1 -c postgres \
  -- pg_restore --no-owner --role=app -d app --verbose < app.dump

The example in this section assumes that you have no other global objects (databases and roles) to dump and restore, as per our recommendation. In case you have multiple roles, make sure you have taken a backup using pg_dumpall -g and you manually restore them in the new cluster.

In case you have multiple databases, you need to repeat the above operation one database at a time, making sure you assign the right ownership.
Cncf backup doc: https://cloudnative-pg.io/documentation/1.24/troubleshooting/#emergency-backup

## Pgdump

pg_dump utility - which relies on logical backups instead of physical ones. 

See [pgdump](postgres-pgdump.md)

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


## No Schema restoration: Why?

We don't use SQL restoration for schema
because with cascade, drops all objects that depend on the schema.
And this object may be external.

There is no guarantee that the results of a specific-schema dump
can be successfully restored into a clean database.

Why? Because the dump (pg_dump) will not dump any other database dependent objects
than the selected schema(s).