
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
us-fairy01   ansible_host=us-fairy01.elfhosted.com cluster_ip=10.0.44.11 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.166/29,10.0.44.11/24] gateway4=23.147.152.161 keepalived_priority=130

[k3s_agents]
us-ranger01  ansible_host=us-ranger01.elfhosted.com cluster_ip=10.0.44.111 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.162/29,10.0.44.111/24] gateway4=23.147.152.161
us-hobbit01  ansible_host=us-hobbit01.elfhosted.com cluster_ip=10.0.44.151 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.164/29,10.0.44.151/24] gateway4=23.147.152.161
us-elf01     ansible_host=10.0.44.21 cluster_ip=10.0.44.21 interfaces=["enp1s0f0","enp1s0f1"] addresses=[x.x.x.x,2606:a8c0:0:b::12/64,2606:a8c0:4:1c::2/64] addresses_internal=[10.0.44.21/24,fd00:10:0:44:0::21/118] gateway4=23.147.152.161 gateway6=2606:a8c0:0:b::1

# We use these for doing ansible installs
# There's no DNS here but these are saved entries in my .ssh/config
[public_hosts]
us-ranger01-public.elfhosted.com
us-hobbit01-public.elfhosted.com
us-fairy01-public.elfhosted.com
us-elf01-public.elfhosted.com

[k3s_elves]
us-elf01

[k3s_rangers]
us-ranger01

[k3s_hobbits]
us-fairy01

[controllers]
us-fairy01

[k3s_observability]
[k3s_goblins]