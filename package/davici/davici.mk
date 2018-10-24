################################################################################
#
# davici
#
################################################################################

DAVICI_VERSION = v1.3
DAVICI_SITE = $(call github,strongswan,davici,$(DAVICI_VERSION))
DAVICI_LICENSE = LGPL-2.1+
DAVICI_LICENSE_FILES = COPYING
DAVICI_DEPENDENCIES = strongswan
DAVICI_INSTALL_STAGING = YES
DAVICI_AUTORECONF = YES

define DAVICI_CREATE_M4
	mkdir -p $(@D)/m4
endef
DAVICI_POST_PATCH_HOOKS += DAVICI_CREATE_M4

$(eval $(autotools-package))
