################################################################################
#
# sl
#
################################################################################

SL_VERSION = 5.02
SL_SITE = $(call github,mtoyoda,sl,$(SL_VERSION))
SL_LICENSE = Custom
SL_LICENSE_FILES = LICENSE
SL_DEPENDENCIES = ncurses

define SL_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define SL_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/sl $(TARGET_DIR)/usr/bin/sl
endef

$(eval $(generic-package))
