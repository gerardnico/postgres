# Postgres Replication



Logical replication uses [WAL entry](postgres-wal)

Since version 10, logical replication matches a normal entry with a database name 
or keywords such as all.

pg_hba.conf
```conf
local    mydatabase      myuser                     trust
```
postgresql.conf
```conf
max_wal_senders = 1
```
