

################################
# Walg with AWS configuration
# You can put any environment to configure wal-g
# Walg also allows to mount a conf file for configuration
################################
# https://wal-g.readthedocs.io/STORAGES/#examples
# s3://bucket/path/to/folder
export WALG_S3_PREFIX=s3://postgres-dev/walg
# Compression: https://github.com/wal-g/wal-g?tab=readme-ov-file#compression
export WALG_COMPRESSION_METHOD=brotli
# Encryption: https://wal-g.readthedocs.io/#encryption
# Generated with: openssl rand -base64 32
export WALG_LIBSODIUM_KEY
WALG_LIBSODIUM_KEY=$(pass postgres/dev-walg/walg-libsodium-base64-key)
export WALG_LIBSODIUM_KEY_TRANSFORM=base64

# Aws bucket
export AWS_ACCESS_KEY_ID
AWS_ACCESS_KEY_ID=$(pass postgres/dev-walg/aws-access-key-id)
export AWS_SECRET_ACCESS_KEY
AWS_SECRET_ACCESS_KEY=$(pass postgres/dev-walg/aws-secret-access-key)
export AWS_ENDPOINT
AWS_ENDPOINT=$(pass postgres/dev-walg/aws-endpoint)
export AWS_S3_FORCE_PATH_STYLE=true


# export
export USER_ID=${UID}
export GROUP_ID=${UID}
