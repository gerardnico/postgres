# Psql Client

## Network

See kb at network-port.md

## Connect

```bash
sudo -i -u ${POSTGRES_USER:-postgres}
psql
# or
psql -U postgres
# or
export PGUSER=postgres
psql
# or
# In a bridge network (docker default), see the host ip of postgres with `docker network inspect bridge`

docker run -it --rm postgres psql -h 172.17.0.2 -U postgres
docker container top postgres
# to get the wsl ip from wsl host
ip -br a 
# to get the wsl ip from windows host
ipconfig.exe
```
* then to connect to the postgres database
```bash
\c # check the current database
# output: You are now connected to database "postgres" as user "postgres".
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