# Postgres User (Role)




```bash
createuser <username>
```

```sql
create user myuser with encrypted password 'mypass';
grant all privileges on database mydb to myuser;
```

### Create Role

```bash
CREATE ROLE combo;
```

### Change/Set Password

```sql
alter user <username> with encrypted password '<password>';
```

### Change Privileges

```sql
grant all privileges on database <dbname> to <username>;
```
