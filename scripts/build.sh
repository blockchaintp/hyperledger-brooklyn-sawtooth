#!/bin/bash
# Copyright 2018 by Blockchain Technology Partners Limited
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
# Clean and build Docker images for running Hyperledger Sawtooth with Brooklyn.
#
# Usage: build.sh [clean] [test|deploy]
# Environment:
#     HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION - The image version
#     REPO - The Docker Hub repository name
##

export HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION="${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION:-0.5.0-SNAPSHOT}"
export REPO="${REPO:-blockchaintp}"
export SAWTOOTH_VERSION="${SAWTOOTH_VERSION:-1.0.5}"

# tags and deploys an image to docker hub
deploy() {
    image="$1"
    docker tag ${image} ${image}:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}
    docker tag ${image} ${REPO}/${image}:latest
    docker tag ${image} ${REPO}/${image}:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}
    docker push ${REPO}/${image}
}

# removes local docker images
clean() {
    image="$1"
    docker rmi ${image}
    docker rmi ${image}:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}
    docker rmi ${REPO}/${image}
    docker rmi ${REPO}/${image}:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}
}

# clean local images
if [ "$1" == "clean" ] ; then
    clean brooklyn-sawtooth 2> /dev/null
    clean sawtooth-contracts 2> /dev/null
    shift
fi

# build the jar file for the catalog bundle
mvn clean install

# build the docker image for brooklyn-sawtooth
docker build . \
    --build-arg HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION=${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION} \
    -t brooklyn-sawtooth \
    -f ./docker/brooklyn-sawtooth

# build sawtooth seth contract deploy image
docker build . \
    --build-arg REPO=${REPO} \
    --build-arg SAWTOOTH_VERSION=${SAWTOOTH_VERSION} \
    -t sawtooth-contracts \
    -f ./docker/sawtooth-contracts

# test or deploy the current build
case "$1" in
    test)
        docker run \
            -p 8082:8081 \
            --volume ~/.ssh:/keys \
            --volume ~/blueprints:/blueprints \
            --name brooklyn \
            brooklyn-sawtooth
        ;;
    deploy)
        deploy brooklyn-sawtooth
        deploy sawtooth-contracts
        ;;
esac
