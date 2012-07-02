#############################################################
#
# LTTng-UST: the userspace tracing library
#
#############################################################
LTTNG_LIBUST_SITE    = http://lttng.org/files/lttng-ust/
LTTNG_LIBUST_VERSION = 2.0.3
LTTNG_LIBUST_SOURCE  = lttng-ust-$(LTTNG_LIBUST_VERSION).tar.bz2

LTTNG_LIBUST_INSTALL_STAGING = YES
LTTNG_LIBUST_DEPENDENCIES    = liburcu util-linux

LTTNG_LIBUST_AUTORECONF = YES

$(eval $(autotools-package))
