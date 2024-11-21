# Psql Client


## Connect

```bash
sudo -i -u ${POSTGRES_USER:-postgres}
# then
psql
```
* then to connect to the postgres database
```bash
\c # check the current database
\c anotherdb # connect to another database
```

## Command

### See the schemas
```
\dn
```


### get help / list of command

```bash
\?
```

### List

```bash
\q            : exit
\list or \l   : list all databases
\c <db name>  : connect to a certain database
\dn           : list the schemas
\dt           : list all tables in the current database using your search_path
\dt *         : list all tables in the current database regardless your search_path
\du           : user account
\d object     : describe object (table, index, ...)
```

### Set the search path

```sql
SET search_path TO cs_realms,cs_ip;
\dt
```