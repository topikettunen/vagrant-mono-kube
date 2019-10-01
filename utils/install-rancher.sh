#!/usr/bin/env bash

kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller \
        --clusterrole cluster-admin \
        --serviceaccount=kube-system:tiller

helm init --service-account tiller --history-max 200

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm install stable/cert-manager \
     --name cert-manager \
     --namespace kube-system \
     --version v0.5.2

helm install rancher-latest/rancher \
     --name rancher \
     --namespace cattle-system \
     --set hostname=rancher.192.168.50.6.xip.io
