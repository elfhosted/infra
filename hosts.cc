
[cc:children]
k3s_servers
k3s_agents
k3s_contended
k3s_dedicated
controllers
public_hosts

[k3s_servers]
eagle01   ansible_host=eagle01.elfhosted.cc cluster_ip=192.168.44.11 external_ip=23.147.152.166 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.166/29,192.168.44.11/24,fd00:192:168:44:0::11/118] gateway4=23.147.152.161 keepalived_priority=130
eagle02   ansible_host=eagle02.elfhosted.cc cluster_ip=192.168.44.12 external_ip=23.147.152.165 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.165/29,192.168.44.12/24,fd00:192:168:44:0::12/118] gateway4=23.147.152.161 keepalived_priority=120
eagle03   ansible_host=eagle03.elfhosted.cc cluster_ip=192.168.44.13 external_ip=23.147.152.157 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.157/29,192.168.44.13/24,fd00:192:168:44:0::13/118] gateway4=23.147.152.153 keepalived_priority=110

[k3s_agents]
yankee01  ansible_host=yankee01.elfhosted.cc cluster_ip=192.168.44.21 external_ip=23.147.152.164 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.164/29,192.168.44.21/24,fd00:192:168:44:0::21/118] gateway4=23.147.152.161
yankee02  ansible_host=yankee02.elfhosted.cc cluster_ip=192.168.44.22 external_ip=23.147.152.162 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.162/29,192.168.44.22/24,fd00:192:168:44:0::22/118] gateway4=23.147.152.161
yankee03  ansible_host=yankee03.elfhosted.cc cluster_ip=192.168.44.23 external_ip=23.147.152.163 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.163/29,192.168.44.23/24,fd00:192:168:44:0::23/118] gateway4=23.147.152.161

yankee04  ansible_host=yankee04.elfhosted.cc cluster_ip=192.168.44.24 external_ip=23.147.152.154 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.154/29,192.168.44.24/24,fd00:192:168:44:0::24/118] gateway4=23.147.152.153
yankee05  ansible_host=yankee05.elfhosted.cc cluster_ip=192.168.44.25 external_ip=23.147.152.155 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.155/29,192.168.44.25/24,fd00:192:168:44:0::25/118] gateway4=23.147.152.153
yankee06  ansible_host=yankee06.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.156 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.156/29,192.168.44.26/24,fd00:192:168:44:0::26/118] gateway4=23.147.152.153
yankee07  ansible_host=yankee07.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.158 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.158/29,192.168.44.27/24,fd00:192:168:44:0::27/118] gateway4=23.147.152.153

yankee08  ansible_host=yankee08.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.130 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.130/29,192.168.44.28/24,fd00:192:168:44:0::28/118] gateway4=23.147.152.129
yankee09  ansible_host=yankee09.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.131 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.131/29,192.168.44.29/24,fd00:192:168:44:0::29/118] gateway4=23.147.152.129
yankee10  ansible_host=yankee10.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.132 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.132/29,192.168.44.30/24,fd00:192:168:44:0::30/118] gateway4=23.147.152.129
yankee11  ansible_host=yankee11.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.133 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.133/29,192.168.44.31/24,fd00:192:168:44:0::31/118] gateway4=23.147.152.129
yankee12  ansible_host=yankee12.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.134 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.134/29,192.168.44.32/24,fd00:192:168:44:0::32/118] gateway4=23.147.152.129
yankee13  ansible_host=yankee13.elfhosted.cc cluster_ip=192.168.44.26 external_ip=23.147.152.135 cluster_nic=bond0 interfaces=["enp1s0f0","enp1s0f1"] addresses=[23.147.152.135/29,192.168.44.33/24,fd00:192:168:44:0::33/118] gateway4=23.147.152.129

# We use these for doing ansible installs
# There's no DNS here but these are saved entries in my .ssh/config
[public_hosts]
yankee01-public.elfhosted.cc
yankee02-public.elfhosted.cc
yankee03-public.elfhosted.cc
yankee04-public.elfhosted.cc
yankee05-public.elfhosted.cc
yankee06-public.elfhosted.cc
yankee07-public.elfhosted.cc
yankee08-public.elfhosted.cc
yankee09-public.elfhosted.cc
yankee10-public.elfhosted.cc
yankee11-public.elfhosted.cc
yankee12-public.elfhosted.cc
yankee13-public.elfhosted.cc

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
yankee07
yankee08
yankee09
yankee10
yankee11
yankee12
yankee13

[k3s_dedicated]
yankee01
yankee02
yankee03
yankee04
yankee05
yankee06
yankee07
yankee08
yankee09
yankee10
yankee11
yankee12
yankee13

[controllers]
eagle01
