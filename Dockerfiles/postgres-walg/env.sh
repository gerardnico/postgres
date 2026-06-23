# built/run env


# https://github.com/wal-g/wal-g/releases
export WALG_VERSION="v3.0.8"
export WALG_OSNAME="22.04"


export PG_MAJOR_VERSION=18
export PG_VERSION="$PG_MAJOR_VERSION.4"
export PG_DOCKER_TAG="$PG_VERSION-bookworm"

# The current version loaded with direnv
# 16.3-latest
# where 16.3 is the postgres version
# and latest is our release
export DOCK_X_TAG=${PG_VERSION}-latest
# image name
export DOCK_X_NAME=postgres-walg
# image namespace
export DOCK_X_NAMESPACE=gerardnico
# Image registry
export DOCK_X_REGISTRY=ghcr.io
# container name
export DOCK_X_CONTAINER=postgres-walg
# Open Port
export DOCK_X_PORTS=5432:5432
# the user (1000 is the value for a WSL user)
export DOCK_X_USER=1000:1000
# the groups of the user
# DOCK_X_USER_GROUPS=postgres
