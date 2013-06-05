################################################################################
#
# json-javascript
#
################################################################################

JSON_JAVASCRIPT_VERSION = 42c18c621a411c3f39a81bb0a387fc50dcd738d9
JSON_JAVASCRIPT_SITE = git://github.com/douglascrockford/JSON-js.git
JSON_JAVASCRIPT_LICENSE = Public Domain
JSON_JAVASCRIPT_LICENSE_FILES = json2.js

define JSON_JAVASCRIPT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/json2.js $(TARGET_DIR)/var/www/json2.js
endef

define JSON_JAVASCRIPT_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/var/www/json2.js
endef

$(eval $(generic-package))
