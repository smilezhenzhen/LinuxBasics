#!/bin/bash

vip='172.29.229.250'
mask='255.255.255.255'

case $1 in
start)
	echo "lo:0 port starting"
	echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
	echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
	echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
	echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce    #限制arp请求
	ifconfig lo:0 $vip netmask $mask broadcast $vip up  #lo接口绑定vip
	route add -host $vip dev lo:0
	;;
stop)
	echo "lo:0 port closing"
        echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
        echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
        echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
        echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
	;;
*)
	echo "Usage $(basename $0) start|stop"
	exit 1
	;;
esac
