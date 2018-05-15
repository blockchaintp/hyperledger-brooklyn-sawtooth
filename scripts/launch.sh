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
# Launches a Brooklyn Sawtooth server instance.
#
# Usage: launch.sh
# Environment:
#     HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION - The image version
#     REPO - The Docker Hub repository name
##

HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION=${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION:-0.5.0}
REPO=${REPO:-blockchaintp}

# create persistence volume if not present
if ! docker volume inspect brooklyn-persistence-data > /dev/null 2>&1 ; then
    docker volume create brooklyn-persistence-data
fi

# start the server
docker run -d \
    -p 8081:8081 \
    -p 8443:8443 \
    -v ~/keys:/keys \
    -v $(pwd)/examples:/blueprints \
    -v brooklyn-persistence-data:/var/brooklyn \
    -v /dev/urandom:/dev/random \
    --name brooklyn \
    ${REPO}/brooklyn-sawtooth:${HYPERLEDGER_BROOKLYN_SAWTOOTH_VERSION}

# follow the brooklyn logs
exec docker logs -f brooklyn
