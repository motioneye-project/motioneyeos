################################################################################
#
# xavante
#
################################################################################

XAVANTE_VERSION = 2.2.1
XAVANTE_SITE = http://github.com/downloads/keplerproject/xavante
XAVANTE_LICENSE = MIT

define XAVANTE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) PREFIX="$(TARGET_DIR)/usr" install
endef

$(eval $(generic-package))
