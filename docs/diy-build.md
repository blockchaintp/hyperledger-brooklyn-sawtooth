Building the Platform
=====================

You can also build a private version of the Sawtooth platform, with your own copies of the Docker images and blueprints. To do this you must also have Maven installed, as well as git, and have access to a Docker Hub account.

    $ REPO=<your Docker hub account name here>
    $ ./scripts/images.sh
    $ ./scripts/deploy.sh
    $ ./scripts/build.sh deploy

Update the blueprints so the value of `sawtooth.repository` refers to your private repository on Docker Hub, and then deploy.


---
Copyright 2018 Blockchain Technology Partners Limited; Licensed under the [Apache License, Version 2.0](./LICENSE)
