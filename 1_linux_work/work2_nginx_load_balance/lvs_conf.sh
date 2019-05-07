#!/bin/bash

vip='172.29.229.250'
iface='eth0:0'
mask='255.255.255.0'
port='80'
nginx1='172.29.229.200'
nginx2='172.29.229.202'
scheduler='wrr'
type='-g'
drgw='172.29.229.194'

case $1 in
start)
	echo "start lvs of dr mode"
	echo "1" > /proc/sys/net/ipv4/ip_forward      #开启路由转发功能
	ifconfig $iface $vip netmask $mask broadcast $vip up #绑定虚拟ip
	route add default gw $drgw
	iptables -F
	ipvsadm -A -t ${vip}:${port} -s $scheduler           #添加虚拟服务记录
	ipvsadm -a -t ${vip}:${port} -r ${nginx1} $type -w 1 #添加真实服务记录
	ipvsadm -a -t ${vip}:${port} -r ${nginx2} $type -w 1 #添加真实服务记录
	ipvsadm --set 30 120 300   #设置tcp tcpfin udp的超时连接值
	;;
stop)
	echo "stop lvs dr"
	ipvsadm -C
	ifconfig $iface down
	;;
*)
	echo "Usage $(basebame $0) start|stop"
	exit 1
	;;
esac




