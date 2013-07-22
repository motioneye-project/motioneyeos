################################################################################
#
# lttng-tools
#
################################################################################

LTTNG_TOOLS_VERSION = 2.2.0
LTTNG_TOOLS_SITE    = http://lttng.org/files/lttng-tools/
LTTNG_TOOLS_SOURCE  = lttng-tools-$(LTTNG_TOOLS_VERSION).tar.bz2
LTTNG_TOOLS_LICENSE = GPLv2; LGPLv2.1 for include/lttng/* and src/lib/lttng-ctl/*
# gpl-2.0.txt and lgpl-2.1.txt files are missing from the sources
LTTNG_TOOLS_LICENSE_FILES = LICENSE

# The host-lttng-babeltrace technically isn't a required build
# dependency. However, having the babeltrace utilities built for the
# host is very useful, since those tools allow to convert the binary
# trace format into an human readable format.
LTTNG_TOOLS_DEPENDENCIES = liburcu popt host-lttng-babeltrace util-linux

LTTNG_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LTTNG_LIBUST),y)
LTTNG_TOOLS_CONF_OPT += --enable-lttng-ust
LTTNG_TOOLS_DEPENDENCIES += lttng-libust
else
LTTNG_TOOLS_CONF_OPT += --disable-lttng-ust
endif

$(eval $(autotools-package))
