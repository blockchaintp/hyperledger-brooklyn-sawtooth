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
##

sawadm keygen --force
sawtooth keygen ${NETWORK} --force
sawset genesis \
  -k /etc/sawtooth/keys/validator.priv \
  -o genesis.batch
sawset proposal create \
  -k /etc/sawtooth/keys/validator.priv \
  sawtooth.validator.batch_injectors=block_info \
  -o config.batch
sawadm genesis \
  genesis.batch config.batch
sawtooth-validator -vv \
  --endpoint tcp://validator.${NETWORK}:8800 \
  --bind component:tcp://eth0:4004 \
  --bind network:tcp://eth0:8800 \
  --peering dynamic \
  --minimum-peer-connectivity 255 \
  --maximum-peer-connectivity 255 \
  --opentsdb-url http://influxdb.${NETWORK}:8086 \
  --opentsdb-db metrics
