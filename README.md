# Postgres Images

This project contains 2 images for postgres PIT backup and recovery.

* [wal-g](Dockerfiles/postgres-walg/README-walg.md) for a physical backup based on `wal-g`
* [restic](Dockerfiles/postgres-restic/README-restic.md) for a logical backup based on `pg_dump` and restic (deprecated
  in favor of wal-g)

## How to back up and do a Point In Time recovery

See [backup and recovery scenario with wal-g](Dockerfiles/postgres-walg/docs/backup-recovery-scenario.md)

## Features

* Backup dump and restore
* Point In Time recovery
* [Wsl Adapted](docs/docker-run.md#wsl-user)

## Support

### Extra info and how-to

* [The Postgres Env](docs/docker-run.md)
* [How to connect to the database](docs/connect.md)
