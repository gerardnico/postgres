


## WSL ready

Under WSL, the user will be `postgres`

Why? The default image use the [UID 999](https://github.com/docker-library/postgres/blob/cf9b6cdd64f8a81b1abf9e487886f47e4971abe2/11/Dockerfile#L15) but the WSL first user is 1000.
This images rectify this so that the Postgres user has the uid `1000`

Set the user to be `1000` and you will own the files in your local mount
```bash
# dock-x
DOCK_X_USER=1000:1000
# docker
docker --user 1000:1000
```
By default, the image starts as `root`


For another uid, see the [official doc](https://github.com/docker-library/docs/tree/master/postgres#arbitrary---user-notes)