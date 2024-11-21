# The base Postgres image does not use the postgres client environment variable
# They use their owns prefixed with `POSTGRES_` because they are meant as argument for initdb
# See https://github.com/docker-library/postgres/issues/402
# This file sets them

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



