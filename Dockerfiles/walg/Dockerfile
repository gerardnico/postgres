###########################################
# Archive of Wal-g building
# https://github.com/wal-g/wal-g?tab=readme-ov-file#installing
# We download the file now as the build breaks without reason
# Ubuntu platform works on debian
FROM postgres:${PG_DOCKER_TAG}  AS wal-g

# Set environment variables
ARG WALG_VERSION


# Install dependencies
RUN apt-get update && apt-get install -y \
    golang-go \
    libbrotli-dev \
    liblzo2-dev \
    libsodium-dev \
    && apt-get clean

# Set Go environment variables
ENV GOPATH=/go
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

# Clone the WAL-G repository and checkout the specified version
RUN mkdir -p /go/src/github.com/wal-g/wal-g &&\
    git clone --branch v${WALG_VERSION} --single-branch https://github.com/wal-g/wal-g /go/src/github.com/wal-g/wal-g && \
    cd /go/src/github.com/wal-g/wal-g && \
    export USE_BROTLI=1 && \
    export USE_LIBSODIUM=1 && \
    export USE_LZO=1 && \
    make deps && \
    make pg_build && \
    cp main/pg/wal-g /usr/local/bin/wal-g && \
    chmod +x /usr/local/bin/wal-g

ENTRYPOINT ["wal-g"]