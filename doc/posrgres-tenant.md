# Tenant

* If you start with one DB per tenant, it's not difficult to migrate a larger tenant to a different instance in the future.
* Either run:
  * a database per tenant (Might need to increase connection limit as a connection is tied to a database) 
  * a schema per tenant.

For now, `tenant id` solution:
  * Pro: New tenant is cheap in metadata
  * Pro: we may migrate a tenant to a `schema`
  * Pro: Easy backup
  * Cons: Needs to handle the `id` sequence
  * Cons: No tool to migrate the data
