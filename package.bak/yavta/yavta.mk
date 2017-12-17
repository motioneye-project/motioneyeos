################################################################################
#
# yavta
#
################################################################################

YAVTA_VERSION = 82ff2efdb9787737b9f21b6f4759f077c827b238
YAVTA_SITE = git://git.ideasonboard.org/yavta.git
YAVTA_LICENSE = GPLv2+
YAVTA_LICENSE_FILES = COPYING.GPL

define YAVTA_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define YAVTA_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/yavta $(TARGET_DIR)/usr/bin/yavta
endef

$(eval $(generic-package))
