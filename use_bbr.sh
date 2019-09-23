#!/bin/bash

function add_bbr()
{
    sudo echo "# Added by RJ env set" >> /etc/sysctl.conf
    sudo echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    sudo echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sudo sysctl -p
}

sysctl net.ipv4.tcp_congestion_control | grep "bbr" >/dev/null
if [ $? -ne 0 ]; then
    add_bbr
    sysctl net.ipv4.tcp_congestion_control | grep "bbr" >/dev/null
    [[ $? -ne 0 ]] && echo "Cudnot set bbr!"
else
    echo "TCP congestion control is already set to BBR!"
fi

