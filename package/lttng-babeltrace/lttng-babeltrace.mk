################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE    = http://lttng.org/files/babeltrace/
LTTNG_BABELTRACE_VERSION = 1.0.2
LTTNG_BABELTRACE_SOURCE  = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2

# One patch touches configure.ac
LTTNG_BABELTRACE_AUTORECONF = YES
HOST_LTTNG_BABELTRACE_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
