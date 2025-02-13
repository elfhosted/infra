#!/bin/bash

NAMESPACES=$(kubectl get pods -A -l app.kubernetes.io/name=filebrowser | cut -f1 -d" ")
for NS in ${NAMESPACES}
do
    USER=$(echo $NS | cut -f2 -d-)
    USED=$(kubectl -n aa-${USER} exec -it $(kubectl -n aa-${USER} get pod -l "app.kubernetes.io/name=filebrowser" -o jsonpath='{.items[0].metadata.name}') -c ${USER}-filebrowser -- df -h /storage/config | grep /storage/config | awk -s '{print $3}')
    if [ "$USED" == "140M" ]; then

        kubectl delete helmrelease -n aa-$USER $USER
        kubectl delete pvc -n aa-$USER --all
        flux reconcile kustomization aa-$USER

        # Loop until PVCs are found
        while true; do
            # Check for any PVCs in the namespace
            if kubectl get pvc -n "aa-$USER" --no-headers | grep -q .; then
                echo "PVCs found in namespace 'aa-$USER'. Exiting loop."
                break
            fi
            echo "No PVCs found in namespace 'aa-$USER'. Retrying in 5 seconds..."
            sleep 5
        done

    fi
done