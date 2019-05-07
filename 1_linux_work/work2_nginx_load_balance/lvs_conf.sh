#!/bin/bash

vip='172.29.229.250'
iface='eth0:0'
mask='255.255.255.255'
port='80'
nginx1='172.29.229.200'
nginx2='172.29.229.202'
#drgw='172.29.229.194'

#./etc/rc.d/init.d/functions   #调用init.d脚本的标准库
case $1 in
start)
	echo "start lvs of dr mode"
	ifconfig $iface $vip netmask $mask broadcast $vip up #绑定虚拟ip
	route add -host $vip dev $iface          #添加路由规则
	echo "1" > /proc/sys/net/ipv4/ip_forward #开启路由转发功能
	ipvsadm --clear    #清除原有转发规则
	#route add default gw $drgw
	iptables -F
	ipvsadm -A -t ${vip}:${port} -s rr           #添加虚拟IP规则
	ipvsadm -a -t ${vip}:${port} -r ${nginx1}:${port} -g  #在虚拟IP中添加服务规则
	ipvsadm -a -t ${vip}:${port} -r ${nginx2}:${port} -g  #在虚拟IP中添加服务规则
	ipvsadm --set 30 120 300   #设置tcp tcpfin udp的超时连接值
	ipvsadm
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




