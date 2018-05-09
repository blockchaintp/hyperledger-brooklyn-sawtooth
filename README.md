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

First, start a Brooklyn server, using a Docker image with Sawtooth platform entities loaded into the catalog. The following example shows the persistence data volume being created, and the `/keys` and `/blueprints` volumes being mounted from the Docker host. If the Docker host is a cloud VM then it may be nescessary to mount the `/dev/urandom` device from the host to allow SSH enough entropy.

    $ docker volume create brooklyn-persistence-data
    $ docker run -d -P \
            -v ~/.ssh:/keys \
            -v $(pwd)/examples:/blueprints \
            -v brooklyn-persistence-data:/var/brooklyn \
            -v /dev/urandom:/dev/random \
            --name brooklyn \
            blockchaintp/brooklyn-sawtooth:0.5.0-SNAPSHOT
    ae82e15583ac4f32724a2daf0f122d3b6c7075ec3fcc35e35f46f6e300c522a9
    $ docker logs -f brooklyn
    [*] start brooklyn server
    [.] waiting for brooklyn api..................ok
    ...

Once the Brooklyn UI is accessible on port 8081, you can then configure a cloud location and deploy your Sawtooth platform.

    $ docker exec brooklyn \
            br add-catalog /blueprints/location.bom
    ...
    $ docker exec brooklyn \
            br deploy /blueprints/platform.yaml
    Id:       | p7n0xemln2
    Name:     | my-sawtooth-platform
    status:   | In progress
    $ docker exec brooklyn \
            br app my-sawtooth-platform
    Id:              | p7n0xemln2
    Name:            | my-sawtooth-platform
    Status:          | STARTING
    ServiceUp:       | false
    Type:            | org.apache.brooklyn.entity.stock.BasicApplication
    CatalogItemId:   | sawtooth-platform-application:0.5.0-SNAPSHOT
    LocationId:      | pr9gp5zheq
    LocationName:    | amazon-dublin
    LocationSpec:    | amazon-dublin
    LocationType:    | org.apache.brooklyn.location.jclouds.JcloudsLocation

Once the Sawtooth network is running, check its status using the main Grafana dashboard for metrics, or access the Sawtooth Explorer to look up raw blockchain data.

## Building the Platform

You can also build a private version of the Sawtooth platform, with your own copies of the Docker images and blueprints. To do this you must also have Maven installed, as well as git, and have access to a Docker Hub account.

    $ REPO=private
    $ ./scripts/images.sh
    $ ./scripts/deploy.sh
    $ ./scripts/build.sh deploy

Update the blueprints to refer to your private repository on Docker Hub, and deploy the platform as above.

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE).
