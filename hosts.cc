
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

[k3s_agents]
yankee01  ansible_host=yankee01.elfhosted.cc cluster_ip=192.168.44.21 external_ip=23.147.152.164 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.164/29,192.168.44.21/24] gateway4=23.147.152.161
yankee02  ansible_host=yankee02.elfhosted.cc cluster_ip=192.168.44.22 external_ip=23.147.152.162 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.162/29,192.168.44.22/24] gateway4=23.147.152.161
yankee03  ansible_host=yankee03.elfhosted.cc cluster_ip=192.168.44.23 external_ip=23.147.152.163 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.163/29,192.168.44.23/24] gateway4=23.147.152.161

# We use these for doing ansible installs
# There's no DNS here but these are saved entries in my .ssh/config
[public_hosts]
yankee01-public.elfhosted.cc
yankee02-public.elfhosted.cc
yankee03-public.elfhosted.cc

eagle01-public.elfhosted.cc

[k3s_elves]


[k3s_rangers]
yankee01
yankee02

[k3s_hobbits]

[controllers]
eagle01

[k3s_observability]
eagle01

[k3s_goblins]