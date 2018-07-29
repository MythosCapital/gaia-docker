#!/bin/bash -e

# install docker
apt-get update
apt-get -y remove docker docker-engine docker.io
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

[ -n "$(apt-key fingerprint 0EBFCD88)" ]

add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get -y install docker-ce

docker run hello-world
