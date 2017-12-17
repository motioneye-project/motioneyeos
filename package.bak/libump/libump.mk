################################################################################
#
# libump
#
################################################################################

LIBUMP_VERSION = ec0680628744f30b8fac35e41a7bd8e23e59c39f
LIBUMP_SITE = $(call github,linux-sunxi,libump,$(LIBUMP_VERSION))
LIBUMP_LICENSE = Apache-2.0
LIBUMP_AUTORECONF = YES
LIBUMP_INSTALL_STAGING = YES

$(eval $(autotools-package))
