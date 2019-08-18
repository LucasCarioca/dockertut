docker build -t lucasfds/multi-client:latest -t lucasfds/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t lucasfds/multi-worker:latest -t lucasfds/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker build -t lucasfds/multi-server:latest -t lucasfds/multi-server:$SHA -f ./server/Dockerfile ./server

docker push lucasfds/multi-client:latest
docker push lucasfds/multi-worker:latest
docker push lucasfds/multi-server:latest

docker push lucasfds/multi-client:$SHA
docker push lucasfds/multi-worker:$SHA
docker push lucasfds/multi-server:$SHA

kubectl apply -f ./k8s

kubectl set image deployments/client-deployment server=lucasfds/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=lucasfds/multi-worker:$SHA
kubectl set image deployments/server-deployment client=lucasfds/multi-server:$SHA