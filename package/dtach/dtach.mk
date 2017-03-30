################################################################################
#
# dtach
#
################################################################################

DTACH_VERSION = v0.9
DTACH_SITE = $(call github,crigler,dtach,$(DTACH_VERSION))
DTACH_LICENSE = GPL-2.0+
DTACH_LICENSE_FILES = COPYING

# The Makefile does not have an install target.
define DTACH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/dtach $(TARGET_DIR)/usr/bin/dtach
endef

$(eval $(autotools-package))
