################################################################################
#
# dash
#
################################################################################

DASH_VERSION = 0.5.7
DASH_SOURCE = dash_$(DASH_VERSION).orig.tar.gz
DASH_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/d/dash
DASH_PATCH = dash_$(DASH_VERSION)-3.diff.gz
DASH_LICENSE = BSD-3c, GPLv2+ (mksignames.c)
DASH_LICENSE_FILES = COPYING

define DASH_INSTALL_TARGET_CMDS
	cp -a $(@D)/src/dash $(TARGET_DIR)/bin/dash
endef

$(eval $(autotools-package))
