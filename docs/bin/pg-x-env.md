% pg-x-env(1) Version Latest | Postgres with eXtra command line Environment
# NAME

The environment of `pg-x`

# LIST

* `PG_X_DUMP_DIR`: The base directory for pg dump backup (Default to: `/tmp/pg-x/dump`) 
* `PG_X_DUMP_SNAPSHOT_DIR`: The dump snapshot directory (Default to: `PG_X_DUMP_DIR/snapshot`)
  * The default destination directory for the creation of every dump 
  * Restic snapshots this directory for Point In Time restoration
  * Before every dump creation/restoration, the directory is cleaned up to have only one dump at a time