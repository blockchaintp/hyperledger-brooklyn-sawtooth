#!/bin/bash
set -x

VERSION=${1:-1.0.3}
REPO=${2:-blockchaintp}
FILTER=${3}

( grep -v "^#" <<IMG
sawtooth-build-debs
#
sawtooth-validator
sawtooth-xo-tp-python
sawtooth-poet-validator-registry-tp
sawtooth-intkey-tp-python
sawtooth-identity-tp
sawtooth-block-info-tp
sawtooth-settings-tp
sawtooth-rest-api
sawtooth-smallbank-tp-go
sawtooth-xo-tp-go
sawtooth-intkey-tp-go
sawtooth-dev-rust
sawtooth-battleship-tp
sawtooth-dev-python
sawtooth-dev-poet-sgx
sawtooth-dev-javascript
sawtooth-intkey-tp-javascript
sawtooth-xo-tp-javascript
sawtooth-dev-java
sawtooth-intkey-tp-java
sawtooth-xo-tp-java
sawtooth-dev-go
sawtooth-dev-cxx
#
sawtooth-stats-influxdb
sawtooth-stats-grafana
apache-basic_auth_proxy
#
sawtooth-seth-tp
sawtooth-seth-rpc
sawtooth-seth-cli
#
rbac-server-production
rbac-ledger-sync-production
rbac-tp-production
rbac-ui-production
#
sawtooth-explorer
IMG
) | grep "${FILTER}" |
    while read image ; do
        docker tag ${image} ${REPO}/${image}:${VERSION}
        docker push ${REPO}/${image}:${VERSION}
    done
