#!/bin/bash

CONTAINER_NAME=$1
PREFIX=${2:-test}
TOTAL=${3:-16}

n=0
while [ $n -lt ${TOTAL} ] ; do
    alias=$(printf "%s-%03d" ${PREFIX} $n)

    docker exec --workdir /data ${CONTAINER_NAME} \
        bash -c "openssl ecparam -genkey -name secp256k1 | openssl ec -out ${alias}.pem" > /dev/null
    docker exec --workdir /data ${CONTAINER_NAME} \
        seth account import ${alias}.pem ${alias} > /dev/null
    docker exec --workdir /data ${CONTAINER_NAME} \
        seth account create --nonce=1 --wait ${alias}

    n=$((n + 1))
done
