# Extension of the Docker image Postgres
# https://github.com/docker-library/docs/blob/master/postgres/README.md
# For ref and Dockerfile example, see postgres-docker

# version of this file
# PG version
ARG PG_MAJOR_VERSION
ARG PG_VERSION
# https://hub.docker.com/_/postgres
# https://github.com/docker-library/postgres/tree/master/18/bookworm
ARG PG_DOCKER_TAG

# Build Extensions
ARG PG_SAFEUPDATE_VERSION=1.5
ARG PG_EXTENSIONS="safeupdate"


# Walg
# Os name is mandatory and may change, it's not a stand linux
# Ubuntu works on debian
ARG WALG_VERSION
ARG WALG_OSNAME

# C Extensions use pgxs for the build
# https://www.postgresql.org/docs/current/extend-pgxs.html
FROM postgres:${PG_DOCKER_TAG} AS pgxs_builder
ARG PG_MAJOR_VERSION
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    checkinstall \
    cmake \
    git \
    curl \
    # Needed for curl, libcurl (used in make file) \
    ca-certificates \
    postgresql-server-dev-${PG_MAJOR_VERSION}

####################
# pg-safeupdate deb package creation
####################
FROM pgxs_builder AS pg-safeupdate
ARG PG_SAFEUPDATE_VERSION
ADD "https://github.com/eradman/pg-safeupdate/archive/refs/tags/${PG_SAFEUPDATE_VERSION}.tar.gz" \
    /tmp/pg-safeupdate.tar.gz
RUN tar -xvf /tmp/pg-safeupdate.tar.gz -C /tmp \
    && rm -rf /tmp/pg-safeupdate.tar.gz
# Build from source
WORKDIR /tmp/pg-safeupdate-${PG_SAFEUPDATE_VERSION}
ENV USE_PGXS=1
RUN make -j$(nproc)
# Create debian package
RUN checkinstall -D --install=no --fstrans=no --backup=no --pakdir=/tmp --nodoc

###############################################
# Postgres Final
###############################################
# suppress warning that it would fail if pg_docker_tag is unknown
# hadolint ignore=InvalidDefaultArgInFrom
FROM postgres:${PG_DOCKER_TAG} AS final

ARG IMAGE_VERSION
ARG PG_VERSION
ARG PG_MAJOR_VERSION
ARG LOG_HOME
ARG WALG_VERSION
ARG WALG_OSNAME

ARG ARCHIVE_MODE=on
ARG ARCHIVE_TIMEOUT=3600
ARG PROJECT_HOME=Dockerfiles/postgres-walg

RUN echo "PG_MAJOR_VERSION is: $PG_MAJOR_VERSION"

