

$PGDATA/log



## Step by Step

### Enable log collector

```bash
psql -U postgres
```
```sql
SHOW logging_collector;
-- may be off 
select name,setting,unit,source,context from pg_settings where name = 'logging_collector';
```

postgres.conf
```
logging_collector = on
```
Enable:
```bash
echo "logging_collector = on" >> $PGDATA/postgresql.conf
```
Restart:
```bash
# select pg_reload_conf(); -- does not work, restart works only
docker stop postgres
docker start postgres
```

### Get log file

```sql
SELECT  pg_current_logfile();
```
```sql
SHOW log_directory;
```
tail it
```bash
tail --follow $PGDATA/log/postgresql-2025-05-09_142252.log
```