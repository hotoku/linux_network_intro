#!/bin/bash -x

./7_1.sh

sudo ip netns exec router iptables -t nat \
     -A PREROUTING \
     -p tcp \
     --dport  54321 \
     -d 203.0.113.254 \
     -j DNAT \
     --to-destination 192.0.2.1
