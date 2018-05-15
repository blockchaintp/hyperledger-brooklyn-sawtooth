Getting Started
===============

This guide will cover deploying Hyperledger Sawtooth to AWS using an Apache Brooklyn server running in a Docker container on your local machine. This blueprint can deploy Sawtooth to other clouds, and Apache Brooklyn can be run and configured differently, but that is beyond the scope of this document.

### Set Up Your AWS Account

Follow [this guide](./aws-setup.md) to set up your AWS account; this is where your Sawtooth platform will be deployed.

### Install Docker

The only software pre-requisite is a recent version of Docker installed.

Follow [this guide](https://docs.docker.com/install/) to install Docker on your machine if you do not have a recent version already installed.

### Start the Brooklyn Server Container

Navigate to the root directory of this repository and run the following command to start a Brooklyn server using a Docker image with the Sawtooth platform entities loaded into the catalog:

    $ docker run -d \
            -p 8081:8081 \
            -v ~/keys:/keys \
            -v $(pwd)/examples:/blueprints \
            --name brooklyn \
            blockchaintp/brooklyn-sawtooth:0.5.0

The output should be the ID of the newly created container (different every time):

	ae82e15583ac4f32724a2daf0f122d3b6c7075ec3fcc35e35f46f6e300c522a9

Note the `/keys` and `/blueprints` volumes being mounted from the Docker host (your local machine). The files, particularly the SSH keys, must be readable by the `brooklyn` user in the container. See the [`launch.sh`](../scripts/launch.sh) script for a more detailed example.

Then run the following command to view the Brooklyn logs:

	 $ docker logs -f brooklyn

The output should print the status of the Brooklyn server that is starting up:

    [*] start brooklyn server
    [.] waiting for brooklyn api..................ok
    ...

### Configure and Add an AWS Deployment Location

Once the Brooklyn server has started up, the UI will be accessible in your browser.

Navigate to [`http://localhost:8081/#v1/editor/catalog/`](http://localhost:8081/#v1/editor/catalog/) and paste the contents of [`location.bom`](../examples/location.bom) into the editor.

You will need to make a number of modifications to this yaml so that it works with your own AWS account:

- Replace the values of `identity` and `credential` with your access key ID and secret key that you created
- Replace the value of `keyPair` with the name of the SSH key pair you created
- Replace the value of `loginUser.privateKeyFile` and `privateKeyFile` with `/keys/<downloaded pem file>.pem`
- Replace the value of each security group ID (`sg-xxxxxx`) with the ID of security group that you created

When you are finished making these edits, click "Add to Catalog."

### Deploy Your Sawtooth Platform

You are now ready to deploy! Navigate to [`http://localhost:8081/`](http://localhost:8081/) and click "+ add application."

Click "sawtooth-platform" and then click "next".

Select one of the AWS locations that you just created from the "Locations" drop down menu and change `sawtooth.version` to `1.0.5`. The rest of the configuration can be left as-is.

When you are finished configuring your deployment, click "Deploy."

### Monitoring Your Deployment

Now that your Sawtooth platform is deploying, navigate to [`http://localhost:8081/#v1/applications`](http://localhost:8081/#v1/applications) to view a live model of your deployment. Once all of the components show green circles next to their names, your deployment is complete!

### Inspecting Your Deployed Sawtooth Platform

Once the Sawtooth network is running, check its status using the main Grafana dashboard for metrics, or access the Sawtooth Explorer to look up raw blockchain data. More details about these components can be found in [this guide](./components.md).


---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](../LICENSE).
