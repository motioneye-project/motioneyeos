#!/bin/sh

# Based on example script created by Adrian Freihofer
# https://github.com/sbabic/meta-swupdate/blob/master/recipes-support/swupdate/swupdate/swupdate.sh

# Override these variables in sourced script(s) located
# in /usr/lib/swupdate/conf.d or /etc/swupdate/conf.d
SWUPDATE_ARGS="-v ${SWUPDATE_EXTRA_ARGS}"
SWUPDATE_WEBSERVER_ARGS=""
SWUPDATE_SURICATTA_ARGS=""

# source all files from /etc/swupdate/conf.d and /usr/lib/swupdate/conf.d/
# A file found in /etc replaces the same file in /usr
for f in `(test -d /usr/lib/swupdate/conf.d/ && ls -1 /usr/lib/swupdate/conf.d/; test -d /etc/swupdate/conf.d && ls -1 /etc/swupdate/conf.d) | sort -u`; do
  if [ -f /etc/swupdate/conf.d/$f ]; then
    . /etc/swupdate/conf.d/$f
  else
    . /usr/lib/swupdate/conf.d/$f
  fi
done

if [ "$SWUPDATE_WEBSERVER_ARGS" != "" -a  "$SWUPDATE_SURICATTA_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -w "$SWUPDATE_WEBSERVER_ARGS" -u "$SWUPDATE_SURICATTA_ARGS"
elif [ "$SWUPDATE_WEBSERVER_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -w "$SWUPDATE_WEBSERVER_ARGS"
elif [ "$SWUPDATE_SURICATTA_ARGS" != "" ]; then
  exec /usr/bin/swupdate $SWUPDATE_ARGS -u "$SWUPDATE_SURICATTA_ARGS"
else
  exec /usr/bin/swupdate $SWUPDATE_ARGS
fi
