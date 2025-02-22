# Postgres Database


## About

This article talks about databases in a [postgres cluster](postgres-cluster.md)

!!! Not to be confounded with the [default database named postgres](#postgres) !!!

## How many databases should be hosted in a single PostgreSQL instance?

Our recommendation is to dedicate a single PostgreSQL cluster (intended as primary and multiple standby servers) to a single database, entirely managed by a single microservice application. 

The reason for this recommendation lies in the Cloud Native concept, based on microservices. In a pure microservice architecture, the microservice itself should own the data it manages exclusively. These could be flat files, queues, key-value stores, or, in our case, a PostgreSQL relational database containing both structured and unstructured data. The general idea is that only the microservice can access the database, including schema management and migrations.

https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/faq.md


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



