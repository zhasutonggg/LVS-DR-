#!/bin/bash
#chkconfig: - 28 71
#desription: LVS FOR DR
LOCK=/var/lock/ipvsadm.lock
VIP=192.168.132.80
RIP1=192.168.132.189
RIP2=192.168.132.190
NETNAME=ens33
. /etc/init.d/functions
start() {
	PID=`ipvsadm -Ln|grep ${VIP} |wc -l`
	if [ $PID -gt 0 ];then
		echo "The LVS-DR is already Running"
	else
		/sbin/ifconfig ${NETNAME}:10 $VIP broadcast $VIP netmask 255.255.255.255 up
		/sbin/route add -host $VIP dev ${NETNAME}:10
		/sbin/ipvsadm -A -t $VIP:80 -s rr
		/sbin/ipvsadm -at $VIP:80 -r $RIP1:80 -g
		/sbin/ipvsadm -at $VIP:80 -r $RIP2:80 -g
		/bin/touch $LOCK
		echo "Starting LVS-DR is ok"
	fi
}

stop() {
		/sbin/ipvsadm -C
		/sbin/route del -host $VIP dev ${NETNAME}:10
		/sbin/ifconfig ${NETNAME}:10 down >/dev/null
		rm -rf $LOCK
		echo "Stopping LVS-DR is OK"

}
status() {
	if [ -e $LOCK ];then
		echo "The LVS-DR is Running"
	else
		echo "The LVS-DR is Stopping"
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
