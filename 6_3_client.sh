#!/bin/bash -x


sudo ip netns exec client dhclient c-veth0
sudo ip netns exec client ip address show
