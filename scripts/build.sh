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
# Build Docker images for running Hyperledger Sawtooth with Brooklyn.
#
# Usage: build.sh [test|deploy]
# Environment:
#     HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION - The image version
#     REPO - The Docker Hub repository name
##

export HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION="${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION:-0.5.0-SNAPSHOT}"
export REPO="${REPO:-blockchaintp}"

# tags and deploys an image to docker hub
deploy() {
    image="$1"
    docker tag ${image} ${REPO}/${image}:latest
    docker tag ${image} ${REPO}/${image}:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}
    docker push ${REPO}/${image}
}

# build the jar file for the catalog bundle
mvn clean install

# build the docker image for brooklyn-sawtooth
docker build . \
    --build-arg HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION=${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION} \
    -t brooklyn-sawtooth \
    -f ./docker/brooklyn-sawtooth

# TODO build sawtooth seth contract deploy image

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
        ;;
esac
