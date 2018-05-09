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
# Start an Apache Brooklyn service with Sawtooth platform catalog entries.
#
# Usage: brooklyn.sh
# Environment:
#     CATALOG_DIR - The catalog directory with jar and bom files
##

CATALOG_DIR="${CATALOG_DIR:-/catalog}"

# add a file to the brooklyn catalog
add() {
  file=$1
  if [ -f ${file} ] ; then
    if br add-catalog ${file} > /dev/null 2>&1 ; then
      echo "[+] added $(basename ${file}) to catalog"
    else
      echo "[!] failed adding $(basename ${file})"
      exit 1
    fi
  fi
}

# start brooklyn server
echo "[*] start brooklyn server"
nohup ${BROOKLYN_HOME}/bin/karaf server &

# wait until brooklyn rest api available
echo -n "[.] waiting for brooklyn api..."
while ! grep "Brooklyn initialisation (part two) complete" ${BROOKLYN_LOG_DIR}/brooklyn.info.log > /dev/null 2>&1 ; do
  sleep 10
  echo -n "..."
done && ( echo "...ok" ; echo "[=] brooklyn rest api live" )

# login to brooklyn server
if br login "http://localhost:8081" admin password ; then
  echo "[=] successful brooklyn login"
else
  echo "[!] failed brooklyn login"
  exit 1
fi

# add jar files to catalog
echo "[>] add catalog libraries"
for jar in $(ls -1 ${CATALOG_DIR}/*.jar) ; do
  add ${jar}
done

# add bom files to catalog
echo "[>] add catalog blueprints"
for bom in $(ls -1 ${CATALOG_DIR}/*.bom) ; do
  add ${bom}
done

# tail the brooklyn logs
echo "[=] brooklyn server started"
exec tail -f ${BROOKLYN_LOG_DIR}/brooklyn.info.log
