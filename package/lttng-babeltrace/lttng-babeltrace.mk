################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE    = http://lttng.org/files/babeltrace/
LTTNG_BABELTRACE_VERSION = 1.1.1
LTTNG_BABELTRACE_SOURCE  = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2
LTTNG_BABELTRACE_LICENSE = MIT; LGPLv2 for include/babeltrace/list.h; GPLv3+ for formats/ctf/metadata/ctf-parser.h
LTTNG_BABELTRACE_LICENSE_FILES = mit-license.txt LICENSE

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2

$(eval $(autotools-package))
$(eval $(host-autotools-package))
