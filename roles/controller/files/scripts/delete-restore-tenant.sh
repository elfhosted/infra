#!/bin/bash

TENANT=$1

kubectl delete helmrelease -n aa-$TENANT $TENANT
kubectl delete pvc -n aa-$TENANT --all
flux reconcile kustomization aa-$TENANT

# Loop until PVCs are found
while true; do
    # Check for any PVCs in the namespace
    if kubectl get pvc -n "aa-$TENANT" --no-headers | grep -q .; then
        echo "PVCs found in namespace 'aa-$TENANT'. Exiting loop."
        break
    fi
    echo "No PVCs found in namespace 'aa-$TENANT'. Retrying in 5 seconds..."
    sleep 5
done