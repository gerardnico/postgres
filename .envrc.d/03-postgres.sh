################################
# Docker Postgres Env
# Env of Docker Postgres (not of Postgres)
# https://github.com/docker-library/docs/tree/master/postgres#environment-variables
################################
# POSTGRES_XXX are environment variables that are passed to `initdb`
# in the [entrypoint of Docker](https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-entrypoint.sh#L92C28-L92C41)
# for the creation/installation of the Postgres cluster
#
# POSTGRES_USER is the OS that runs the postgres daemon and owns the file on the file system
# Don't change the name.
# The UID and directories permissions are hardcoded in the image
# See [Postgres User is 999](https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15)
export POSTGRES_USER=postgres
# PGPORT is 5432 (the default)
# Password to connect remotely
export POSTGRES_PASSWORD=welcome
# database name (by default: POSTGRES_USER)
# This is the name of the default database
# Don't change it postgres extensions may have this name hardcoded so setting another value is discouraged
export POSTGRES_DB=postgres
# POSTGRES_INITDB_ARGS to send arguments to postgres initdb
# We allow group access to that use in the postgres group have also access to the postgres files
# See [Ref](https://www.postgresql.org/docs/14/app-initdb.html)
export POSTGRES_INITDB_ARGS="--allow-group-access"
# The method of password authentication for remote connection (ie host connection `all all` in pg_hba.conf)
# See [Doc](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_host_auth_method)
export POSTGRES_HOST_AUTH_METHOD=scram-sha-256


#################################
# Pg_Cron
#################################
# Pg Cron Db (should be the default database (ie same value as POSTGRES_DB)
# PG_CRON_DB=postgres
