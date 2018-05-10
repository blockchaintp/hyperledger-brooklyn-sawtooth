#!/bin/bash
# Copyright 2018 by Cloudsoft Corporation Limited
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#set -x # DEBUG

##
# Deploy or clean Docker images for the Hyperledger Sawtooth platform.
#
# Usage: clean.sh
# Usage: deploy.sh
# Environment:
#     VERSION - The image version
#     REPO - The Docker Hub repository name
#     FILTER - Filter to select images
##

VERSION="${VERSION:-1.0.5}"
REPO="${REPO:-blockchaintp}"
FILTER="$1"
ACTION=$(basename "$0" .sh)
echo -n "${ACTION}: "

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
        case "${ACTION}" in
            clean)
                for tag in ${image} ${image}:${VERSION} ${REPO}/${image}:latest ${REPO}/${image}:${VERSION} ; do
                    docker rmi ${tag} > /dev/null 2>&1 && echo -n "x" || echo -n "."
                done
                ;;
            deploy)
                for tag in ${image}:${VERSION} ${REPO}/${image}:latest ${REPO}/${image}:${VERSION} ; do
                    docker tag ${image} ${tag}
                done
                docker push ${REPO}/${image}:${VERSION} > /dev/null 2>&1 && echo -n "+" || echo -n "."
                ;;
        esac
    done
echo
