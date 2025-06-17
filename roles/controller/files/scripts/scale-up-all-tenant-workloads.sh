#!/bin/bash
set -euo pipefail

NAMESPACES=$(kubectl get ns -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep '^aa-')

for NS in ${NAMESPACES}; do
    echo "Scaling workloads in namespace: $NS"

    # Scale Deployments
    DEPLOYMENTS=$(kubectl get deployments -n "$NS" -o jsonpath='{.items[*].metadata.name}')
    for DEPLOYMENT in $DEPLOYMENTS; do
        echo "  Scaling deployment/$DEPLOYMENT to 1 replica"
        kubectl scale deployment "$DEPLOYMENT" -n "$NS" --replicas=1
    done

    # Scale StatefulSets
    STATEFULSETS=$(kubectl get statefulsets -n "$NS" -o jsonpath='{.items[*].metadata.name}')
    for STATEFULSET in $STATEFULSETS; do
        echo "  Scaling statefulset/$STATEFULSET to 1 replica"
        kubectl scale statefulset "$STATEFULSET" -n "$NS" --replicas=1
    done
done