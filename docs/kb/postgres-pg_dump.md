# Postgres Dump

## About

`pg_dump`:
* is just a pg client (such as `psql`)
* internally executes SELECT statements.
* use any default connection settings and [environment variables used by the `libpq` library](https://www.postgresql.org/docs/current/libpq-envars.html).


pg_dump utility relies on logical backups instead of physical ones.

## vs pg_dumpall

pg_dumpall  dumps global objects that are common to all databases, namely database roles, tablespaces, and privilege grants for configuration parameters. (pg_dump does not save these objects.)

## password

If you use password authentication it will ask for a password each time. It is convenient to have a ~/.pgpass file in such cases. See Section 32.16 for more information.
https://www.postgresql.org/docs/current/libpq-pgpass.html

## kubernetes

See backup 


## Dump Format

* dir: 
* sql: a sql file
* archive: one custom archive format
* 
* custom, 
* directory: one data file by tables. It will upload only the table changed 
* tar,
* plain text (default) - a sql file

### Plain Text ie SQL (Default)

On an empty database
```bash
pg_dump postgres
pg_dump --format=p postgres
```
```
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--
```

### Custom Format

On an empty database
```bash
pg_dump --format=c postgres
```
```
0ENCODINENCODINGSET client_encoding = 'UTF8';)16.4 (Debian 16.4-1.pgdg120+2)
00lse
STDSTRINGS
STDSTRINGS(SET standard_conforming_strings = 'on';
00lse
SEARCHPATH
SEARCHPATH8SELECT pg_catalog.set_config('search_path', '', false);
12622463postgreDATABASEpCREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
DROP DATABASE postgres;
```

### Tar Format

On an empty database
```bash
pg_dump --format=t postgres
```
```
toc.dat0000600 0004000 0002000 00000001524 14701242431 0014437 0ustar00postgrespostgres0000000 0000000 PGDM%+   postgres16.4 (Debian 16.4-1.pgdg1200ENCODINENCODINGSET client_encoding = 'UTF8';
00lse
STDSTRINGS
STDSTRINGS(SET standard_conforming_strings = 'on';
00lse
SEARCHPATH
SEARCHPATH8SELECT pg_catalog.set_config('search_path', '', false);
12622463postgreDATABASEpCREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
DROP DATABASE postgres;
postgresfalserestore.sql0000600 0004000 0002000 00000002435 14701242431 0015366 0ustar00postgrespostgres0000000 0000000 --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg120+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--
```


### Dir

Example: data for data file and toc for code.

```bash
/data/pgdump/dumpfile-db-postgres/3229.dat.gz
/data/pgdump/dumpfile-db-postgres/3231.dat.gz
/data/pgdump/dumpfile-db-postgres/3389.dat.gz
/data/pgdump/dumpfile-db-postgres/3390.dat.gz
/data/pgdump/dumpfile-db-postgres/toc.dat
```

* No data change

```bash
repository 337fcbe2 opened (version 2, compression level auto)
comparing snapshot 5aecd0a8 to 8098a02a:

[0:00] 100.00%  13 / 13 index files loaded
M    /data/pgdump/dumpfile-db-postgres/toc.dat

Files:           0 new,     0 removed,     1 changed
Dirs:            0 new,     0 removed
Others:          0 new,     0 removed
Data Blobs:      1 new,     1 removed
Tree Blobs:      4 new,     4 removed
  Added:   7.653 KiB
  Removed: 7.656 KiB
```

* Added a table

```bash
repository 337fcbe2 opened (version 2, compression level auto)
comparing snapshot 8098a02a to 2d62b66e:

[0:00] 100.00%  14 / 14 index files loaded
-    /data/pgdump/dumpfile-db-postgres/3225.dat.gz
-    /data/pgdump/dumpfile-db-postgres/3227.dat.gz
+    /data/pgdump/dumpfile-db-postgres/3229.dat.gz
+    /data/pgdump/dumpfile-db-postgres/3231.dat.gz
-    /data/pgdump/dumpfile-db-postgres/3385.dat.gz
+    /data/pgdump/dumpfile-db-postgres/3389.dat.gz
+    /data/pgdump/dumpfile-db-postgres/3390.dat.gz
     M    /data/pgdump/dumpfile-db-postgres/toc.dat
-    /data/pgdump/dumpfile-sc-test.sql/

Files:           4 new,     3 removed,     1 changed
Dirs:            0 new,     1 removed
Others:          0 new,     0 removed
Data Blobs:      1 new,     1 removed
Tree Blobs:      4 new,     5 removed
Added:   7.992 KiB
Removed: 7.666 KiB
```

* Added data (a row)

```bash
repository 337fcbe2 opened (version 2, compression level auto)
comparing snapshot 2d62b66e to bcbdf9df:

[0:00] 100.00%  15 / 15 index files loaded
M    /data/pgdump/dumpfile-db-postgres/3390.dat.gz
M    /data/pgdump/dumpfile-db-postgres/toc.dat

Files:           0 new,     0 removed,     2 changed
Dirs:            0 new,     0 removed
Others:          0 new,     0 removed
Data Blobs:      2 new,     1 removed
Tree Blobs:      4 new,     4 removed
Added:   8.031 KiB
Removed: 7.992 KiB
```

## other note on other file

# Postgres PgDump/PgRestore

## About

https://www.postgresql.org/docs/15/backup.html

## Type
### Plain (in PSQL format)

The whole database in a PSQL file.

Example:

* Backup

```bash
pg_dump dbname | gzip  > $PGDATA/dump/dumpfile.sql.gz
```

* Restore

```bash
dropdb dbname
createdb dbname
gunzip < $PGDATA/dump/dumpfile.sql.gz | psql --set ON_ERROR_STOP=on --single-transaction dbname
# run analyze (to update the stats)
```

where:

* `ON_ERROR_STOP` - stop on error
* `single-transaction` will commit only at the end (to avoid a partially restored dump)

You can also [split](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP-LARGE)

### Custom

Same as gzip with the advantage that tables can be restored selectively `pg_dump` and `pg_restore`

[example](https://www.postgresql.org/docs/15/app-pgrestore.html#APP-PGRESTORE-EXAMPLES)
[ref](https://www.postgresql.org/docs/current/backup-dump.html#BACKUP-DUMP-LARGE)

Example:
* Dump

```bash
# in -Fc, F means format, c means custom
pg_dump -Fc dbname > filename.dump
```

* Restore in the same database

```bash
# dropdb dbname
pg_restore -d dbname filename.dump
```

* Restore in another database

```bash
# the database is created from template0 not template1, to ensure it is initially empty.
createdb -T template0 newdb
# -C is not used to connect directly to the database to be restored into.
pg_restore -d newdb db.dump
```

## Custom Format to PLSql

The custom binary postgres export data. It can be converted to plain text using pg_restore as follows
```bash
pg_restore data.dump -f plain.sql
```


## In parallel (big database)

```bash
pg_dump -j parralelNum -F d -f out.dir dbname
```

```bash
pg_restore -j
```


## Pgdump and Restic Stdin

https://www.postgresql.org/docs/current/app-pgdump.html
```bash
tar -c whatever/ | gzip --rsyncable > file.tar.gz
```

```bash
bash -c 'pg_dumpall --clean -U$POSTGRES_USER' \
    | gzip --rsyncable \
    | restic backup \
    --host "myapp-prod-db" \
    --stdin --stdin-filename \
    postgres.sql.gz
```

As client with pg_dump
https://github.com/ixc/restic-pg-dump-docker/blob/master/Dockerfile

