#!/bin/bash
set -e

#adds a simple secret to cluster
kubectl create secret generic pgpassword  --from-literal PGPASSWORD=$1