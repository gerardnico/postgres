# Postgres restic

## About

This image extends
the [Official Docker image](https://github.com/docker-library/docs/blob/master/postgres/README.md)

* with [pg-x](docs/pg-x.md) - the control script that wraps pg_dump, restic and rclone command for Point In Time backup
  and restoration
* with `pg_vector`
* with `pg_python`

> [!Warning] This image is deprecated in favor of [wal-g](../postgres-walg/README-walg.md)

## Image Usage

* Set the [postgres value](../../.envrc.d/03-postgres.sh) in an `.env` file or in the shell
* To run with the volume at `mount` on
  the [disk](https://github.com/docker-library/docs/blob/master/postgres/README.md#where-to-store-data)

```bash
docker rm postgres
docker run \
  --name postgres \
  --env-file .env \
  --user 1000:1000 \
  --group-add postgres \
  -d \
  -p 5432:5432 \
  -v $PWD/mount:/var/lib/postgresql \
  gerardnico/postgres-restic:18.3-latest
```

Error?

```bash
docker logs postgres
```

## How to

* [How to perform a dump](./docs/dump.md)
* [How to restore from a dump](./docs/restore.md)
* [How to set the retention policy and integrity check](./docs/snapshot.md)

## Contributing / How to develop

See [CONTRIBUTING.md](../../.github/CONTRIBUTING.md)

## Support

### Restic Repo not found

Be sure to path the good password in the environment variable ie `RESTIC_PASSWORD`.

```bash
postgres          | Restic Repo not found - Restic init at s3:host/bucket-name
postgres          | Fatal: create key in repository at s3:host/bucket-name failed: repository master key and config already initialized
```
