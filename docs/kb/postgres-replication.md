# Postgres Replication



Logical replication uses [WAL entry](postgres-wal.md)

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

## logical

Sequin efficiently captures changes using logical replication. Except at very extreme scale, logical replication adds little overhead to the performance of your database. 
https://github.com/sequinstream/sequin