#!/bin/bash
# Shows addresses assigned to all network interfaces.
ip addr

# Shows the current neighbour table in kernel.
ip neigh

# Bring up interface x.
ip link set x up

# Bring down interface x.
ip link set x down

# Show table routes.
ip route
