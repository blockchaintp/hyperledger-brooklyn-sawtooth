Using the Platform
==================

If you have not already, use the [getting started](./getting-started.md) instructions to create a Sawtooth platform deployment.

## Deploying a Smart Contract to the Hyperledger Sawtooth Platform Using Truffle

We will use the [Tierion](https://github.com/Tierion/tierion-erc20-smart-contract) Network Token
ERC20 Ethereum Smart Contract repository, which contains Solidity code for an ERC-20 token smart
contract as an example.

The Apache Brooklyn deployed Hyperledger Sawtooth provides this functionailty via an effector on the
`sawtooth-platform-server-node` entity.

To call the effector you will need to provide the ID of the admin account. You can get this form the
`sawtooth.seth.account` sensor on `sawtooth-platform-server-node`.

Once you have noted this value, open the effectors
tab and click invoke on `deploy-smart-contract`.

For `source` enter `https://github.com/Tierion/tierion-erc20-smart-contract`
and for the `account` enter the ID from the `sawtooth.seth.account`.

Click invoke and
the truffle deploy process will be started. You can follow the progress of this on the activities tab of
the `sawtooth-platform-server-node`.


---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE)
