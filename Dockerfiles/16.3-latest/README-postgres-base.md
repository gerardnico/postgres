# Pg-X Base Image

## About

The base `pg-x` image that extends the [Official Docker image](https://github.com/docker-library/docs/blob/master/postgres/README.md)
* with [pg-x](../../docs/bin/pg-x.md) and its dependencies such as restic and rclone for Point In Time backup and restoration
* with [walg](../../docs/kb/postgres-wal-g.md)
* with `pg_vector`
* with `pg_python`
but:
* without the `sql` and [postgres exporters](../../docs/kb/postgres-exporter.md) (ie without supervisor)
* without [pg_cron](../../docs/kb/postgres-pg-cron.md)
