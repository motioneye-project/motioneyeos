LTTNG_BABELTRACE_SITE    = http://lttng.org/files/babeltrace/
LTTNG_BABELTRACE_VERSION = 1.0.0-rc6
LTTNG_BABELTRACE_SOURCE  = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
