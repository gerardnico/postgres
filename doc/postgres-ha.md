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

### HA repmgrd

`repmgrd` monitors the cluster and facilitate automatic failover.
It constantly checks the health of the primary server
and the standby servers to ensure they are up and running.
If the primary server goes down, `repmgrd` will automatically elect a new primary server from the available standby servers.

https://medium.com/@joao_o/postgresql-high-availability-and-automatic-failover-using-repmgr-5f505dc6913a

### Postgres Operator (Crunchy Data, Go)

https://github.com/CrunchyData/postgres-operator

### HA Postgres Operator Zalando (Patroni, Spilo)

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