################################################################################
#
# lttng-libust
#
################################################################################

LTTNG_LIBUST_SITE    = http://lttng.org/files/lttng-ust/
LTTNG_LIBUST_VERSION = 2.2.0
LTTNG_LIBUST_SOURCE  = lttng-ust-$(LTTNG_LIBUST_VERSION).tar.bz2
LTTNG_LIBUST_LICENSE = LGPLv2.1; GPLv2 for lttng-gen-tp and ust-ctl
LTTNG_LIBUST_LICENSE_FILES = COPYING

LTTNG_LIBUST_INSTALL_STAGING = YES
LTTNG_LIBUST_DEPENDENCIES    = liburcu util-linux

LTTNG_LIBUST_AUTORECONF = YES

$(eval $(autotools-package))
