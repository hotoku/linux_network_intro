#!/bin/bash -x

ip netns list | awk '{print $1}' | xargs -n1 sudo ip netns delete
sudo ip addr flush dev eth0

sudo ip netns add server
sudo ip netns add client

sudo ip link add s-veth0 type veth peer name c-veth0

sudo ip link set s-veth0 netns server
sudo ip link set c-veth0 netns client

sudo ip netns exec server ip link set s-veth0 up
sudo ip netns exec client ip link set c-veth0 up

sudo ip netns exec server ip address add 192.0.2.254/24 dev s-veth0

sudo ip netns exec server dnsmasq \
     --dhcp-range=192.0.2.100,192.0.2.200,255.255.255.0 \
     --interface=s-veth0 \
     --no-daemon
