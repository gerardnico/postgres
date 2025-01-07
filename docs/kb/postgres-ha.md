# HA

Why HA?
* Your application is outgrowing a single PostgreSQL node

## Tools
### HA Stolon

https://github.com/sorintlab/stolon
https://github.com/sorintlab/stolon/blob/master/doc/simplecluster.md
works with: https://etcd.io/ key store
stolon eliminates the requirement of a shared storage since it uses postgres streaming replication

### HA Fly

fly-prefer-region
For write:
https://fly.io/docs/networking/dynamic-request-routing/#the-fly-prefer-region-request-header

### repmgrd (Replication Manager)

https://www.repmgr.org/ (developed by Edb same as [](#cloudnative))

`repmgrd` monitors the cluster and facilitate automatic failover.
It constantly checks the health of the primary server
and the standby servers to ensure they are up and running.
If the primary server goes down, `repmgrd` will automatically elect a new primary server from the available standby servers.

https://medium.com/@joao_o/postgresql-high-availability-and-automatic-failover-using-repmgr-5f505dc6913a
https://github.com/EnterpriseDB/repmgr/tree/master

### Postgres Kubernetes Operator
See [](postgres-kubernetes.md#operator)


### HA Citus (Distributed ???)
Citus is a `PostgreSQL extension` that transforms Postgres into a distributed database
https://github.com/citusdata/citus


### Replication with PgBackRest

https://pgbackrest.org/user-guide.html#replication