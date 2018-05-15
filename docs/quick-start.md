Quick Start
===========

This guide is intended for users who are familiar with Docker and Brooklyn and who already have an AWS EC2 account available with appropriate keys and credentials. See the [getting started instructions](./getting-started.md) for a more detailed, step-by-step guide.

The only software pre-requisite is a recent version of Docker installed, and you must have credentials and SSH keys available to access the AWS EC2 cloud. You must also have an AWS security group configured which allows access to ports _22_, _3000_, _3030_, _4200_, _4201_, _8000_, _8080_, _8090_ and _9090_ and allows machines in the same group to communicate on all TCP and UDP ports.

Navigate to the root directory of this repository and run the following command to start a Brooklyn server using a Docker image with the Sawtooth platform entities loaded into the catalog:

    $ docker run -d \
            -p 8081:8081 \
            -v ~/keys:/keys \
            -v $(pwd)/examples:/blueprints \
            --name brooklyn \
            blockchaintp/brooklyn-sawtooth:0.5.0
    ae82e15583ac4f32724a2daf0f122d3b6c7075ec3fcc35e35f46f6e300c522a9
    $ docker logs -f brooklyn
    [*] start brooklyn server
    [.] waiting for brooklyn api..................ok
    ...

Note the `/keys` and `/blueprints` volumes being mounted from directories on the host. The files, particularly the SSH keys, must be readable by the `brooklyn` user in the container. See the [`launch.sh`](../scripts/launch.sh) script for a more detailed example.

Once the Brooklyn server has started up, the console UI will be accessible at [`http://localhost:8081/`](http://localhost:8081/) and you can also use the `br` command-line tool either on the Docker container or remotely after logging in.

Now you should edit the [example application blueprint](../examples/example.yaml) so that it works with your own AWS account. Set the values of `identity` and `credential` with your access key ID and secret key and update the `keyPair` name with a key pair that is available on your AWS account and set the `loginUser.privateKeyFile` and `privateKeyFile` values to point to the `.pem` for that key par, which should be saved in your `~/keys` directory. Replace the value of the security group ID (`sg-xxxxxx`) with the ID of the security group described above.

When you are finished making these edits, you can deploy the Sawtooth platform using the following Docker command:

    $ docker exec brooklyn br deploy /blueprints/example.yaml
    Id:       | p7n0xemln2
    Name:     | example-sawtooth-platform
    status:   | In progress

Once the Brooklyn console shows the platform has started, you can retrieve details about service configuration and links using the following command:

    $ docker exec brooklyn status.sh example-sawtooth-platform
    {
      "host.address": "172.31.30.8",
      "seth.account": "9a998829441e9f114cc4168c371b24220e844074",
      "administrator.id": "0326a02883aa1394a446455ef3d905adaec01f7b33837c4618180a09a13318c417"
      "links": {
          "grafana.uri": "http://172.31.30.8:3000",
          "rest-api.uri": "http://172.31.30.8:8080",
    ...

---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE).
