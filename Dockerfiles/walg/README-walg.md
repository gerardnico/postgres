# Wal-g


## Installation

### wal-g from Release

```Dockerfile
# Os name is mandatory and may change, it's not a stand linux
# Ubuntu works on debian
ARG WALG_INCLUDED="false"
ARG WALG_VERSION="v3.0.3"
ARG WALG_OSNAME=ubuntu-20.04

ADD https://github.com/wal-g/wal-g/releases/download/$WALG_VERSION/wal-g-pg-${WALG_OSNAME}-amd64.tar.gz \
    wal-g-pg-${WALG_OSNAME}-amd64.tar.gz
RUN tar -zxvf wal-g-pg-${WALG_OSNAME}-amd64.tar.gz && \
    rm wal-g-pg-${WALG_OSNAME}-amd64.tar.gz && \
    mv wal-g-pg-${WALG_OSNAME}-amd64 /usr/local/bin/wal-g && \
    chmod +x /usr/local/bin/wal-g
```


### wal-g from source (DockerFile)
The [Dockerfile](Dockerfile) is an archive of [Wal-g building](https://github.com/wal-g/wal-g?tab=readme-ov-file#installing)
We download the file now as the build breaks without reason
(Ubuntu platform works on debian)
