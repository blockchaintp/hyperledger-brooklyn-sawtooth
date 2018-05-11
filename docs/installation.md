## Deploying a Smart Contract to the Hyperledger Sawtooth platform Using Truffle

We will use the [Tierion](https://github.com/Tierion/tierion-erc20-smart-contract) Network Token 
ERC20 Ethereum Smart Contract repository, which contains Solidity code for an ERC-20 token smart 
contract as an example.

The Apache Brooklyn deployed Hyperledger Sawtooth provides this functionailty via an effector on the 
sawtooth-platform-server-node.

To call the effector you will need to provide the id of the admin account.  You can get this form the 
sawtooth.seth.account sensor on the sawtooth-platform-server-node.  Once you have this open the effectors 
tab and click invoke on "Deploy smart Contract".  For the repo url enter `https://github.com/Tierion/tierion-erc20-smart-contract`
and for the seth_account_id enter the id from the sawtooth.seth.account sensor.  Click invoke and 
the truffle deploy process will be started.  You can follow the progress of this on the activities tab of 
the sawtooth-platform-server-node.

# Installing the Hyperledger Sawtooth blueprint to an existing Apache Brooklyn instance

The following steps will install the Hyperledger Sawtooth blueprints to an existing 
Apache Brooklyn instance using the Apache Brooklyn br command which is available 
[here](https://brooklyn.apache.org/v/latest/ops/cli/).

Firstly log in to brooklyn using a cli command like the following:

    br login http://localhost:80 admin password

You can now add catalog files (.bom) and bundles (.jar/zip) using the `br catalog add` 
command.  We can add the Sawtooth catalog and bundle using the following commands:

    br catalog add https://github.com/blockchaintp/hyperledger-brooklyn-sawtooth/releases/download/v0.5.0/sawtooth-0.5.0.jar
    br catalog add https://github.com/blockchaintp/hyperledger-brooklyn-sawtooth/releases/download/v0.5.0/sawtooth.bom

You should now see the sawtooth-platform option on the "Create Application" window.

Follow along with the tutorial from [here](https://github.com/blockchaintp/hyperledger-brooklyn-sawtooth#configure-and-add-an-aws-deployment-location)

# Troubleshooting Brooklyn

The following notes should help to debug issues arrising when trying to deploy the 
Hyperledger Sawtooth application.  For more detailed information on troubleshooting 
deployment and other issues see 
[Troubleshooting](https://brooklyn.apache.org/v/latest/ops/troubleshooting/index.html) 
on the Apache Brooklyn site.

Apache Brooklyn will report on the status of you deployment via the sensors view of 
each entity.  However if there has been a deployment failure or an entity fails 
entirely then this will be shown as a red flame on the applications view.  You can 
expand higher level entities on the left of the view to see which child entity has failed.  
Once you have identified the failing entity you will be able to get initial debugging 
information from the Summary and Sensors tabs.  The following sections should help you 
identity and solve common types of failure.

## Log files

If you have started Apache Brooklyn using Docker then you can access the log files with 
`docker logs brooklyn`. If you have started Apache Brooklyn using a different method then 
see the [Apache Brooklyn loggging](https://brooklyn.apache.org/v/latest/ops/logging.html) 
docs for information.

## Issues provisioning

Issues with provisioning (starting and setting up a VM on the target cloud) will happen fairly
quickly after the attempted deployment and will cause all entities to fail.  The summary view 
for each entity will show the error returned from the target cloud's API.  Start by checking
that your location has the correct identity, credential, keypair, and privateKeyFile.  You 
could also check that the target security group allows ssh access from the location where you 
are running Apache Brooklyn.

See (here)[https://brooklyn.apache.org/v/latest/ops/troubleshooting/deployment.html#vm-provisioning-failures] 
for more details.

## Issues with installation / launch

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

