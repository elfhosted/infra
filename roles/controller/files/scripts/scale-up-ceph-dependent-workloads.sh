#!/bin/bash

# This script is intended to be used to safely shut down all workloads dependent on rook-ceph storage,
# such that maintenance can be performed on the cluster without risk of impacting i/o operations

# Shut down CPNG databases
k annotate cluster -n debridmediamanager debridmediamanager --overwrite cnpg.io/hibernation-
k annotate cluster -n torrentio torrentio --overwrite cnpg.io/hibernation-
k annotate cluster -n kube-prometheus-stack grafana --overwrite cnpg.io/hibernation-
k annotate cluster -n stremio-jackett-cacher stremio-jackett-cacher --overwrite cnpg.io/hibernation-

# Annatar
k scale deployment -n annatar --replicas 1
k scale statefulset -n annatar --replicas 1

# Chartmuseum
k scale deployment -n chartmuseum --replicas 1

# Jacketito
k scale deployment -n jackettio --replicas 1

# Mediafusion
k scale deployment -n mediafusion --replicas 1
k scale statefulset -n mediafusion --replicas 1

# Torrentio
k scale deployment -n torrentio --replicas 2
k scale statefulset -n torrentio --replicas 1