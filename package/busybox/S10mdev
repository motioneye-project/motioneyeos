#!/bin/sh
#
# Start mdev....
#

case "$1" in
  start)
	echo "Starting mdev..."
	echo /sbin/mdev >/proc/sys/kernel/hotplug
	/sbin/mdev -s
	;;
  stop)
	;;
  restart|reload)
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