####################################
# COPY/Prebuild Installation
####################################
# pg-safeupdate extension
COPY --from=pg-safeupdate /tmp/*.deb /tmp
RUN apt-get install --no-install-recommends -y /tmp/*.deb


####################
# Walg
####################
ADD https://github.com/wal-g/wal-g/releases/download/$WALG_VERSION/wal-g-pg-${WALG_OSNAME}-amd64.tar.gz \
    wal-g-pg-${WALG_OSNAME}-amd64.tar.gz
RUN tar -zxvf wal-g-pg-${WALG_OSNAME}-amd64.tar.gz && \
    rm wal-g-pg-${WALG_OSNAME}-amd64.tar.gz && \
    mv wal-g-pg-${WALG_OSNAME}-amd64 /usr/local/bin/wal-g && \
    chmod +x /usr/local/bin/wal-g

####################################
# Package
# At the top so that we don't need to run it again if we change the conf
####################################
RUN apt-get update && \
    echo "Common tool" && \
    apt-get install --no-install-recommends -y \
        bash \
        curl \
        ca-certificates \
        unzip \
        bzip2 && \
    echo "Templating with envsubst (in gettext)" && \
    apt-get install --no-install-recommends -y gettext && \
    echo "Supervisor" && \
    apt-get install --no-install-recommends -y supervisor && \
    echo "PG extension (pgvector, plpython extension)" && \
    apt-get install --no-install-recommends -y \
        postgresql-${PG_MAJOR}-pgvector \
        python3 \
        postgresql-plpython3-${PG_MAJOR} && \
    echo "Cleaning" && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    # No apt-get can be used from this point or you need to run apt-get update \
    # to update the repo again \
    apt-get clean



##############
# Labels
# https://docs.docker.com/reference/dockerfile/#label
# This labels are used by Github
####################################
# * connect the repo
LABEL org.opencontainers.image.source="https://github.com/gerardnico/postgres"
# * set a description
LABEL org.opencontainers.image.description="Postgres in Docker"
# * version
LABEL image-version=${IMAGE_VERSION}
LABEL pg-version=${PG_VERSION}

##############
# Env
###############


# The log home
ENV LOG_HOME=/var/log

# Ensure UTF-8
ENV LANG=en_US.UTF-8
ENV LC_CTYPE=C.UTF-8
ENV LC_COLLATE=C.UTF-8
# TZ is the OS env
# Gnu https://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html
# TZ is supported by Postgres
# Postgres: https://www.postgresql.org/docs/current/app-initdb.html#id-1.9.5.3.7
ENV TZ='Etc/UTC'
# Other env are set in postgres-client.sh
# All date are UTC (Os, Database, ...)
# https://www.postgresql.org/docs/current/libpq-envars.html
# Etc means etcetera
ENV PGTZ='Etc/UTC'

#############
## Pg
#############

# The defined VOLUME was changed in 18 and above to /var/lib/postgresql
# (one level below pgdata) as it allows for migration
# https://github.com/docker-library/docs/tree/master/postgres#pgdata
ENV MOUNTED_DIR=/var/lib/postgresql

RUN mkdir -p "${MOUNTED_DIR}"; \
    # Every user should be able to create directory in it \
    chown root:postgres "${MOUNTED_DIR}"; \
    chmod 0777 "${MOUNTED_DIR}"

# the PGDATA environment variable of the image was changed to be version specific in PostgresSQL 18 and above
# This will allow users upgrading between PostgresSQL major releases
# to use the faster `--link` when running pg_upgrade and mounting /var/lib/postgresql
# https://github.com/docker-library/docs/tree/master/postgres#pgdata
# Don't create it in the image, the owner should be the user that starts
# it will create it if needed
ENV PGDATA="$MOUNTED_DIR/$PG_MAJOR_VERSION/docker"

#####################################
# Bash
#####################################
# The base Postgres image does not use the postgres environment variable
# Postgres Local Connection env
# so that when logged in, we can connect automatically and wal-g also

# Install env
ADD resources/bash/profile/profile.d/* /etc/profile.d
ADD resources/bash/profile/profile /etc/profile


##################################
# Walctl
##################################
# Install bash-lib into its own directory
# so that we can mount them and edit them
ENV BASHLIB_PATH="/usr/local/lib/bash-lib"
RUN mkdir -p $BASHLIB_PATH
ADD $PROJECT_HOME/bin/lib/* $BASHLIB_PATH
ADD --chmod=0775 --chown=root:postgres $PROJECT_HOME/bin/walctl /usr/local/bin/


# Conf
# https://github.com/docker-library/docs/blob/master/postgres/README.md#database-configuration
# postgresql.conf is a template and accepts env so that we can be consistent
# Don't add secret in their
# The conf directory default to `pgdata`
# Conf Must be mounted, must not be in the image

# Database Init Scripts
# The (*.sql, *.sql.gz, or *.sh) init scripts
# Executed
#  * in sorted name order as defined by the current locale (default to en_US.utf8)
#  * at database initialization only happens on container startup
#  * ie the data directory is empty
# https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-entrypoint.sh#L161
# ADD resources/postgres/initdb/* /docker-entrypoint-initdb.d

# Postgres Scripts
# the end / in the target is important to tell that this is a directory
# ADD resources/postgres/script/* /script/

####################################
# Postgres User (ie al 1000:1000)
####################################
# Reset the id of the postgres user from 999 to 1000
# so that it's WSL ready
## Adapted from https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15
RUN deluser postgres; \
    groupadd -r postgres --gid=1000; \
    useradd -r -g postgres --uid=1000 --home-dir=$MOUNTED_DIR --shell=/bin/bash postgres; \
    mkdir -p $MOUNTED_DIR; \
    chown -R postgres:postgres $MOUNTED_DIR; \
    chown -R postgres:postgres /run/postgresql


####################################
# HEALTHCHECK
####################################
# pg_isready issues a connection check to a PostgreSQL database.
HEALTHCHECK --interval=2s --timeout=2s --retries=10 CMD pg_isready --username postgres --host localhost

#############################
## Postgres Entrypoint
#############################
# Entrypoint
# https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-entrypoint.sh
# example of how to use "docker-entrypoint.sh" to extend/reuse the initialization behavior
# https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-ensure-initdb.sh
## wrapper around docker-entrypoint.sh
# ADD --chmod=0775 --chown=root:postgres resources/postgres/postgres-ctl /usr/local/bin/

# We set the full path so that if the script is mounted
# the user can see a permission denied if the script does not have any execution rights
# ENTRYPOINT [ "/usr/local/bin/postgres-ctl" ]
