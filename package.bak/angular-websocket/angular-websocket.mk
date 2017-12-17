################################################################################
#
# angular-websocket
#
################################################################################

ANGULAR_WEBSOCKET_VERSION = v2.0.0
ANGULAR_WEBSOCKET_SITE = $(call github,AngularClass,angular-websocket,$(ANGULAR_WEBSOCKET_VERSION))
ANGULAR_WEBSOCKET_LICENSE = MIT
ANGULAR_WEBSOCKET_LICENSE_FILES = LICENSE

# install .min.js as .js
define ANGULAR_WEBSOCKET_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/dist/angular-websocket.min.js \
		$(TARGET_DIR)/var/www/angular-websocket.js
endef

$(eval $(generic-package))
