
```
netstat -lp --protocol=unix | grep postgres
```

The interfaces on which the PostgreSQL server listens to are configured 

* in [postgresql.conf](postgres-conf.md).
```conf
listen_addresses = '*'
```
* in [pg_hba.conf](postgres-auth-pg_hba.conf) for authorization and method