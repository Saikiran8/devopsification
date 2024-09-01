#!/bin/sh

# Retrieve the endpoint
ENDPOINT=$(kubectl get endpoints java-app-service -n k8s -o jsonpath='{.subsets[0].addresses[0].ip}:{.subsets[0].ports[0].port}')

# Update the ConfigMap
kubectl create configmap java-config --from-literal=REACT_APP_API_URL=http://$ENDPOINT -o yaml --dry-run=client | kubectl apply -f -
