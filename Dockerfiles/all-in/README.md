# Postgres and Collectors with Supervisor 


## Example of Run

```bash
dock-x run \
  --mount type=bind,source="${DBCTL_PATH}",target=/usr/local/bin/dbctl \
  -v "${MOUNT_POINT}":/data \
  -v "${PROFILE_D}":/etc/profile.d \
  -v "${BASHLIB_PATH}":/usr/local/lib/bash-lib \
  supervisor-ctl \
  -c shared_buffers=256MB \
  -c max_connections=200
```