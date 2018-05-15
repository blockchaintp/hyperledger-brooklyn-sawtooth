GCE Account Setup
=================

This document provides instructions for setting up your GCE account onto which you will deploy the Sawtooth platform.  For more information on configuring GCE as a target cloud see the Apache Brooklyn docs [here](https://brooklyn.apache.org/v/latest/locations/index.html#google-compute-engine-gce)

### Create a GCE Service Account

Follow [this guide](https://cloud.google.com/iam/docs/service-accounts) to create a service account.  You will need to download the private key and you will also need the email address that google has assigned to the service account.

You will need to create a location that looks like the following:

```
location:
  jclouds:google-compute-engine:
    region: us-central1-a
    identity: <email of service account>
    credential: |
      <private key for service account>
    templateOptions:
      network: <VPC url setup as discussed below>
```

### Setup GCE firewall rules

It is recommended that you setup a VPC with default subnets for any region that you wish to deploy the hyperledger-broolkyn-sawtooth blueprint to.

Follow [this guide](https://cloud.google.com/appengine/docs/standard/python/creating-firewalls) to setup 2 default firewall rules for the target region(s).  The first rule should allow all traffice within the target subnet and the second should allow the following inbound access from your IP (or 0.0.0.0/0 for all access): 22, 3000, 3030, 4200, 4201, 8000, 8080, 8090, 9090.

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](../LICENSE)
