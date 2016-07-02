################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE = http://lttng.org/files/babeltrace
LTTNG_BABELTRACE_VERSION = 1.2.4
LTTNG_BABELTRACE_SOURCE = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2
LTTNG_BABELTRACE_LICENSE = MIT, LGPLv2.1 (include/babeltrace/list.h), GPLv2 (test code)
LTTNG_BABELTRACE_LICENSE_FILES = mit-license.txt gpl-2.0.txt LICENSE

LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2 host-pkgconf
HOST_LTTNG_BABELTRACE_DEPENDENCIES = \
	host-popt host-util-linux host-libglib2 host-pkgconf

# for 0002-configure-fix-uuid-support-detection-on-static-build.patch
LTTNG_BABELTRACE_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
