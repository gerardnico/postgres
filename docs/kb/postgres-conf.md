# Postgres Conf

* postgresql.conf
* pg_hba.conf
* and pg_ident.conf

## reload

If you edit a conf file on a running system, you have to

* `SIGHUP` the server for the changes to take effect,
* run `pg_ctl reload`
* or execute `SELECT pg_reload_conf()`

## Client authentication file (pg_hba.conf)

[](postgres-pg_hba.conf.md)