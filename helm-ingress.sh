#!/bin/bash
set -e

#create tiller service account
kubectl create -f tiller.yml

#initialize helm
helm init --service-account tiller --history-max 200

#add repo
helm repo add kubernetes https://kubernetes-charts.storage.googleapis.com

#ingress insall 
helm install --name ingress stable/nginx-ingress

#to uninstal run below
#helm delete ingress