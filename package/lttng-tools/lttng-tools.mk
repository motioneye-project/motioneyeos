LTTNG_TOOLS_VERSION = 2.0-pre15
LTTNG_TOOLS_SITE    = http://lttng.org/files/bundles/20111214/
LTTNG_TOOLS_SOURCE  = lttng-tools-$(LTTNG_TOOLS_VERSION).tar.bz2

# The host-lttng-babeltrace technically isn't a required build
# dependency. However, having the babeltrace utilities built for the
# host is very useful, since those tools allow to convert the binary
# trace format into an human readable format.
LTTNG_TOOLS_DEPENDENCIES = liburcu popt host-lttng-babeltrace lttng-libust

$(eval $(call AUTOTARGETS))
