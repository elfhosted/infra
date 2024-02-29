#!/bin/bash

# This script is intended to be used to safely shut down all workloads dependent on rook-ceph storage,
# such that maintenance can be performed on the cluster without risk of impacting i/o operations

# Shut down CPNG databases
k annotate cluster -n debridmediamanager debridmediamanager --overwrite cnpg.io/hibernation=on
k annotate cluster -n torrentio torrentio --overwrite cnpg.io/hibernation=on
k annotate cluster -n kube-prometheus-stack grafana --overwrite cnpg.io/hibernation=on
k annotate cluster -n stremio-jackett-cacher stremio-jackett-cacher --overwrite cnpg.io/hibernation=on

# Annatar
k scale deployment -n annatar --replicas 0
k scale statefulset -n annatar --replicas 0

# Chartmuseum
k scale deployment -n chartmuseum --replicas 0

# Jacketito
k scale deployment -n jackettio --replicas 0

# Mediafusion
k scale deployment -n mediafusion --replicas 0
k scale statefulset -n mediafusion --replicas 0

# Torrentio
k scale deployment -n torrentio --replicas 0
k scale statefulset -n torrentio --replicas 0
