################################################################################
#
# wsapi
#
################################################################################

WSAPI_VERSION = 1.5
WSAPI_SITE = http://github.com/downloads/keplerproject/wsapi
WSAPI_LICENSE = MIT

define WSAPI_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/lua/5.1/wsapi
	$(INSTALL) -m 0644 -D $(@D)/src/wsapi/*.lua \
		$(TARGET_DIR)/usr/share/lua/5.1/wsapi
endef

$(eval $(generic-package))
