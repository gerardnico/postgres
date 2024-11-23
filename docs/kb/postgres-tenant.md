# Tenant

* If you start with one DB per tenant, it's not difficult to migrate a larger tenant to a different instance in the future.
* Either run:
  * a database per tenant (Might need to increase connection limit as a connection is tied to a database) 
  * a schema per tenant.

## actual solution 

For now, `tenant id` solution:
  * Pro: New tenant is cheap in metadata
  * Pro: we may migrate a tenant to a `schema`
  * Pro: Easy backup
  * Cons: Needs to handle the `id` sequence
  * Cons: No tool to migrate the data

## solution

### database/schema per tenant 

provides isolation and flexibility but requires more resources and effort to operate. 

### all tenant in one schema/database

all tenants in the same shared schema and add a tenant identifier to every table

This approach is simple and cost-effective, which is why most new applications start here. 

## blog post pg_karnak

pg_karnak is a distributed ddl layer that operates across tenants and postgres instances - soon to be open sourced. It includes an extension that intercepts ddls, a transaction coordinator to apply schemas to every tenant during DDL execution and a central metadata store. 

Rules: primary keys must include the tenant_id column

https://www.thenile.dev/blog/distributed-ddl

