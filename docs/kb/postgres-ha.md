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
#### CloudNative

https://cloudnative-pg.io/
https://cloudnative-pg.io/documentation
https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/quickstart.md

It defines a new Kubernetes resource called Cluster representing
a PostgreSQL cluster made up of a single primary
and an optional number of replicas that co-exist
in a chosen Kubernetes namespace for High Availability and offloading of read-only queries.

#### Crunchy Data

https://github.com/CrunchyData/postgres-operator


#### Zalando (Patroni, Spilo)

https://github.com/zalando/postgres-operator/
It makes easy and convenient to run Patroni based clusters on K8s.

```bash
kubectl create namespace test
kubectl config set-context $(kubectl config current-context) --namespace=test
```

Based on:
* [Patroni](https://github.com/patroni/patroni) - HA Postgres deployment template
* [Spilo](https://github.com/zalando/spilo) - Image of PostgreSQL and Patroni


### HA Citus (Distributed ???)
Citus is a `PostgreSQL extension` that transforms Postgres into a distributed database
https://github.com/citusdata/citus


### Replication with PgBackRest

https://pgbackrest.org/user-guide.html#replication