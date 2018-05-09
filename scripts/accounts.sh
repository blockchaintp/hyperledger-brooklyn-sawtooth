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
# Create Seth accounts using the Sawtooth Seth CLI command.
#
# Usage: accounts.sh container-name [quantity]
# Environment:
#     PREFIX - The string prefix to identify the accounts
##

CONTAINER_NAME=$1
TOTAL=${2:-16}
PREFIX=${PREFIX:-test}

n=0
while [ $n -lt ${TOTAL} ] ; do
    alias=$(printf "%s-%03d" ${PREFIX} $n)

    docker exec --workdir /data ${CONTAINER_NAME} \
        bash -c "openssl ecparam -genkey -name secp256k1 | openssl ec -out ${alias}.pem" > /dev/null
    docker exec --workdir /data ${CONTAINER_NAME} \
        seth account import ${alias}.pem ${alias} > /dev/null
    docker exec --workdir /data ${CONTAINER_NAME} \
        seth account create --nonce=0 --wait ${alias}

    n=$((n + 1))
done
