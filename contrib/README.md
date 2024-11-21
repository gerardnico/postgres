# CONTRIB 



## How to install a dev environment

### Clone the repo

```bash
git clone git@github.com/gerardnico/postgres-x
cd postgres-x
chmod +x bin/*
```

### Install the docker helper command

Install [dockenv](https://github.com/gerardnico/dock-x) to run docker command
```bash
brew install --HEAD gerardnico/tap/dock-x
```

### Install the environment load command
Install [direnv-ext](https://github.com/gerardnico/direnv-x) to
load the env files via [.envrc](../.envrc).
```bash
brew install --HEAD gerardnico/tap/direnv-x
```

## Dev Steps (build, run, update, repeat)

The executables are helper to build docker images
around [dock-x script](https://github.com/gerardnico/dock-x)

### Step 1 - Build

[pbuild](pbuild) will build the image

### Step 2 - Develop

Execute [prun](prun) (a custom `docker run` to mount) to:
* run the build image 
* and mount the scripts to develop

### Step 3 - Clean

* [pclean](pclean) to clean (the mounted postgres data)

## Note: Image

All resources that are copied into the image are located in [the resources directory](../resources)