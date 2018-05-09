Hyperledger Brooklyn Sawtooth
=============================

This repository contains [Apache Brooklyn](https://brooklyn.apache.org/) blueprints for a [Hyperledger Sawtooth](https://github.com/hyperledger/sawtooth-core) blockchain platform, using Docker.

## Getting Started

The only pre-requisite is a recent version of Docker installed.

Use the [example files](./examples) as templates to create a Sawtooth platform blueprint. It must include the `sawtooth-platform-application` entity, with configuration for size and network name and optionally the CIDR for the network subnet and a name for the validator cluster.

    services:
      - type: sawtooth-platform-application
        name: "my-sawtooth-platform"
        brooklyn.config:
          sawtooth.version: "1.0.5"
          sawtooth.repository: "sawtooth"
          sawtooth.size: 4
          sawtooth.network: "example.com"
          sawtooth.network.cidr: "10.0.0.0/24"
          sawtooth.cluster.name: "example

First, start a Brooklyn server, using a Docker image with Sawtooth platform entities loaded into the catalog. The following example shows the `/keys` and `/blueprints` volumes being mounted from the Docker host. Note that the files, particularly the SSH keys, must be readable by the `brooklyn` user in the container. See the `launch.sh` script for a more detailed example.

    $ docker run -d -P \
            -v ~/keys:/keys \
            -v $(pwd)/examples:/blueprints \
            --name brooklyn \
            blockchaintp/brooklyn-sawtooth:0.5.0-SNAPSHOT
    ae82e15583ac4f32724a2daf0f122d3b6c7075ec3fcc35e35f46f6e300c522a9
    $ docker logs -f brooklyn
    [*] start brooklyn server
    [.] waiting for brooklyn api..................ok
    ...

Once the Brooklyn UI is accessible on port 8081, you can then configure a cloud location and deploy your Sawtooth platform.

    $ docker exec brooklyn br add-catalog /blueprints/location.bom
    ...
    $ docker exec brooklyn br deploy /blueprints/platform.yaml
    Id:       | p7n0xemln2
    Name:     | my-sawtooth-platform
    status:   | In progress

Once the Sawtooth network is running, check its status using the main Grafana dashboard for metrics, or access the Sawtooth Explorer to look up raw blockchain data. You can also check the values of various sensors by running the following command.

    $ docker exec brooklyn status.sh my-sawtooth-platform
    {
      "host.address": "172.31.30.8",
      "seth.account": "9a998829441e9f114cc4168c371b24220e844074",
      "administrator.id": "0326a02883aa1394a446455ef3d905adaec01f7b33837c4618180a09a13318c417"
    }

## Building the Platform

You can also build a private version of the Sawtooth platform, with your own copies of the Docker images and blueprints. To do this you must also have Maven installed, as well as git, and have access to a Docker Hub account.

    $ REPO=private
    $ ./scripts/images.sh
    $ ./scripts/deploy.sh
    $ ./scripts/build.sh deploy

Update the blueprints to refer to your private repository on Docker Hub, and deploy the platform as above.

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE).
