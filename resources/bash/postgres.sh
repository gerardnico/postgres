# The base Postgres image does not use the postgress environment variable
# Postgres Local Connection env
# so that when logged in, we can connect automatically and wal-g also

############################
# Docker/Conf env
# https://github.com/docker-library/docs/blob/master/postgres/README.md#environment-variables
############################
# postgres is the default database, is always present
# and is the default of all extensions as stated here
# https://www.postgresql.org/docs/9.1/creating-cluster.html
export POSTGRES_DB="${POSTGRES_DB:-postgres}"
export POSTGRES_USER="${POSTGRES_USER:-${POSTGRES_DB}}"

############################
# Default connection variable for postgres (psql, pg_dump, ...) and wal-g uses them also
# Pg Doc: https://www.postgresql.org/docs/current/libpq-envars.html
# Wal-g doc: https://github.com/wal-g/wal-g/blob/master/docs/PostgreSQL.md#configuration
############################
export PGHOST=/var/run/postgresql
export PGUSER="${POSTGRES_USER}"
export PGDATABASE="${POSTGRES_DB}"
# PGPASSWORD is not required to connect from localhost

# color in diagnostic messages (https://www.postgresql.org/docs/current/app-pgrestore.html)
# value may be always, auto and never
export PG_COLOR=always


