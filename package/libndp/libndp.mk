################################################################################
#
# libndp
#
################################################################################

LIBNDP_VERSION = v1.4
LIBNDP_SITE = $(call github,jpirko,libndp,$(LIBNDP_VERSION))
LIBNDP_LICENSE = LGPLv2.1+
LIBNDP_LICENSE_FILES = COPYING
LIBNDP_AUTORECONF = YES
LIBNDP_INSTALL_STAGING = YES
LIBNDP_CONF_OPT = --disable-debug

$(eval $(autotools-package))
