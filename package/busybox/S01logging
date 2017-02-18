#!/bin/sh
#
# Start logging
#

SYSLOGD_ARGS=-n
KLOGD_ARGS=-n
[ -r /etc/default/logging ] && . /etc/default/logging

start() {
	printf "Starting logging: "
	start-stop-daemon -b -S -q -m -p /var/run/syslogd.pid --exec /sbin/syslogd -- $SYSLOGD_ARGS
	start-stop-daemon -b -S -q -m -p /var/run/klogd.pid --exec /sbin/klogd -- $KLOGD_ARGS
	echo "OK"
}

stop() {
	printf "Stopping logging: "
	start-stop-daemon -K -q -p /var/run/syslogd.pid
	start-stop-daemon -K -q -p /var/run/klogd.pid
	echo "OK"
}

case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  restart|reload)
	stop
	start
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
