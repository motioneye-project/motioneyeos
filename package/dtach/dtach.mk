################################################################################
#
# dtach
#
################################################################################

DTACH_VERSION = 0.8
DTACH_SITE = http://downloads.sourceforge.net/project/dtach/dtach/$(DTACH_VERSION)
DTACH_LICENSE = GPLv2+
DTACH_LICENSE_FILES = COPYING

# The Makefile does not have an install target.
define DTACH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/dtach $(TARGET_DIR)/usr/bin/dtach
endef

$(eval $(autotools-package))
