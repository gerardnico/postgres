# Postgres and Wal-g

This project contains the [Dockerfile](Dockerfile) that creates the image
`ghcr.io/gerardnico/postgres-walg:18.4-latest`.

It's an extension of the [official postgres database](https://hub.docker.com/_/postgres)
that contains the [wal-g](https://wal-g.readthedocs.io) executable for backup and restoration

## Image Usage: Backup and recovery scenario

See [Backup and recovery scenario](docs/backup-recovery-scenario.md)

## Dockerfile Development

* Build the image with [build](build)
* Run it with [run](run) so that:
  * `wal-g` env are set
  * and all scripts are mounted locally

```bash
./build
./run
```

* Modify the scripts


## Any error? Log

* The log in the container is at `$PGDATA/log`
* It's not on the container log
