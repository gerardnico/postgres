


"docker-ensure-initdb.sh" as a Kubernetes "init container"
to ensure the provided database directory is initialized; see also "startup probes" for an alternative solution
(no-op if database is already initialized)
[Ref](https://github.com/docker-library/postgres/blob/d08757ccb56ee047efd76c41dbc148e2e2c4f68f/16/bookworm/docker-ensure-initdb.sh)

## kube

* 1. Databases love high IOPS low latency storage. So try to use local, non-clustered storage for the Postgres nodes. Skip using longhorn and use local disks and use database replicas for hot data durability. 
* 2. Don't use volume backup for database disaster recovery. You get crash consistent recovery at best. 

If you use Longhorn you will also get higher latency and your DB performance will suffer. 

Use the CNPG provided:
* Backup - https://cloudnative-pg.io/documentation/1.24/backup/
* and Recovery procedures. https://cloudnative-pg.io/documentation/1.24/recovery/

They also use S3/Object Storage and do not require you to have a storage cluster, like Longhorn. 

You also get freebies, like:
* Point In Time recovery 
* and Replica Clusters. https://cloudnative-pg.io/documentation/1.24/replica_cluster/

Remember you are dealing with databases here. If you DIY features like backups you most likely will do it wrong. 

I recommend you to stay with the proven solutions, like CNPGs backup implementation using Barman Object Store.

on CloudNativePG docs:

“Block storage considerations (Ceph/Longhorn)

Most block storage solutions in Kubernetes, such as Longhorn and Ceph, recommend having multiple replicas of a volume to enhance resiliency. This approach works well for workloads that lack built-in resiliency.

However, CloudNativePG integrates this resiliency directly into the Postgres Cluster through the number of instances and the persistent volumes attached to them, as explained in “Synchronizing the state”.

As a result, defining additional replicas at the storage level can lead to write amplification, unnecessarily increasing disk I/O and space usage.

longhorn has a data locality mode (strict-local) which forces a volume to be local to the host with only 1 replica. This is beneficial when data replication is on the application level.

https://www.reddit.com/r/kubernetes/s/EwtFl4Z3Lk


## Type installation

### (non-operator) Single-instance 

/ Static installation — designed to run only the primary, very limited cluster support included out-of-the-box

They don’t provide additional management value as operators, but they are simple and production-ready. If you don’t require DB Cluster for small applications without H-A requirements — you can use them.

https://github.com/bitnami/charts/tree/main/bitnami/postgresql

https://medium.com/@davidpech_39825/dbaas-in-2024-which-postgresql-operator-for-kubernetes-to-select-for-your-platform-4d17352b35a1


### StatefulSet — first generation

depending on the Kubernetes primitive without Patroni

### Patroni — second generation 

utilizing proven H-A solution outside of Kubernetes

### “CloudNative” operator — third generation 

where the H-A logic is integrated inside the operator itself

StatefulSet was originally designed to handle stateful workloads with some identity around PersistentVolume, BUT the way it scales (+1) is very limiting for many use cases. Simple example — you have pg-0 primary Pod, pg-1 corrupted replica, pg-2 healthy replica. What to do not? If you lower StatefulSet size, you kill the healthy replica instead of the corrupted one. So the new marketing term “CloudNative” operator was born promising that it includes the logic inside.



## Operator


non exhaustive list, in chronological order from their publication on GitHub:

Crunchy Data Postgres Operator (2017)
Zalando Postgres Operator (2017)
Stackgres (2020)
Percona Operator for PostgreSQL (2021)
Kubegres (2021)
Ref: https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/faq.md


### failover management 

most of these operators use an external failover management tool ( like Patroni, repmgr, or Stolon) and rely on StatefulSets.

Why isn't CloudNativePG using StatefulSets?

CloudNativePG does not rely on StatefulSet resources, and instead manages the underlying PVCs directly by leveraging the selected storage class for dynamic provisioning.
refer to the "Custom Pod Controller" section for details and reasons behind this decision.
https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/controller.md
They use a  instance manager, which runs inside each PostgreSQL pod that makes sure that the database server is up, including accessory services like logging, export of metrics, continuous archiving of WAL files, etc.
https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/instance_manager.md

### outage

an outage of the operator does not necessarily imply a PostgreSQL database outage; it's like running a database without a DBA or system administrator.


### CloudNative (CNPG)

https://github.com/cloudnative-pg/cloudnative-pg?tab=readme-ov-file

It defines a Cluster resource representing a PostgreSQL cluster, including a primary instance and optional replicas for high availability and read query offloading within a Kubernetes namespace. Applications within the same Kubernetes cluster connect seamlessly to the PostgreSQL database through a service managed by the operator. External applications can access PostgreSQL using a LoadBalancer service, which can be exposed via TCP with the service template capability.

How to blog:
https://glasskube.dev/guides/deploy-Postgres-kubernetes/

Make sure to always specific a separate volume for the write-ahead-log for PostgreSQL, as we don't want to fill up all of our disk space with logs.
```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
name: pg-glasskube-cluster
spec:
  instances: 3
  storage:
    size: 1Gi
  walStorage:
    size: 1Gi
```

https://cloudnative-pg.io/
https://cloudnative-pg.io/documentation
https://github.com/cloudnative-pg/cloudnative-pg/blob/main/docs/src/quickstart.md

It defines a new Kubernetes resource called Cluster representing
a PostgreSQL cluster made up of a single primary
and an optional number of replicas that co-exist
in a chosen Kubernetes namespace for High Availability and offloading of read-only queries.

### Crunchy Data




https://github.com/CrunchyData/postgres-operator



### Zalando (Patroni, Spilo)

patroni is a supervisor daemon running all the time capable of handling restarts

https://github.com/zalando/postgres-operator/
It makes easy and convenient to run Patroni based clusters on K8s.

i chose zalando postgres operator, because of the operator gui, makes it super easy to deploy clusters


```bash
kubectl create namespace test
kubectl config set-context $(kubectl config current-context) --namespace=test
```

Based on:
* [Patroni](https://github.com/patroni/patroni) - HA Postgres deployment template
* [Spilo](https://github.com/zalando/spilo) - Image of PostgreSQL and Patroni

### Kubegres

https://github.com/reactive-tech/kubegres

Backup runs: 
```bash
pg_dumpall -h mypostgres-replica -U postgres -c | gzip > /var/lib/backup/mypostgres-backup-05_10_2021_10_36_00.gz
```
https://www.kubegres.io/doc/enable-backup.html

## Management Operator

### EasyMile postgresql-operator to create database and user

Postgres credentials manager.

Connect to an instance via the top level user and create databases with users and passwords via a referenced secret or something.

They make dishing out Postgres multi tenancy setups to teams easier.

PostgreSQL Operator to create Databases and Users across multiple engines

https://easymile.github.io/postgresql-operator/
https://github.com/EasyMile/postgresql-operator

https://www.reddit.com/r/kubernetes/s/EwtFl4Z3Lk


## doc

### how to choose an operator 

Post: https://medium.com/@davidpech_39825/dbaas-in-2024-which-postgresql-operator-for-kubernetes-to-select-for-your-platform-51cf4d5dec4a
Podcast: https://kube.fm/which-postgresql-operator-david

### Recommended architectures for PostgreSQL in Kubernetes

Posted on September 29, 2023 by Gabriele Bartolini

https://www.cncf.io/blog/2023/09/29/recommended-architectures-for-postgresql-in-kubernetes/