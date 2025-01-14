#!/bin/bash
for NS in $(kubectl get pods -A -l app.kubernetes.io/created-by=volsync | grep aa- | cut -f1 -d' ' | uniq); do
    kubectl delete replicationsource -n $NS --all
    flux reconcile kustomization $NS
done