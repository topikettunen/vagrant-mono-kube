#!/usr/bin/env bash

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
     tee -a /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubectl docker.io
usermod -aG docker vagrant

wget https://github.com/rancher/rke/releases/download/v0.2.7/rke_linux-amd64
mv rke_linux-amd64 rke
chmod +x rke
mv rke /usr/local/bin/

cd /vagrant
rke up
