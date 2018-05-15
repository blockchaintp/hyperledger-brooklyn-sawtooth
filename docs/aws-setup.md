AWS Account Setup
=================

This document provides instructions for setting up your AWS account onto which you will deploy the Sawtooth platform.

### Create an AWS Access Key

Follow [this guide](https://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) to create an access key. Be sure to make note of the access key ID and secret key as you will need these later.

### Create an AWS SSH Key Pair

Follow [this guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to create an SSH key pair. Be sure to make note of the name you give to your key pair as you will need this later.

When you create your key pair, the `.pem` file will automatically be downloaded. Create a `~/keys` directory and place your downloaded `.pem` file inside it.

Run the following command to change the permissions so Brooklyn will be able to read it:

	$ chmod 644 ~/keys/*.pem

### Create an AWS Security Group

Follow [this guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#creating-security-group) to create security group. Be sure to make note of the ID of the group as you will need this later.

Your security group must be configured to allow access to ports _22_, _3000_, _3030_, _4200_, _4201_, _8000_, _8080_, _8090_ and _9090_, and must allow machines in the same group to communicate on all TCP and UDP ports.

Follow [this guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-network-security.html#adding-security-group-rule) to create these rules:

Inbound:
- Type: All TCP | Source: Custom "sg-[your SG ID here]"
- Type: All UDP | Source: Custom "sg-[your SG ID here]"
- Type: SSH | Source: Custom "My IP" (port 22 is automatically selected)
- Type: Custom TCP Rule | Port Range: 3000 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 3030 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 4200 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 4201 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 8000 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 8080 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 8090 | Source: Custom "My IP"
- Type: Custom TCP Rule | Port Range: 9090 | Source: Custom "My IP"

Outbound:
- Type: All TCP | Source: Custom "sg-[your SG ID here]"


---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE)
