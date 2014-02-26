################################################################################
#
# zyre
#
################################################################################

ZYRE_VERSION = 378b8b5cf76d10f5e41b339a4bcb0dc6197a9edf
ZYRE_SITE = $(call github,zeromq,zyre,$(ZYRE_VERSION))
ZYRE_LICENSE = LGPLv3+
ZYRE_LICENSE_FILES = COPYING COPYING.LESSER
ZYRE_INSTALL_STAGING = YES
ZYRE_DEPENDENCIES = filemq
ZYRE_AUTORECONF = YES

define ZYRE_CREATE_CONFIG_DIR
	mkdir -p $(@D)/config
endef

ZYRE_POST_PATCH_HOOKS += ZYRE_CREATE_CONFIG_DIR

$(eval $(autotools-package))
