docker-nodebb
===================

NodeBB Forum made easy with Docker with built-in redis.

## NodeBB

[NodeBB](https://nodebb.org/) Forum Software - A better community platform for the modern web. NodeBB is a next generation forum software that's free and easy to use.

## Building docker-nodebb

There is not need to pull the image locally, it's already hosted on docker hub. But in case you want to make some modifications, here is how:

    git clone https://github.com/srounet/docker-nodebb
    cd docker-nodebb
    docker build -t nodebb .


## Running docker-nodebb

This image only expose nodebb default port 4567

    sudo docker run -d -P --name nodebb nopz/docker-nodebb

## Live debugging the app

In case you need to ssh into the docker image you can do so:

   docker exec -t -i nodebb bash

## Where is my nodebb at ?

    docker ps -a

This command should print something like:

    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                                                                                          NAMES
    0433aed80953        forum               "supervisord -n"       6 seconds ago       Up 2 seconds        80/tcp, 443/tcp, 0.0.0.0:32789->4567/tcp

Here the local port is 32789, so without reverse-proxy my http addresse will be `http://MY_IP:32789`
