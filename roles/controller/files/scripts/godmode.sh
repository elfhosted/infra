#!/bin/bash
USER=$1

kubectl -n aa-${USER} exec -it $(kubectl -n aa-${USER} get pod -l "app.kubernetes.io/name=filebrowser" -o jsonpath='{.items[0].metadata.name}') -c ${USER}-filebrowser /bin/bash