################################################################################
#
# zyre
#
################################################################################

ZYRE_VERSION = a351468b7d313fc90c446668122365851a9c60e4
ZYRE_SITE = $(call github,zeromq,zyre,$(ZYRE_VERSION))
ZYRE_LICENSE = LGPLv3+
ZYRE_LICENSE_FILES = COPYING COPYING.LESSER
ZYRE_INSTALL_STAGING = YES
ZYRE_DEPENDENCIES = czmq zeromq host-pkgconf
ZYRE_AUTORECONF = YES

define ZYRE_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

ZYRE_POST_PATCH_HOOKS += ZYRE_CREATE_CONFIG_DIR

$(eval $(autotools-package))
