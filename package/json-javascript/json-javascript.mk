################################################################################
#
# json-javascript
#
################################################################################

JSON_JAVASCRIPT_VERSION = 3d7767b6b1f3da363c625ff54e63bbf20e9e83ac
JSON_JAVASCRIPT_SITE = $(call github,douglascrockford,JSON-js,$(JSON_JAVASCRIPT_VERSION))
JSON_JAVASCRIPT_LICENSE = Public Domain
JSON_JAVASCRIPT_LICENSE_FILES = json2.js

define JSON_JAVASCRIPT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/json2.js $(TARGET_DIR)/var/www/json2.js
endef

$(eval $(generic-package))
