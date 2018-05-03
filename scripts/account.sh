#!/bin/bash
# Copyright 2018 by Blockchain Technology Partners

#set -x # DEBUG

APP=${1:-sawtooth-platform-application}

host_address=$(br app ${APP} entity sawtooth-platform-server-node sensor host.address)
echo "${host_address}"
# 18.196.191.3

seth_account=$(br app ${APP} entity sawtooth-platform-server-node sensor sawtooth.seth.account)
echo "${seth_account}"
# 64314c730d7fdc91aa5c9d4355e8606e4a088616
