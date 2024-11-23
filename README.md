# PG-X - Postgres with eXtra



## Run

### Docker

Set your value in the [.env](.env) file

* To run with `pgdata` at `/data` on the [disk](https://github.com/docker-library/docs/blob/master/postgres/README.md#where-to-store-data)

```bash
docker rm postgres
docker run \
  --name postgres \
  --env-file .env \
  --user 1000:1000 \
  --group-add postgres \
  -d \
  -p 5432:5432 \
  -v $PWD/mount:/data \
  gerardnico/postgres:16.3-latest
```

Error?
```bash
docker logs postgres
```

## Extras


* Backup dump and restore
* Point In Time recovery with restic
* [Wsl Adapted](docs/how-to/init.md#wsl)

## How to

* [How to init/create the container](docs/how-to/init.md)
* [How to perform a dump](docs/how-to/dump.md)
* [How to restore from a dump](docs/how-to/restore.md)
* [How to set the retention policy and integrity check](docs/how-to/snapshot.md)


## Env

See [.env](.env)

Note that all [libpq environments variable](https://www.postgresql.org/docs/current/libpq-envars.html) 
may be applied for client app.


## Support

### Diagnostic

Log is on at `$PGDATA/log`

### Restic Repo not found

Be sure to path the good password in the environment variable ie `RESTIC_PASSWORD`.

```bash
postgres          | Restic Repo not found - Restic init at s3:host/bucket-name
postgres          | Fatal: create key in repository at s3:host/bucket-name failed: repository master key and config already initialized
```


## How to contribute

See [dev doc](contrib/README)


