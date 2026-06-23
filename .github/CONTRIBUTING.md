# Contributing Guideline

We follow this [GitHub contributing guideline](https://docs.github.com/en/contributing)

## How to install a dev environment

### Clone the repo

```bash
git clone git@github.com/gerardnico/postgres
```

### Install the docker helper command

Install [dockenv](https://github.com/gerardnico/dock-x) to run docker command

```bash
brew install --HEAD gerardnico/tap/dock-x
```

## Dev Steps (build, run, update, repeat)

The executables are helper to build docker images
around [dock-x script](https://github.com/gerardnico/dock-x)

### Step 0 - Go to the project

```bash
cd Dockerfiles/postgres-walg
# or
cd Dockerfiles/postgres-restic
```

### Step 1 - Build

build the image

```bash
./build
```

### Step 2 - Develop

Execute `run` to:

* set the restic or walg env (and aws env)
* run the build image with the scripts mounted locally to develop

```bash
./run
```

### Step 3 - Clean

[pclean](../contrib/scripts/pclean) to clean (the mounted postgres data)
and simulate a lost of data.

### Deploy

[pclean](../contrib/scripts/pclean) to clean (the mounted postgres data)
and simulate a lost of data.

## Note: common resources

All resources that are copied into the image are located in [the resources directory](../resources)
