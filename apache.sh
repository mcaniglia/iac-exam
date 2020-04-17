#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update

# install docker community edition
apt-cache policy docker-ce
apt-get install -y docker-ce

# pull nginx image
docker pull httpd:2-alpine

# run container with port mapping - host:container
docker run -d -p 80:80 --name apache httpd:2-alpine