# Dev


## Install

```bash
git clone git@github.com/gerardnico/postgres
cd postgres
chmod +x bin/*
sudo apt-get install -y direnv
```

## Env

Env files are mounted via [.envrc](../.envrc).

## Development script

When developing, use the `d` (docker) command to:
* [dbuild](../bin/dbuild) to build the image
* [dstart](../bin/dstart) to start a dev image where the resources are mounted
* [dpush](../bin/dpush) to push to the registry
* [dexec](../bin/dexec) to execute a command generally `dexec bash -l`
* [dstop](../bin/dstop) to stop the container

These scripts are mounted via [.envrc](../.envrc) on the PATH.

## Image

All resources that copied in the image are located in [the resources directory](../resources)
