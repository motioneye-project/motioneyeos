################################################################################
#
# lttng-babeltrace
#
################################################################################

LTTNG_BABELTRACE_SITE = http://www.efficios.com/files/babeltrace
LTTNG_BABELTRACE_VERSION = 1.5.7
LTTNG_BABELTRACE_SOURCE = babeltrace-$(LTTNG_BABELTRACE_VERSION).tar.bz2
LTTNG_BABELTRACE_LICENSE = MIT, LGPL-2.1 (include/babeltrace/list.h), GPL-2.0 (test code)
LTTNG_BABELTRACE_LICENSE_FILES = mit-license.txt gpl-2.0.txt LICENSE
LTTNG_BABELTRACE_DEPENDENCIES = popt util-linux libglib2 host-pkgconf
# The host-elfutils dependency is optional, but since we don't have
# options for host packages, just build support for it
# unconditionally.
HOST_LTTNG_BABELTRACE_DEPENDENCIES = \
	host-popt host-util-linux host-libglib2 host-pkgconf host-elfutils
HOST_LTTNG_BABELTRACE_CONF_OPTS += --enable-debug-info

# We're patching tests/lib/Makefile.am
LTTNG_BABELTRACE_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_ELFUTILS),y)
LTTNG_BABELTRACE_DEPENDENCIES += elfutils
LTTNG_BABELTRACE_CONF_OPTS += --enable-debug-info
LTTNG_BABELTRACE_CONF_ENV += bt_cv_lib_elfutils=yes
else
LTTNG_BABELTRACE_CONF_OPTS += --disable-debug-info
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
