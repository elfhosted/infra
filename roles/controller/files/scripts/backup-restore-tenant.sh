#!/bin/bash

TENANT=$1

NODE=$(kubectl get pods -n aa-$TENANT --selector="app.kubernetes.io/name=filebrowser" -o jsonpath='{.items[0].spec.nodeName}')

echo "Identified $TENANT is on $NODE..."
# shut down any deployments in the ns
kubectl scale deployment -n aa-$TENANT --all --replicas 0

# perform a just-in-time backup
for RS in $(kubectl get replicationsource -n aa-$TENANT -o=name | cut -f2 -d/); do

    echo "$(date '+%H:%M:%S') Triggering manual backup of $RS..."
    MANUAL=$(date +%s)
    kubectl patch replicationsource  -n aa-$TENANT $RS --type merge -p '{"spec":{"restic":{"unlock":"'$MANUAL'"}}}' > /dev/null 2>&1 &
    kubectl patch replicationsource  -n aa-$TENANT $RS --type merge -p '{"spec":{"trigger":{"manual":"'$MANUAL'"}}}' > /dev/null 2>&1 &

    LAST_MANUAL_SYNC=""

    while [ "$LAST_MANUAL_SYNC" != "$MANUAL" ]; do
        # Perform the sync check
        LAST_MANUAL_SYNC=$(kubectl get replicationsource  -n aa-$TENANT $RS --template=\{\{.status.lastManualSync}})

        # Print progress and wait for 10 seconds
        echo -n '💾'
        sleep 10
    done

    if [ "$LAST_MANUAL_SYNC" == "$MANUAL" ]; then
        echo "✅ Done!"
    fi
done

# Execute deletion and reconciliation commands
kubectl cordon $NODE
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
kubectl uncordon $NODE