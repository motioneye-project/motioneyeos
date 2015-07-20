################################################################################
#
# lttng-tools
#
################################################################################

LTTNG_TOOLS_VERSION = 2.6.0
LTTNG_TOOLS_SITE = http://lttng.org/files/lttng-tools
LTTNG_TOOLS_SOURCE = lttng-tools-$(LTTNG_TOOLS_VERSION).tar.bz2
LTTNG_TOOLS_LICENSE = GPLv2+; LGPLv2.1+ for include/lttng/* and src/lib/lttng-ctl/*
LTTNG_TOOLS_LICENSE_FILES = gpl-2.0.txt lgpl-2.1.txt LICENSE
LTTNG_TOOLS_CONF_OPTS += --with-xml-prefix=$(STAGING_DIR)/usr

# The host-lttng-babeltrace technically isn't a required build
# dependency. However, having the babeltrace utilities built for the
# host is very useful, since those tools allow to convert the binary
# trace format into an human readable format.
LTTNG_TOOLS_DEPENDENCIES = liburcu libxml2 popt host-lttng-babeltrace util-linux

ifeq ($(BR2_PACKAGE_LTTNG_LIBUST),y)
LTTNG_TOOLS_CONF_OPTS += --enable-lttng-ust
LTTNG_TOOLS_DEPENDENCIES += lttng-libust
else
LTTNG_TOOLS_CONF_OPTS += --disable-lttng-ust
endif

$(eval $(autotools-package))
