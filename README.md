Brooklyn Hyperledger Sawtooth
=============================

This repository contains [Apache Brooklyn](https://brooklyn.apache.org/) blueprints for a [Hyperledger Sawtooth](https://github.com/hyperledger/sawtooth-core) blockchain network, using Docker.

To install the blueprints, download the Jar and BOM files for the [latest release](https://github.com/blockchaintp/brooklyn-hyperledger-sawtooth/releases/latest) and install them onto a running Brooklyn server. The `sawtooth.bom` file references the Jar archive, so check to be sure it points at the correct location on the filesystem before adding to the catalog.

    $ mkdir lib
    $ cp sawtooth.jar lib/
    $ vi sawtooth.bom
    $ br add-catalog sawtooth.bom

Now you will have several new applications available for installation when you access the Brooklyn Web UI.

## Getting Started

Use the [example files](./examples) as templates to create a Sawtooth network blueprint. It must include the `sawtooth-cluster-application` entity, with configuration for size and network name and optionally the CIDR for the network subnet and a name for the validator cluster.

    services:
      - type: sawtooth-cluster-application
        name: "sawtooth-cluster"
        brooklyn.config:
          sawtooth.version: "1.0.5"
          sawtooth.repository: "sawtooth"
          sawtooth.size: 4
          sawtooth.network: "example"
          sawtooth.network.cidr: "10.0.0.0/24"
          sawtooth.cluster.name: "cluster

The blueprint can also contain `sawtooth-remote-cluster-application` entities, to add validators and transaction processors in other locations - or these can be deployed later.

    $ br deploy sawtooth.yaml

Once the Sawtooth network is running, check its status using the main Grafana dashboard for metrics, or access the REST API to look up raw blockchain data.

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE).
