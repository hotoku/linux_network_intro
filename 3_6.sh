#!/bin/bash -x

ip netns list | awk '{print $1}' | xargs -n1 sudo ip netns delete
sudo ip addr flush dev eth0


sudo ip netns add ns1
sudo ip netns add ns2
sudo ip netns add router1
sudo ip netns add router2

sudo ip link add ns1-veth0 type veth peer name gw1-veth0
sudo ip link add gw1-veth1 type veth peer name gw2-veth0
sudo ip link add gw2-veth1 type veth peer name ns2-veth0

sudo ip link set ns1-veth0 netns ns1
sudo ip link set gw1-veth0 netns router1
sudo ip link set gw1-veth1 netns router1
sudo ip link set gw2-veth0 netns router2
sudo ip link set gw2-veth1 netns router2
sudo ip link set ns2-veth0 netns ns2

sudo ip netns exec ns1     ip address add 192.0.2.1/24 dev ns1-veth0
sudo ip netns exec router1 ip address add 192.0.2.254/24 dev gw1-veth0
sudo ip netns exec router1 ip address add 203.0.113.1/24 dev gw1-veth1
sudo ip netns exec router2 ip address add 203.0.113.2/24 dev gw2-veth0
sudo ip netns exec router2 ip address add 198.51.100.254/24 dev gw2-veth1
sudo ip netns exec ns2     ip address add 198.51.100.1/24 dev ns2-veth0

sudo ip netns exec ns1     ip link set ns1-veth0 up
sudo ip netns exec router1 ip link set gw1-veth0 up
sudo ip netns exec router1 ip link set gw1-veth1 up
sudo ip netns exec router2 ip link set gw2-veth0 up
sudo ip netns exec router2 ip link set gw2-veth1 up
sudo ip netns exec ns2     ip link set ns2-veth0 up

sudo ip netns exec ns1 ip route add default via 192.0.2.254
sudo ip netns exec ns2 ip route add default via 198.51.100.254
sudo ip netns exec router1 sysctl net.ipv4.ip_forward=1
sudo ip netns exec router2 sysctl net.ipv4.ip_forward=1

sudo ip netns exec router1 ip route add 198.51.100.0/24 via 203.0.113.2
sudo ip netns exec router2 ip route add 192.0.2.0/24 via 203.0.113.1

