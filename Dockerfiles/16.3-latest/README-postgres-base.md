# Pg-X Base Image

## About

The base `pg-x` image that extends the [Official Docker image](https://github.com/docker-library/docs/blob/master/postgres/README.md)
* with [pg-x](../../docs/bin/pg-x.md) and its dependencies such as restic and rclone for Point In Time backup and restoration
but:
* without the exporters (without supervisor)
* without walg
* without pg_cron
