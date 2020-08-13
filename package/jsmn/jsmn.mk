################################################################################
#
# jsmn
#
################################################################################

JSMN_VERSION = 1.1.0
JSMN_SITE = $(call github,zserge,jsmn,v$(JSMN_VERSION))
JSMN_LICENSE = MIT
JSMN_LICENSE_FILES = LICENSE
# single-header, header-only library
JSMN_INSTALL_STAGING = YES
JSMN_INSTALL_TARGET = NO

define JSMN_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/jsmn.h $(STAGING_DIR)/usr/include/jsmn.h
endef

$(eval $(generic-package))
