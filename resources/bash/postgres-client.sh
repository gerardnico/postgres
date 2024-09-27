# The base Postgres image does not use the postgres client environment variable
# They use their owns prefixed with `POSTGRES_`
# See https://github.com/docker-library/postgres/issues/402
# This file sets them back

# Postgres Local Connection env
# so that when logged in, we and all cli (wal-g, psql, ...) also can connect automatically

############################
# Docker/Conf env
# https://github.com/docker-library/docs/blob/master/postgres/README.md#environment-variables
############################
# The env variable of the docker image (not of the db)
# postgres is the default database, is always present
# and is the default of all extensions as stated here
# https://www.postgresql.org/docs/9.1/creating-cluster.html
export POSTGRES_DB="${POSTGRES_DB:-postgres}"
export POSTGRES_USER="${POSTGRES_USER:-${POSTGRES_DB}}"

############################
# The env variable for all cli
# Default connection variable for postgres (psql, pg_dump, ...) and wal-g uses them also
# Pg Doc: https://www.postgresql.org/docs/current/libpq-envars.html
# Wal-g doc: https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#configuration
############################
export PGHOST=/var/run/postgresql
export PGUSER="${POSTGRES_USER}"
export PGDATABASE="${POSTGRES_DB}"
# PGPASSWORD is not required to connect from localhost
#export PGOPTIONS=''
#export PGPORT=5432



