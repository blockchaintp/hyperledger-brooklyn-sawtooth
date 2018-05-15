Hyperledger Brooklyn Sawtooth
=============================

This repository contains [Apache Brooklyn](https://brooklyn.apache.org/) blueprints for a [Hyperledger Sawtooth](https://www.hyperledger.org/projects/sawtooth) blockchain platform using [Docker](https://www.docker.com/).

Please note that this is an early access release of the Brooklyn sawtooth platform and is intended for development use and testing rather than for production deployments. However, we are adding more features and configuration options to the platform that will be useful for building production ready applications.

## Purpose

Our motivation is to simplify the deployment of Hyperledger Sawtooth using Apache Brooklyn to automate this in a wide range of configurations and on a wide range of environments. We intend to offer this to the Hyperledger community as an incubator project along the same lines as [Hyperledger Caliper](https://www.hyperledger.org/projects/caliper) ultimately providing similar blueprints for [Hyperledger Fabric](https://www.hyperledger.org/projects/fabric) and potentially other Hyperledger frameworks.

## Overview

The [Sawtooth platform](./docs/platform.md) consists of a number of separate [components](./docs/components.md) that can be used as the basis for building blockchain applications. These include:

* Sawtooth core components
* Seth components
* RBAC components
* Sawtooth explorer GUI
* Grafana monitoring tool

In-depth descriptions and diagrams of all these components can be found in the links above.

## Getting Started

The [getting started guide](./docs/getting-started.md) shows you the simplest way to deploy your own instance of the platform.

If you are already running a Brooklyn server and want to use a downloaded release of this repository (rather than running Brooklyn in a Docker container with the release baked in), skip "Start the Brooklyn Server Container" in the getting started guide and instead follow [this guide](./docs/advanced-installation.md). Afterwards, return back and continue with the getting started guide.

If you want to build a private version of the Sawtooth platform, follow [this guide](./docs/diy-build.md) before proceeding with the getting started guide.

## Using the Platform

[This guide](./docs/use-the-platform.md) shows you how to make use of the Sawtooth platform once it has been deployed.

## Troubleshooting

The [troubleshooting guide](./docs/troubleshooting.md) will help you solve potential deployment / configuration issues.

## Contributing

Since Hyperledger Sawtooth is an ever-changing and ever-expanding project, contributions to this repository are welcomed and encouraged in the form of:

* Testing deployments on different clouds and creating issues with feedback
* Adding additional Sawtooth components to the blueprint as part of the platform

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE).
