#############################################################
#
# LTTng-Tools: the trace control client
#
#############################################################
LTTNG_TOOLS_VERSION = 2.0.1
LTTNG_TOOLS_SITE    = http://lttng.org/files/lttng-tools/
LTTNG_TOOLS_SOURCE  = lttng-tools-$(LTTNG_TOOLS_VERSION).tar.bz2

# The host-lttng-babeltrace technically isn't a required build
# dependency. However, having the babeltrace utilities built for the
# host is very useful, since those tools allow to convert the binary
# trace format into an human readable format.
LTTNG_TOOLS_DEPENDENCIES = liburcu popt host-lttng-babeltrace

LTTNG_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LTTNG_LIBUST),y)
LTTNG_TOOLS_CONF_OPT += --enable-lttng-ust
LTTNG_TOOLS_DEPENDENCIES += lttng-libust
else
LTTNG_TOOLS_CONF_OPT += --disable-lttng-ust
endif

$(eval $(autotools-package))
