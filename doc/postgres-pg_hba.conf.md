# pg_hba.conf configuration file

## About

The `pg_hba.conf` [configuration](postgres-conf.md) file controls:

* which hosts are allowed to connect,
* how clients are authenticated,
* which PostgresSQL usernames they can use, which databases they can access.

## Example

Allow the user "foo" from host 192.168.1.100 to connect to the primary

```ini
# as a replication standby if the user's password is correctly supplied.
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    replication     foo             192.168.1.100/32        md5
```

## Docker

You can set the method for all
host [via the POSTGRES_HOST_AUTH_METHOD](https://github.com/docker-library/docs/blob/master/postgres/README.md#postgres_host_auth_method)

```bash
echo "host all all all $POSTGRES_HOST_AUTH_METHOD" >> pg_hba.conf
```

## Format

A default `pg_hba.conf` file is installed when the data directory is initialized
by `initdb`.

Records take one of these forms:

```bash
# Con Type    Database  User  Address  Method  [Options]
local         DATABASE  USER           METHOD  [OPTIONS]
host          DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
hostssl       DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
hostnossl     DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
hostgssenc    DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
hostnogssenc  DATABASE  USER  ADDRESS  METHOD  [OPTIONS]
```

where the uppercase items must be replaced by actual values.

### Connection Type

The first field is the connection type:

- "local" is a Unix-domain socket
- "host" is a TCP/IP socket (encrypted or not)
- "hostssl" is a TCP/IP socket that is SSL-encrypted
- "hostnossl" is a TCP/IP socket that is not SSL-encrypted
- "hostgssenc" is a TCP/IP socket that is GSSAPI-encrypted
- "hostnogssenc" is a TCP/IP socket that is not GSSAPI-encrypted

### DATABASE

DATABASE can be:
* "all" (does not match "replication". Access to replication must be enabled in a separate record)
* "sameuser",
* "samerole",
* "replication",
* a database name,
* a regular expression (if it starts with a slash (/))
* a comma-separated list thereof.
* or a @file to include names from a separate file.

### USER

USER can be:

* "all",
* a username,
* a group name prefixed with "+",
* a regular expression (if it starts with a slash (/))
* a comma-separated list thereof.
* or a @file to include names from a separate file.

### ADDRESS

ADDRESS specifies the set of hosts the record matches. It can be:

* A host name,
* A suffix of the actual host name (ie A host name that starts with a dot (.) matches a suffix of the actual host name.)
* An IP address and a CIDR mask. 
* "samehost" to match any of the server's own IP addresses,
* "samenet" to match any address in any subnet that the server is directly connected to.
* An IP address and netmask in separate columns to specify the set of hosts. 

### METHOD 

METHOD can be:
* [trust" (not recommended since it allows anyone to connect without a password)](https://www.postgresql.org/docs/14/auth-trust.html)
* "reject", 
* "md5", (send encrypted passwords)
* "scram-sha-256", (send encrypted passwords)
* "password" (sends passwords in clear text)
* "gss", 
* "sspi", 
* "ident", 
* "peer", 
* "pam", 
* "ldap", 
* "radius" 
* or "cert".

