#!/bin/bash

RASPIMJPEG_CONF=/data/etc/raspimjpeg.conf
RASPIMJPEG_LOG=/var/log/raspimjpeg.log
MOTIONEYE_CONF=/data/etc/motioneye.conf
STREAMEYE_CONF=/data/etc/streameye.conf
STREAMEYE_LOG=/var/log/streameye.log

test -r $RASPIMJPEG_CONF || exit 1
test -r $STREAMEYE_CONF || exit 1

watch() {
    count=0
    while true; do
        sleep 5
        if ! ps aux | grep raspimjpeg.py | grep -v grep &>/dev/null; then
            logger -t streameye -s "not running, respawning"
            start
        fi
    done
}

function start() {
    pid=$(ps | grep raspimjpeg.py | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
    if [ -n "$pid" ]; then
        return
    fi

    raspimjpeg_opts=""
    while read line; do
        if echo "$line" | grep false &>/dev/null; then
            continue
        fi
        if echo "$line" | grep true &>/dev/null; then
            line=$(echo $line | cut -d ' ' -f 1)
        fi
        raspimjpeg_opts="$raspimjpeg_opts --$line"
    done < $RASPIMJPEG_CONF

    source $STREAMEYE_CONF
    streameye_opts="-p $PORT"
    if [ -n "$CREDENTIALS" ] && [ "$AUTH" = "basic" ]; then
        streameye_opts="$streameye_opts -a basic -c $CREDENTIALS"
    fi

    if [ -r $MOTIONEYE_CONF ] && grep 'log-level debug' $MOTIONEYE_CONF >/dev/null; then
        raspimjpeg_opts="$raspimjpeg_opts -d"
        streameye_opts="$streameye_opts -d"
    fi

    raspimjpeg.py $raspimjpeg_opts 2>$RASPIMJPEG_LOG | streameye $streameye_opts &>$STREAMEYE_LOG &
}

function stop() {
    # stop the streameye background watch process
    ps | grep streameye | grep -v $$ | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1 | xargs -r kill

    # stop the raspimjpeg process
    pid=$(ps | grep raspimjpeg.py | grep -v grep | tr -s ' ' | sed -e 's/^\s//' | cut -d ' ' -f 1)
    if [ -z "$pid" ]; then
        return
    fi
    
    kill -HUP "$pid" &>/dev/null
    count=0
    while kill -0 "$pid" &>/dev/null && [ $count -lt 5 ]; do
        sleep 1
        count=$(($count + 1))
    done
    kill -KILL "$pid" &>/dev/null
}

case "$1" in
    start)
        start
        watch &
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        start
        watch &
        ;;

    *)
        echo $"Usage: $0 {start|stop|restart}"
        exit 1
esac

