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
# Build Docker images for Hyperledger Sawtooth.
#
# Usage: build.sh
# Environment:
#     BUILD_DIR - Directory to checkout Sawtooth repositories
#     *_REPO - GitHub repository URL
#     *_BRANCH - GitHub repository branch to use
##

BUILD_DIR="${BUILD_DIR:-./build}"

SAWTOOTH_CORE_REPO="${SAWTOOTH_CORE_REPO:-https://github.com/blockchaintp/sawtooth-core.git}"
SAWTOOTH_CORE_BRANCH="${SAWTOOTH_CORE_BRANCH:-1-0}"
SAWTOOTH_SETH_REPO="${SAWTOOTH_SETH_REPO:-https://github.com/blockchaintp/sawtooth-seth.git}"
SAWTOOTH_SETH_BRANCH="${SAWTOOTH_SETH_BRANCH:-seth-rpc-eth-call}"
SAWTOOTH_NEXT_DIRECTORY_REPO="${SAWTOOTH_NEXT_DIRECTORY_REPO:-https://github.com/blockchaintp/sawtooth-next-directory.git}"
SAWTOOTH_NEXT_DIRECTORY_BRANCH="${SAWTOOTH_NEXT_DIRECTORY_BRANCH:-master}"
SAWTOOTH_EXPLORER_REPO="${SAWTOOTH_EXPLORER_REPO:-https://github.com/blockchaintp/sawtooth-explorer.git}"
SAWTOOTH_EXPLORER_BRANCH="${SAWTOOTH_EXPLORER_BRANCH:-standalone-dockerfile}"

# checkout a git repository
checkout() {
    dir=$1
    proj=$(echo ${dir} | tr 'a-z-' 'A-Z_')
    repo="${proj}_REPO"
    branch="${proj}_BRANCH"
    git clone ${!repo}
    cd ${dir}
    git fetch --all
    git checkout ${!branch}
    cd ..
}

# build images with docker compose
compose() {
    dir=$1
    cd ${dir}
    docker-compose build
    cd ..
}

# clean up build directory
if [ -d "${BUILD_DIR}" ] ; then
    sudo rm -rf "${BUILD_DIR}"
fi
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# clone the required projects
checkout sawtooth-core
checkout sawtooth-seth
checkout sawtooth-next-directory
checkout sawtooth-explorer

# build sawtooth-core images
cd sawtooth-core
./bin/build_all debs
./bin/build_all installed
cd ..

# build sawtooth-seth images
compose sawtooth-seth

# build sawtooth-next-directory images
touch sawtooth-next-directory/server/config.py
compose sawtooth-next-directory

# build sawtooth-explorer images
compose sawtooth-explorer

# tidy up
docker image prune --force
