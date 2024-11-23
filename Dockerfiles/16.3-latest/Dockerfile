# Extension of the Docker image Postgres
# https://github.com/docker-library/docs/blob/master/postgres/README.md
# For ref and Dockerfile example, see postgres-docker


# version of this file
# PG version
ARG PG_MAJOR_VERSION=16
ARG PG_VERSION=16.3
# https://hub.docker.com/_/postgres
# https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/Dockerfile
ARG PG_DOCKER_TAG=16.3

# Build Extensions
ARG PG_SAFEUPDATE_VERSION=1.5
ARG PG_EXTENSIONS="safeupdate"


# https://github.com/restic/restic/releases/
ARG RESTIC_VERSION=0.16.4

# https://hub.docker.com/r/rclone/rclone/tags
ARG RCLONE_VERSION=1.68.1

# Walg
# Os name is mandatory and may change, it's not a stand linux
# Ubuntu works on debian
ARG WALG_VERSION="v3.0.3"
ARG WALG_OSNAME=ubuntu-20.04

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
    # Needed for curl, libcurl (used in make file)
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

####################
# Rclone
####################
# We use the rclone DockerFile
# https://github.com/rclone/rclone/blob/master/Dockerfile
# COPY --from=rclone:rclone:${RCLONE_VERSION} does not work
# We set it here as a multi-step build then
FROM rclone/rclone:${RCLONE_VERSION} AS rclone



###############################################
# Postgres Final
###############################################
FROM postgres:${PG_DOCKER_TAG} AS final

ARG IMAGE_VERSION
ARG PG_VERSION
ARG PG_MAJOR_VERSION
ARG RESTIC_VERSION
ARG RCLONE_VERSION
ARG LOG_HOME
ARG WALG_VERSION
ARG WALG_OSNAME

ARG ARCHIVE_MODE=on
ARG ARCHIVE_TIMEOUT=3600

####################################
# COPY/Prebuild Installation
####################################
# pg-safeupdate extension
COPY --from=pg-safeupdate /tmp/*.deb /tmp
RUN apt-get install --no-install-recommends -y /tmp/*.deb

# rclone
COPY --chmod=0775 --from=rclone /usr/local/bin/rclone /usr/local/bin/

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
    # to update the repo again
    apt-get clean


####################################
# Download Installation
# At the top so that we don't need to run it again if we change the conf
####################################
# We use ADD because it put the downloaded asset in a cache
# Restic
ADD "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_amd64.bz2" \
    restic.bz2
RUN bzip2 -d restic.bz2 && \
    chmod +x restic && \
    mv restic /usr/local/bin/


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
LABEL rclone-version=${RCLONE_VERSION}

##############
# Env
###############
## The mounted directory
ENV DATA_HOME=/data
RUN echo "Create the data directory" && \
    mkdir -p "${DATA_HOME}" && \
    echo "Every user should be able to create directory in it" && \
    chown root:postgres "${DATA_HOME}" && \
    chmod 0777 "${DATA_HOME}"

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

#####################################
# Bash
#####################################
# The base Postgres image does not use the postgres environment variable
# Postgres Local Connection env
# so that when logged in, we can connect automatically and wal-g also

# Install env
ADD resources/bash/profile/profile.d/* /etc/profile.d
ADD ../../resources/bash/profile/profile /etc/profile


# Install bash-lib into its own directory
# so that we can mount them and edit them
RUN mkdir -p /usr/local/lib/bash-lib
ADD vendors/bash-lib/lib/* /usr/local/lib/bash-lib
# Lib is not in the path by default
ENV PATH="/usr/local/lib/bash-lib:${PATH}"



#####################################
# Restic
#####################################
RUN mkdir -p /etc/bash_completion.d && \
    restic generate --bash-completion /etc/bash_completion.d/restic

##################################
# Pg-x
##################################
ADD --chmod=0775 --chown=root:postgres bin/pg-x /usr/local/bin/

# The directory where to dump pg dump backup
# The os user is always postgres
ENV PG_X_DUMP_DIR=${DATA_HOME}/pgdump


# Other env are set in postgres-client.sh
# All date are UTC (Os, Database, ...)
# https://www.postgresql.org/docs/current/libpq-envars.html
# Etc means etcetera
ENV PGTZ='Etc/UTC'

# Conf
# https://github.com/docker-library/docs/blob/master/postgres/README.md#database-configuration
# postgresql.conf is a template and accepts env so that we can be consistent
# Don't add secret in their
# The conf directory default to `pgdata`
ENV POSTGRES_CONF_DIR=/etc/postgresql/
ADD ../../resources/postgres/conf/postgresql.conf ${POSTGRES_CONF_DIR}/postgresql.conf.template
RUN envsubst < ${POSTGRES_CONF_DIR}/postgresql.conf.template > ${POSTGRES_CONF_DIR}/postgresql.conf
ADD ../../resources/postgres/conf/pg_hba.conf ${POSTGRES_CONF_DIR}/pg_hba.conf.template
RUN envsubst < ${POSTGRES_CONF_DIR}/pg_hba.conf.template > ${POSTGRES_CONF_DIR}/pg_hba.conf

# PgData is not set in /var/lib/postgresql/data
# to be able to mount only one volume
# if more saved data are needed
# Don't create it, the owner should be the user that starts
# it will create it if needed
ENV PGDATA=${DATA_HOME}/pgdata


# Database Init Scripts
# The (*.sql, *.sql.gz, or *.sh) init scripts
# Executed
#  * in sorted name order as defined by the current locale (default to en_US.utf8)
#  * at database initialization only happens on container startup
#  * ie the data directory is empty
# https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-entrypoint.sh#L161
ADD resources/postgres/initdb/* /docker-entrypoint-initdb.d

# Postgres Scripts
# the end / in the target is important to tell that this is a directory
ADD resources/postgres/script/* /script/



####################################
# Third User (ie al 1000:1000)
####################################
# Gives permission to the running user to create its own HOME
# Gives permission to all users to create log
# All users can write in /run because supervisor will write socket/file in it (Error: Cannot open an HTTP server: socket.error reported errno.EACCES)
# Add the user 1000:1000 (al) and give it the postgres group
RUN chmod 0777 /home && \
    chmod -R 0777 /var/log && \
    chmod 0777 /run && \
    echo "Give permission on /var/run/supervisor.sock (to avoid Permission denied: file: /usr/lib/python3/dist-packages/supervisor/xmlrpc.py)" && \
    chmod 0777 /var && \
    chmod 0777 /var/run && \
    echo "Add the group as config writer" && \
    chmod g+w /etc/postgresql && \
    echo "postgres user from 999 to 1000"

RUN deluser postgres
# RUN groupdel postgres
RUN groupadd -r postgres --gid=1000
    # https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
RUN useradd -r -g postgres --uid=1000 --home-dir=/var/lib/postgresql --shell=/bin/bash postgres
    # also create the postgres user's home directory with appropriate permissions
    # see https://github.com/docker-library/postgres/issues/274
RUN mkdir -p /var/lib/postgresql
RUN chown -R postgres:postgres /var/lib/postgresql
RUN chown -R postgres:postgres /run/postgresql


####################################
# Docker
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
ADD --chmod=0775 --chown=root:postgres ../../resources/postgres/postgres-ctl /usr/local/bin/

# We set the full path so that if the script is mounted
# the user can see a permission denied if the script does not have any execution rights
ENTRYPOINT [ "/usr/local/bin/postgres-ctl" ]
