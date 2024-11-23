# Postgres Memory


## Internal
[Memory Parameters documentation](https://www.postgresql.org/docs/current/runtime-config-resource.html#RUNTIME-CONFIG-RESOURCE-MEMORY)

See parameters in [postgres.conf](../ansible-role/templates/postgresql.conf.ini)

```bash
ActualMaxRAM = shared_buffers + (temp_buffers + work_mem) * max_connections
# default
ActualMaxRAM = 128Mb + (8MB + 4Mb) * 100 = 1326Mb
# actual
ActualMaxRAM = 128Mb + (1MB + 5Mb) * 50 = 378Mb
```

* shared_buffers: 40% of the memory
* max_connections: maximum number of parallel connections
* temp_buffers (used for temporary tables (dropped at the end of a session), setting temp_buffers to pretty low (default is 8 MB) will allow setting work_mem a bit higher.)
* work_mem: working memory


https://stackoverflow.com/questions/28844170/how-to-limit-the-memory-that-is-available-for-postgresql-server


## OS resources

https://www.postgresql.org/docs/15/kernel-resources.html#SYSVIPC

## process

The process that are running in the container and their owner.

```bash
UID        PID  PPID  C STIME TTY          TIME CMD
root        25    21  0 14:14 pts/0    00:00:00 /bin/bash /usr/local/bin/postgres-entrypoint.sh postgres -c config_file=/etc/postgresql/postgresql.conf
root        27    23  0 14:14 pts/1    00:00:00 postgres_exporter --log.level=warn
postgres    48    25  0 14:14 pts/0    00:00:00 postgres -c config_file=/etc/postgresql/postgresql.conf
postgres    69    48  0 14:14 ?        00:00:00 postgres: logger
postgres    70    48  0 14:14 ?        00:00:00 postgres: checkpointer
postgres    71    48  0 14:14 ?        00:00:00 postgres: background writer
postgres    73    48  0 14:14 ?        00:00:00 postgres: walwriter
postgres    74    48  0 14:14 ?        00:00:00 postgres: autovacuum launcher
postgres    75    48  0 14:14 ?        00:00:00 postgres: archiver
postgres    76    48  0 14:14 ?        00:00:00 postgres: pg_cron launcher
postgres    77    48  0 14:14 ?        00:00:00 postgres: logical replication launcher
postgres    78    48  0 14:14 ?        00:00:00 postgres: eraldy eraldy 172.17.0.1(47582) idle
root        95     0  0 14:16 pts/2    00:00:00 bash
root       323    95  0 14:20 pts/2    00:00:00 ps -ef
```


## Memory
```bash
8.72656 MB postgres: background writer
8.58203 MB postgres: autovacuum launcher
8.41406 MB postgres: logical replication launcher
8.05469 MB postgres: archiver failed on
6.19141 MB postgres: logger
39.082 MB postgres -c config_file=/etc/postgresql/postgresql.conf -c
3.57812 MB /bin/bash /usr/local/bin/postgres-ctl postgres -c
31.3359 MB /usr/bin/python3 /usr/bin/supervisord -c /supervisord.conf
18.8984 MB postgres: checkpointer
14.5 MB postgres: walwriter
14.4492 MB postgres: pg_cron launcher
0.921875 MB /bin/sh
0.882812 MB /usr/bin/tail -f /var/log/postgres/postgres.log
Total: 101.2MiB
```
