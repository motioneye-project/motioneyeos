################################################################################
#
# lcdapi
#
################################################################################

LCDAPI_VERSION = dbbdca06f271b8cf81b4817a9da3d558cfe59905
LCDAPI_SITE = $(call github,spdawson,lcdapi,$(LCDAPI_VERSION))
LCDAPI_LICENSE = LGPLv2.1+
LCDAPI_LICENSE_FILES = COPYING
LCDAPI_AUTORECONF = YES
LCDAPI_INSTALL_STAGING = YES

define LCDAPI_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

LCDAPI_POST_PATCH_HOOKS += LCDAPI_CREATE_M4_DIR

$(eval $(autotools-package))
