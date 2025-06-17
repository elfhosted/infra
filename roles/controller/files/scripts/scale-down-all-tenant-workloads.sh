#!/bin/bash
set -euo pipefail

NAMESPACES=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep '^aa-')

for NS in ${NAMESPACES}; do
    echo "Scaling down workloads in namespace: $NS"

    # Scale Deployments to 0
    DEPLOYMENTS=$(kubectl get deployments -n "$NS" -o jsonpath='{.items[*].metadata.name}')
    for DEPLOYMENT in $DEPLOYMENTS; do
        echo "  Scaling deployment/$DEPLOYMENT to 0 replicas"
        kubectl scale deployment "$DEPLOYMENT" -n "$NS" --replicas=0
    done

    # Scale StatefulSets to 0
    STATEFULSETS=$(kubectl get statefulsets -n "$NS" -o jsonpath='{.items[*].metadata.name}')
    for STATEFULSET in $STATEFULSETS; do
        echo "  Scaling statefulset/$STATEFULSET to 0 replicas"
        kubectl scale statefulset "$STATEFULSET" -n "$NS" --replicas=0
    done
done