#############################################################
#
# fwup
#
#############################################################

FWUP_VERSION = v0.7.0
FWUP_SITE = $(call github,fhunleth,fwup,$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_DEPENDENCIES = libconfuse libarchive libsodium
FWUP_AUTORECONF = YES

define FWUP_ADD_M4_DIR
	mkdir -p $(@D)/m4
endef

FWUP_POST_PATCH_HOOKS += FWUP_ADD_M4_DIR
HOST_FWUP_POST_PATCH_HOOKS += FWUP_ADD_M4_DIR

$(eval $(autotools-package))
$(eval $(host-autotools-package))
