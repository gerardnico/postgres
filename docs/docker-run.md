# Postgres Init: How to create a container ?

## About

Below is an article over the [docker postgres](https://hub.docker.com/_/postgres)

* [configuration](https://hub.docker.com/_/postgres#environment-variables)
* and layout

## Environment Variable Name

The docker image use `POSTGRES` as prefix, and we set them to
the [PG client environment variable](https://www.postgresql.org/docs/current/libpq-envars.html)
with [this profile script](../resources/bash/profile/profile.d/postgres-client.sh)

## Walg and restic environment

For specific env for `walg` and `restic`, check the respective run script

* [walg run](../Dockerfiles/postgres-walg/run)
* [restic run](../Dockerfiles/postgres-restic/run)

## Conf explained

### POSTGRES_DB - the default database created

https://github.com/docker-library/docs/tree/master/postgres#postgres_db

`postgres` as a default database may hardcoded in extensions

After initialization, a database cluster will contain a database named postgres,
which is meant as a default database for use by utilities, users and third party applications.
The database server itself does not require the postgres database to exist,
but many external utility programs assume it exists.
https://www.postgresql.org/docs/9.1/creating-cluster.html

### POSTGRES_USER - the OS and postgres owner user

https://github.com/docker-library/docs/tree/master/postgres#postgres_user

They are used to init the database and should not be changed.
Why?

* `postgres` as user is hardcoded in
  the [imaqe](https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15)

If you change the user, you will get:

```
chmod: changing permissions of '/var/run/postgresql': Operation not permitted
The files belonging to this database system will be owned by user "al".
This user must also own the server process.
```

### WSL (user)

Because this image is [WSL ready](pg-x-docker.md#wsl-ready), the user 1000 is the postgres user

Under WSL, run your docker command with:

```bash
docker \
    --user 1000:1000 \
    --user "${UID}:${GID}"
```

### PGDATA

https://github.com/docker-library/docs/tree/master/postgres#user-content-pgdata

Postgres initdb requires a subdirectory to be created within the mount point to contain the data.

* the mount point is `/var/lib/postgresql`
* `PGDATA` should be a subdirectory og `/var/lib/postgresql`
  * since 18, in docker `/var/lib/postgresql/${MAJOR}/docker`
  * the owner is the [POSTGRES_USER](#postgres_user---the-os-and-postgres-owner-user).

```bash
docker run \
  -v /data:/var/lib/postgresql \
  postgres
```

## POSTGRES_HOST_AUTH_METHOD

Note:
the [POSTGRES_HOST_AUTH_METHOD](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_host_auth_method)
should not be set to `trust` so that remote clients needs to give a password.

## Conf (postgresql.conf)

### Via file

https://github.com/docker-library/docs/tree/master/postgres#database-configuration

```bash
# get the default file
docker run -i --rm postgres cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf
# set it
docker run -v "$PWD/my-postgres.conf":/etc/postgresql/postgresql.conf
```

### Via command line

With the [c flag](https://www.postgresql.org/docs/14/app-postgres.html#id-1.9.5.14.6.3)

```bash
docker run -d \
  --name some-postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  postgres \
  -c shared_buffers=256MB \
  -c max_connections=200
```
