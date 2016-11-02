################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE = http://www.efficios.com/files/babeltrace
LTTNG_BABELTRACE_VERSION = 1.4.0
LTTNG_BABELTRACE_SOURCE = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2
LTTNG_BABELTRACE_LICENSE = MIT, LGPLv2.1 (include/babeltrace/list.h), GPLv2 (test code)
LTTNG_BABELTRACE_LICENSE_FILES = mit-license.txt gpl-2.0.txt LICENSE
LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2 host-pkgconf
LTTNG_BABELTRACE_CONF_OPTS += --disable-debug-info
HOST_LTTNG_BABELTRACE_DEPENDENCIES = \
	host-popt host-util-linux host-libglib2 host-pkgconf

$(eval $(autotools-package))
$(eval $(host-autotools-package))
