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
# Launch main validator with genesis block
#
# Usage: genesis.sh
# Environment:
#   TARGET_WAIT_TIME
#   INITIAL_WAIT_TIME
#   MAX_BATCHES_PER_BLOCK
#   MODULE
##
if [ -z "${HOST_ADDRESS}" ]; then
	ENDPOINT_ADDRESS=validator.${NETWORK}
else
	ENDPOINT_ADDRESS=${HOST_ADDRESS}
fi

sawadm keygen --force
sawtooth keygen ${NETWORK} --force
sawset genesis \
  -k /etc/sawtooth/keys/validator.priv \
  -o genesis.batch
sawset proposal create \
  -k /etc/sawtooth/keys/validator.priv \
  sawtooth.consensus.algorithm=poet \
  sawtooth.poet.report_public_key_pem='-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArMvzZi8GT+lI9KeZiInn
4CvFTiuyid+IN4dP1+mhTnfxX+I/ntt8LUKZMbI1R1izOUoxJRoX6VQ4S9VgDLEC
PW6QlkeLI1eqe4DiYb9+J5ANhq4+XkhwgCUUFwpfqSfXWCHimjaGsZHbavl5nv/6
IbZJL/2YzE37IzJdES16JCfmIUrk6TUqL0WgrWXyweTIoVSbld0M29kToSkMXLsj
8vbQbTiKwViWhYlzi0cQIo7PiAss66lAW0X6AM7ZJYyAcfSjSLR4guMz76Og8aRk
jtsjEEkq7Ndz5H8hllWUoHpxGDqLhM9O1/h+QdvTz7luZgpeJ5KB92vYL6yOlSxM
fQIDAQAB
-----END PUBLIC KEY-----' \
  sawtooth.poet.valid_enclave_measurements=$(poet enclave --enclave-module ${MODULE:-simulator} measurement) \
  sawtooth.poet.valid_enclave_basenames=$(poet enclave --enclave-module ${MODULE:-simulator} basename) \
  sawtooth.validator.batch_injectors=block_info \
  -o config.batch
poet registration create \
  -k /etc/sawtooth/keys/validator.priv \
  --enclave-module ${MODULE:-simulator} \
  -o poet.batch
sawset proposal create \
  -k /etc/sawtooth/keys/validator.priv \
  sawtooth.poet.target_wait_time=${TARGET_WAIT_TIME:-5} \
  sawtooth.poet.initial_wait_time=${INITIAL_WAIT_TIME:-25} \
  sawtooth.publisher.max_batches_per_block=${MAX_BATCHES_PER_BLOCK:-100} \
  -o poet-settings.batch
sawadm genesis \
  genesis.batch config.batch poet.batch poet-settings.batch
sawtooth-validator -vv \
  --endpoint tcp://${ENDPOINT_ADDRESS}:8800 \
  --bind component:tcp://0.0.0.0:4004 \
  --bind network:tcp://0.0.0.0:8800 \
  --peering dynamic \
  --network-auth trust \
  --scheduler ${SCHEDULER:-serial} \
  --minimum-peer-connectivity ${MINIMUM_PEERS:-3} \
  --maximum-peer-connectivity 255 \
  --opentsdb-url http://influxdb.${NETWORK}:8086 \
  --opentsdb-db metrics
