Troubleshooting
===============

The following notes should help to debug issues arrising when trying to deploy the
Hyperledger Sawtooth application.  For more detailed information on troubleshooting
deployment and other issues see
[Troubleshooting](https://brooklyn.apache.org/v/latest/ops/troubleshooting/index.html)
on the Apache Brooklyn site.

## Monitoring Your Deployment

Apache Brooklyn will report on the status of you deployment via the sensors view of
each entity in the GUI.  However if there has been a deployment failure or an entity fails
entirely then this will be shown as a red flame on the applications view.  You can
expand higher level entities on the left of the view to see which child entity has failed.
Once you have identified the failing entity you will be able to get initial debugging
information from the Summary and Sensors tabs.  The following sections should help you
identity and solve common types of failure.

## Log Files

If you have started Apache Brooklyn using Docker then you can access the log files with
`docker logs brooklyn`. If you have started Apache Brooklyn using a different method then
see the [Apache Brooklyn loggging](https://brooklyn.apache.org/v/latest/ops/logging.html)
docs for information.

## Issues Provisioning

Issues with provisioning (starting and setting up a VM on the target cloud) will happen fairly
quickly after the attempted deployment and will cause all entities to fail.  The summary view
for each entity will show the error returned from the target cloud's API.  Start by checking
that your location has the correct identity, credential, keypair, and privateKeyFile.  You
could also check that the target security group allows ssh access from the location where you
are running Apache Brooklyn.

See (here)[https://brooklyn.apache.org/v/latest/ops/troubleshooting/deployment.html#vm-provisioning-failures]
for more details.

## Issues with Installation / Launch

If provisioning succeeds but deployment still fails then this is likely to be a problem with
installing and running a specific entity.

In the application view click on the failed enity and then click on the activities tab.  You can
now see the activity that failed (usually start).  Drill down into this by clicking on it and drill
down further into each failed step until you reach the step that actually failed.  You should see the
stdin, stdout, stderr, and environment that was run in that step.  Opening each of these will give you
a good idea of what failed.

You can also see details of how to ssh to the failed entity's VM where you can try the above commands
or look for logs specific to the entity.

The most common cause of installation and launch failures for the Sawtooth blueprint is connectivity
failures between entities or from VMs to the internet for downloading dependencies.  Check your
cloud's configuration for security groups, subnets, routing tables, gateways, etc.  See
[here](https://brooklyn.apache.org/v/latest/ops/troubleshooting/connectivity.html) for more help
in how to solve these types of issues.


---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE)
