Barman get the data via ssh

One Barman, many Postgres servers

Barman is able to take backups using either:
* Rsync, which uses SSH as a transport mechanism, 
* or pg_basebackup, which uses Postgres streaming replication protocol (recommended)

Used by cncf kubernetes


relies on Rsync and SSH connections for transferring backup and WAL files to your Barman server.
https://docs.pgbarman.org/release/3.12.0/user_guide/pre_requisites.html#pre-requisites-ssh-connections

https://docs.pgbarman.org/release/3.12.0/user_guide/quickstart.html

## cloud snapshot backup (disk)

The cloud provider API is used to create a snapshot for each specified disk.

https://docs.pgbarman.org/release/3.12.0/user_guide/backup.html#backup-cloud-snapshot-backups
