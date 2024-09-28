
```
netstat -lp --protocol=unix | grep postgres
```

The interfaces on which the PostgreSQL server listens to are configured 

* in postgresql.conf.
```conf
listen_addresses = '*'
```
* in [pg_hba.conf](postgres-pg_hba.conf.md) for authorization and method