################################################################################
#
# lcdapi
#
################################################################################

LCDAPI_VERSION = v0.11
LCDAPI_SITE = $(call github,spdawson,lcdapi,$(LCDAPI_VERSION))
LCDAPI_LICENSE = LGPL-2.1+
LCDAPI_LICENSE_FILES = COPYING
LCDAPI_AUTORECONF = YES
LCDAPI_INSTALL_STAGING = YES

define LCDAPI_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

LCDAPI_POST_PATCH_HOOKS += LCDAPI_CREATE_M4_DIR

$(eval $(autotools-package))
