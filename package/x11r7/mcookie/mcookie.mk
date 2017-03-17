################################################################################
#
# mcookie
#
################################################################################

MCOOKIE_LICENSE = Public Domain

define MCOOKIE_EXTRACT_CMDS
	cp package/x11r7/mcookie/mcookie.c $(@D)/
endef

define MCOOKIE_BUILD_CMDS
	(cd $(@D); $(TARGET_CC) -Wall -Os -s mcookie.c -o mcookie)
endef

define MCOOKIE_INSTALL_TARGET_CMDS
	install -m 0755 -D $(@D)/mcookie $(TARGET_DIR)/usr/bin/mcookie
endef

$(eval $(generic-package))
