# Psql Client



```bash
sudo -i -u postgres
# then
psql
# then to connect to the postgres database
\c postgres
\c combo # combo for the api app
# then to see the schema
\dn
```


More
```bash
# then to get a list of command
\?
```

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

```sql
SET search_path TO cs_realms,cs_ip;
\dt
```