# Postgres Client connection


## About
When a client application connects to the database server,
it specifies which PostgreSQL database username it wants to connect


## User

Within the SQL environment, the active database username determines access privileges to database objects
Therefore, it is essential to restrict which database users can connect.

```bash
sudo -i -u postgres
createuser --interactive --pwprompt
```

## Authentication

Client authentication
is controlled by the configuration file [](postgres-auth-pg_hba.conf.md)


