#!/bin/bash
set -e

#install ibmcli
#curl -sL https://ibm.biz/idt-installer | bash
#ibmcloud -v


#login to ibmcli
# ibmcloud login -a cloud.ibm.com -r us-south -g Default -u $IBMCLOUD_EMAIL -p $IBMCLOUD_PASSWORD
ibmcloud login -a cloud.ibm.com -r us-south -g Default -u $1 -p $2

#configure and login to registry
# ibmcloud plugin install container-registry -r Bluemix
ibmcloud cr login

#configure kubectl
eval $(ibmcloud ks cluster-config --cluster mycluster -s | grep export)

docker build -t lucasfds/multi-client:latest -f ./client/Dockerfile ./client
docker build -t lucasfds/multi-worker:latest -f ./worker/Dockerfile ./worker
docker build -t lucasfds/multi-server:latest -f ./server/Dockerfile ./server

# docker build -t lucasfds/multi-client:latest -t lucasfds/multi-client:$SHA -f ./client/Dockerfile ./client
# docker build -t lucasfds/multi-worker:latest -t lucasfds/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# docker build -t lucasfds/multi-server:latest -t lucasfds/multi-server:$SHA -f ./server/Dockerfile ./server

docker tag lucasfds/multi-client:latest us.icr.io/lucasfds/multi-client:latest
docker tag lucasfds/multi-worker:latest us.icr.io/lucasfds/multi-worker:latest
docker tag lucasfds/multi-server:latest us.icr.io/lucasfds/multi-server:latest

docker push us.icr.io/lucasfds/multi-client:latest
docker push us.icr.io/lucasfds/multi-worker:latest
docker push us.icr.io/lucasfds/multi-server:latest

# docker push lucasfds/multi-client:$SHA
# docker push lucasfds/multi-worker:$SHA
# docker push lucasfds/multi-server:$SHA

kubectl apply -f ./k8s

# kubectl set image deployments/client-deployment client=lucasfds/multi-client:$SHA
# kubectl set image deployments/worker-deployment worker=lucasfds/multi-worker:$SHA
# kubectl set image deployments/server-deployment server=lucasfds/multi-server:$SHA

# kubectl expose deployment/ingress-nginx-ingress-controller --type=NodePort --port=80 --name=ingress-nginx-ingress-controller-nodeport --target-port=80


