NODE=$1
if [ -z "$NODE" ]; then
    echo "Usage: $0 <node-name>"
    exit 1
fi

# We need the node uncondoned for backups to run
kubectl uncordon $NODE
# Get namespaces with pods on the given node
NAMESPACES=$(kubectl get pods -A -o wide -l app.kubernetes.io/name=filebrowser --field-selector spec.nodeName=$NODE | grep aa- | awk '{print $1}' | uniq)
for NS in $NAMESPACES; do
    TENANT="${NS#aa-}"

    # shut down any deployments in the ns
    kubectl scale deployment -n $NS --all --replicas 0
    
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
    kubectl delete helmrelease -n $NS --all
    kubectl delete pvc -n $NS --all
    flux reconcile kustomization $NS
    # wait for helmrelease to deploy

    # Loop until PVCs are found
    while true; do
        # Check for any PVCs in the namespace
        if kubectl get pvc -n "$NS" --no-headers | grep -q .; then
            echo "PVCs found in namespace '$NS'. Exiting loop."
            break
        fi
        echo "No PVCs found in namespace '$NS'. Retrying in 5 seconds..."
        sleep 5
    done
    kubectl uncordon $NODE
done