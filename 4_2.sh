#!/bin/bash -x

ip netns list | awk '{print $1}' | xargs -n1 sudo ip netns delete
sudo ip addr flush dev eth0

sudo ip netns add ns1
sudo ip netns add ns2

sudo ip link add ns1-veth0 type veth peer name ns2-veth0

sudo ip link set ns1-veth0 netns ns1
sudo ip link set ns2-veth0 netns ns2

sudo ip netns exec ns1 ip link set ns1-veth0 up
sudo ip netns exec ns2 ip link set ns2-veth0 up

sudo ip netns exec ns1 ip address add 192.0.2.1/24 dev ns1-veth0
sudo ip netns exec ns2 ip address add 192.0.2.2/24 dev ns2-veth0

# MACアドレスの変更
sudo ip netns exec ns1 ip link set dev ns1-veth0 address 00:00:5E:00:53:01
sudo ip netns exec ns2 ip link set dev ns2-veth0 address 00:00:5E:00:53:02
