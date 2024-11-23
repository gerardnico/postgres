# Init: Run the container for the first time





Note: the [POSTGRES_HOST_AUTH_METHOD](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_host_auth_method)
should not be set to `trust` so that remote clients needs to give a password.


## POSTGRES_USER AND POSTGRES_DB

They are used to init the database and should not be changed.
Why?
* `postgres` as user is hardcoded in the [imaqe](https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15)
* `postgres` as a default database may hardcoded in extensions

If you change the user, you will get:
```
chmod: changing permissions of '/var/run/postgresql': Operation not permitted
The files belonging to this database system will be owned by user "al".
This user must also own the server process.
```
