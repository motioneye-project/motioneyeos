JQUERY_VERSION = 1.7.1
JQUERY_SITE = http://code.jquery.com
JQUERY_SOURCE = jquery-$(JQUERY_VERSION).min.js

define JQUERY_EXTRACT_CMDS
	cp $(DL_DIR)/$(JQUERY_SOURCE) $(@D)
endef

define JQUERY_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/$(JQUERY_SOURCE) \
		$(TARGET_DIR)/var/www/jquery.js
endef

define JQUERY_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/var/www/jquery.js
endef

$(eval $(generic-package))
