################################################################################
#
# zyre
#
################################################################################

ZYRE_VERSION = v2.0.0
ZYRE_SITE = $(call github,zeromq,zyre,$(ZYRE_VERSION))
ZYRE_LICENSE = MPL-2.0
ZYRE_LICENSE_FILES = LICENSE
ZYRE_INSTALL_STAGING = YES
ZYRE_DEPENDENCIES = czmq zeromq host-pkgconf
ZYRE_AUTORECONF = YES
ZYRE_CONF_OPTS = --without-docs

define ZYRE_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

ZYRE_POST_PATCH_HOOKS += ZYRE_CREATE_CONFIG_DIR

$(eval $(autotools-package))
