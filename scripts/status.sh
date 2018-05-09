#!/bin/bash
# Copyright 2018 by Blockchain Technology Partners
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
# Gets the current status of a running Brooklyn Sawtooth application.
#
# Usage: status.sh [application-name]
##

APP=${1:-sawtooth-platform-application}

# get sensor data
host_address=$(br app ${APP} entity sawtooth-platform-server-node sensor host.address)
seth_account=$(br app ${APP} entity sawtooth-platform-server-node sensor sawtooth.seth.account)
administrator_id=$(br app ${APP} entity sawtooth-platform-server-node sensor sawtooth.next-directory.administrator.id)

# output json data
cat <<EOF
{
  "host.address": "${host_address}",
  "seth.account": "${seth_account}",
  "administrator.id": "${administrator_id}"
}
EOF
