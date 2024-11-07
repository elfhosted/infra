
[cc:children]
k3s_servers
k3s_agents
k3s_observability
k3s_elves   # customer workloads
k3s_rangers # dedicated customer nodes
k3s_hobbits # lightweight rangers
controllers
public_hosts

[k3s_servers]
eagle01   ansible_host=eagle01.elfhosted.cc cluster_ip=192.168.44.11 external_ip=23.147.152.166 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.166/29,192.168.44.11/24] gateway4=23.147.152.161 keepalived_priority=130
eagle02   ansible_host=eagle02.elfhosted.cc cluster_ip=192.168.44.12 external_ip=23.147.152.165 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.165/29,192.168.44.12/24] gateway4=23.147.152.161 keepalived_priority=120
eagle03   ansible_host=eagle03.elfhosted.cc cluster_ip=192.168.44.13 external_ip=23.147.152.157 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.157/29,192.168.44.13/24] gateway4=23.147.152.153 keepalived_priority=110

[k3s_agents]
yankee01  ansible_host=yankee01.elfhosted.cc cluster_ip=192.168.44.21 external_ip=23.147.152.164 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.164/29,192.168.44.21/24] gateway4=23.147.152.161
yankee02  ansible_host=yankee02.elfhosted.cc cluster_ip=192.168.44.22 external_ip=23.147.152.162 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.162/29,192.168.44.22/24] gateway4=23.147.152.161
yankee03  ansible_host=yankee03.elfhosted.cc cluster_ip=192.168.44.23 external_ip=23.147.152.163 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.163/29,192.168.44.23/24] gateway4=23.147.152.161
yankee04  ansible_host=yankee04.elfhosted.cc cluster_ip=192.168.44.24 external_ip=23.147.152.154 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.154/29,192.168.44.24/24] gateway4=23.147.152.153
yankee05  ansible_host=yankee05.elfhosted.cc cluster_ip=192.168.44.25 external_ip=23.147.152.155 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.155/29,192.168.44.25/24] gateway4=23.147.152.153
yankee06  ansible_host=yankee06.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.156 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.156/29,192.168.44.26/24] gateway4=23.147.152.153


# We use these for doing ansible installs
# There's no DNS here but these are saved entries in my .ssh/config
[public_hosts]
yankee01-public.elfhosted.cc
yankee02-public.elfhosted.cc
yankee03-public.elfhosted.cc
yankee04-public.elfhosted.cc
yankee05-public.elfhosted.cc
yankee06-public.elfhosted.cc

eagle01-public.elfhosted.cc
eagle02-public.elfhosted.cc
eagle03-public.elfhosted.cc


[k3s_elves]

[k3s_contended]
yankee01
yankee02
yankee03
yankee04
yankee05
yankee06

[k3s_dedicated]
yankee01
yankee02
yankee03
yankee04
yankee05
yankee06

[k3s_hobbits]

[controllers]
eagle01

[k3s_observability]
eagle01

[k3s_goblins]