## How to define the snapshot policy and check integrity


### Subset Data Check

With [rolling data check](https://restic.readthedocs.io/en/v0.13.1/045_working_with_repos.html#checking-integrity-and-consistency).

You can set the t value in `--read-data-subset=n/t` with the `DBCTL_CHECK_SUBSET` env

```env
PG_X_CHECK_SUBSET=5
```

#### Forget Policy

[Forget Policy](https://restic.readthedocs.io/en/v0.13.1/060_forget.html?highlight=forget#removing-snapshots-according-to-a-policy)

```
PG_X_FORGET_POLICY=--keep-hourly 5 --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 3
```