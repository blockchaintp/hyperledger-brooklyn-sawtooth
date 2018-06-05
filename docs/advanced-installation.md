Advanced Installation
=====================

The following steps will install Hyperledger Sawtooth blueprints to an existing
Apache Brooklyn instance using the Apache Brooklyn `br` command which is available
[here](https://brooklyn.apache.org/v/latest/ops/cli/). The blueprints can be downloaded from the latest release of this repository (see below).

Log into Brooklyn using a CLI command like the following:

    $ br login http://localhost:8081 admin password

You can now add catalog files (.bom) and bundles (.jar/zip) using the `br catalog add`
command -- add the Sawtooth catalog and bundle using the following commands:

    $ br catalog add \
        https://github.com/blockchaintp/hyperledger-brooklyn-sawtooth/releases/download/v0.5.1/sawtooth-0.5.1.jar
    $ br catalog add \
        https://github.com/blockchaintp/hyperledger-brooklyn-sawtooth/releases/download/v0.5.1/sawtooth.bom

You should now see `sawtooth-platform` in the "Create Application" of the Brooklyn GUI and various Sawtooth entities and applications listed in the "Catalog" pane.

![Apache Brooklyn Catalog](./images/apache-brooklyn-catalog.png)

Now you can follow along with the getting started guide from [here](./getting-started.md#configure-and-add-an-aws-deployment-location), assuming you have already completed the prerequisite AWS account setup described [here](./aws-setup.md).

There are also instructions [here](./gce-setup.md) for using GCE as a target cloud.

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](../LICENSE)
