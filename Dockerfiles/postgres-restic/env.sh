export PG_MAJOR_VERSION=18
export PG_VERSION=18.4
export PG_DOCKER_TAG=18.4-bookworm


export DOCK_X_TAG=${PG_VERSION}-restic-latest
# image name (should be the same as the github repo)
export DOCK_X_NAME=postgres
# image namespace
export DOCK_X_NAMESPACE=gerardnico
# Image registry
export DOCK_X_REGISTRY=ghcr.io
# container name
export DOCK_X_CONTAINER=postgres-restic
# Open Port
export DOCK_X_PORTS=5432:5432
# the user (1000 is the value for a WSL user)
export DOCK_X_USER=1000:1000
# the groups of the user
# DOCK_X_USER_GROUPS=postgres
