# Init: How to create a container ?


## About
This image extends the image



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
* `postgres` as user is hardcoded in the [imaqe](https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15)


If you change the user, you will get:
```
chmod: changing permissions of '/var/run/postgresql': Operation not permitted
The files belonging to this database system will be owned by user "al".
This user must also own the server process.
```

### WSL (user)

Because this image is [WSL ready](../pg-x-docker.md#wsl-ready), the user 1000 is the postgres user

Under WSL, run your docker command with:
```bash
docker \
    --user 1000:1000
```

### PGDATA

https://github.com/docker-library/docs/tree/master/postgres#user-content-pgdata

PgData is not set by default to `/var/lib/postgresql/data`
to be able to mount only one volume
if more saved data are needed.


Postgres initdb requires a subdirectory to be created within the mountpoint to contain the data.

The owner should be the [POSTGRES_USER](#postgres_user---the-os-and-postgres-owner-user).

Set to `PG_X_HOME/pgdata` (ie `/data/pgdata`)

```bash
docker run \ 
  -v /data:/data \
  postgres
```


## POSTGRES_HOST_AUTH_METHOD

Note: the [POSTGRES_HOST_AUTH_METHOD](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_host_auth_method)
should not be set to `trust` so that remote clients needs to give a password.

## Conf (postgresql.conf)

https://github.com/docker-library/docs/tree/master/postgres#database-configuration
```bash
# get the default file
docker run -i --rm postgres cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf
# set it
docker run -v "$PWD/my-postgres.conf":/etc/postgresql/postgresql.conf 
```