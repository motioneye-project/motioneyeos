################################################################################
#
# cgilua
#
################################################################################

CGILUA_VERSION = 5.1.4
CGILUA_SITE = http://github.com/downloads/keplerproject/cgilua
CGILUA_LICENSE = MIT

define CGILUA_INSTALL_TARGET_CMDS
	$(MAKE) PREFIX="$(TARGET_DIR)/usr" -C $(@D) install
endef

$(eval $(generic-package))
