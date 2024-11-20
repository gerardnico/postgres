# CONTRIB 



## Dev Steps

The executables are helper to build docker images
around [dockenv script](https://github.com/gerardnico/dockenv)

### Step 1 - Build

[pbuild](pbuild) will build the image

### Step 2 - Develop

Execute [prun](prun) (a custom `docker run` to mount) to:
* run the build image 
* and mount the scripts to develop

### Step 3 - Clean

* [pclean](pclean) to clean (the mounted postgres data)

