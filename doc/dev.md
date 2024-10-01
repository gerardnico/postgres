# Dev


## How to install a dev environment

### Clone the repo

```bash
git clone git@github.com/gerardnico/postgres
cd postgres
chmod +x bin/*
```

### Install the docker helper command

Install [dockenv](https://github.com/gerardnico/dockenv) to run docker command
```bash
brew install --HEAD gerardnico/tap/dockenv
```

### Install the environment load command
Install [direnv-ext](https://github.com/gerardnico/direnv-ext) to 
load the env files via [.envrc](../.envrc).
```bash
brew install --HEAD gerardnico/tap/direnvext
```



## Note: Image

All resources that copied in the image are located in [the resources directory](../resources)
