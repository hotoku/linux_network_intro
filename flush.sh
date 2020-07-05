#!/bin/bash -x

for n in $(ip netns | awk '{print $1}'); do
    sudo ip netns exec $n ip neigh flush all
done
