# How to connect to the default postgres database


## How to connect locally in the container


* Get a container shell
```bash
# with dock-x
dock-x shell
# or
docker exec -ti postgres /usr/bin/env bash 
```

Then in the container shell
* Switch to the [POSTGRES_USER](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_user), the system user that starts the postgres daemon
```bash
# ie `su postgres` by default as `postgres` is the default
su ${POSTGRES_USER:-postgres} 
```
* then use [psql](../kb/postgres-psql.md) to connect. 
```bash
psql
```
Tip: hy you can connect without password? 
Because the [pg_hba.conf](../kb/postgres-auth-pg_hba.conf.md) file allow it
via the `trust` level
```bash
# "local" is for Unix domain socket connections only
local   all             all                                     trust
```
* then use [SQL or PSQL command](../kb/postgres-psql.md#command)
```bash
# example
\c # check the current database
```

## How to connect remotely to the postgres daemon

Get your database client, create a connection with the following properties:
* USER: [POSTGRES_USER](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_user) (postgres default)
* HOST: 
  * `localhost` if you run docker on your laptop
  * `hostname` if you run the container on a host
* DATABASE: [POSTGRES_DB](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_db) (postgres default)
* PORT: `5432`

