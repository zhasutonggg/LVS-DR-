#!/bin/bash
#chkconfig: - 28 71
#desription: LVS FOR DR is real server
LOCK=/var/lock/ipvsadm.lock
VIP=192.168.132.80
. /etc/init.d/functions
start() {
	PID=`ifconfig |grep lo:10|wc -l`
	if [ $PID -ne 0 ];then
		echo "The LVS-DR-RIP is already running"
	else
		/sbin/ifconfig lo:10 $VIP netmask 255.255.255.255 broadcast $VIP up
		/sbin/route add -host $VIP dev lo:10
		echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
		echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
		echo "1" >/proc/sys/net/ipv4/conf/ens33/arp_ignore
		echo "2" >/proc/sys/net/ipv4/conf/ens33/arp_announce
		echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
		echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce	
		/bin/touch $LOCK
		echo "Start LVS-DR-RIP server is OK"
		
	fi
}

stop() {
	/sbin/route del -host $VIP dev lo:10
	/sbin/ifconfig lo:10 down >/dev/null
	echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
	echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    	echo "0" >/proc/sys/net/ipv4/conf/ens33/arp_ignore
    	echo "0" >/proc/sys/net/ipv4/conf/ens33/arp_announce
    	echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    	echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
	rm -rf $LOCK
	echo "Stopping LVS-DR-RIP  is OK"
}

status() {
	if [ -e $LOCK ];
	then
	echo "The LVS-DR-RIP  is running"
	else
	echo "The LVS-DR-RIP  is not running"
	fi
}
select chance in start stop status restart quit;do
case "$REPLY" in
	1)
		start
		exit 0
		;;
	3)
		status
		exit 0
		;;
	4)
		stop
		start
		exit 0
		;;
	2)
		stop
		exit 0
		;;
	5)
		echo "bye"
		break
		;;
	*)
		echo "选择错误,请重新选择（1，2，3，4，5）"
		;;
esac
done
