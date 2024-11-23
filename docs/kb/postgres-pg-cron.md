# Pg-Cron

## Postgres Conf

```ini
# Add settings for extensions here

# pg_cron
# https://github.com/citusdata/pg_cron?tab=readme-ov-file#setting-up-pg_cron
shared_preload_libraries = 'pg_cron'

#------------------------------------------------------------------------------
# PG CRON
#------------------------------------------------------------------------------
# The database where pg_cron background worker expects its metadata tables to be created
# Changed at runtime via the entrypoint
cron.database_name = 'postgres'
# Timezone created at image buildtime (UTC)
cron.timezone = '${PGTZ}'
```

## Steps

### Create

Every minutes
https://bradymholt.github.io/cron-expression-descriptor/
http://crontab.guru/

```sql
SELECT cron.schedule('test','*/1 * * * *', $$INSERT INTO my_table (column1, column2) VALUES ('value1', 'value2')$$);
```

```
+--------+
|schedule|
+--------+
|1       | <-- the job id (1 if this is the first)
+--------+
```

### Unschedule/stop

```sql
SELECT cron.unschedule('test');
SELECT cron.unschedule(jobName);
SELECT cron.unschedule(jobId);
```

```sql
+----------+
|unschedule|
+----------+
|true      |
+----------+
```

### Update Schedule

```sql
UPDATE cron.job SET schedule = '0 0 * * *' WHERE jobname = 'test';
```

### Select

```sql
SELECT * FROM cron.job;
```

## Monitor

```sql
SELECT j.*,
       jd.*
FROM cron.job j
       LEFT JOIN cron.job_run_details jd
                 ON j.jobid = jd.jobid
ORDER BY jd.start_time DESC;
```

## Maintenance - Cron

-- Vacuum every day at 10:00am (UTC)

```sql
SELECT cron.schedule('nightly-vacuum', '0 10 * * *', 'VACUUM');
```
