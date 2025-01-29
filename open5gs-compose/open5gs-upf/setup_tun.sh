#!/bin/sh

if ! grep "ogstun" /proc/net/dev > /dev/null; then
    ip tuntap add name ogstun mode tun
fi

if [ -n "${SUBNET_V4}" ]; then
    ip addr del ${SUBNET_V4} dev ogstun 2> /dev/null
    ip addr add ${SUBNET_V4} dev ogstun
fi

# if [ -n "${SUBNET_V6}" ]; then
#     ip addr del 2001:db8:cafe::1/48 dev ogstun 2> /dev/null
#     ip addr add 2001:db8:cafe::1/48 dev ogstun
# fi

ip link set ogstun up
iptables -t nat -A POSTROUTING -s `echo ${SUBNET_V4} | sed 's/\.1\//.0\//g'` ! -o ogstun -j MASQUERADE
