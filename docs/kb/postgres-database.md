# Postgres Database


## About

This article talks about databases in a [postgres cluster](postgres-cluster.md)

!!! Not to be confounded with the [default database named postgres](#postgres) !!!

## Postgres

The `postgres database` in the [cluster](postgres-cluster.md) is a default database meant for use by users, utilities and third party applications.
[Ref](https://www.postgresql.org/docs/14/app-initdb.html)

## Create

When you later create a database, everything in the template1 database is copied. 
(Therefore, anything installed in template1 is automatically copied into each database created later)


Every instance of a running PostgreSQL server manages one or more databases.
via:
* https://www.postgresql.org/docs/15/sql-createdatabase.html
* https://www.postgresql.org/docs/15/app-createdb.html



