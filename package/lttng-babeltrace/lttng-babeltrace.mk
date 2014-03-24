################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE    = http://lttng.org/files/babeltrace/
LTTNG_BABELTRACE_VERSION = 1.2.1
LTTNG_BABELTRACE_SOURCE  = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2
LTTNG_BABELTRACE_LICENSE = MIT; LGPL2.1 for include/babeltrace/list.h; GPLv2+ for test code
LTTNG_BABELTRACE_LICENSE_FILES = mit-license.txt gpl-2.0.txt LICENSE

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
